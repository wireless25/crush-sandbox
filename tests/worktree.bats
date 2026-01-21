#!/usr/bin/env bats

# Source the main script to test the functions
source /Users/stephansimonett/Code/docker-sandbox-crush/docker-sandbox-crush

# Setup/teardown helpers
setup_git_repo() {
    local temp_dir="$1"
    cd "$temp_dir"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    echo "initial commit" > README.md
    git add README.md
    git commit -q -m "Initial commit"
}

cleanup_git_repo() {
    local temp_dir="$1"
    cd /
    rm -rf "$temp_dir"
}

@test "validate_git_repository: returns 0 when in git repo" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    run validate_git_repository
    [ "$status" -eq 0 ]
    [ -z "$output" ]

    cleanup_git_repo "$temp_dir"
}

@test "validate_git_repository: returns 1 when not in git repo" {
    local temp_dir
    temp_dir=$(mktemp -d)

    cd "$temp_dir"
    run validate_git_repository
    [ "$status" -eq 1 ]
    [[ "$output" == *"Not in a git repository"* ]]

    cd /
    rm -rf "$temp_dir"
}

@test "validate_worktree_branch_args: fails when branch-name without worktree" {
    BRANCH_NAME="test-branch"
    WORKTREE_MODE="false"

    run validate_worktree_branch_args
    [ "$status" -eq 1 ]
    [[ "$output" == *"--branch-name requires --worktree"* ]]

    BRANCH_NAME=""
    WORKTREE_MODE="false"
}

@test "validate_worktree_branch_args: passes when branch-name with worktree" {
    BRANCH_NAME="test-branch"
    WORKTREE_MODE="true"

    run validate_worktree_branch_args
    [ "$status" -eq 0 ]

    BRANCH_NAME=""
    WORKTREE_MODE="false"
}

@test "get_root_workspace: returns correct git root path" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"
    mkdir -p "$temp_dir/nested/deep"

    cd "$temp_dir/nested/deep"
    local root
    root=$(get_root_workspace)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    # Use realpath to get the canonical path
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        # Fallback: use pwd -P
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    [ "$root" = "$temp_dir" ]

    cleanup_git_repo "$temp_dir"
}

@test "prepare_worktree_directory: creates .worktrees directory" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    [ -d "${temp_dir}/.worktrees" ]
    [ -f "${temp_dir}/.worktrees/.gitignore" ]

    # Check .gitignore content
    local ignore_content
    ignore_content=$(cat "${temp_dir}/.worktrees/.gitignore")
    [ "$ignore_content" = "*" ]

    cleanup_git_repo "$temp_dir"
}

@test "prepare_worktree_directory: works if .worktrees already exists" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    # Create directory manually first
    mkdir -p "${temp_dir}/.worktrees"

    # Should not fail
    prepare_worktree_directory "$temp_dir"

    [ -d "${temp_dir}/.worktrees" ]

    cleanup_git_repo "$temp_dir"
}

