# PRD: Crush Configuration for Docker Sandbox

## Introduction

Users need to provide Crush CLI configuration to the Docker sandbox container securely. Configuration includes authentication tokens, API keys, workspace-specific settings, and environment-specific configuration. The solution must mount configuration files in a read-only manner from two sources (host's Crush installation folder), and inject sensitive values as environment variables instead of file mounts.

## Goals

- Enable Crush CLI in the container to access user's configuration securely
- Support multiple configuration types: authentication, settings, and environment config
- Provide flexible configuration from host source
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

### US-003: Mount host configuration read-only into container
**Description:** As a developer, I need to mount the host's Crush configuration directory as read-only inside the container at a standard location.

**Acceptance Criteria:**
- [x] Add Docker volume mount flag: `-v ${host_config_path}:/host-crush-config:ro`
- [x] Mount point `/host-crush-config` is consistent and predictable
- [x] Mount is read-only (`:ro` flag) to prevent container from modifying host files
- [x] Only add mount flag if host config directory exists and is readable
- [x] Test that files inside `/host-crush-config` are not writable from within container

### US-006: Set CRUSH_GLOBAL_CONFIG environment variable
**Description:** As the Crush CLI container entry point, I need to set an environment variable pointing to the merged configuration so Crush CLI can find it.

**Acceptance Criteria:**
- [x] Export `CRUSH_GLOBAL_CONFIG=/tmp/crush-config/merged` environment variable
- [x] Variable is set before executing Crush CLI command
- [x] Variable persists for the entire container session
- [x] Test that Crush CLI can read config from this location

### US-008: Add CLI flags to control configuration sources
**Description:** As a user, I want to control which configuration sources are used so I can debug or override default behavior.

**Acceptance Criteria:**
- [x] Add `--no-host-config` flag to skip mounting host Crush config
- [x] Flags work independently and can be combined
- [x] Help text updated to document new flags

### US-009: Document configuration behavior in README
**Description:** As a user, I want clear documentation on how configuration is provided to the container so I can set it up correctly.

**Acceptance Criteria:**
- [x] Add section "Configuration" to README.md
- [x] Document default config locations: `~/.config/crush/`
- [x] Document read-only mount security
- [x] Provide examples of config directory structure
- [x] List all CLI flags for controlling configuration

## Functional Requirements

- FR-1: Detect Crush config from `~/.config/crush/` in priority order
- FR-3: Mount host config to `/host-crush-config:ro` in container if exists and readable
- FR-5: config source to `/tmp/crush-config/merged/`
- FR-6: Set `CRUSH_GLOBAL_CONFIG=/tmp/crush-config/merged` environment variable for Crush CLI
- FR-9: Support `--no-host-config` CLI flag
- FR-10: Log all configuration operations (source detection, merging)

## Non-Goals

- No automatic configuration generation or validation
- No configuration migration or version compatibility handling
- No configuration encryption or secrets management integration
- No UI or interactive setup for configuration
- No per-container configuration persistence (config re-read on each start)

## Design Considerations

- **Security**: All mounts are read-only to prevent container from modifying host files
- **Isolation**: Per-workspace configuration
- **Flexibility**: Support any file format (Crush can interpret its own config)
- **Fallback**: Graceful degradation if config sources are missing (log warnings, continue)

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
- Configuration setup requires no additional steps beyond standard Crush config
- Startup time increased by less than 2 seconds for configuration merge
