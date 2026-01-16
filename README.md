# Docker Sandbox Crush

A lightweight bash wrapper that runs the [Crush CLI](https://github.com/charmbracelet/crush) in a Docker sandbox with persistent package manager caches. Perfect for isolating your development environment while keeping tools and dependencies cached per workspace.

## 🚀 Quick Start

### Prerequisites

- **macOS** (primary target)
- **Docker Desktop** installed and running

### Installation

#### One-command installation (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/docker-sandbox-crush > /dev/null
sudo chmod +x /usr/local/bin/docker-sandbox-crush
```

#### Manual installation

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
   sudo mv docker-sandbox-crush /usr/local/bin/
   ```

#### Install using the script itself

If you've cloned the repository, you can use the built-in install command:

```bash
./docker-sandbox-crush install
```

This will:
- Validate Docker is available
- Install the script to `/usr/local/bin/docker-sandbox-crush`
- Display version information for installed tools

**Note:** gitleaks Docker image will be pulled automatically on first use for credential scanning. No additional installation is required.

## ✨ Features

- **Workspace isolation**: Each workspace directory gets its own sandbox container
- **Persistent caches**: npm and pnpm caches persist per workspace for faster subsequent runs
- **Automatic Crush CLI installation**: Crush CLI is installed automatically on first use
- **Git config injection**: Your Git user.name and user.email are passed into the container
- **Container reuse**: Containers are stopped but not removed, enabling fast restarts
- **Debugging support**: Use `--shell` flag to get an interactive shell instead of Crush CLI
- **Configuration support**: Automatically mounts and merges Crush configuration from host

## ⚙️ Configuration

The Docker sandbox automatically provides Crush CLI configuration:

### Configuration Sources

**Host configuration** (global defaults):
- `~/.config/crush/`

**Workspace configuration** (workspace-specific):
- `.crush.json` or `crush.json` (relative to workspace root)

If you maintain global Crush config with commands, skills, or settings, this will be mounted into the container. Any workspace-specific config will override these settings.
Config files in the workspace are mounted into the container with the rest of the code and take precedence over host config by default in Crush. Make sure to configure your skills
and commands accordingly. If you want to use global configured skills, add the `/tmp/crush-config/merged/skills` path to the skills option in the config (global on host or in workspace) to make Crush pick them up.

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
docker-sandbox-crush run --no-host-config
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
docker-sandbox-crush run
```

This will:
1. Create (or reuse) a sandbox container for your workspace
2. Mount your workspace at the same absolute path
3. Install Crush CLI if not already installed
4. Install pnpm for package management
5. Start the Crush CLI

### Start a debug shell

If you need to debug or run manual commands:

```bash
docker-sandbox-crush run --shell
```

This gives you an interactive shell in the sandbox container instead of running Crush CLI.

### Clean up the sandbox

To remove the container and cache volume for the current workspace:

```bash
docker-sandbox-crush clean
```

Add `--force` to skip confirmation:

```bash
docker-sandbox-crush clean --force
```

### Show version

```bash
docker-sandbox-crush --version
```

### Update to latest version

```bash
docker-sandbox-crush update
```

This will:
- Check for the latest version on GitHub
- Compare with your current version
- Prompt for confirmation if a newer version is available
- Download and replace the script automatically
- Validate the downloaded script before installing

### Get help

```bash
docker-sandbox-crush --help
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
   - gitleaks is automatically installed when you run `docker-sandbox-crush run --cred-scan`
   - Prompts you to continue or abort if credentials detected
   - Can be bypassed with `--no-cred-scan` flag (use with caution)

5. **Workspace isolation** - Prevents cross-project contamination:
   - Each workspace has its own container
   - Caches are per-workspace
   - No shared state between workspaces

## 🔧 How It Works

### Workspace Isolation

Each workspace directory (your current working directory) gets its own:
- **Container**: Named `crush-sandbox-<hash>` where `<hash>` is derived from your workspace path
- **Cache volume**: Named `crush-cache-<hash>` for persistent package manager caches

This means different projects have completely isolated sandbox environments.

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

### Typical workflow

```bash
# Navigate to your project
cd ~/projects/my-app

# Start Crush CLI in sandbox
docker-sandbox-crush run

# ... work with Crush CLI ...

# When done, Crush CLI exits and container stops
# Next time, container is reused (instant start)
```

### Using with different workspaces

```bash
cd ~/projects/project-a
docker-sandbox-crush run  # Uses crush-sandbox-<hash-a>

cd ~/projects/project-b
docker-sandbox-crush run  # Uses crush-sandbox-<hash-b>
```

Each workspace has its own isolated environment.

### Debugging setup issues

```bash
# Get a shell to check installation
docker-sandbox-crush run --shell

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
docker-sandbox-crush run --shell
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
