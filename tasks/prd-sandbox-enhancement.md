# PRD: Enhanced Docker Sandbox with Crush CLI and Cache Persistence

## Introduction

Enhance the existing docker-sandbox-crush wrapper to automatically install and configure the Crush CLI in the sandbox container, along with providing package manager cache persistence. This will create a seamless developer experience where tools are pre-installed, caches persist between runs, and the sandbox feels like a native development environment.

## Goals

- Automatically install Crush CLI in sandbox containers on first startup
- Pre-install minimal essential utilities (npm, pnpm only)
- Persist package manager caches per workspace for faster subsequent runs
- Provide seamless developer experience with minimal manual setup
- Keep implementation simple using existing base image and startup scripts

## User Stories

### US-001: Create per-workspace cache volume
**Description:** As a developer, I want the sandbox to have a dedicated cache volume per workspace so my package manager caches persist between sessions and improve startup speed.

**Acceptance Criteria:**
- [x] Tool creates a named Docker volume for each workspace on first run
- [x] Volume name follows pattern: `crush-cache-<workspace-hash>`
- [x] Volume is mounted in container at `/workspace-cache`
- [x] Cache volume persists even after container is stopped/removed
- [x] Volume is reused when container is recreated
- [x] Typecheck/lint passes

### US-002: Configure npm cache directory
**Description:** As a developer, I want npm to use the persistent cache volume so packages downloaded in one session are available in the next session.

**Acceptance Criteria:**
- [x] npm cache directory is set to `/workspace-cache/npm` via npm config
- [x] npm config is set during container creation/startup
- [x] npm cache persists across container restarts
- [x] npm cache is shared across all npm installs in the workspace
- [x] Typecheck/lint passes

### US-003: Configure pnpm cache directory
**Description:** As a developer, I want pnpm to use the persistent cache volume so packages are cached between sessions.

**Acceptance Criteria:**
- [x] pnpm cache directory is set to `/workspace-cache/pnpm` via pnpm config
- [x] pnpm config is set during container creation/startup
- [x] pnpm cache persists across container restarts
- [x] pnpm cache is shared across all pnpm installs in the workspace
- [x] Typecheck/lint passes

### US-004: Pre-install npm package manager
**Description:** As a developer, I want npm to be available in the sandbox so I can install Node.js dependencies without any setup.

**Acceptance Criteria:**
- [x] npm is pre-installed (comes with base node:18-alpine image)
- [x] npm is available in PATH from container startup
- [x] npm version is displayed on container start for verification
- [x] Typecheck/lint passes

### US-005: Pre-install pnpm package manager
**Description:** As a developer, I want pnpm to be available in the sandbox so I can use it as an alternative package manager without manual installation.

**Acceptance Criteria:**
- [x] pnpm is installed during container startup via npm global install
- [x] pnpm is available in PATH from container startup
- [x] pnpm installation is cached to avoid re-installing on every container start
- [x] pnpm version is displayed on container start for verification
- [x] Typecheck/lint passes

### US-006: Create Crush CLI startup script with caching
**Description:** As a developer, I want Crush CLI to be automatically installed in the sandbox with caching so it's available on first use without manual installation, but doesn't slow down subsequent startups.

**Acceptance Criteria:**
- [x] Startup script is created inside container at `/usr/local/bin/setup-crush.sh`
- [x] Script checks if Crush CLI is already installed and skips if present
- [x] If not installed, script installs Crush CLI via `npm install -g @charmland/crush`
- [x] Crush CLI installation uses the npm cache for faster installs
- [x] Installation success/failure is logged with clear messages
- [x] Typecheck/lint passes

### US-007: Execute Crush CLI setup script on container start
**Description:** As a developer, I want the Crush CLI setup script to run automatically when the container starts so Crush CLI is always available without manual intervention.

**Acceptance Criteria:**
- [x] Setup script is executed during container startup (before user gets shell)
- [x] Setup script runs silently on success (no noise in output)
- [x] Errors from setup script are displayed to user
- [x] User shell is only started after setup completes successfully
- [x] Setup is skipped if Crush CLI is already installed (fast path)
- [x] Typecheck/lint passes

### US-008: Update container creation to mount cache volume
**Description:** As a developer, I want the cache volume to be mounted in the container when it's created so all package manager operations use the persistent cache.

**Acceptance Criteria:**
- [ ] Container creation includes volume mount for workspace cache
- [ ] Cache volume is mounted at `/workspace-cache`
- [ ] Volume mount is added to existing `docker create` arguments
- [ ] Cache volume is created if it doesn't exist
- [ ] Typecheck/lint passes

