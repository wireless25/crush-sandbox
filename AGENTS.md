# AGENTS.md - Guide for Working in This Repository

## Project Overview

This is a minimal bash wrapper script that creates a Docker sandbox environment for running the Crush CLI agent. The tool isolates development work in containers, provides per-workspace container isolation with **Git worktree support**, and automates Crush CLI installation.

**Key characteristics:**
- Single executable bash script (`docker-sandbox-crush` - installs as `crush-sandbox` command)
- Alias `crushbox` available after installation
- macOS-focused (relies on Docker Desktop path mapping)
- **Per-workspace container isolation (one sandbox per workspace directory)**
- **Git worktree support for parallel development across multiple branches (primary feature)**
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
    ├── prd-crush-config.md               # PRD for Crush configuration management
    ├── prd-worktree-container-isolation.md  # PRD for per-worktree container isolation
    └── prd-worktree-branch-handling.md  # PRD for worktree branch handling enhancements
```

## Commands

### Available Commands

**When using the script from the repo:**
- `./docker-sandbox-crush run` - Start the Crush CLI in a Docker sandbox
- `./docker-sandbox-crush run --worktree [name]` - Create a worktree and start Crush CLI in it
- `./docker-sandbox-crush list-worktrees` - List all git worktrees in current workspace
- `./docker-sandbox-crush remove-worktree <name>` - Remove a worktree
- `./docker-sandbox-crush clean` - Remove the sandbox container and cache volume
- `./docker-sandbox-crush reset` - Alias for `clean`
- `./docker-sandbox-crush install` - Install the script to `/usr/local/bin/crush-sandbox`
- `./docker-sandbox-crush update` - Update to the latest version

**After installation:**
- `crush-sandbox run` - Start the Crush CLI in a Docker sandbox
- `crush-sandbox run --worktree [name]` - Create a worktree and start Crush CLI in it
- `crushbox run` - Alias for `crush-sandbox run`
- `crushbox run --worktree [name]` - Alias for `crush-sandbox run --worktree [name]`
- `crush-sandbox list-worktrees` - List all git worktrees in current repository
- `crush-sandbox list-containers` - List all containers for current repository
- `crush-sandbox remove-worktree <name>` - Remove a git worktree
- `crush-sandbox clean` - Remove sandbox containers (prompts for current vs all)
- `crush-sandbox install` - Reinstall or update the script
- `crush-sandbox update` - Update to the latest version

### Command Options

- `--version` - Show version information
- `--force` - Skip confirmation prompts (use with `clean` and `remove-worktree` commands)
- `--shell` - Start an interactive shell instead of Crush CLI (for debugging)
- `--no-host-config` - Skip mounting host Crush config directory
- `--cred-scan` - Enable credential scanning before starting container
- `--worktree [name]` - Create a worktree with optional name, then start Crush CLI in it (blank input uses worktree name as branch name)
- `--branch-name [name]` - Specify branch name for worktree (requires --worktree, skips branch prompt)

### Environment Variables

- `DOCKER_SANDBOX_IMAGE` - Override the Docker image (default: `node:22-alpine`)
- Example: `DOCKER_SANDBOX_IMAGE=node:20-alpine ./docker-sandbox-crush run` or `DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run`

## Essential Testing Commands

This project uses **bats-core** for automated testing:

```bash
# Run all bats tests
bats tests/

# Run specific test file
bats tests/worktree.bats

# Run with verbose output
bats -v tests/

