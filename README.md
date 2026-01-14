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

This will validate Docker is available and install the script to `/usr/local/bin/docker-sandbox-crush`.

## ✨ Features

- **Workspace isolation**: Each workspace directory gets its own sandbox container
- **Persistent caches**: npm and pnpm caches persist per workspace for faster subsequent runs
- **Automatic Crush CLI installation**: Crush CLI is installed automatically on first use
- **Git config injection**: Your Git user.name and user.email are passed into the container
- **Container reuse**: Containers are stopped but not removed, enabling fast restarts
- **Debugging support**: Use `--shell` flag to get an interactive shell instead of Crush CLI

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

### Get help

```bash
docker-sandbox-crush --help
```

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
