# Crush Sandbox

A lightweight bash wrapper that runs the [Crush CLI](https://github.com/charmbracelet/crush) in a Docker sandbox with **Git worktree support**. Perfect for AI-assisted development across multiple branches simultaneously, with per-workspace persistent caching for fast builds.

## 🚀 Quick Start

### Prerequisites

- **macOS** (primary target)
- **Docker Desktop** installed and running

### Installation

#### npm global install (recommended)

The recommended installation method uses npm to install crush-sandbox globally:

```bash
npm install -g crush-sandbox
```

#### Direct script installation

**Automatic installation:**

```bash
curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null
sudo chmod +x /usr/local/bin/crush-sandbox
ln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox
```

**Manual installation:**

1. Download the script:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush
   ```

2. Make it executable:
   ```bash
   chmod +x docker-sandbox-crush
   ```

3. Move it to your PATH:
   ```bash
   sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox
   ```

**Install using the script itself:**

If you've cloned the repository, you can use the built-in install command:

```bash
./docker-sandbox-crush install
```

This will:
- Validate Docker is available
- Install the script to `/usr/local/bin/crush-sandbox`
- Create a `crushbox` alias symlink
- Display version information for installed tools

**Note:** gitleaks Docker image will be pulled automatically on first use for credential scanning. No additional installation is required.

## ✨ Features
- **Git worktree support** - Work on multiple branches simultaneously without git conflicts
- **Per-worktree container isolation**: Each worktree (main + each worktree) gets its own container for crash isolation
- **Shared cache volumes**: All worktrees in same repository share a cache volume for fast installs
- **Workspace path mounting**: Your workspace is mounted at same absolute path inside container, makes debugging easier
- **Persistent caches**: npm and pnpm caches persist per repository for faster subsequent runs
- **Automatic Crush CLI installation**: Crush CLI is installed automatically on first use
- **Git config injection**: Your Git user.name and user.email are passed into the container
- **Container reuse**: Containers are stopped but not removed, enabling fast restarts
- **Container shell**: Use `--shell` flag to get an interactive shell instead of Crush CLI
- **Configuration support**: Automatically mounts and merges Crush configuration from host
- **Programmatic mode**: Send prompts directly via `-p` flag or piped input for automation and CI/CD

## 🌳 Git Worktrees

Git worktrees allow you to check out multiple branches simultaneously in different directories.

### Why Worktrees Matter for AI Development

Traditional git workflow forces you to switch branches (`git checkout`) to work on different features. This means:
- You can only work on one feature at a time
- Stashing or committing work-in-progress to switch contexts
- Crush CLI can only work on the current branch
- Slow context switching between features

With git worktrees:
- **Work on multiple branches simultaneously** - Each worktree is an isolated directory on a different branch
- **No context switching** - Jump between worktrees instantly, no stashing or committing needed
- **Perfect for AI agents** - Crush can generate code in one worktree while you review in another
- **Isolated environments** - Each worktree has its own docker container, sharing one cache volume with all containers in the same repository

### Worktree Structure

```
my-project/                    # Main workspace (e.g., main branch)
├── src/
├── .worktrees/               # Worktree directory
│   ├── feature-login/        # Worktree 1 (feature/login branch)
│   │   ├── src/
│   │   └── package.json
│   ├── fix-bug-123/         # Worktree 2 (bugfix/123 branch)
│   │   ├── src/
│   │   └── package.json
│   └── experiment-api/       # Worktree 3 (experiment/api branch)
│       ├── src/
│       └── package.json
└── package.json
```

Each worktree is a **separate Crush sandbox** with its own isolated container (crash-safe) but shares the npm/pnpm cache volume with other worktrees in the same repository.

### Crush Sandbox + Worktrees Workflow

1. **Create worktree**: `crush-sandbox run --worktree feature-login`
2. **Work in isolation**: Crush CLI runs in `my-project/.worktrees/feature-login/` with its own container
3. **Generate code**: AI creates feature code in worktree
4. **Switch workspace**: `cd ../fix-bug-123` (instant, no git operations, each has its own container)
5. **Review later**: Come back to worktree anytime, work is preserved
6. **List containers**: `crush-sandbox list-containers` to see all workspace containers
7. **Clean up**: `crush-sandbox remove-worktree feature-login` when done (also removes its container)
8. **Restart**: Run a worktree sandbox later with `crush-sandbox run --worktree feature-login` (existing worktree name restarts the container) or `cd .worktrees/feature-login` and `crush-sandbox run`

### Comparison: Traditional vs Worktree

| Task | Traditional Git | With Worktrees |
|------|-----------------|----------------|
| Work on 2 features | Stash/commit, checkout branch | `cd .worktrees/feature2` |
| AI code review | Push PR, review in same repo | Generate in worktree, review in main |
| Context switch | 30-60 seconds | <1 second |
| Uncommitted changes | Must stash or commit | Stay in worktree |
| Parallel testing | Difficult | Easy (each worktree has its own sandbox) |

### Worktree Commands

**Create a new worktree with auto-generated name:**
```bash
crush-sandbox run --worktree
```

**Create worktree with custom name:**
```bash
crush-sandbox run --worktree feature-login
```

**List all worktrees:**
```bash
crush-sandbox list-worktrees
```

**List all containers:**
```bash
crush-sandbox list-containers
```
This shows all containers for the repository (main + all worktrees) with their status (running/stopped) and current workspace indicator.

**Remove a worktree:**
```bash
crush-sandbox remove-worktree feature-login
```

**Force remove (with uncommitted changes):**
```bash
crush-sandbox remove-worktree feature-login --force
```

## ⚙️ Configuration

The Docker sandbox automatically provides Crush CLI configuration:

### Configuration Sources

**Host configuration** (global defaults):
- `~/.config/crush/` - Global Crush config (read-only mount)
- `~/.local/share/crush/` - Crush session data (read-only mount)

**Workspace configuration** (workspace-specific):
- `.crush.json` or `crush.json` (relative to workspace root)

If you maintain global Crush config with commands, skills, or settings, this will be mounted into the container. Any workspace-specific config will override these settings.
Config files in the workspace are mounted into the container with the rest of the code and take precedence over host config by default in Crush. Make sure to configure your skills
and commands accordingly. If you want to use global configured skills, add the `/tmp/crush-config/merged/skills` path to the skills option in the config (global on host or in workspace) to make Crush pick them up.

### Session Data Mounting

Crush CLI session data (including authentication tokens, model preferences, and other runtime state) is mounted from your host machine into the container.

**Important**: Session data is mounted **read-only** from `~/.local/share/crush/` on your host. This means:

- **Configuration changes made inside the container are lost when the container stops**
  - Tokens and authentication must be completed on the host machine
  - Model preferences and settings should be configured on the host
  - The container only reads pre-authenticated session data

- **Recommended workflow**:
  1. Run Crush CLI on the host machine first: `crush`
  2. Complete authentication and configure your preferences
  3. Run `crush-sandbox run` to use your pre-configured session
  4. Use `--no-host-config` flag to skip host config/session mounting (requires re-authentication each session)

- **Why read-only?**
  - Prevents the AI agent from modifying your authentication tokens
  - Ensures session integrity and security
  - Keeps configuration changes persistent on your host machine

**Example to include skills from global host in the config**:
```json
{
  "$schema": "https://charm.land/crush.json",
  "options": {
    "skills_paths": [
      "~/.config/crush/skills",
      "/tmp/crush-config/merged/skills"
    ]
  }
}
```

With this configuration, you can still use `crush` on your host machine with the same setup.

### Configuration Merge Behavior

1. Host configuration is copied to the container
2. Workspace configuration is mounted with the workspace, **overwriting** host config (Crush default behavior)
3. Host configuration is available at `/tmp/crush-config/merged` inside the container
4. `CRUSH_GLOBAL_CONFIG` environment variable is set to this location

This means workspace-specific settings always override global defaults.

### Security

- All configuration mounts are **read-only** (`:ro` flag)
- The container cannot modify your host configuration files

### Configuration Control Flags

You can control configuration behavior with these flags:

| Flag | Description |
|------|-------------|
| `--no-host-config` | Skip mounting host Crush config directory |

**Examples**:

```bash
# Skip host configuration
crush-sandbox run --no-host-config
# Or use alias:
crushbox run --no-host-config
```

### Configuration Directory Structure Example

```
~/.config/crush/                    # Host configuration (global)
├── crush.json                     # Main Crush config
└── skills                         # Skills directory
└── commands                       # Commands directory
```

If you have a `crush.json` or `.crush.json` already in the workspace root, this will take precedence over the `.config/crush/` directory by Crush CLI's own behavior.

## 📖 Usage

### Start Crush CLI in a sandbox

Navigate to your workspace directory and run:

```bash
crush-sandbox run
```

Or use the alias:

```bash
crushbox run
```

This will:
1. Create (or reuse) a sandbox container for your workspace
2. Mount your workspace at the same absolute path
3. Install Crush CLI if not already installed
4. Install pnpm for package management
5. Start the Crush CLI

### Programmatic Mode

For automation and CI/CD pipelines, you can send prompts directly without interactive mode:

**Using `-p` flag:**
```bash
crush-sandbox run -p "Create a REST API with authentication"
```

**Using piped input:**
```bash
cat "./ralph/prompt.md" | crush-sandbox run
```

**Using heredocs:**
```bash
crush-sandbox run -p "$(cat <<EOF
Create a login form with:
- Email field
- Password field
- Remember me checkbox
- Login button
EOF
)"
```

**With `--quiet` flag (suppresses container setup messages):**
```bash
crush-sandbox run -p "Refactor code" --quiet
```

**With worktree:**
```bash
crush-sandbox run --worktree feature-auth -p "Add OAuth login"
```

#### Programmatic Mode Details

**Detection**: Programmatic mode is automatically enabled when:
- `-p "prompt"` flag is provided (explicit prompt)
- Stdin has piped input (e.g., `echo "prompt" | crush-sandbox run`)

**Priority**: If both `-p` flag and piped input are present, the `-p` value is used (explicit wins).

**Empty prompts**: Empty prompts pass through to Crush CLI without validation. Let Crush CLI handle the empty prompt.

**Multi-line support**: Works with:
- `-p` flag with quoted strings (preserves newlines)
- Heredocs with `-p` flag
- Piped multi-line input

**Quiet mode**: `--quiet` flag suppresses container setup messages in programmatic mode:

Crush CLI output is always visible. Error messages always appear even in quiet mode.

**Flag conflicts**: The `--shell` flag cannot be used with programmatic mode (`-p` flag or piped input).

**Exit codes**: Crush CLI exit codes propagate to script exit for automation scripts.

### Start a debug shell

If you need to debug or run manual commands:

```bash
crush-sandbox run --shell
```

Or with the alias:

```bash
crushbox run --shell
```

This gives you an interactive shell in the sandbox container instead of running Crush CLI.

**Note:** The `--shell` flag cannot be used with `-p` flag or piped input (programmatic mode).

### Clean up the sandbox

To remove the container and cache volume for the current workspace:

```bash
crush-sandbox clean
```

Or with the alias:

```bash
crushbox clean
```

Add `--force` to skip prompts and clean all containers + cache:

```bash
crush-sandbox clean --force
```

### Show version

```bash
crush-sandbox --version
```

### Command Options

| Option | Description |
|--------|-------------|
| `-p "prompt"` | Send prompt directly to Crush CLI (programmatic mode) |
| `--quiet` | Suppress container setup messages in programmatic mode |
| `--shell` | Start interactive shell instead of Crush CLI (for debugging) |
| `--worktree [name]` | Create a worktree with optional name |
| `--branch-name [name]` | Specify branch name for worktree (requires --worktree) |
| `--no-host-config` | Skip mounting host Crush config directory |
| `--cred-scan` | Enable credential scanning before starting container |
| `--force` | Skip confirmation prompts (use with clean and remove-worktree) |
| `--version` | Show version information |

### Update to latest version

```bash
crush-sandbox update
```

This will:
- Check for the latest version on GitHub
- Compare with your current version
- Prompt for confirmation if a newer version is available
- Download and replace the script automatically
- Validate the downloaded script before installing

### Get help

```bash
crush-sandbox help
```

## 🔒 Security

### Security Overview

The docker-sandbox-crush tool implements several security controls to make AI-assisted development safe(er). However, the tool requires you to follow certain security practices to ensure safe operation.
Crush asks for your permission before performing any operation, but if you use `--yolo` mode or use it programmatically with `crush run` in a ralph loop, you must be aware of the security implications.

### Read-Write Workspace Access

The Crush agent inside the container has **full read-write access** to your workspace files. This is intentional and necessary for the agent to:

- Read and modify source code files
- Run build commands and tests
- Create new files and directories
- Install packages and dependencies
- Execute git operations

**Security Implications:**

1. **Trust the AI agent**: The agent can modify any file in your workspace
2. **Credential exposure risk**: Never store secrets (API keys, passwords, tokens) in your workspace files
3. **Review all changes**: Always review agent-generated changes
4. **Use version control**: Git provides a safety net - you can revert any unwanted changes

**Best Practices:**

- Store credentials in:
  - Environment variables
  - Secret management tools
  - CI/CD pipeline secrets (GitHub Actions Secrets, GitLab CI Variables)
  - `.env` files that are gitignored
- Never commit credentials to git
- Use `.gitignore` to exclude files with secrets
- Rotate credentials if they were ever committed accidentally

### Git Branch Protection for Production

When planning to use `--yolo` mode or use it programmatically with `crush run`, you should configure git branch protection to prevent direct pushes to production branches. This ensures:

- All agent-generated code goes through a pull request process
- Code review is required before merging
- CI/CD checks must pass before merging
- Unauthorized direct commits are blocked

### What the Agent Can and Cannot Do

#### Capabilities

The Crush agent inside the sandbox container can:

✅ **Read and write workspace files**
- Full access to all files in the mounted workspace
- Can create, modify, delete any file
- Can execute any command within the workspace

✅ **Run commands and scripts**
- Execute build commands (npm build, cargo build, etc.)
- Run tests (npm test, pytest, etc.)
- Install packages (npm install, pip install, etc.)

✅ **Make git operations**
- Create commits
- Create branches
- Stage files
- Push to remote repositories

✅ **Access network resources**
- Download dependencies from npm, PyPI, etc.
- Make HTTP requests (if in code)
- Clone other git repositories

#### Limitations

The Crush agent cannot:

❌ **Access files outside the workspace**
- Container is limited to mounted workspace directory
- Cannot access your home directory (except workspace subdirectories)
- Cannot access system files or other projects

❌ **Run with elevated privileges**
- Container runs as non-root user
- Cannot install system packages globally
- Cannot modify Docker host

❌ **Escalate privileges**
- Docker capabilities are dropped (except CHOWN and DAC_OVERRIDE)
- Cannot gain root access
- Cannot modify container configuration

❌ **Access host resources directly**
- No direct access to host network
- No access to host filesystem beyond workspace
- Cannot interact with other containers

#### Security Controls in Place

The tool implements these security controls:

1. **Resource limits** - Prevents resource exhaustion attacks:
   - Memory limited to 4GB
   - CPU limited to 2 cores
   - Process count limited to 100 PIDs

2. **Non-root user** - Limits attack surface:
   - Container runs as your UID/GID
   - Cannot perform privileged operations

3. **Capability dropping** - Reduces Linux capabilities:
   - All capabilities dropped by default
   - CHOWN and DAC_OVERRIDE added back (required for cache and workspace access)

4. **Credential scanning** - Warns about exposed secrets:
   - Scans workspace with gitleaks before starting
   - gitleaks is automatically installed when you run `crush-sandbox run --cred-scan`
   - Prompts you to continue or abort if credentials detected
   - Can be bypassed with `--no-cred-scan` flag (use with caution)

5. **Workspace isolation** - Prevents cross-project contamination:
   - Each workspace has its own container
   - Caches are per-workspace
   - No shared state between workspaces

## 🔧 How It Works

### Workspace Isolation

Each workspace directory (main or worktree) gets its own:
- **Container**: Named `crush-sandbox-<repo-hash>` (main) or `crush-sandbox-<repo-hash>-<worktree-name>` (worktree)
- **Cache volume**: Named `crush-cache-<repo-hash>` for persistent package manager caches (shared across all worktrees in same repository)

This means:
- Each worktree has crash isolation (stopping one doesn't affect others)
- All worktrees in same repository share npm/pnpm cache for fast installs
- Different repositories have completely isolated sandbox environments

### Container Lifecycle

1. **Create**: Container is created from `node:18-alpine` base image
2. **Configure**: Workspace and cache volumes are mounted, environment variables are set
3. **Start**: Container is started
4. **Use**: Crush CLI or shell runs inside the container
5. **Stop**: Container is stopped when you exit (kept for reuse)

Containers are **not removed** automatically, so subsequent starts are instant.

### Cache Persistence

The cache volume stores:
- **npm cache**: `/workspace-cache/npm`
- **pnpm store**: `/workspace-cache/pnpm/store`
- **pnpm cache**: `/workspace-cache/pnpm/cache`

This means:
- Packages downloaded once stay cached
- Switching workspaces switches cache volumes
- Faster installs after the first run

### Automatic Tool Installation

On container startup:
1. **Crush CLI**: Installed via `npm install -g @charmland/crush` (cached after first install)
2. **pnpm**: Installed via `npm install -g pnpm` (uses npm cache)

Installation happens automatically and silently on every container start, with fast-path checks to skip re-installation.

## 📋 Examples

### Worktree Examples

#### Example 1: Feature Development Workflow
```bash
# Navigate to your project
cd ~/projects/my-app