# Run specific test
bats -f "test_name" tests/worktree.bats
```

Manual testing (for Docker/container features not covered by unit tests):
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
3. Run `./docker-sandbox-crush run` to test Crush CLI integration
4. Verify Crush CLI works inside the container
5. Run `./docker-sandbox-crush clean` to reset
6. Test worktree functionality:
   - `./docker-sandbox-crush run --worktree test1`
   - `./docker-sandbox-crush run --worktree test2`
   - `./docker-sandbox-crush list-containers`
   - Verify each worktree has its own container
   - Run `./docker-sandbox-crush clean` and test both cleanup options
7. Test parallel execution:
   - Run `./docker-sandbox-crush run` in main workspace (terminal 1)
   - Run `./docker-sandbox-crush run --worktree test1` (terminal 2)
   - Verify both containers are running independently

## Core Functions

### `validate_docker()`
Checks if Docker CLI is installed and Docker daemon is running. Fails early with clear error messages if Docker is unavailable.

### `get_workspace_info()`
Returns the current working directory (absolute path). Used as the base for container naming and workspace mounting.

### `read_git_config()`
Reads `user.name` and `user.email` from `~/.gitconfig`. Returns pipe-delimited string `"name|email"`. Git config is optional - missing values only generate warnings, not errors.

### `get_container_name()`
Generates deterministic container name based on workspace type.
- **Main workspace**: `crush-sandbox-<repo-hash>` where hash is SHA256 of repository root path
- **Worktree**: `crush-sandbox-<repo-hash>-<worktree-name>` where worktree name is extracted from path
- Repository hash derived from `get_root_workspace()` for consistency across all worktrees
- Each workspace (main + each worktree) gets its own container for crash isolation
- SHA256 provides cryptographically secure hashing (truncated to 12 characters)

### `get_cache_volume_name()`
Generates deterministic cache volume name from repository root path using SHA256 hash (truncated to first 12 characters).
- Pattern: `crush-cache-<repo-hash>` where hash is from repository root path
- Same repository always produces same volume name
- Used for shared package manager caches across all worktrees
- SHA256 provides cryptographically secure hashing (vs. MD5)

### `container_exists()`
Checks if a container with the given name exists (including stopped containers).
- Uses `docker ps -a --filter "name=^${container_name}$"`
- Returns boolean (exit code)

### `get_repository_containers()`
Finds all containers for a given repository.
- Takes repository root path as argument
- Filters Docker containers by name prefix `crush-sandbox-<repo-hash>-`
- Returns list of all container names for that repository
- Used by `list-containers` and `clean` commands

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
Removes sandbox resources with user-specified scope:
1. Validates Docker availability and git repository
2. Computes current workspace and repository root
3. Finds all containers for the repository
4. **Prompts user for cleanup scope** (unless `--force` flag is set):
   - Option 1: Clean current workspace container only
   - Option 2: Clean all workspace containers in repository
5. For current workspace cleanup:
   - Removes only the current workspace's container
   - Does NOT remove cache volume (shared across all workspaces)
6. For all workspaces cleanup:
   - Removes all containers for the repository
   - Removes cache volume
   - Requires additional confirmation unless `--force` flag is set

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

### `get_host_session_data_path()`
Detects and validates host Crush session data directory.
- Checks `~/.local/share/crush/`
- Validates directory exists and is readable
- Returns empty string with warning if no session data found
- Exits with error if directory exists but is not readable

### `setup_crush_config_script()`
Creates a startup script inside the container at `/usr/local/bin/setup-crush-config.sh` that:
- Creates **separate** writable directories for config and data
- `/tmp/crush-config/config` - writable copy of host configuration
- `/tmp/crush-config/data` - writable copy of host session data
- Copies host config from read-only mount `/host-crush-config`
- Copies host session data from read-only mount `/host-session-data`
- Sets `CRUSH_GLOBAL_CONFIG` environment variable to `/tmp/crush-config/config`
- Sets `CRUSH_GLOBAL_DATA` environment variable to `/tmp/crush-config/data`
- Logs which sources were copied
- **Note**: Runtime changes inside container are lost when container stops
  - Users should authenticate and configure Crush on host machine first
  - Container only reads pre-configured session data

### `validate_git_repository()`
Validates that the current directory is a git repository.
- Uses `git rev-parse --git-dir` to check for git repository
- Exits with error message if not in a git repository
- Required for worktree commands

### `get_root_workspace()`
Returns the root directory of the git repository.
- Uses `git rev-parse --show-toplevel` to find git root
- Returns absolute path to git repository root
- Used to determine container/volume names (all worktrees in same repo share same container)
- Critical for worktree functionality - workspace path resolution differs for worktrees vs main workspace

### `prepare_worktree_directory()`
Prepares the `.worktrees` directory in the root workspace.
- Creates `.worktrees` directory if it doesn't exist
- Creates `.worktrees/.gitignore` with `*` pattern (ignores all worktree contents)
- Prevents worktree directories from being tracked in git
- Called automatically when creating new worktrees

### `generate_worktree_name()`
Generates a random 8-character alphanumeric worktree name.
- Uses `/dev/urandom` with `LC_ALL=C tr -dc 'a-zA-Z0-9'` for random characters
- Truncates to 8 characters
- Used when `--worktree` flag is provided without a name
- Ensures unique worktree names

### `worktree_exists()`
Checks if a worktree with the given name exists.
- Takes workspace path and worktree name as arguments
- Checks `git worktree list` for matching path
- Uses `awk` to extract paths from git worktree output
- Returns exit code 0 if exists, 1 if not
- Prevents duplicate worktree names

### `create_worktree()`
Creates a new git worktree and starts Crush CLI in it.
- Takes workspace path, worktree name, and optional branch name as arguments
- Validates worktree doesn't already exist
- Determines branch to use:
  - Explicit branch name from argument
  - Current branch (if in existing worktree)
  - Prompts user for branch name if not specified
- Creates worktree via `git worktree add`:
  - Existing branch: `git worktree add <path> <branch>`
  - New branch: `git worktree add -b <branch> <path>`
- Displays worktree path and branch name
- Returns error if worktree creation fails

### `list_worktrees()`
Lists all git worktrees in the current repository.
- Calls `git worktree list` to get all worktrees
- Parses output to extract path and branch information
- Marks the current worktree with `(current)` indicator
- Displays in user-friendly format with indentation
- Shows "No worktrees found" message if none exist
- Works from any directory within the git repository

### `remove_worktree()`
Removes a git worktree and its directory.
- Takes workspace path, worktree name, and force flag as arguments
- Validates worktree exists
- Builds `git worktree remove` command:
  - Standard: `git worktree remove <path>`
  - Force: `git worktree remove --force <path>`
- Force flag removes worktrees with uncommitted changes
- Displays success message with worktree path
- Returns error if removal fails
- Provides hint to use `--force` if uncommitted changes prevent removal

### `list_containers()`
Lists all containers for the current repository.
- Validates git repository and gets repository root
- Finds all containers with matching repository hash prefix
- For each container, displays:
  - Workspace path (main or `.worktrees/<name>`)
  - Branch name
  - Container status with visual indicator (🟢 running, 🔴 stopped, ⚪ nonexistent)
  - Container name
- Marks current workspace with `(current)` indicator
- Works from any directory within the git repository
- Shows "No containers found" message if none exist

## Code Patterns and Conventions

### Naming Conventions
- **Container names**:
  - Main workspace: `crush-sandbox-<repo-hash>`
  - Worktree: `crush-sandbox-<repo-hash>-<worktree-name>`
  - Hash function: SHA256 of repository root path (via `shasum -a 256`), truncated to 12 chars
- **Volume names**: `crush-cache-<repo-hash>`
  - Hash function: SHA256 of repository root path (via `shasum -a 256`), truncated to 12 chars
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
- **Each workspace (main + each worktree) has its own container**
  - Container names include repository hash + worktree name (for uniqueness)
  - **All worktrees in the same repository share a single cache volume**
  - Stopping one worktree's container doesn't affect others
  - Enables parallel execution across multiple worktrees

### Worktree Patterns
- Worktree directory structure: `workspace/.worktrees/<worktree-name>/`
- Worktree names use only alphanumeric characters, hyphens, and underscores
- Worktree names are validated to prevent path injection
- `.worktrees/.gitignore` contains `*` to ignore all worktree contents
- Worktrees are managed via git's native `git worktree` commands
- Container workspace switches to worktree path when using `--worktree` flag
- Worktree creation handles branch name in multiple ways:
  - **Interactive mode**: Prompts for branch name (blank input defaults to worktree name)
  - **`--branch-name` flag**: Uses specified branch name directly, skips all prompts
  - **Non-TTY mode**: Automatically uses worktree name as branch name
- Existing branches are checked out, new branches are created automatically
- Git handles validation (invalid characters, duplicate branches, etc.)

### Worktree Branch Handling

#### Interactive Mode (TTY Available)
When running in a terminal, worktree creation prompts for branch name:
```bash
./docker-sandbox-crush run --worktree feature-auth
# Prompts: Branch name (press Enter to use 'feature-auth'):
```
- Press Enter to use worktree name as branch name
- Enter an existing branch name to check it out
- Enter a new branch name to create it

#### Using `--branch-name` Flag
For programmatic usage or to skip prompts, specify branch name directly:
```bash
# Checkout existing branch
./docker-sandbox-crush run --worktree auth-work --branch-name feature-auth

