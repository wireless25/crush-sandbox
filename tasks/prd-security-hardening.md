# PRD: Security Hardening for Docker Sandbox

## Introduction

Implement comprehensive security improvements for the docker-sandbox-crush tool based on a recent security audit. The audit identified several medium and high-priority security gaps that should be addressed to make the tool production-ready. The changes will focus on defense-in-depth principles: container hardening, resource limits, credential protection, and proper workflow controls while maintaining the read-write workspace functionality required for AI coding assistants.

## Goals

- Implement all HIGH priority security items from the security audit
- Implement all MEDIUM priority security items from the security audit
- Organize work in phases for systematic, tested delivery
- Maintain backward compatibility with existing functionality
- Provide clear documentation on security best practices for users
- Enable production-safe usage with proper safeguards in place

## User Stories

### Phase 1: Critical Security Controls

### US-001: Add resource limits to prevent DoS attacks
**Description:** As a system administrator, I want resource limits applied to containers so that a runaway or malicious agent cannot exhaust host resources.

**Acceptance Criteria:**
- [x] Add `--memory=4g` flag to docker_args in create_container function
- [x] Add `--memory-swap=4g` flag to docker_args in create_container function
- [x] Add `--cpus=2.0` flag to docker_args in create_container function
- [x] Add `--pids-limit=100` flag to docker_args in create_container function
- [x] Manual test: Run container and verify resource limits are applied (docker inspect)
- [x] Manual test: Attempt to spawn many processes - verify limit is enforced

### US-002: Run container as non-root user
**Description:** As a security-conscious user, I want the container to run as non-root so that if the agent exploits a vulnerability, the impact is limited.

**Acceptance Criteria:**
- [x] Add `--user` flag with `$(id -u):$(id -g)` to docker_args in create_container function
- [x] Ensure workspace mount permissions work correctly with non-root user
- [x] Ensure cache volume is accessible to non-root user
- [x] Manual test: Run container and verify user is not root (docker exec whoami)
- [x] Manual test: Verify Crush CLI can read/write workspace files

### US-003: Add security section to README
**Description:** As a user, I want security best practices documented so I understand how to use the tool safely in production.