# Create worktree for new feature
crush-sandbox run --worktree feature-auth

# Inside Crush CLI, generate authentication code
> Crush: Implement JWT authentication
[AI generates auth system in .worktrees/feature-auth/]

# Switch back to main workspace
cd ~/projects/my-app

# Continue working on main branch
git pull origin main

# Later, review the worktree
cd .worktrees/feature-auth
git diff main  # See all changes from worktree

# When satisfied, merge to main
git checkout main
git merge feature-auth
crush-sandbox remove-worktree feature-auth
```

#### Example 2: Parallel Development
```bash
# Main workspace: stable branch
cd ~/projects/my-app

# Worktree 1: User profile feature
crush-sandbox run --worktree feature-profile
# AI generates user profile code

# Worktree 2: API refactoring
cd ~/projects/my-app
crush-sandbox run --worktree refactor-api
# AI refactors API endpoints

# Worktree 3: Bugfix
cd ~/projects/my-app
crush-sandbox run --worktree fix-auth-bug
# AI fixes authentication bug

# List all worktrees
crush-sandbox list-worktrees

# Worktrees:
#   - /Users/user/projects/my-app/.worktrees/feature-profile
#     Branch: feature/profile
#   - /Users/user/projects/my-app/.worktrees/refactor-api (current)
#     Branch: refactor/api
#   - /Users/user/projects/my-app/.worktrees/fix-auth-bug
#     Branch: fix/auth-bug