# Create and checkout new branch
./docker-sandbox-crush run --worktree auth-work --branch-name feature-new-auth
```
- Requires `--worktree` flag to be present
- Skips all branch-related prompts
- Creates new branch if it doesn't exist
- Checks out existing branch if it already exists

#### Non-TTY Mode (Programmatic Usage)
When running in scripts or piped input (non-TTY), branch name defaults to worktree name:
```bash
# These commands use worktree name as branch name automatically
echo "" | ./docker-sandbox-crush run --worktree test1
./docker-sandbox-crush run --worktree test1 < /dev/null
```
- No prompts in non-TTY mode
- Worktree name is used as branch name by default
- Use `--branch-name` to specify different branch
- Git validation errors are displayed directly

#### Programmatic Usage Examples
```bash
# Script: Create worktree for specific branch
#!/bin/bash
./docker-sandbox-crush run --worktree feature-login --branch-name feature/login

# CI/CD: Create worktree from environment variables
./docker-sandbox-crush run --worktree ci-build --branch-name $CI_BRANCH_NAME

# Automation: Create multiple worktrees in a loop
for feature in feature-a feature-b feature-c; do
  ./docker-sandbox-crush run --worktree "${feature}-work" --branch-name "$feature"
done

# Non-TTY: Use worktree name as branch name
yes "" | ./docker-sandbox-crush run --worktree auto-branch-test
```

#### Branch Validation and Errors
All branch validation is handled by git:
- Invalid characters: Git displays clear error messages
- Duplicate branches: Git shows which worktree has the branch checked out
- Permission errors: Git provides descriptive error messages
- Repository errors: Standard git error messages apply

No additional sanitization is performed beyond what git provides.

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
- Caches are **per-repository** (shared across all worktrees in same repository)
- Same repository always uses same cache volume
- This enables fast npm/pnpm installs across all worktrees
- Cache volume name derived from repository root path
- Switching workspaces within same repository reuses cache
- Different repositories have separate cache volumes
- This prevents cache pollution between different projects

### Worktree vs Container Naming
- **Container names** are **workspace-scoped** (unique per workspace):
  - Main workspace: `crush-sandbox-<repo-hash>`
  - Worktree: `crush-sandbox-<repo-hash>-<worktree-name>`
  - Each workspace gets its own container for crash isolation
- **Cache volume names** are **repository-scoped** (shared across all workspaces):
  - Pattern: `crush-cache-<repo-hash>`
  - All worktrees in same repository use same cache volume
- Repository hash derived from repository root path (via `get_root_workspace()`)
- Worktree name extracted from workspace path (e.g., `.worktrees/feature-123` → `feature-123`)
- Example: If workspace is `/projects/my-app` and worktree is `.worktrees/feature`, container is named `crush-sandbox-<hash>-feature`, cache is `crush-cache-<hash>`

### Worktree Isolation
- Each worktree has its own directory at `.worktrees/<name>/`
- Worktree directories are gitignored (`*.worktrees/.gitignore` contains `*`)
- **Each worktree has its own container for crash isolation**
- Worktrees share the same Crush cache volume for fast package installs
- Worktree changes are independent (no git conflicts between branches)
- Stopping one worktree's container doesn't affect others
- **Multiple worktrees can run Crush CLI simultaneously** (parallel execution)
- Switching worktrees requires creating new containers (not instant switch)

### Worktree Branch Management
- **Interactive mode**: Prompts for branch name, blank input defaults to worktree name
- **Programmatic mode**: Use `--branch-name` flag to specify branch without prompts
- **Non-TTY mode**: Automatically uses worktree name as branch name
- Creating worktree for existing branch: checks out that branch in new directory
- Creating worktree for new branch: creates branch and checks it out in new directory
- Same branch cannot be checked out in multiple worktrees simultaneously
- Must switch main workspace to different branch if worktree needs that branch
- Git handles all validation (invalid characters, duplicate branches, etc.)

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
- Host session data detected from `~/.local/share/crush/`
- Configuration mounted read-only inside container at `/host-crush-config`
- Session data mounted read-only inside container at `/host-session-data`
- **Separate writable directories created inside container**:
  - `/tmp/crush-config/config` - writable copy of host config
  - `/tmp/crush-config/data` - writable copy of host session data
- `CRUSH_GLOBAL_CONFIG` environment variable points to `/tmp/crush-config/config`
- `CRUSH_GLOBAL_DATA` environment variable points to `/tmp/crush-config/data`
- Secret files detected by pattern and injected as environment variables
- All mounts are read-only for security (container cannot modify host files)
- **Important**: Runtime changes inside container (tokens, model preferences) are **lost on container stop**
  - Users should authenticate and configure Crush on the host machine first
  - Container only reads the pre-authenticated session data
  - Use `--no-host-config` to skip mounting host config and data

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
| `prd-worktree-container-isolation.md` | ✅ Complete (all acceptance criteria checked) |
| `prd-worktree-branch-handling.md` | ✅ Complete (all acceptance criteria checked) |

## Usage Examples

### Basic Usage
```bash
# Start Crush CLI in main workspace
./docker-sandbox-crush run