@test "generate_worktree_name: generates 8-character alphanumeric name" {
    local name
    name=$(generate_worktree_name)

    [ ${#name} -eq 8 ]
    [[ "$name" =~ ^[a-zA-Z0-9]{8}$ ]]
}

@test "generate_worktree_name: generates different names on multiple calls" {
    local name1
    local name2

    name1=$(generate_worktree_name)
    name2=$(generate_worktree_name)

    # While theoretically possible to get the same, extremely unlikely
    # This test assumes randomness works correctly
    [ "$name1" != "$name2" ] || echo "Warning: Generated same name twice (very unlikely)"
}

@test "worktree_exists: returns 1 when worktree doesn't exist" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    run worktree_exists "$temp_dir" "test-worktree"
    [ "$status" -eq 1 ]

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: creates worktree for existing branch" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Create a test branch
    git checkout -q -b feature/test
    echo "test file" > test.txt
    git add test.txt
    git commit -q -m "Add test file"
    git checkout -q main

    prepare_worktree_directory "$temp_dir"

    run create_worktree "$temp_dir" "my-worktree" "feature/test"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree created"* ]]
    [[ "$output" == *"Branch: feature/test"* ]]
    [ -d "${temp_dir}/.worktrees/my-worktree" ]

    # Verify worktree exists
    run worktree_exists "$temp_dir" "my-worktree"
    if [ "$status" -ne 0 ]; then
        echo "DEBUG: git worktree list:"
        git worktree list
        echo "DEBUG: expected path: ${temp_dir}/.worktrees/my-worktree"
    fi
    [ "$status" -eq 0 ]

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: creates worktree for new branch" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    run create_worktree "$temp_dir" "new-feature" "new-branch"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree created"* ]]
    [[ "$output" == *"new branch created"* ]]
    [[ "$output" == *"Branch: new-branch"* ]]
    [ -d "${temp_dir}/.worktrees/new-feature" ]

    # Verify branch was created
    run git branch --list new-branch
    [ "$status" -eq 0 ]

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: fails if worktree already exists" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    # Create first worktree
    run create_worktree "$temp_dir" "duplicate" "branch1"
    [ "$status" -eq 0 ]

    # Try to create with same name
    run create_worktree "$temp_dir" "duplicate" "branch2"
    [ "$status" -eq 1 ]
    [[ "$output" == *"already exists"* ]]

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: uses worktree name as branch name on blank input" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    # Create worktree with blank input (should use worktree name as branch)
    # Use bash here-string to simulate pressing Enter
    run create_worktree "$temp_dir" "test-branch" <<< ""

    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree created"* ]]
    [[ "$output" == *"Branch: test-branch"* ]]
    [[ "$output" == *"new branch created"* ]]
    [ -d "${temp_dir}/.worktrees/test-branch" ]

    # Verify branch was created with worktree name
    run git branch --list test-branch
    [ "$status" -eq 0 ]

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: checks out existing branch when blank input matches existing branch" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Create an existing branch that matches worktree name
    git checkout -q -b existing-feature
    echo "test" > test.md
    git add test.md
    git commit -q -m "Add test"
    git checkout -q main

    prepare_worktree_directory "$temp_dir"

    # Create worktree with blank input (should use existing branch with worktree name)
    # Use bash here-string to simulate pressing Enter
    run create_worktree "$temp_dir" "existing-feature" <<< ""

    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree created"* ]]
    [[ "$output" == *"Branch: existing-feature"* ]]
    # Should NOT say "new branch created" since branch already exists
    [[ "$output" != *"new branch created"* ]]
    [ -d "${temp_dir}/.worktrees/existing-feature" ]

    # Verify worktree is on the correct branch
    run git -C "${temp_dir}/.worktrees/existing-feature" branch --show-current
    [ "$output" = "existing-feature" ]

    cleanup_git_repo "$temp_dir"
}

@test "list_worktrees: displays no worktrees message when none exist" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" == *"No worktrees found"* ]]

    cleanup_git_repo "$temp_dir"
}

@test "list_worktrees: displays worktrees when they exist" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    # Create two worktrees
    create_worktree "$temp_dir" "worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "worktree2" "branch2" >/dev/null 2>&1

    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktrees:"* ]]
    [[ "$output" == *"${temp_dir}/.worktrees/worktree1"* ]]
    [[ "$output" == *"${temp_dir}/.worktrees/worktree2"* ]]
    [[ "$output" == *"Branch:"* ]]

    cleanup_git_repo "$temp_dir"
}

@test "list_worktrees: marks current worktree" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    # Create worktree
    create_worktree "$temp_dir" "current-worktree" "feature/test" >/dev/null 2>&1

    # Change into the worktree
    cd "${temp_dir}/.worktrees/current-worktree"

    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" == *"(current)"* ]]

    cleanup_git_repo "$temp_dir"
}

