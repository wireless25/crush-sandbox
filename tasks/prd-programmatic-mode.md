# PRD: Programmatic Mode for Crush Sandbox

## Introduction

Add programmatic mode support to crush-sandbox to enable automated and non-interactive use of the Crush CLI. Currently, crush-sandbox only supports interactive mode where the Crush app starts and waits for user input. This feature enables users to pipe prompts via stdin or use a `-p` flag to send prompts directly, making it suitable for scripting, CI/CD pipelines, and automation workflows. Programmatic mode will also include a `--quiet` flag to suppress container setup messages for cleaner output in automated scenarios.

## Goals

- Enable programmatic usage via `-p "prompt"` flag
- Enable programmatic usage via piped input (`echo "prompt" | crush-sandbox run`)
- Maintain backward compatibility with existing interactive mode
- Support multi-line prompts in programmatic mode
- Provide `--quiet` flag to suppress container setup messages in programmatic mode
- Ensure Crush CLI output is always visible to user in programmatic mode
- Prevent `--shell` flag from being used in programmatic mode

## User Stories

### US-001: Detect programmatic mode from command line flags
**Description:** As a user, I want to use `-p` flag to send a prompt directly to Crush CLI so I can automate code generation.

**Acceptance Criteria:**
- [x] Add `-p` flag to argument parser (after `run` command, accepts quoted string)
- [x] Set PROGRAMATIC_MODE=true when `-p` flag is present
- [x] Store prompt value from `-p` flag in PROMPT variable
- [x] Script exits with clear error if `-p` flag has no value
- [x] Update help text to show `-p "prompt"` option

### US-002: Detect programmatic mode from piped stdin
**Description:** As a user, I want to pipe prompts to crush-sandbox so I can use it with Unix pipes like other CLI tools.

**Acceptance Criteria:**
- [x] Detect if stdin has data available using `read -t 0` (bash compatible)
- [x] Set PROGRAMATIC_MODE=true when stdin has data
- [x] Read piped input with `PROMPT=$(cat)` command
- [x] If both `-p` and piped input are present, use `-p` value (explicit wins)
- [x] Documentation includes piped input usage examples

### US-003: Execute Crush CLI in programmatic mode
**Description:** As a user, I want Crush CLI to run in programmatic mode (`crush run`) when I provide a prompt so I get automated responses.

**Acceptance Criteria:**
- [ ] In programmatic mode, execute `docker exec -i ... crush run "$PROMPT"` (not just `crush`)
- [ ] Use `-i` flag for docker exec (no `-t`, not interactive)
- [ ] Prompt is properly quoted to handle spaces and special characters
- [ ] Crush CLI stdout/stderr is forwarded to user terminal (no changes needed, automatic)
- [ ] Multi-line prompts work correctly (via `-p` with quotes or here-documents)

### US-004: Prevent --shell in programmatic mode
**Description:** As a developer, I want to prevent conflicting flags so users don't get unexpected behavior.

**Acceptance Criteria:**
- [ ] Add validation to check if both PROGRAMATIC_MODE=true and SHELL_MODE=true
- [ ] If both are true, print error message: "Error: --shell flag cannot be used with -p or piped input"
- [ ] Exit with error code 1 when validation fails
- [ ] Validation happens before any Docker operations

### US-005: Add --quiet flag for programmatic mode
**Description:** As a user, I want to suppress container setup messages in programmatic mode so I get clean output for automation.

**Acceptance Criteria:**
- [ ] Add `--quiet` flag to argument parser
- [ ] When QUIET_MODE=true, suppress these messages in programmatic mode:
  - "Starting container..."
  - "Setting up Crush CLI..."
  - "Setup Crush configuration..."
  - "Installing pnpm..."
  - "pnpm installed"
  - "npm version: X"
  - "pnpm version: X"
  - "pnpm store configured to: /workspace-cache/pnpm/store"
  - "Starting Crush CLI..."
  - "Stopping container..."
  - "Container stopped"
- [ ] QUIET_MODE does NOT affect interactive mode (only programmatic)
- [ ] Error messages still appear even in quiet mode
- [ ] Crush CLI output always appears (never suppressed)
- [ ] Update help text to show `--quiet` option

### US-006: Handle empty prompts gracefully
**Description:** As a user, I want empty prompts to be handled gracefully so I get predictable behavior.