# Switch between worktrees instantly (no git checkout needed)
cd ../feature-profile
cd ../fix-auth-bug
```

#### Example 3: Bugfix vs Feature Isolation
```bash
# Main workspace on stable branch (production code)
cd ~/projects/my-app
git checkout main

# Worktree for urgent bugfix (isolated from feature work)
crush-sandbox run --worktree fix-critical-bug
> Crush: Fix the production authentication bug
[AI generates bugfix in isolation]

# Meanwhile, main workspace remains stable
# No risk of accidentally including untested changes

# Test bugfix in its own sandbox
cd .worktrees/fix-critical-bug
npm test  # Run tests in bugfix environment

# Merge only when ready
git checkout main
git merge fix-critical-bug
crush-sandbox remove-worktree fix-critical-bug
```

#### Example 4: AI-Assisted PR Workflow
```bash
# Worktree for Crush-generated PR
cd ~/projects/my-app
crush-sandbox run --worktree pr-add-dashboard

# Crush generates complete feature
> Crush: Add admin dashboard with charts and analytics
[AI creates entire feature in worktree]

# Stay in main workspace to review
cd ~/projects/my-app

# Compare worktree to main
git diff main .worktrees/pr-add-dashboard/

# Test worktree changes
cd .worktrees/pr-add-dashboard
crush-sandbox run --shell  # Debug in worktree sandbox
npm test                   # Run tests

