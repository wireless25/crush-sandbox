# PRD: Enhanced Logging System

## Introduction

Enhance the logging output of docker-sandbox-crush to provide a more beautiful, clear, and visually appealing experience for startup messages and status updates. The enhanced logging will use bold, high-contrast colors optimized for dark mode terminals, consistent spacing, and visual symbols to create a professional and polished CLI experience.

## Goals

- Improve visual clarity of startup messages and status updates with vibrant, high-contrast colors
- Add consistent spacing and visual hierarchy to logging output
- Incorporate visual symbols/icons for quick scanning of log levels
- Create a polished, professional CLI appearance optimized for dark mode
- Maintain backward compatibility (colors work with NO_COLOR flag)

## User Stories

### US-001: Define enhanced color palette with high-contrast colors
**Description:** As a developer, I need a vibrant, high-contrast color palette optimized for dark mode terminals so that logs are visually striking and easy to read.

**Acceptance Criteria:**
- [ ] Define color variables with ANSI codes: GREEN (success), RED (error), YELLOW (warning), BLUE (info), MAGENTA (header), CYAN (accent), GRAY (dim)
- [ ] Use bold modifier (`\033[1m`) for high-contrast appearance
- [ ] Keep NO_COLOR compatibility (colors disabled when NO_COLOR is set or not a TTY)
- [ ] Colors work on most terminal emulators (macOS Terminal, iTerm2, Linux terminals)

### US-002: Add visual icons/symbols to log level helpers
**Description:** As a user, I want to see clear visual icons next to each log message so I can quickly identify success, errors, warnings, and information.

**Acceptance Criteria:**
- [ ] Update `print_success()` to include ✓ icon (green checkmark)
- [ ] Update `print_error()` to include ✗ icon (red cross)
- [ ] Update `print_warning()` to include ⚠ icon (yellow warning)
- [ ] Update `print_info()` to include → icon (cyan arrow)
- [ ] Add `print_header()` function with a horizontal separator line (├──)
- [ ] Add `print_section()` function for major sections with box-drawing characters

### US-003: Add section headers with visual separators
**Description:** As a user, I want clearly marked sections in the startup output so I can understand the flow of operations.

**Acceptance Criteria:**
- [ ] Add section header for "Environment Setup" section (workspace, container, cache volume)
- [ ] Add section header for "Configuration" section (git config, host config)
- [ ] Add section header for "Container Management" section (creation/reuse, starting)
- [ ] Add section header for "Package Management" section (npm, pnpm installation/versions)
- [ ] Add section header for "Session" section (starting Crush CLI, stopping container)
- [ ] Each section header uses box-drawing characters (┌──, ├──, └──) or bold text with separator line
- [ ] Section headers are spaced with blank line before and after

### US-004: Enhance startup sequence status messages
**Description:** As a user, I want status messages to use consistent formatting with icons, colors, and alignment so the startup process is clear and professional.

**Acceptance Criteria:**
- [ ] Replace plain "Workspace: $workspace" with styled version using print_info
- [ ] Replace "Container name: $container_name" with styled version using print_info
- [ ] Replace "Cache volume: $cache_volume_name" with styled version using print_info
- [ ] Replace "Creating new container" with print_success or print_info with icon
- [ ] Replace "Reusing existing container" with print_success with icon
- [ ] Replace "Starting container..." with styled version
- [ ] Replace "Setting up Crush CLI..." with styled version
- [ ] Replace "Setup Crush configuration..." with styled version
- [ ] Replace "Installing pnpm..." with styled version
- [ ] Replace "Starting Crush CLI..." with styled header message
- [ ] Replace "Stopping container..." with styled version
- [ ] All messages use appropriate icons and colors

### US-005: Add success indicators for completed operations
**Description:** As a user, I want to see confirmation when operations complete successfully so I have confidence the process is working.

**Acceptance Criteria:**
- [ ] Add success message after container starts: "Container started successfully"
- [ ] Add success message after Crush CLI setup: "Crush CLI ready"
- [ ] Add success message after configuration merge: "Configuration merged"
- [ ] Add success message after pnpm install: "pnpm installed"
- [ ] Add success message after container stops: "Container stopped"
- [ ] All success messages use print_success() with ✓ icon

### US-006: Add spacing and visual hierarchy
**Description:** As a user, I want blank lines between sections and consistent indentation so the log output is easy to scan and understand.

**Acceptance Criteria:**
- [ ] Add blank line before each section header
- [ ] Add blank line after each section header
- [ ] Add blank line between major operation blocks
- [ ] Indent sub-messages within sections (e.g., version info, config details)
- [ ] Consistent 2-space indentation for related messages

### US-007: Enhance version display with visual formatting
**Description:** As a user, I want version information to be displayed with colors and consistent formatting so it's easy to spot.

**Acceptance Criteria:**
- [ ] Format "npm version: X.Y.Z" with cyan color and icon
- [ ] Format "pnpm version: X.Y.Z" with cyan color and icon
- [ ] Format "pnpm store configured to: /path" with cyan color and icon
- [ ] Add visual separator line between version info and next section