# Start Crush CLI with interactive shell (for debugging)
./docker-sandbox-crush run --shell

# List all containers for the repository
./docker-sandbox-crush list-containers

# Clean current workspace container only
./docker-sandbox-crush clean

# Clean all workspace containers and cache volume
./docker-sandbox-crush clean
# (choose option 2 when prompted)
```

### Worktree Usage
```bash
# Create a worktree with auto-generated name (uses worktree name as branch)
./docker-sandbox-crush run --worktree

# Create a worktree with specific name (blank input uses worktree name as branch)
./docker-sandbox-crush run --worktree feature-auth
# (prompts: Branch name (press Enter to use 'feature-auth'): )

# Create a worktree with specific branch name (programmatic, no prompt)
./docker-sandbox-crush run --worktree auth-work --branch-name feature/auth

# List all worktrees in the repository
./docker-sandbox-crush list-worktrees

# List all containers (main + all worktrees)
./docker-sandbox-crush list-containers

# Remove a worktree
./docker-sandbox-crush remove-worktree feature-auth
```

### Branch Handling Examples
```bash
# Interactive mode: use worktree name as branch (press Enter at prompt)
./docker-sandbox-crush run --worktree login-feature
# Prompt: Branch name (press Enter to use 'login-feature'):
# Press Enter → Creates worktree with branch 'login-feature'