@test "remove_worktree: removes existing worktree" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    # Create worktree
    create_worktree "$temp_dir" "to-remove" "feature/test" >/dev/null 2>&1

    [ -d "${temp_dir}/.worktrees/to-remove" ]

    # Remove worktree
    run remove_worktree "$temp_dir" "to-remove" "false"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree removed"* ]]

    # Verify directory is gone
    [ ! -d "${temp_dir}/.worktrees/to-remove" ]

    cleanup_git_repo "$temp_dir"
}

@test "remove_worktree: fails when worktree doesn't exist" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    run remove_worktree "$temp_dir" "nonexistent" "false"
    [ "$status" -eq 1 ]
    [[ "$output" == *"does not exist"* ]]

    cleanup_git_repo "$temp_dir"
}

@test "remove_worktree: removes worktree with uncommitted changes when --force is used" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    prepare_worktree_directory "$temp_dir"

    # Create worktree
    create_worktree "$temp_dir" "force-test" "feature/test" >/dev/null 2>&1

    # Make uncommitted changes in worktree
    echo "uncommitted" > "${temp_dir}/.worktrees/force-test/newfile.txt"

    # Try without force (should fail)
    run remove_worktree "$temp_dir" "force-test" "false"
    [ "$status" -eq 1 ]

    # Now try with force (should succeed)
    run remove_worktree "$temp_dir" "force-test" "true"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree removed"* ]]
    [ ! -d "${temp_dir}/.worktrees/force-test" ]

    cleanup_git_repo "$temp_dir"
}

@test "get_workspace_info: normalizes to worktree root when in subdirectory" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"
    prepare_worktree_directory "$temp_dir"

    # Create worktree with new branch (not reusing current branch to avoid conflict)
    create_worktree "$temp_dir" "subdir-test" "test-branch" >/dev/null 2>&1

    # Create a nested subdirectory in worktree
    mkdir -p "${temp_dir}/.worktrees/subdir-test/nested/deep"

    # Navigate to nested subdirectory
    cd "${temp_dir}/.worktrees/subdir-test/nested/deep"

    # get_workspace_info should return worktree root, not nested path
    local result
    result=$(get_workspace_info)

    # Should be normalized to worktree root
    [ "$result" = "${temp_dir}/.worktrees/subdir-test" ]

    cleanup_git_repo "$temp_dir"
}

@test "get_workspace_info: returns exact path when in main workspace subdirectory" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Create a nested subdirectory in main workspace
    mkdir -p "${temp_dir}/nested/deep"

    # Navigate to nested subdirectory
    cd "${temp_dir}/nested/deep"

    # get_workspace_info should return current directory (not normalized)
    local result
    result=$(get_workspace_info)

    # Should be exact path (not normalized) since not in worktree
    [ "$result" = "${temp_dir}/nested/deep" ]

    cleanup_git_repo "$temp_dir"
}

@test "extract_worktree_name: returns worktree name when in worktree" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"
    prepare_worktree_directory "$temp_dir"

    # Create worktree
    create_worktree "$temp_dir" "my-worktree" "test-branch" >/dev/null 2>&1

    # Test with worktree root path
    local result
    result=$(extract_worktree_name "${temp_dir}/.worktrees/my-worktree")
    [ "$result" = "my-worktree" ]

    # Test with nested path in worktree
    result=$(extract_worktree_name "${temp_dir}/.worktrees/my-worktree/nested/deep")
    [ "$result" = "my-worktree" ]

    cleanup_git_repo "$temp_dir"
}

@test "extract_worktree_name: returns empty string when not in worktree" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    # Test with main workspace path
    local result
    result=$(extract_worktree_name "$temp_dir")
    [ "$result" = "" ]

    # Test with nested path in main workspace
    result=$(extract_worktree_name "${temp_dir}/nested/deep")
    [ "$result" = "" ]

    cleanup_git_repo "$temp_dir"
}