# Review and merge
cd ~/projects/my-app
git checkout -b add-dashboard
git merge pr-add-dashboard
git push origin add-dashboard
crush-sandbox remove-worktree pr-add-dashboard
```

### Programmatic Mode Examples

#### Simple one-liners
```bash
# Generate a component
crush-sandbox run -p "Create a React button component with hover states"

# Add a feature
echo "Add dark mode support" | crush-sandbox run

# Fix a bug
crush-sandbox run -p "Fix the authentication redirect loop"
```

#### CI/CD Pipeline Integration
```bash
#!/bin/bash
# CI/CD pipeline script

# Run automated code generation
crush-sandbox run -p "Add unit tests for user authentication" --quiet

# Run tests
npm test

# If tests pass, commit and push
git add .
git commit -m "Add auth unit tests"
git push origin main
```

#### Multi-command automation
```bash
# Generate multiple components in sequence
for component in Button Input Modal; do
  crush-sandbox run -p "Create a React ${component} component" --quiet
done
```

#### Advanced piping examples
```bash
# Multi-line piped input
echo -e "Fix login bug\nAdd validation\nUpdate tests" | crush-sandbox run

# Heredoc piped input
crush-sandbox run <<EOF
Create a login form with:
- Email field
- Password field
- Remember me checkbox
- Login button
EOF