# Interactive mode: specify existing branch
./docker-sandbox-crush run --worktree my-work
# Prompt: Branch name (press Enter to use 'my-work'):
# Type: develop → Creates worktree and checks out 'develop' branch

# Interactive mode: create new branch
./docker-sandbox-crush run --worktree my-work
# Prompt: Branch name (press Enter to use 'my-work'):
# Type: feature/new-login → Creates worktree and new branch 'feature/new-login'

# Programmatic mode: specify branch with --branch-name
./docker-sandbox-crush run --worktree test-work --branch-name feature/test
# No prompt, directly creates worktree with branch 'feature/test'

# Non-TTY mode: automatic branch name from worktree
yes "" | ./docker-sandbox-crush run --worktree auto-branch
# No prompt, creates worktree with branch 'auto-branch'

# CI/CD example: create worktree from environment variable
./docker-sandbox-crush run --worktree ci-"$BUILD_ID" --branch-name "$CI_BRANCH"
```

### Parallel Worktree Usage
```bash
# Terminal 1: Start Crush CLI in main workspace
cd /projects/my-app
./docker-sandbox-crush run

# Terminal 2: Create and run Crush CLI in worktree 1
cd /projects/my-app
./docker-sandbox-crush run --worktree feature-auth

# Terminal 3: Create and run Crush CLI in worktree 2
cd /projects/my-app
./docker-sandbox-crush run --worktree feature-ui