### US-008: Update cache volume creation messages
**Description:** As a user, I want clear, styled messages about cache volume operations so I understand what's happening with the persistent cache.

**Acceptance Criteria:**
- [ ] Replace "Using existing cache volume: $name" with print_info with icon
- [ ] Replace "Creating cache volume: $name" with print_info with icon
- [ ] Replace "Cache volume created: $name" with print_success with icon
- [ ] Group cache volume messages in a dedicated section

## Functional Requirements

- FR-1: Define enhanced color palette with bold, high-contrast ANSI codes (GREEN, RED, YELLOW, BLUE, MAGENTA, CYAN, GRAY)
- FR-2: Update all print_* helper functions to use icons and enhanced colors
- FR-3: Add print_header() function for major sections with visual separators
- FR-4: Add print_section() function for subsections with consistent formatting
- FR-5: Apply section headers to all major blocks: Environment Setup, Configuration, Container Management, Package Management, Session
- FR-6: Replace all plain echo statements in startup flow with styled print_* functions
- FR-7: Add success confirmation messages for completed operations
- FR-8: Add blank lines before/after sections and 2-space indentation for sub-messages
- FR-9: Format version information (npm, pnpm) with icons and colors
- FR-10: Maintain NO_COLOR compatibility (disable colors when NO_COLOR env var is set)
- FR-11: Maintain TTY detection (disable colors when not in terminal)

## Non-Goals

- No changes to error/warning messages from validation functions (validate_docker, validate_workspace_path)
- No changes to credential scanning output (gitleaks messages)
- No changes to clean_command output (container/volume removal messages)
- No changes to install/update/uninstall command output
- No changes to help/usage messages
- No progress bars or spinners (keep simple status messages)
- No sound effects or terminal bells
- No support for light mode terminals

## Design Considerations

### Color Palette (Dark Mode Optimized)
- **GREEN** (success): `\033[1;32m` - Bright green with bold for success messages
- **RED** (error): `\033[1;31m` - Bright red with bold for errors
- **YELLOW** (warning): `\033[1;33m` - Bright yellow with bold for warnings
- **BLUE** (info): `\033[1;34m` - Bright blue with bold for general info
- **MAGENTA** (header): `\033[1;35m` - Bright magenta with bold for section headers
- **CYAN** (accent): `\033[1;36m` - Bright cyan with bold for accents and version info
- **GRAY** (dim): `\033[0;90m` - Dim gray for secondary text and separators
- **NC** (no color): `\033[0m` - Reset color

### Icon Mapping
- Success: `✓` (Unicode U+2713)
- Error: `✗` (Unicode U+2717)
- Warning: `⚠` (Unicode U+26A0)
- Info: `→` (Unicode U+2192)
- Header/Section: `┌──`, `├──`, `└──` (Box-drawing characters)

### Visual Hierarchy Example
```
[blank line]
┌── Environment Setup ─────────────────────────────
  → Workspace: /Users/user/my-project
  → Container name: crush-sandbox-abc123
  → Cache volume: crush-cache-abc123
[blank line]

┌── Configuration ────────────────────────────────
  → Git user.name: John Doe
  → Git user.email: john@example.com
  → Host Crush config: /home/user/.config/crush
[blank line]

┌── Container Management ─────────────────────────
  ✓ Reusing existing container: crush-sandbox-abc123
  ✓ Container started successfully
[blank line]

┌── Package Management ─────────────────────────
  → Setting up Crush CLI...
  ✓ Crush CLI ready
  → Installing pnpm...
  ✓ pnpm installed
  → npm version: 22.0.0
  → pnpm version: 9.0.0
  → pnpm store configured to: /workspace-cache/pnpm/store
[blank line]

┌── Session ─────────────────────────────────────
  → Starting Crush CLI...
[Crush CLI runs here]
  ✓ Container stopped
```

### Spacing Rules
- Blank line before each section header
- Blank line after each section header
- No blank line between related messages in same section
- Blank line between major operation blocks (e.g., after versions, before session)
- 2-space indentation for messages within sections

## Technical Considerations

- Color codes use ANSI escape sequences compatible with most terminal emulators
- All colors disabled when `NO_COLOR` environment variable is set (maintain existing behavior)
- All colors disabled when not running in TTY (maintain existing behavior `[ -t 0 ]` check)
- Unicode icons used (✓, ✗, ⚠, →) - should work on macOS and Linux terminals
- Box-drawing characters (┌──, ├──, └──) for headers - may not render on some legacy terminals
- No changes to script logic, only output formatting
- All changes are additive (no breaking changes)

## Success Metrics

- Users can quickly identify success/error/warning messages by icon and color
- Startup flow is visually structured with clear section boundaries
- Terminal output is aesthetically pleasing and professional
- No regression in functionality (all operations work identically)
- NO_COLOR and non-TTY modes still work correctly

## Open Questions

None. The scope is clearly defined to startup messages and status updates only.