**Acceptance Criteria:**
- [ ] If PROMPT is empty string (e.g., `echo "" | crush-sandbox run`), execute `crush run ""`
- [ ] Let Crush CLI handle empty prompt (don't validate prompt length)
- [ ] If user provides `-p ""` explicitly, execute `crush run ""`
- [ ] No validation error for empty prompts

### US-007: Support multi-line prompts
**Description:** As a user, I want to send multi-line prompts so I can provide complex instructions to Crush CLI.

**Acceptance Criteria:**
- [ ] Multi-line prompts work with `-p` flag using quotes:
  ```bash
  crush-sandbox run -p "Line 1
  Line 2
  Line 3"
  ```
- [ ] Multi-line prompts work with heredocs:
  ```bash
  crush-sandbox run -p "$(cat <<EOF
  Line 1
  Line 2
  Line 3
  EOF
  )"
  ```
- [ ] Multi-line prompts work with piped input:
  ```bash
  echo -e "Line 1\nLine 2\nLine 3" | crush-sandbox run
  ```
- [ ] Newlines and special characters are preserved when passed to `crush run`

## Functional Requirements

- FR-1: Add `-p` flag to accept prompt string as argument
- FR-2: Detect piped stdin input using `read -t 0` bash construct
- FR-3: Read piped input via `PROMPT=$(cat)` command
- FR-4: When both `-p` and piped input present, use `-p` value (explicit wins)
- FR-5: In programmatic mode, execute `docker exec -i ... crush run "$PROMPT"`
- FR-6: In programmatic mode, use `-i` flag (no `-t`) for docker exec
- FR-7: Prevent use of `--shell` flag when PROGRAMATIC_MODE=true
- FR-8: Add `--quiet` flag to suppress container setup messages
- FR-9: `--quiet` only applies to programmatic mode, not interactive mode
- FR-10: Empty prompts pass through to Crush CLI without validation
- FR-11: Multi-line prompts work with `-p` flag, heredocs, and piped input
- FR-12: Crush CLI output is always visible to user (never suppressed)
- FR-13: Error messages always appear even when `--quiet` is set

## Non-Goals (Out of Scope)

- Passing additional Crush CLI flags (e.g., `--model`, `--temperature`, `--max-tokens`)
- Supporting `crush run` without arguments for interactive programmatic mode
- Adding `--verbose` flag (current debug output is sufficient)
- Persistent programmatic mode configuration (e.g., environment variables)
- Batch processing of multiple prompts in one invocation
- Output formatting or parsing of Crush CLI responses
- Non-bash shell compatibility (script is bash-specific)

## Design Considerations

- Maintain backward compatibility: existing `crush-sandbox run` behavior unchanged
- Follow Unix conventions: tools that can consume stdin should do so automatically
- Quiet mode should be clean but not silent: errors always show
- Container setup messages are helpful for interactive users but noise for automation
- Prompt detection should be unambiguous: `-p` wins over piped input
- Multi-line prompts: preserve whitespace exactly as provided by user

## Technical Considerations

- **Bash compatibility**: `read -t 0` works in bash (script's target shell)
- **Input consumption**: `cat` consumes stdin, can't read twice - need to check first
- **Docker exec flags**: `-i` for input only (programmatic), `-it` for interactive (TTY)
- **Quote handling**: use `"$PROMPT"` (double quotes) to preserve spaces/newlines
- **Exit codes**: propagate Crush CLI exit code to script exit for automation
- **Signal handling**: ensure container stops cleanly even with piped input
- **Argument parsing**: maintain existing pattern in while loop (docker-sandbox-crush:1705-1772)
- **Conditional output**: wrap existing echo statements in `if [ "$QUIET_MODE" != "true" ]` checks

## Success Metrics

- Users can run `crush-sandbox run -p "prompt"` and get Crush CLI output
- Users can run `echo "prompt" | crush-sandbox run` and get Crush CLI output
- Multi-line prompts work correctly in all three formats (flag, heredoc, pipe)
- `--quiet` suppresses container setup messages but shows Crush CLI output
- Existing interactive mode is unaffected (no regressions)
- Error messages clearly indicate flag conflicts (e.g., --shell with -p)
- Crush CLI exit codes propagate correctly for automation scripts

## Open Questions

None at this time.

## Usage Examples

### Interactive Mode (unchanged)
```bash
# Start interactive Crush app
crush-sandbox run

# Start with shell debugging
crush-sandbox run --shell
```

### Programmatic Mode with -p flag
```bash
# Simple prompt
crush-sandbox run -p "Create a React component for user login"

# Multi-line prompt
crush-sandbox run -p "Create a REST API with:
- GET /users
- POST /users
- DELETE /users/:id"

# With quiet flag (no container setup messages)
crush-sandbox run -p "Add unit tests" --quiet

# With worktree
crush-sandbox run --worktree feature-auth -p "Add OAuth login"
```

### Programmatic Mode with piped input
```bash
# Simple pipe
echo "Add error handling" | crush-sandbox run

# Multi-line pipe
echo -e "Fix login bug\nAdd validation\nUpdate tests" | crush-sandbox run

# With heredoc
crush-sandbox run <<EOF
Create a login form with:
- Email field
- Password field
- Remember me checkbox
- Login button
EOF

# With quiet flag
echo "Refactor code" | crush-sandbox run --quiet

# With worktree
echo "Fix bug" | crush-sandbox run --worktree bugfix-login
```

### Error Cases
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