# Each worktree has its own isolated container
# Stopping one doesn't affect the others
# All worktrees share the same npm/pnpm cache
```

### Container Management
```bash
# Check status of all containers
./docker-sandbox-crush list-containers

# Clean only the current workspace's container
./docker-sandbox-crush clean
# (choose option 1 when prompted)

# Clean all containers and cache volume (full reset)
./docker-sandbox-crush clean
# (choose option 2 when prompted)

# Force clean all containers and cache (skip prompts)
./docker-sandbox-crush clean --force
```

### Migration from Old Version
```bash
# After updating to per-worktree container isolation:

# 1. Clean up old containers and cache
./docker-sandbox-crush clean
# Choose option 2 (clean all workspaces) when prompted

# 2. Verify cleanup is complete
./docker-sandbox-crush list-containers
# Should show "No containers found"

# 3. Recreate containers for each workspace
# For main workspace:
cd /projects/my-app
./docker-sandbox-crush run

# For each worktree:
cd /projects/my-app/.worktrees/feature-auth
./docker-sandbox-crush run

# 4. Verify all containers exist
./docker-sandbox-crush list-containers
# Should show main workspace + all worktrees
```

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
- **Per-worktree container isolation** prevents cross-worktree interference
- **Parallel execution safety** - each worktree has isolated environment

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
- Container name is based on current workspace path
- **Each worktree has its own container with unique name**
- Use `crush-sandbox list-containers` to see all containers for the repository

### Configuration not being mounted
- Check that config directories exist: `ls ~/.config/crush` or `ls ~/.crush`
- Verify directory is readable: `test -r ~/.config/crush && echo readable`
- Check script output for warnings about missing config
- Use `--shell` flag to inspect inside container: `ls /host-crush-config`

### Session data lost / re-authentication required
- **Expected behavior**: Session data changes inside container are lost on container stop
- Session data is mounted read-only from host for security
- **Solution**: Authenticate and configure Crush on host machine first
  - Run Crush CLI on host: `crush`
  - Complete authentication (device code flow, API keys, etc.)
  - Session data saved to `~/.local/share/crush/`
  - Then run `crush-sandbox run` to use pre-authenticated session
- **Alternative**: Use `--no-host-config` to run without host session data (requires re-authentication each session)

### "Multiple containers found" when running clean
- This is normal when you have multiple worktrees
- You'll be prompted to choose cleanup scope:
  - Option 1: Clean current workspace container only
  - Option 2: Clean all workspace containers in repository
- Use `crush-sandbox list-containers` to see all containers

### Worktree: "Not in a git repository"
- Worktree commands require a git repository
- Solution: Initialize git first: `git init`
- Or navigate to a directory that is a git repository

### Worktree: "Worktree already exists"
- Worktree name is already in use
- Solution: Use a different name or remove existing worktree
- List existing worktrees: `crush-sandbox list-worktrees`
- Remove existing worktree: `crush-sandbox remove-worktree <name>`

### Worktree: Cannot remove with uncommitted changes
- Worktree has uncommitted changes
- Solution: Use `--force` flag: `crush-sandbox remove-worktree <name> --force`
- Or commit/stash changes first: `cd .worktrees/<name> && git commit -am "Save work"`

### Worktree: "Branch already checked out elsewhere"
- Branch is already checked out in another worktree or main workspace
- Solution: Use a different branch or remove worktree with that branch
- Switch main workspace to a different branch if needed

### Container: "Container not found" after switching worktrees
- Each worktree has its own container
- Switching to a different worktree requires creating its container
- Solution: Run `crush-sandbox run` in the new worktree to create its container

### Parallel Execution: "Multiple Crush CLI sessions running"
- This is now supported with per-worktree containers
- Each worktree has its own isolated container
- You can run `crush-sandbox run` in different worktree directories simultaneously
- Use `crush-sandbox list-containers` to see all running containers