**Acceptance Criteria:**
- [ ] Add "Security" section to README.md
- [ ] Document the read-write workspace requirement and implications
- [ ] Explain git branch protection requirements for production use
- [ ] Document credential handling (don't store in workspace files)
- [ ] Provide example GitHub/GitLab branch protection configurations
- [ ] Explain what the agent can and cannot do (based on audit)

### US-004: Document CI/CD security requirements
**Description:** As a DevOps engineer, I want guidance on CI/CD security checks so I can set up proper validation for agent-generated code.

**Acceptance Criteria:**
- [ ] Add "CI/CD Security" subsection to README security section
- [ ] List required CI checks: linting, tests, security scanning, dependency checks
- [ ] Provide example GitHub Actions workflow with security checks
- [ ] Explain why code review is critical for agent-generated PRs
- [ ] Reference common security tools (Snyk, Dependabot, npm audit)

### US-005: Add credential scanning before agent runs
**Description:** As a security-conscious user, I want the tool to warn me about credentials in the workspace so I don't accidentally expose secrets.

**Acceptance Criteria:**
- [ ] Add function to scan workspace for credentials using gitleaks
- [ ] Run scan in run_command() before container starts
- [ ] Display warning if credentials detected
- [ ] Prompt user to continue or abort if credentials found
- [ ] Add `--no-cred-scan` flag to skip scanning (for trusted workspaces)
- [ ] Add note in README about credential scanning behavior
- [ ] Manual test: Create test file with dummy API key - verify detection

### Phase 2: Important Security Improvements

### US-006: Replace MD5 with SHA256 for container/volume naming
**Description:** As a security auditor, I want cryptographically secure hashing so container names cannot be manipulated via collision attacks.

**Acceptance Criteria:**
- [ ] Update get_container_name() to use SHA256 instead of MD5
- [ ] Update get_cache_volume_name() to use SHA256 instead of MD5
- [ ] Ensure hash output is truncated to reasonable length (e.g., first 12 chars) for name length
- [ ] Manual test: Run tool and verify container name uses new hash format
- [ ] Manual test: Verify same workspace produces same container name (deterministic)

### US-007: Validate and sanitize workspace paths
**Description:** As a security-conscious user, I want workspace paths validated so that malicious paths cannot cause command injection.

**Acceptance Criteria:**
- [ ] Add function validate_workspace_path() that checks for problematic characters
- [ ] Check for backticks, dollar signs, and other shell metacharacters
- [ ] Call validation in get_workspace_info() or run_command()
- [ ] Display clear error message and exit if validation fails
- [ ] Add test cases for various malicious path patterns
- [ ] Manual test: Attempt to run from path with special chars - verify rejection

### US-008: Drop unnecessary Docker capabilities
**Description:** As a security-hardening measure, I want unnecessary Linux capabilities dropped from the container to reduce attack surface.

**Acceptance Criteria:**
- [ ] Add `--cap-drop` `ALL` flag to docker_args in create_container function
- [ ] Add `--cap-add` `CHOWN` flag (needed for npm cache operations)
- [ ] Add `--cap-add` `DAC_OVERRIDE` flag (needed for workspace access)
- [ ] Manual test: Verify Crush CLI still works with restricted capabilities
- [ ] Manual test: Verify npm and pnpm can read/write cache

### US-009: Use mktemp for temporary file in update function
**Description:** As a security auditor, I want temporary files created securely to prevent TOCTOU race condition attacks.

**Acceptance Criteria:**
- [ ] Replace `"/tmp/docker-sandbox-crush-update.$$"` with `$(mktemp)` in update_command
- [ ] Ensure temp file is cleaned up after use
- [ ] Test that update functionality still works correctly

### Phase 3: Documentation and Cleanup

### US-010: Add security checklist to README
**Description:** As a user, I want a security checklist so I can verify I've configured everything correctly before using the tool in production.

**Acceptance Criteria:**
- [ ] Add "Security Checklist" subsection to README
- [ ] List items to verify: branch protection, CI/CD, credential management
- [ ] Include checklist items for container configuration verification
- [ ] Make checklist actionable (checkbox-style items users can verify)

### US-011: Update AGENTS.md with security changes
**Description:** As a future developer or AI agent, I want the AGENTS.md file updated so it reflects the new security controls.

**Acceptance Criteria:**
- [ ] Update Core Functions section to mention resource limits in create_container()
- [ ] Update Code Patterns section to document security flags
- [ ] Add resource limits to Docker Patterns subsection
- [ ] Add credential scanning to Important Gotchas subsection
- [ ] Update Technical Specifications to list new docker_args flags
- [ ] Update Security Considerations section with new controls

### US-012: Create security testing guide
**Description:** As a developer, I want a guide for manually testing security features so I can verify each control is working correctly.

**Acceptance Criteria:**
- [ ] Create `SECURITY_TESTING.md` file
- [ ] Document test for resource limits (inspect container, verify limits)
- [ ] Document test for non-root user (run whoami in container)
- [ ] Document test for credential scanning (create test file with secret)
- [ ] Document test for path validation (try various invalid paths)
- [ ] Document test for dropped capabilities (verify operation still works)
- [ ] Include commands for each test and expected outputs

## Functional Requirements

### Phase 1 Requirements
- FR-1: Container must enforce memory limit of 4GB
- FR-2: Container must enforce memory-swap limit of 4GB (no swapping)
- FR-3: Container must limit CPU to 2 cores
- FR-4: Container must limit process count to 100 PIDs
- FR-5: Container must run as non-root user (current user's UID/GID)
- FR-6: README must document security best practices
- FR-7: README must provide example branch protection configurations
- FR-8: README must document CI/CD security requirements
- FR-9: Tool must scan workspace for credentials before container starts
- FR-10: Tool must warn and prompt if credentials are detected
- FR-11: Tool must provide `--no-cred-scan` flag to bypass scanning

### Phase 2 Requirements
- FR-12: Container/volume names must use SHA256 instead of MD5
- FR-13: Tool must validate workspace paths for shell metacharacters
- FR-14: Tool must reject invalid workspace paths with clear error message
- FR-15: Container must drop all Linux capabilities by default
- FR-16: Container must add back CHOWN capability (for npm cache)
- FR-17: Container must add back DAC_OVERRIDE capability (for workspace access)
- FR-18: Update function must use mktemp for temporary file creation

### Phase 3 Requirements
- FR-19: README must include security checklist for production use
- FR-20: AGENTS.md must document new security controls
- FR-21: SECURITY_TESTING.md must provide test procedures for each security feature

## Non-Goals

Out of scope for this implementation:
- Network isolation (user chose to keep default bridge network)
- Read-only root filesystem
- Seccomp/AppArmor profiles
- Container healthchecks
- GPG signature verification for updates
- Automated security testing (manual only)
- Git push confirmation mechanism (requires agent coordination)
- Temporary credential injection mechanism
- External secret management integration (documentation only)

## Design Considerations

### Backward Compatibility
- All changes must maintain existing functionality
- Resource limits should be set to reasonable defaults (not too restrictive)
- Non-root user must work with existing workspace/cache permissions
- Credential scanning should be optional (not break existing workflows)

### User Experience
- Security warnings should be clear and actionable
- Error messages should explain what went wrong and how to fix it
- Documentation should be practical, not theoretical
- Credential scanning should be fast (not delay normal operations)

### Platform Considerations
- Script is macOS-focused, verify changes work on macOS
- Alpine Linux image capabilities may differ from other bases
- UID/GID mapping works correctly on macOS Docker Desktop

## Technical Considerations

### Docker Container Creation
The create_container() function will be modified to include:
```bash
docker_args+=(
    # Resource limits
    "--memory=4g"
    "--memory-swap=4g"
    "--cpus=2.0"
    "--pids-limit=100"
    # Security hardening
    "--user" "$(id -u):$(id -g)"
    "--cap-drop" "ALL"
    "--cap-add" "CHOWN"
    "--cap-add" "DAC_OVERRIDE"
)
```

### Hashing Algorithm
Replace MD5 with SHA256:
```bash
# Old: hash="$(echo -n "$workspace" | md5)"
# New:
hash="$(echo -n "$workspace" | shasum -a 256 | awk '{print $1}' | cut -c1-12)"
```

### Credential Scanning
Use gitleaks for scanning:
```bash
if gitleaks detect --source "$workspace" --no-banner 2>&1 | grep -q "leak"; then
    echo "⚠️  WARNING: Potential credentials detected in workspace"
    # Prompt user to continue or abort
fi
```

### Path Validation
Check for dangerous characters:
```bash
validate_workspace_path() {
    if [[ "$workspace" =~ [\$\`\\] ]]; then
        echo "Error: Workspace path contains invalid characters" >&2
        exit 1
    fi
}
```

### Dependencies
- gitleaks must be available on host system (document in README)
- If gitleaks is missing, issue warning but don't fail (feature degraded)
- All other changes use built-in bash/Docker features

## Success Metrics

- All HIGH priority security items implemented and tested
- All MEDIUM priority security items implemented and tested
- Documentation covers all new security features
- No regression in existing functionality
- Manual tests verify each security control works as expected
- Tool can be used in production with documented safeguards

## Open Questions

- What default resource limits should we use? (proposed: 4GB memory, 2 CPUs, 100 PIDs)
- Should credential scanning fail hard or just warn? (proposed: warn with continue/abort prompt)
- What happens if gitleaks is not installed? (proposed: warn but continue operation)
- Should we add flags to override resource limits? (proposed: no, keep simple)
- Should we add verbose mode for debugging security features? (proposed: no, not in scope)