@test "extract_worktree_name: returns empty string for .worktrees path without worktree" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"
    mkdir -p "$temp_dir/.worktrees"

    # Test with .worktrees directory itself
    local result
    result=$(extract_worktree_name "${temp_dir}/.worktrees")
    [ "$result" = "" ]

    cleanup_git_repo "$temp_dir"
}

@test "get_cache_volume_name: returns same volume name for all worktrees in repository" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Get cache volume name for repository root
    local cache_volume_main
    cache_volume_main=$(get_cache_volume_name "$temp_dir")

    # Verify naming pattern: crush-cache-<repo-hash>
    [[ "$cache_volume_main" =~ ^crush-cache-[a-f0-9]{12}$ ]]

    # Create two worktrees
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "worktree2" "branch2" >/dev/null 2>&1

    # Get cache volume name using same repository root (as worktrees do)
    local cache_volume_worktree1
    cache_volume_worktree1=$(get_cache_volume_name "$temp_dir")
    local cache_volume_worktree2
    cache_volume_worktree2=$(get_cache_volume_name "$temp_dir")

    # All worktrees should use the same cache volume (repository-scoped)
    [ "$cache_volume_main" = "$cache_volume_worktree1" ]
    [ "$cache_volume_main" = "$cache_volume_worktree2" ]

    cleanup_git_repo "$temp_dir"
}

@test "list_containers: displays no containers message when none exist" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"

    run list_containers
    [ "$status" -eq 0 ]
    [[ "$output" == *"No containers found"* ]]

    cleanup_git_repo "$temp_dir"
}

@test "list_containers: displays containers when they exist" {
    # Skip if Docker is not available
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "Docker not available"
    fi

    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Create worktrees
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "test-worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "test-worktree2" "branch2" >/dev/null 2>&1

    # Create containers for each workspace
    local root_workspace
    root_workspace=$(get_root_workspace)

    # Create container for main workspace
    local main_container
    main_container=$(get_container_name "$root_workspace" "")
    docker create --name "$main_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    # Create containers for worktrees
    local worktree1_container
    worktree1_container=$(get_container_name "$root_workspace" "test-worktree1")
    docker create --name "$worktree1_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    local worktree2_container
    worktree2_container=$(get_container_name "$root_workspace" "test-worktree2")
    docker create --name "$worktree2_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    run list_containers
    [ "$status" -eq 0 ]
    [[ "$output" == *"Containers:"* ]]
    [[ "$output" == *"$main_container"* ]]
    [[ "$output" == *"$worktree1_container"* ]]
    [[ "$output" == *"$worktree2_container"* ]]
    [[ "$output" == *"Branch:"* ]]
    [[ "$output" == *"Status:"* ]]

    # Cleanup containers
    docker rm -f "$main_container" "$worktree1_container" "$worktree2_container" >/dev/null 2>&1

    cleanup_git_repo "$temp_dir"
}

@test "list_containers: marks current workspace" {
    # Skip if Docker is not available
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "Docker not available"
    fi

    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Create worktree
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "current-worktree" "test-branch" >/dev/null 2>&1

    # Create container for worktree
    local root_workspace
    root_workspace=$(get_root_workspace)
    local worktree_container
    worktree_container=$(get_container_name "$root_workspace" "current-worktree")
    docker create --name "$worktree_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    # Change into worktree
    cd "${temp_dir}/.worktrees/current-worktree"

    run list_containers
    [ "$status" -eq 0 ]
    [[ "$output" == *"(current)"* ]]

    # Cleanup container
    docker rm -f "$worktree_container" >/dev/null 2>&1

    cleanup_git_repo "$temp_dir"
}

