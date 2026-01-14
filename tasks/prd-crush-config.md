# PRD: Crush Configuration for Docker Sandbox

## Introduction

Users need to provide Crush CLI configuration to the Docker sandbox container securely. Configuration includes authentication tokens, API keys, workspace-specific settings, and environment-specific configuration. The solution must mount configuration files in a read-only manner from two sources (host's Crush installation and worktree folder), merge them with worktree taking precedence, and inject sensitive values as environment variables instead of file mounts.

## Goals

- Enable Crush CLI in the container to access user's configuration securely
- Support multiple configuration types: authentication, settings, and environment config
- Provide flexible configuration merging from host and worktree sources
- Ensure sensitive values are not exposed via file mounts
- Maintain per-workspace isolation while allowing global defaults

## User Stories

### US-001: Discover and validate host Crush configuration location
**Description:** As a developer, I need to identify the host's Crush configuration directory so it can be mounted read-only into the container.

**Acceptance Criteria:**
- [x] Detect Crush config location using standard paths: `~/.config/crush/` or `~/.crush/`
- [x] Validate that the config directory exists and is readable
- [x] Log a warning if host config directory doesn't exist (but continue execution)
- [x] Fail if config directory exists but is not readable (permission error)
- [x] Store validated path in a variable for use in Docker mount commands

### US-002: Discover and validate worktree Crush configuration location
**Description:** As a developer, I need to identify a Crush configuration folder within the worktree so workspace-specific settings can override host defaults.

**Acceptance Criteria:**
- [x] Check for worktree config at `.config/crush/` (relative to workspace root)
- [x] Log a warning if worktree config directory doesn't exist (but continue execution)
- [x] Fail if worktree config directory exists but is not readable (permission error)
- [x] Store validated path in a variable for use in Docker mount commands

### US-003: Mount host configuration read-only into container
**Description:** As a developer, I need to mount the host's Crush configuration directory as read-only inside the container at a standard location.

**Acceptance Criteria:**
- [x] Add Docker volume mount flag: `-v ${host_config_path}:/host-crush-config:ro`
- [x] Mount point `/host-crush-config` is consistent and predictable
- [x] Mount is read-only (`:ro` flag) to prevent container from modifying host files
- [x] Only add mount flag if host config directory exists and is readable
- [x] Test that files inside `/host-crush-config` are not writable from within container

### US-004: Mount worktree configuration read-only into container
**Description:** As a developer, I need to mount the worktree's Crush configuration directory as read-only inside the container at a standard location.

**Acceptance Criteria:**
- [ ] Add Docker volume mount flag: `-v ${worktree_config_path}:/worktree-crush-config:ro`
- [ ] Mount point `/worktree-crush-config` is consistent and predictable
- [ ] Mount is read-only (`:ro` flag) to prevent container from modifying workspace files
- [ ] Only add mount flag if worktree config directory exists and is readable
- [ ] Test that files inside `/worktree-crush-config` are not writable from within container

### US-005: Merge configuration from both sources with worktree precedence
**Description:** As the Crush CLI container entry point, I need to merge configuration from host and worktree sources so worktree values override host values.

**Acceptance Criteria:**
- [ ] Create a startup script `/usr/local/bin/setup-crush-config.sh` that runs before Crush CLI
- [ ] Copy host config from `/host-crush-config` to `/tmp/crush-config/merged/` if it exists
- [ ] Copy worktree config from `/worktree-crush-config` to `/tmp/crush-config/merged/` overwriting any files from host config
- [ ] Create target directory `/tmp/crush-config/merged/` if it doesn't exist
- [ ] Log which configuration files were merged (host vs worktree)
- [ ] Skip merge if neither source exists (no config to provide)

### US-006: Set CRUSH_GLOBAL_CONFIG environment variable
**Description:** As the Crush CLI container entry point, I need to set an environment variable pointing to the merged configuration so Crush CLI can find it.

**Acceptance Criteria:**
- [ ] Export `CRUSH_GLOBAL_CONFIG=/tmp/crush-config/merged` environment variable
- [ ] Variable is set before executing Crush CLI command
- [ ] Variable persists for the entire container session
- [ ] Test that Crush CLI can read config from this location

### US-007: Extract and inject sensitive values as environment variables
**Description:** As a developer, I need to extract sensitive configuration values (tokens, API keys) from config files and inject them as environment variables instead of exposing via file mounts.

**Acceptance Criteria:**
- [ ] Detect files matching pattern `*.secrets`, `*.env`, or files containing `secret`, `token`, `key`, `password` in filename
- [ ] Parse key-value pairs from detected files (support `KEY=VALUE` format, JSON, YAML)
- [ ] Convert file-based secrets to environment variables (e.g., file content becomes variable value)
- [ ] Inject variables into container via `-e` flags in `docker exec` command
- [ ] Log warning for unsupported secret file formats (skip those files)
- [ ] Support both host and worktree secret files (worktree takes precedence)

### US-008: Add CLI flags to control configuration sources
**Description:** As a user, I want to control which configuration sources are used so I can debug or override default behavior.

**Acceptance Criteria:**
- [ ] Add `--no-host-config` flag to skip mounting host Crush config
- [ ] Add `--no-worktree-config` flag to skip mounting worktree Crush config
- [ ] Add `--config-path <path>` flag to specify custom config directory (overrides auto-detection)
- [ ] Add `--secrets-only` flag to only mount secrets as env vars, skip file mounts
- [ ] Flags work independently and can be combined
- [ ] Help text updated to document new flags

### US-009: Document configuration behavior in README
**Description:** As a user, I want clear documentation on how configuration is provided to the container so I can set it up correctly.

**Acceptance Criteria:**
- [ ] Add section "Configuration" to README.md
- [ ] Document default config locations: `~/.config/crush/` or `~/.crush/`
- [ ] Document worktree config locations: `.crush/` or `.config/crush/`
- [ ] Explain merge behavior (worktree overrides host)
- [ ] Document read-only mount security
- [ ] Document environment variable injection for secrets
- [ ] Provide examples of config directory structure
- [ ] List all CLI flags for controlling configuration

## Functional Requirements

- FR-1: Detect Crush config from `~/.config/crush/` or `~/.crush/` in priority order
- FR-2: Detect worktree config from `.crush/` or `.config/crush/` (relative to workspace) in priority order
- FR-3: Mount host config to `/host-crush-config:ro` in container if exists and readable
- FR-4: Mount worktree config to `/worktree-crush-config:ro` in container if exists and readable
- FR-5: Merge both config sources to `/tmp/crush-config/merged/` with worktree taking precedence
- FR-6: Set `CRUSH_GLOBAL_CONFIG=/tmp/crush-config/merged` environment variable for Crush CLI
- FR-7: Extract secrets from files matching `*.secrets`, `*.env`, or containing `secret`/`token`/`key`/`password` in filename
- FR-8: Inject secrets as environment variables via Docker `-e` flags
- FR-9: Support `--no-host-config`, `--no-worktree-config`, `--config-path`, `--secrets-only` CLI flags
- FR-10: Log all configuration operations (source detection, merging, secret extraction)

## Non-Goals

- No automatic configuration generation or validation
- No configuration migration or version compatibility handling
- No configuration encryption or secrets management integration
- No UI or interactive setup for configuration
- No per-container configuration persistence (config re-read on each start)

## Design Considerations

- **Security**: All mounts are read-only to prevent container from modifying host files
- **Isolation**: Per-workspace configuration via worktree-specific mounts
- **Flexibility**: Support any file format (Crush can interpret its own config)
- **Fallback**: Graceful degradation if config sources are missing (log warnings, continue)
- **Precedence**: Clear rule that worktree config always overrides host config

## Technical Considerations

- Bash script runs in user context (no Docker privileges required)
- Config detection uses `test -d` and `test -r` for validation
- Secret file parsing uses basic `grep`, `awk`, or `jq` for JSON/YAML
- Merge uses `cp -r` to copy files (format-agnostic)
- Environment variable injection uses `-e KEY=VALUE` Docker flags
- Docker exec command may exceed shell argument limits if too many env vars (use `--env-file` if needed)

## Success Metrics

- Users can run Crush CLI in container with their existing configuration unchanged
- Secrets are never exposed via file mounts (only via environment variables)
- Worktree-specific config overrides host config without manual intervention
- Configuration setup requires no additional steps beyond standard Crush config
- Startup time increased by less than 2 seconds for configuration merge

## Open Questions

- Should we support extracting secrets from JSON/YAML nested structures, or only flat key-value pairs?
- What is the maximum number of environment variables we can inject via `-e` flags before hitting Docker limits?
- Should we copy configuration files on every container start, or only if merged directory is missing/stale?
- How should we handle config file name collisions between host and worktree (currently: worktree overwrites)?
