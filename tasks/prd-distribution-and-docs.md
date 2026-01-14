# PRD: Remote Distribution and Documentation for Docker Sandbox Crush

## Introduction

Make the docker-sandbox-crush tool easily installable without manual copy-pasting, and create professional open-source documentation to help others discover, install, and use the tool effectively.

## Goals

- Provide an easy way to install the script remotely in any project
- Create friendly, professional open-source documentation (README)
- Lower friction for new users to try the tool
- Enable one-command installation without file copying
- Establish the project as a legitimate open-source tool

## User Stories

### US-001: Install script remotely via curl
**Description:** As a developer, I want to install the sandbox tool with a single command so I don't need to copy files into each project.

**Status:** ✅ Complete

**Acceptance Criteria:**
- [x] Script is available for download from a public URL (GitHub raw content)
- [x] Single curl command downloads and installs the script to /usr/local/bin or similar
- [x] Install command is documented in README
- [x] Installation sets executable permissions automatically
- [x] Installation validates Docker is available before completing
- [x] Typecheck/lint passes

### US-002: Create comprehensive README documentation
**Description:** As a new user, I want clear, friendly documentation that explains what the tool does and how to use it so I can quickly get started.

**Status:** ✅ Complete

**Acceptance Criteria:**
- [x] README has welcoming introduction explaining the tool's purpose
- [x] README includes quick start section with installation commands
- [x] README documents all commands (run, clean) and flags (--shell, --force)
- [x] README includes examples of common use cases
- [x] README explains the workspace isolation concept
- [x] README includes troubleshooting section
- [x] README has badges for status/license
- [x] README is written in friendly, open-source project tone
- [x] README is concise yet comprehensive

### US-003: Publish code to public GitHub repository
**Description:** As a maintainer, I want the code in a public GitHub repo so others can access, fork, and contribute to the project.

**Status:** ✅ Complete

**Acceptance Criteria:**
- [x] Repository is pushed to GitHub
- [x] Repository has proper .gitignore (ignoring local config files)
- [x] Repository includes LICENSE file (choose appropriate open-source license)
- [x] Repository includes README.md in root
- [x] Repository has clear repository name and description
- [x] Repository includes contribution guidelines or code of conduct

### US-004: Add version information to script
**Description:** As a user, I want to see what version of the script I'm running so I can report issues and verify updates.

**Status:** ✅ Complete

**Acceptance Criteria:**
- [x] Script has a VERSION variable at the top
- [x] `--version` or `version` command displays current version
- [x] Version is updated in README when releasing
- [x] Typecheck/lint passes

### US-005: Add update command
**Description:** As a user, I want to update the script to the latest version without manual re-installation so I stay current with fixes and features.

**Status:** ✅ Complete

**Acceptance Criteria:**
- [x] Script accepts `update` command
- [x] `update` command downloads latest version from remote URL
- [x] Update command replaces current script with new version
- [x] Update command displays version change information
- [x] Update command validates download before replacing
- [x] Typecheck/lint passes

### US-006: Create GitHub release workflow (optional)
**Description:** As a maintainer, I want to create GitHub releases automatically so users can easily track versions and changes.

**Acceptance Criteria:**
- [ ] GitHub Actions workflow creates releases on git tags
- [ ] Releases include version notes
- [ ] Releases attach the script file for direct download
- [ ] Release notes document changes since last version

## Functional Requirements

- FR-1: Script must be downloadable via curl from a stable public URL
- FR-2: Installation command must work on macOS (primary target)
- FR-3: README must include installation instructions for both direct download and package manager (if applicable)
- FR-4: README must explain the sandbox concept and benefits clearly
- FR-5: README must document all available commands and flags
- FR-6: Script must support `--version` flag to display version
- FR-7: Script must support `update` command to refresh from remote
- FR-8: Repository must include appropriate LICENSE file
- FR-9: README tone must be welcoming and community-oriented
- FR-10: README must include troubleshooting common issues

## Non-Goals (Out of Scope)

- Creating Homebrew formula (unless specifically requested)
- Creating npm package for distribution
- Multi-platform support (focus on macOS)
- Auto-updating background process
- Telemetry or analytics
- Dependency management beyond the script itself
- Complex CI/CD pipelines
- Automated testing across platforms

## Design Considerations

- Use GitHub raw URL for script download (reliable and fast)
- Keep installation simple (curl + chmod + mv)
- Version format: semantic versioning (v0.1.0, etc.)
- Use MIT or BSD license for maximum compatibility
- README structure: Title → Description → Installation → Usage → Examples → Troubleshooting → License
- Installation path: /usr/local/bin/docker-sandbox-crush (standard location)
- Update command overwrites script in-place
- Friendly language: use "you" and "we", avoid jargon where possible

## Technical Considerations

- Remote URL: `https://raw.githubusercontent.com/wireless25/crush-sandbox/refs/heads/main/docker-sandbox-crush`
- Installation command: `curl -fsSL <url> -o /usr/local/bin/docker-sandbox-crush && chmod +x /usr/local/bin/docker-sandbox-crush`
- Update command: download to temp file, verify, then move to replace
- Version stored as variable at top of script
- Update command compares remote version vs local version
- GitHub releases can use gh CLI or GitHub Actions

## Success Metrics

- New user can install and run the tool in under 5 minutes
- README answers common questions without needing to look at code
- Users can update the tool with a single command
- README makes the project look polished and trustworthy
- Installation success rate is high (no manual steps that fail)

## Open Questions

- What should the GitHub repository name and username be?
- Which open-source license to use? (MIT recommended for tools)
- Should the installation command require sudo?
- Should the script self-update automatically on each run? (Probably no, explicit updates better)
- What initial version number? (v0.1.0 or v1.0.0?)