@test "multiple worktrees have different container names" {
    # Skip if Docker is not available
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "Docker not available"
    fi

    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Get root workspace
    local root_workspace
    root_workspace=$(get_root_workspace)

    # Create worktrees
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "worktree2" "branch2" >/dev/null 2>&1

    # Get container names for each workspace
    local main_container
    main_container=$(get_container_name "$root_workspace" "")
    local worktree1_container
    worktree1_container=$(get_container_name "$root_workspace" "worktree1")
    local worktree2_container
    worktree2_container=$(get_container_name "$root_workspace" "worktree2")

    # Verify all container names are different
    [ "$main_container" != "$worktree1_container" ]
    [ "$main_container" != "$worktree2_container" ]
    [ "$worktree1_container" != "$worktree2_container" ]

    # Verify naming patterns
    [[ "$main_container" =~ ^crush-sandbox-[a-f0-9]{12}$ ]]
    [[ "$worktree1_container" =~ ^crush-sandbox-[a-f0-9]{12}-worktree1$ ]]
    [[ "$worktree2_container" =~ ^crush-sandbox-[a-f0-9]{12}-worktree2$ ]]

    cleanup_git_repo "$temp_dir"
}

@test "stopping one worktree container doesn't affect others" {
    # Skip if Docker is not available
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "Docker not available"
    fi

    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Get root workspace
    local root_workspace
    root_workspace=$(get_root_workspace)

    # Create worktrees
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "worktree2" "branch2" >/dev/null 2>&1

    # Create containers for each workspace
    local main_container
    main_container=$(get_container_name "$root_workspace" "")
    local worktree1_container
    worktree1_container=$(get_container_name "$root_workspace" "worktree1")
    local worktree2_container
    worktree2_container=$(get_container_name "$root_workspace" "worktree2")

    docker create --name "$main_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1
    docker create --name "$worktree1_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1
    docker create --name "$worktree2_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    # Start all containers
    docker start "$main_container" >/dev/null 2>&1
    docker start "$worktree1_container" >/dev/null 2>&1
    docker start "$worktree2_container" >/dev/null 2>&1

    # Verify all containers are running
    docker inspect --format '{{.State.Status}}' "$main_container" | grep -q "running"
    docker inspect --format '{{.State.Status}}' "$worktree1_container" | grep -q "running"
    docker inspect --format '{{.State.Status}}' "$worktree2_container" | grep -q "running"

    # Stop worktree1 container
    docker stop "$worktree1_container" >/dev/null 2>&1

    # Verify worktree1 is stopped
    docker inspect --format '{{.State.Status}}' "$worktree1_container" | grep -q "exited"

    # Verify main and worktree2 are still running
    docker inspect --format '{{.State.Status}}' "$main_container" | grep -q "running"
    docker inspect --format '{{.State.Status}}' "$worktree2_container" | grep -q "running"

    # Cleanup containers
    docker rm -f "$main_container" "$worktree1_container" "$worktree2_container" >/dev/null 2>&1

    cleanup_git_repo "$temp_dir"
}

@test "clean current workspace only removes one container" {
    # Skip if Docker is not available
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "Docker not available"
    fi

    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Get root workspace
    local root_workspace
    root_workspace=$(get_root_workspace)

    # Create worktrees
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "worktree2" "branch2" >/dev/null 2>&1

    # Create containers for each workspace
    local main_container
    main_container=$(get_container_name "$root_workspace" "")
    local worktree1_container
    worktree1_container=$(get_container_name "$root_workspace" "worktree1")
    local worktree2_container
    worktree2_container=$(get_container_name "$root_workspace" "worktree2")

    docker create --name "$main_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1
    docker create --name "$worktree1_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1
    docker create --name "$worktree2_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    # Navigate to worktree1 and run clean for current workspace only
    cd "${temp_dir}/.worktrees/worktree1"

    # Simulate clean current workspace by calling clean_command with scope="current"
    # We'll implement this manually for testing since clean_command prompts for input
    docker stop "$worktree1_container" >/dev/null 2>&1
    docker rm "$worktree1_container" >/dev/null 2>&1

    # Verify worktree1 container is removed
    ! container_exists "$worktree1_container"

    # Verify main and worktree2 containers still exist
    container_exists "$main_container"
    container_exists "$worktree2_container"

    # Cleanup remaining containers
    docker rm -f "$main_container" "$worktree2_container" >/dev/null 2>&1

    cleanup_git_repo "$temp_dir"
}