### US-009: Run Crush CLI by default instead of interactive shell
**Description:** As a developer, I want Crush CLI to start automatically when I run the sandbox so I don't have to manually invoke it every time.

**Acceptance Criteria:**
- [ ] Container startup executes Crush CLI instead of `/bin/sh`
- [ ] Crush CLI is launched with appropriate flags for interactive use
- [ ] If Crush CLI is not installed, error message directs user to check logs
- [ ] Container exits when Crush CLI exits
- [ ] Fallback to shell option available via `--shell` flag for debugging
- [ ] Typecheck/lint passes

### US-010: Add `--shell` flag for debugging
**Description:** As a developer, I want to be able to get an interactive shell instead of running Crush CLI so I can debug setup issues or run manual commands.

**Acceptance Criteria:**
- [ ] Tool accepts `--shell` flag with `run` command
- [ ] When `--shell` is set, container starts with `/bin/sh` instead of Crush CLI
- [ ] `--shell` flag is documented in help output
- [ ] Typecheck/lint passes

### US-011: Clean command should also remove cache volume
**Description:** As a developer, I want the `clean` command to remove the cache volume so I can completely reset the sandbox environment including caches.

**Acceptance Criteria:**
- [ ] `clean` command removes the cache volume for the current workspace
- [ ] Cache volume removal happens after container removal
- [ ] Clean command confirms cache volume removal (or requires --force)
- [ ] Error if cache volume doesn't exist (non-fatal)
- [ ] Typecheck/lint passes

## Functional Requirements

- FR-1: Tool must create a named Docker volume per workspace for caches
- FR-2: Cache volume name must follow pattern `crush-cache-<workspace-hash>`
- FR-3: Cache volume must be mounted at `/workspace-cache` in container
- FR-4: npm cache must be configured to use `/workspace-cache/npm`
- FR-5: pnpm must be installed and its cache configured to use `/workspace-cache/pnpm`
- FR-6: Crush CLI must be installed via startup script with existence check
- FR-7: Crush CLI installation must use npm global install with cache
- FR-8: Crush CLI must launch automatically on container start
- FR-9: Startup must be fast on subsequent runs (skip install if already installed)
- FR-10: Tool must accept `--shell` flag to bypass Crush CLI and get a shell
- FR-11: Clean command must remove both container and cache volume
- FR-12: All cache operations must be isolated per workspace

## Non-Goals (Out of Scope)

- Shared cache across multiple workspaces (intentionally isolated)
- Pre-installing other dev tools beyond npm/pnpm
- Custom Docker image builds
- Automatic Crush CLI updates (manual via clean + new container)
- Configuration for cache directory paths
- Cache size limits or cleanup
- Multiple Crush CLI versions
- Container orchestration or multi-container setups

## Design Considerations

- Use per-workspace volumes for cache isolation
- Startup script should be idempotent (safe to run multiple times)
- Fast path for already-installed Crush CLI (check existence before install)
- Cache volumes use workspace hash for consistent naming with containers
- Error messages should be actionable (e.g., "Run with --shell to debug")
- Keep base image unchanged (node:18-alpine) - no custom images needed

## Technical Considerations

- npm comes pre-installed with node:18-alpine image
- pnpm install: `npm install -g pnpm` (installs to npm global cache)
- Crush CLI install: `npm install -g @charmbracelet/crush-cli`
- Cache config:
  - npm: `npm config set cache /workspace-cache/npm`
  - pnpm: `pnpm config set store-dir /workspace-cache/pnpm/store` and `pnpm config set cache-dir /workspace-cache/pnpm/cache`
- Startup script path: `/usr/local/bin/setup-crush.sh` (or injected via entrypoint)
- Volume naming consistency: use same hash function as container name
- pnpm store structure: separate store-dir and cache-dir for full caching

## Success Metrics

- Developer can run `docker-sandbox-crush run` and immediately get Crush CLI prompt
- Second startup is fast (< 2 seconds) after first install
- npm and pnpm caches work across container restarts
- `docker-sandbox-crush run --shell` provides a shell with npm/pnpm available
- Cache volumes are properly isolated per workspace

## Open Questions

- Should Crush CLI auto-update check be added on startup? (Probably not in scope)
- What happens if Crush CLI installation fails? (Should fail container start with clear error)
- Should we add a `status` command to show cache volume size? (Nice to have, not critical)
- Should we validate Crush CLI is available before running, or let it fail naturally?
