# PRD: Docker Sandbox for Crush CLI

## Introduction

Create a simple wrapper tool that allows running the Crush CLI agent in a Docker sandbox on macOS. This provides the same security isolation benefits as Docker's sandbox feature but specifically for the Crush CLI agent, keeping the implementation minimal and focused.

## Goals

- Allow running Crush CLI in a Docker container with workspace mounted at same absolute path
- Reuse existing containers per workspace directory (one sandbox per workspace)
- Inject Git user configuration from host into container
- Keep the tool minimal - only the bare minimum functionality needed

## User Stories

### US-001: Parse CLI arguments and validate environment
**Description:** As a developer, I want the tool to accept CLI arguments and check that Docker is available so it fails fast with a clear error message.

**Acceptance Criteria:**
- [x] Tool accepts a single subcommand: `run`
- [x] Tool validates Docker daemon is running and accessible
- [x] Tool validates Docker CLI is installed
- [x] If Docker is not available, tool exits with clear error message
- [x] Typecheck/lint passes

### US-002: Get current working directory and Git config
**Description:** As a developer, I want the tool to discover the current workspace path and Git user configuration so the container can be properly configured.

**Acceptance Criteria:**
- [x] Tool retrieves current working directory absolute path
- [x] Tool attempts to read Git `user.name` from `~/.gitconfig`
- [x] Tool attempts to read Git `user.email` from `~/.gitconfig`
- [x] Missing Git config is not an error (optional, warn only)
- [x] Typecheck/lint passes

### US-003: Determine sandbox container name
**Description:** As a developer, I want a predictable container name based on the workspace directory so containers can be reused per workspace.

**Acceptance Criteria:**
- [x] Container name is derived from workspace directory (e.g., hash or normalized path)
- [x] Same workspace always produces same container name
- [x] Container name is a valid Docker container name (no special characters)
- [x] Typecheck/lint passes

### US-004: Check if sandbox container already exists
**Description:** As a developer, I want to check if a container already exists for this workspace to decide whether to reuse or create it.

**Acceptance Criteria:**
- [ ] Tool queries Docker to check if container with the sandbox name exists
- [ ] Returns boolean indicating existence
- [ ] Does not fail if container doesn't exist
- [ ] Typecheck/lint passes

### US-005: Create new sandbox container
**Description:** As a developer, I want to create a new container with the Crush CLI environment when one doesn't exist for this workspace.

**Acceptance Criteria:**
- [ ] Container is created from a base image (e.g., `node:18-alpine` or similar suitable for Crush)
- [ ] Current working directory is mounted at the same absolute path (read/write)
- [ ] Git user.name and user.email are passed as environment variables if available
- [ ] Container is created in stopped state (not started yet)
- [ ] Container name matches the deterministic naming scheme
- [ ] Typecheck/lint passes

### US-006: Start sandbox container and run Crush CLI
**Description:** As a developer, I want the tool to start the sandbox container and execute the Crush CLI inside it.

**Acceptance Criteria:**
- [ ] Container is started (or restarted if it was stopped)
- [ ] Crush CLI is executed inside the container with a default command (e.g., interactive shell)
- [ ] Current working directory in container matches the mounted workspace path
- [ ] Container attaches to current terminal/stdin/stdout/stderr
- [ ] When Crush exits, container is stopped (but not removed for reuse)
- [ ] Typecheck/lint passes

### US-007: Handle container cleanup (optional command)
**Description:** As a developer, I want to be able to remove the sandbox container to reset the environment.

**Acceptance Criteria:**
- [ ] Tool accepts `clean` or `reset` subcommand
- [ ] Stops the sandbox container if running
- [ ] Removes the sandbox container
- [ ] Confirm before deletion or require `--force` flag
- [ ] Typecheck/lint passes

## Functional Requirements

- FR-1: Tool must be a CLI executable named `docker-sandbox-crush` or similar
- FR-2: Tool must accept `run` subcommand to launch the sandboxed agent
- FR-3: Tool must validate Docker availability before proceeding
- FR-4: Tool must determine a unique, deterministic container name per workspace directory
- FR-5: Tool must check if a container for this workspace already exists
- FR-6: Tool must create a new container if one doesn't exist, with workspace mounted at same absolute path
- FR-7: Tool must inject Git user.name and user.email as environment variables if available
- FR-8: Tool must start the container and execute Crush CLI inside it
- FR-9: Tool must reuse existing containers per workspace (one sandbox per workspace)
- FR-10: Tool must stop (but not remove) container when agent exits, to allow reuse
- FR-11: Tool must provide a `clean` subcommand to remove the sandbox container

## Non-Goals (Out of Scope)

- Authentication handling - users must manage their own Crush CLI authentication
- Credential storage in Docker volumes
- Support for multiple agents (only Crush CLI)
- Custom agent configuration or templates
- Volume mounting beyond the workspace directory
- Docker access from inside the sandbox
- Environment variable configuration beyond Git config
- Custom container images or templates
- Container status commands
- Linux or Windows support (macOS only)

## Design Considerations

- Use a simple shell script or minimal Go/Bun executable
- Container naming: use a hash of the workspace directory for uniqueness
- Base image: choose a minimal Alpine-based image with necessary dependencies for Crush CLI
- Error messages should be clear and actionable
- Tool should fail fast with helpful errors (Docker not running, invalid directory, etc.)

## Technical Considerations

- Crush CLI is typically a Node.js-based tool, so use a Node.js base image
- Workspace mounting must use the same absolute path on both host and container (macOS handles this well)
- Container lifecycle: create → start → attach → stop → reuse
- Git config is optional - don't fail if missing
- Only support macOS (Linux Docker Desktop path mapping works differently)

## Success Metrics

- Developer can run `docker-sandbox-crush run` in any directory and get a working Crush CLI session
- Containers are reused correctly for the same workspace directory
- Workspace files are synchronized between host and container
- Tool provides clear error messages when Docker is unavailable

## Open Questions

- What base image and tag should be used? (e.g., `node:18-alpine`, `node:20-alpine`, or a custom image?)
- What is the exact Crush CLI command to run? (e.g., interactive mode vs. accepting a command?)
- Should we validate that Crush CLI is installed in the base image, or let the user ensure it's there?
- What should the default entrypoint be - a shell or the Crush CLI binary directly?