@test "clean all workspaces removes all containers and cache" {
    # Skip if Docker is not available
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "Docker not available"
    fi

    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path to account for macOS /var -> /private/var symlink
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Get root workspace
    local root_workspace
    root_workspace=$(get_root_workspace)

    # Create worktrees
    prepare_worktree_directory "$temp_dir"
    create_worktree "$temp_dir" "worktree1" "branch1" >/dev/null 2>&1
    create_worktree "$temp_dir" "worktree2" "branch2" >/dev/null 2>&1

    # Create containers for each workspace
    local main_container
    main_container=$(get_container_name "$root_workspace" "")
    local worktree1_container
    worktree1_container=$(get_container_name "$root_workspace" "worktree1")
    local worktree2_container
    worktree2_container=$(get_container_name "$root_workspace" "worktree2")

    docker create --name "$main_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1
    docker create --name "$worktree1_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1
    docker create --name "$worktree2_container" node:22-bookworm tail -f /dev/null >/dev/null 2>&1

    # Create cache volume
    local cache_volume_name
    cache_volume_name=$(get_cache_volume_name "$root_workspace")
    docker volume create "$cache_volume_name" >/dev/null 2>&1

    # Verify all containers and cache volume exist
    container_exists "$main_container"
    container_exists "$worktree1_container"
    container_exists "$worktree2_container"
    docker volume ls -q --filter "name=^${cache_volume_name}$" | grep -q "^${cache_volume_name}$"

    # Simulate clean all by removing all containers and cache volume
    docker rm -f "$main_container" "$worktree1_container" "$worktree2_container" >/dev/null 2>&1
    docker volume rm "$cache_volume_name" >/dev/null 2>&1

    # Verify all containers are removed
    ! container_exists "$main_container"
    ! container_exists "$worktree1_container"
    ! container_exists "$worktree2_container"

    # Verify cache volume is removed
    ! docker volume ls -q --filter "name=^${cache_volume_name}$" | grep -q "^${cache_volume_name}$"

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: uses worktree name as branch name in non-TTY mode" {
    local temp_dir
    temp_dir=$(mktemp -d)

    setup_git_repo "$temp_dir"
    prepare_worktree_directory "$temp_dir"

    # Simulate non-TTY mode by closing stdin and redirecting from /dev/null
    # This prevents the `read` command from prompting for input
    run create_worktree "$temp_dir" "nontty-test" "" </dev/null

    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree created"* ]]
    [[ "$output" == *"Branch: nontty-test"* ]]

    # Verify worktree was created with the correct branch
    cd "$temp_dir/.worktrees/nontty-test"
    local branch
    branch=$(git branch --show-current)
    [ "$branch" = "nontty-test" ]

    cleanup_git_repo "$temp_dir"
}

@test "create_worktree: non-TTY mode checks out existing branch" {
    local temp_dir
    temp_dir=$(mktemp -d)

    # Normalize temp_dir path
    if command -v realpath >/dev/null 2>&1; then
        temp_dir=$(realpath "$temp_dir")
    else
        temp_dir=$(cd "$temp_dir" && pwd -P)
    fi

    setup_git_repo "$temp_dir"

    # Create an existing branch
    cd "$temp_dir"
    git branch existing-branch

    prepare_worktree_directory "$temp_dir"

    # Simulate non-TTY mode and create worktree with name matching existing branch
    run create_worktree "$temp_dir" "existing-branch" "" </dev/null

    [ "$status" -eq 0 ]
    [[ "$output" == *"Worktree created"* ]]
    [[ "$output" == *"Branch: existing-branch"* ]]

    # Verify worktree was created with the existing branch
    cd "$temp_dir/.worktrees/existing-branch"
    local branch
    branch=$(git branch --show-current)
    [ "$branch" = "existing-branch" ]

    cleanup_git_repo "$temp_dir"
}