# Quiet mode with piping
echo "Refactor code" | crush-sandbox run --quiet
```

#### With worktrees
```bash
# Generate code in worktree for review
crush-sandbox run --worktree feature-ui -p "Redesign the user profile page" --quiet

# Review in main workspace
cd ../
# Compare changes
git diff main .worktrees/feature-ui/
```

#### Error handling
```bash
# --shell not allowed with -p
crush-sandbox run --shell -p "test"
# Error: --shell flag cannot be used with -p or piped input

# --shell not allowed with piped input
echo "test" | crush-sandbox run --shell
# Error: --shell flag cannot be used with -p or piped input

# Empty prompt passes through
echo "" | crush-sandbox run
# Executes: crush run "" (Crush CLI handles empty prompt)
```

### Basic Usage Examples

#### Typical workflow
```bash
# Navigate to your project
cd ~/projects/my-app

# Start Crush CLI in sandbox
crush-sandbox run
# Or use alias:
# crushbox run

# ... work with Crush CLI ...

# When done, Crush CLI exits and container stops
# Next time, container is reused (instant start)
```

#### Using with different workspaces
```bash
cd ~/projects/project-a
crush-sandbox run  # Uses crush-sandbox-<hash-a>

cd ~/projects/project-b
crush-sandbox run  # Uses crush-sandbox-<hash-b>
```

Each workspace has its own isolated environment.

#### Debugging setup issues
```bash
# Get a shell to check installation
crush-sandbox run --shell
# Or:
crushbox run --shell

