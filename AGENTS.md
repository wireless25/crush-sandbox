# AGENTS.md - Guide for Working in This Repository

## Project Overview

This is a minimal bash wrapper script that creates a Docker sandbox environment for running the Crush CLI agent. The tool isolates development work in containers, provides persistent package manager caches per workspace, and automates Crush CLI installation.

**Key characteristics:**
- Single executable bash script (`docker-sandbox-crush` - installs as `crush-sandbox` command)
- Alias `crushbox` available after installation
- macOS-focused (relies on Docker Desktop path mapping)
- Per-workspace container isolation (one sandbox per workspace directory)
- Persistent cache volumes for npm/pnpm
- Automatic Crush CLI installation on first use
- Automatic configuration mounting and merging (host)
- Secret extraction and injection as environment variables

## Project Structure

```
docker-sandbox-crush/
├── docker-sandbox-crush          # Main executable bash script
└── tasks/
    ├── prd-docker-sandbox-crush.md        # Original PRD for core functionality
    ├── prd-sandbox-enhancement.md         # PRD for cache persistence and enhancements
    ├── prd-distribution-and-docs.md      # PRD for distribution/docs (not yet implemented)
    └── prd-crush-config.md               # PRD for Crush configuration management
```

## Commands

### Available Commands

**When using the script from the repo:**
- `./docker-sandbox-crush run` - Start the Crush CLI in a Docker sandbox
- `./docker-sandbox-crush clean` - Remove the sandbox container and cache volume
- `./docker-sandbox-crush reset` - Alias for `clean`
- `./docker-sandbox-crush install` - Install the script to `/usr/local/bin/crush-sandbox`
- `./docker-sandbox-crush update` - Update to the latest version

**After installation:**
- `crush-sandbox run` - Start the Crush CLI in a Docker sandbox
- `crushbox run` - Alias for `crush-sandbox run`
- `crush-sandbox clean` - Remove the sandbox container and cache volume
- `crush-sandbox install` - Reinstall or update the script
- `crush-sandbox update` - Update to the latest version

### Command Options

- `--version` - Show version information
- `--force` - Skip confirmation prompts (use with `clean` command)
- `--shell` - Start an interactive shell instead of Crush CLI (for debugging)
- `--no-host-config` - Skip mounting host Crush config directory
- `--cred-scan` - Enable credential scanning before starting container

### Environment Variables

- `DOCKER_SANDBOX_IMAGE` - Override the Docker image (default: `node:22-alpine`)
- Example: `DOCKER_SANDBOX_IMAGE=node:20-alpine ./docker-sandbox-crush run` or `DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run`

## Essential Testing Commands

There are **no automated tests** in this project. Testing is manual:

```bash
# Test Docker availability
docker info

# Test the tool (from within a workspace)
./docker-sandbox-crush run

# Test with a different Docker image
DOCKER_SANDBOX_IMAGE=node:20-alpine ./docker-sandbox-crush run

# Test with shell mode for debugging
./docker-sandbox-crush run --shell

# Test cleanup
./docker-sandbox-crush clean
```

To validate changes:
1. Ensure script is executable: `chmod +x docker-sandbox-crush`
2. Run `./docker-sandbox-crush run` to start Crush CLI
3. Verify Crush CLI works inside the container
4. Run `./docker-sandbox-crush clean` to reset
5. Repeat with different workspace directories to test isolation

## Core Functions

### `validate_docker()`
Checks if Docker CLI is installed and Docker daemon is running. Fails early with clear error messages if Docker is unavailable.

### `get_workspace_info()`
Returns the current working directory (absolute path). Used as the base for container naming and workspace mounting.

### `read_git_config()`
Reads `user.name` and `user.email` from `~/.gitconfig`. Returns pipe-delimited string `"name|email"`. Git config is optional - missing values only generate warnings, not errors.

### `get_container_name()`
Generates deterministic container name from workspace path using SHA256 hash (truncated to first 12 characters).
- Pattern: `crush-sandbox-<sha256_hash>`
- Same workspace always produces same container name
- Used for container reuse per workspace
- SHA256 provides cryptographically secure hashing (vs. MD5)

### `get_cache_volume_name()`
Generates deterministic cache volume name from workspace path using SHA256 hash (truncated to first 12 characters).
- Pattern: `crush-cache-<sha256_hash>`
- Same workspace always produces same volume name
- Used for persistent package manager caches
- SHA256 provides cryptographically secure hashing (vs. MD5)