# Inside the container:
which crush          # Check if Crush CLI is installed
pnpm --version       # Check pnpm version
npm --version        # Check npm version
```

## 🐛 Troubleshooting

### "docker daemon is not running or not accessible"

**Problem**: Docker Desktop is not running.

**Solution**: Start Docker Desktop and wait for it to be ready. Verify with:
```bash
docker info
```

### "Git user.name and user.email not configured"

**Problem**: Git user configuration is missing.

**Solution**: This is a warning, not an error. Add to `~/.gitconfig` if Crush CLI needs git operations:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Crush CLI not working in container

**Problem**: Crush CLI installation failed.

**Solution**: Run with `--shell` flag to debug:
```bash
crush-sandbox run --shell
# Then manually install:
npm install -g @charmland/crush
```

### Cache not persisting

**Problem**: Packages are re-downloaded every time.

**Solution**: Verify cache volume exists:
```bash
docker volume ls | grep crush-cache
```

Check if volume is mounted:
```bash
docker inspect <container-name> | grep Mounts
```

### "Cannot write to /usr/local/bin" during install

**Problem**: No write permissions to `/usr/local/bin`.

**Solution**: Run with sudo:
```bash
sudo ./docker-sandbox-crush install
```

Or choose a different installation directory in your PATH.

### Container name changes unexpectedly

**Problem**: Different containers for the same project.

**Solution**: Ensure you're in the same workspace directory. Container names are based on the current working directory (`pwd`).

### "Not in a git repository" when using --worktree

**Problem**: Tried to use worktree features outside a git repository.

**Solution**: Worktrees only work in git repositories. Initialize git first:
```bash
git init
```

### Worktree directory not found

**Problem**: Container starts but worktree path doesn't exist.

**Solution**: Check `.worktrees/` directory in git root:
```bash
ls -la .worktrees/
```

If missing, create a new worktree:
```bash
crush-sandbox run --worktree my-feature
```

### Cannot remove worktree with uncommitted changes

**Problem**: Worktree has uncommitted changes and `remove-worktree` fails.

**Solution**: Use `--force` flag:
```bash
crush-sandbox remove-worktree my-feature --force
```

Or commit/stash changes first:
```bash
cd .worktrees/my-feature
git add .
git commit -m "Save work"
cd ..
crush-sandbox remove-worktree my-feature
```

### Container/volume mismatch with worktree

**Problem**: Container uses root workspace name instead of worktree name.

**Solution**: This is expected behavior! Containers and caches are named based on the **root git workspace**, not the current worktree path. All worktrees in the same project share the same container and cache. This is intentional - it allows fast switching between worktrees without recreating containers.

### Branch conflicts when creating worktree

**Problem**: Git error "Branch already checked out elsewhere" when creating worktree.

**Solution**: The branch is already checked out in another worktree or the main workspace. Either:
- Use a different branch: `crush-sandbox run --worktree feature2 other-branch`
- Switch main workspace to a different branch first
- Remove the worktree that has the branch: `crush-sandbox remove-worktree other-worktree`

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 🙋 Support

If you encounter issues or have questions:
1. Check the [Troubleshooting](#-troubleshooting) section above
2. Search existing [GitHub Issues](https://github.com/wireless25/crush-sandbox/issues)
3. [Open a new issue](https://github.com/wireless25/crush-sandbox/issues/new) with details

## 🔗 Related

- [Crush CLI](https://github.com/charmbracelet/crush) - The AI-powered CLI assistant
- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop) - Container runtime

---

Made with ❤️ for developers who love isolated environments