### `container_exists()`
Checks if a container with the given name exists (including stopped containers).
- Uses `docker ps -a --filter "name=^${container_name}$"`
- Returns boolean (exit code)

### `create_cache_volume()`
Creates a named Docker volume for caching if it doesn't already exist.
- Reuses existing volume if present
- Named volumes persist even after container removal
- Mounted at `/workspace-cache` in container

### `create_container()`
Creates a new Docker container with:
- Base image: `node:22-alpine` (configurable via `DOCKER_SANDBOX_IMAGE`)
- Workspace mounted at same absolute path (read/write)
- Cache volume mounted at `/workspace-cache`
- Git config passed as environment variables (`GIT_USER_NAME`, `GIT_USER_EMAIL`)
- npm cache configured to `/workspace-cache/npm`
- pnpm store/cache configured to `/workspace-cache/pnpm/...`
- Container runs `tail -f /dev/null` to stay alive
- **Resource limits** for DoS prevention (4GB memory, 2 CPUs, 100 PIDs)
- **Non-root user** (UID 1000) for attack surface reduction
- **Capability dropping** (all dropped, only CHOWN and DAC_OVERRIDE added back)

### `validate_workspace_path()`
Validates workspace path for security (prevents command injection).
- Checks for shell metacharacters: `$, `, \, ;, |, &, <, >`
- Checks for command substitution patterns: `$(...)`
- Exits with clear error message if invalid characters found

### `ensure_gitleaks_image()`
Ensures gitleaks Docker image is available for credential scanning.
- Checks if `ghcr.io/gitleaks/gitleaks:latest` image exists locally (fast path)
- Pulls image from GitHub Container Registry if not present
- Shows warning if pull fails (feature degrades gracefully)
- Called from `scan_credentials()` before scanning

### `scan_credentials()`
Scans workspace for credentials before container starts.
- Uses gitleaks Docker image (`ghcr.io/gitleaks/gitleaks:latest`) for secret detection
- Mounts workspace into gitleaks container for scanning
- Warns if gitleaks image not available (feature degraded, not failed)
- Prompts user to continue or abort if credentials detected
- Can be bypassed with `--no-cred-scan` flag (use with caution)

### `setup_crush_script()`
Creates a startup script inside the container at `/usr/local/bin/setup-crush.sh` that:
- Checks if Crush CLI is already installed (fast path)
- Installs Crush CLI via `npm install -g @charmland/crush` if missing
- Logs success/failure messages

### `run_container()`
Main execution function that:
1. Starts (or restarts) the container
2. Runs the Crush CLI setup script
3. Installs pnpm via npm global install (if not present)
4. Displays npm and pnpm versions
5. Executes either Crush CLI or interactive shell based on `--shell` flag
6. Stops container when session ends

### `run_command()`
Orchestrates the full `run` command flow:
1. Validates Docker availability
2. Gets workspace info
3. **Validates workspace path** for security (prevents command injection)
4. **Scans workspace for credentials** using gitleaks
5. Computes container and volume names
6. Creates cache volume (if needed)
7. Reads Git config
8. Creates container (if it doesn't exist) or reuses existing
9. Runs the container

### `clean_command()`
Removes sandbox resources:
1. Stops container (if running)
2. Removes container
3. Removes cache volume
4. Requires confirmation unless `--force` flag is set

### `install_command()`
Installs docker-sandbox-crush script to system.
1. Validates Docker is available and running
2. Downloads latest script from GitHub
3. Installs script to `/usr/local/bin/docker-sandbox-crush`
4. Displays installation summary and tool versions
5. Notes that gitleaks Docker image will be pulled on first use

### `get_host_crush_config_path()`
Detects and validates host Crush configuration directory.
- Checks `~/.config/crush/`
- Validates directory exists and is readable
- Returns empty string with warning if no config found
- Exits with error if directory exists but is not readable

### `setup_crush_config_script()`
Creates a startup script inside the container at `/usr/local/bin/setup-crush-config.sh` that:
- Creates merged config directory at `/tmp/crush-config/merged/`
- Copies host config from `/host-crush-config` if available
- Sets `CRUSH_GLOBAL_CONFIG` environment variable to merged directory
- Logs which sources were merged

## Code Patterns and Conventions

### Naming Conventions
- Container names: `crush-sandbox-<hash>`
- Volume names: `crush-cache-<hash>`
- Hash function: SHA256 of workspace path (via `shasum -a 256`), truncated to 12 chars
- Functions use snake_case
- Variables use snake_case for local variables, UPPERCASE for globals

### Error Handling
- `set -e` at top of script - exits immediately on any command failure
- Error messages written to stderr (`>&2`)
- Validation functions return non-zero exit codes on failure
- Silent failures suppressed with `> /dev/null 2>&1` where appropriate
- Non-fatal warnings (e.g., missing Git config) are logged but don't exit

### Docker Patterns
- Containers are created with `docker create` (not `docker run`)
- Containers are started separately with `docker start`
- Containers execute commands via `docker exec` (not `docker run`)
- TTY detection: `[ -t 0 ]` to determine if running interactively
- Interactive mode: `docker exec -it` (with TTY) or `docker exec -i` (without TTY)
- **Security flags** applied to containers:
  - `--memory=4g` - Memory limit (prevents resource exhaustion)
  - `--memory-swap=4g` - No swapping (prevents disk exhaustion)
  - `--cpus=2.0` - CPU limit (prevents CPU DoS)
  - `--ulimit nproc=100` - Process limit (prevents fork bomb)
  - `--user 1000:1000` - Non-root user (limits attack surface)
  - `--cap-drop ALL` - Drop all capabilities (reduce attack surface)
  - `--cap-add CHOWN` - Add CHOWN (required for npm cache)
  - `--cap-add DAC_OVERRIDE` - Add DAC_OVERRIDE (required for workspace access)

### Bash Patterns
- Arrays for Docker args: `docker_args=(...)` then `"${docker_args[@]}"`
- Parameter expansion for splitting pipe-delimited values:
  - `${git_config%|*}` - everything before first `|`
  - `${git_config##*|}` - everything after last `|`
- Command substitution: `$(command)` for capturing output
- String comparison: `[[ "$var" =~ ^[yY] ]]` for regex matching

### Persistence Strategy
- Containers are stopped but **not removed** after use
- This enables fast startup (reuse existing container)
- Cache volumes are separate from containers
- Both container and volume persist until `clean` command

## Important Gotchas

### Workspace Path Mapping
- Workspace is mounted at **same absolute path** in container
- This works seamlessly on macOS Docker Desktop
- Container's working directory is set to workspace path
- Relative paths work identically inside and outside container

### Container Lifecycle
1. `docker create` creates stopped container
2. `docker start` starts the container
3. `docker exec` runs commands in running container
4. `docker stop` stops container (keeps it around for reuse)
5. `docker rm` removes container permanently

### Cache Isolation
- Caches are per-workspace (not per-container)
- Same workspace always uses same cache volume
- Switching workspaces switches cache volumes automatically
- This prevents cache pollution between different projects

### Crush CLI Installation
- Installed via npm global: `npm install -g @charmland/crush`
- Installation happens on **every container start** via setup script
- Setup script has fast path (checks if `crush` command exists)
- Uses npm cache for faster installs after first time
- If installation fails, container continues but Crush CLI won't work

### pnpm Installation
- Installed via npm global: `npm install -g pnpm`
- Installed on **every container start** (no caching check)
- Installation uses npm cache for speed
- pnpm config set for store-dir and cache-dir after install

### TTY Detection
- `[ -t 0 ]` checks if stdin is a terminal
- Affects whether `-t` flag is passed to `docker exec`
- Non-interactive mode (e.g., piping commands) uses `-i` only
- Interactive mode (typical use) uses `-it` for full terminal support

### Git Config Handling
- Git config is **optional** - not required for operation
- Only reads from `~/.gitconfig`, not `.git/config` in workspace
- Passed as environment variables, not written to container's git config
- Crush CLI inside container can use these env vars for git operations

### Configuration Handling
- Host config detected from `~/.config/crush/`
- Configuration mounted read-only inside container at `/host-crush-config`
- `CRUSH_GLOBAL_CONFIG` environment variable set to merged config directory
- Secret files detected by pattern and injected as environment variables
- All mounts are read-only for security (container cannot modify host files)

### Credential Scanning
- Workspace scanned with gitleaks before container starts
- Warns if credentials detected (API keys, passwords, tokens)
- Prompts user to continue or abort if secrets found
- Can be enabled with `--cred-scan` flag

### Workspace Path Validation
- Paths validated for shell metacharacters before container creation
- Prevents command injection attacks via malicious paths
- Checks for: `$, `, \, ;, |, &, <, >` and command substitution `$(...)`
- Exits with clear error message if validation fails

## Technical Specifications

### Base Image
- Default: `node:22-alpine` - Minimal Node.js environment
- Can be overridden via `DOCKER_SANDBOX_IMAGE` environment variable
- Includes npm pre-installed
- Alpine Linux for small footprint
- Uses `tail -f /dev/null` to keep container running

### Container Security Configuration
- **User**: Non-root (UID 1000:GID 1000)
- **Resource limits**:
  - Memory: 4GB (`--memory=4g`)
  - Swap: 4GB (no swapping allowed, `--memory-swap=4g`)
  - CPU: 2 cores (`--cpus=2.0`)
  - Processes: 100 PIDs (`--ulimit nproc=100`)
- **Capabilities**:
  - Drop all capabilities by default (`--cap-drop ALL`)
  - Add back CHOWN (needed for npm cache ownership)
  - Add back DAC_OVERRIDE (needed for workspace file access)

### Cache Configuration
- **npm cache**: `/workspace-cache/npm` (via `npm_config_cache` env var)
- **pnpm store**: `/workspace-cache/pnpm/store` (via `pnpm config set store-dir` config)
- **pnpm cache**: `/workspace-cache/pnpm/cache` (via `pnpm config set cache-dir` config)

### Script Entry Points
- Main logic in `case` statement at end of script
- Argument parsing loop sets `COMMAND`, `FORCE`, `SHELL_MODE`
- Commands dispatched to `run_command()` or `clean_command()`

## PRD Status

| PRD | Status |
|-----|--------|
| `prd-docker-sandbox-crush.md` | ✅ Complete (all acceptance criteria checked) |
| `prd-sandbox-enhancement.md` | ✅ Complete (all acceptance criteria checked) |
| `prd-distribution-and-docs.md` | ⚠️ Partially complete (version and update implemented, README and LICENSE done) |
| `prd-crush-config.md` | ✅ Complete (all acceptance criteria checked) |

## Development Workflow

1. **Making changes**: Edit the `docker-sandbox-crush` script directly
2. **Testing changes**:
   - Run `./docker-sandbox-crush run` to test basic functionality
   - Run `./docker-sandbox-crush run --shell` to debug container state
   - Run `./docker-sandbox-crush clean --force` to reset environment
   - Test with multiple workspace directories to verify isolation
3. **Verification**:
   - Check that Docker is available before running
   - Verify container names are deterministic
   - Verify cache volumes persist across restarts
   - Verify Crush CLI is installed and functional
   - Verify Git config is properly passed through

## Security Considerations

**Implemented Security Controls:**
- Script runs with current user's permissions (no sudo required for Docker)
- Container mounts workspace with read/write access
- **Resource limits** prevent DoS attacks (memory, CPU, process count)
- **Non-root container** user limits attack surface
- **Capability dropping** reduces Linux capabilities to minimum required
- **Workspace path validation** prevents command injection
- **Credential scanning** warns about exposed secrets (via gitleaks)
- **Cryptographic hashing** (SHA256) for container/volume names
- **Secure temporary file creation** (mktemp) prevents TOCTOU attacks

**User Responsibilities:**
- Authentication for Crush CLI must be managed by user (not handled by script)
- Store credentials in environment variables or secret managers (not in workspace files)
- Use Git branch protection for production deployments
- Configure CI/CD with security checks (linting, tests, scanning)
- Review all AI-generated code before merging

## Future Enhancements (Not Yet Implemented)

From `prd-distribution-and-docs.md`:
- GitHub releases with version tags
- LICENSE file

## Common Issues and Solutions

### "docker daemon is not running or not accessible"
- Solution: Start Docker Desktop and wait for it to be ready
- Check with `docker info`

### "Git user.name and user.email not configured"
- This is a warning, not an error
- Solution: Add to `~/.gitconfig` if Crush CLI needs git operations

### Container exists but Crush CLI not working
- Run with `--shell` flag to debug: `./docker-sandbox-crush run --shell`
- Check if `crush` command exists: `which crush`
- Manually install: `npm install -g @charmland/crush`

### Cache not persisting
- Verify cache volume exists: `docker volume ls | grep crush-cache`
- Check volume is mounted: `docker inspect <container-name>` | grep Mounts

### Container name changes unexpectedly
- Ensure you're in the same workspace directory
- Container name is based on current working directory (not script location)

### Configuration not being mounted
- Check that config directories exist: `ls ~/.config/crush` or `ls ~/.crush`
- Verify directory is readable: `test -r ~/.config/crush && echo readable`
- Check script output for warnings about missing config
- Use `--shell` flag to inspect inside container: `ls /host-crush-config`
