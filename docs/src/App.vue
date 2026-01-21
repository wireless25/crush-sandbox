<script setup lang="ts">
import { ref } from 'vue'
import pkg from '../../package.json'

const copiedCode = ref<string | null>(null)

const copyToClipboard = async (code: string, id: string) => {
  try {
    await navigator.clipboard.writeText(code)
    copiedCode.value = id
    setTimeout(() => {
      copiedCode.value = null
    }, 2000)
  } catch (err) {
    console.error('Failed to copy:', err)
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#0a0a0a] text-[#e0e0e0] font-mono">
    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0a] border-b-2 border-[#ffb000]">
      <div class="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <span class="text-[#ffb000] text-xl font-bold tracking-tight">&gt;_ crush-sandbox</span>
        </div>
        <div class="flex items-center gap-4 text-xs">
          <span class="text-[#666]">v{{ pkg.version }}</span>
          <span class="hidden md:inline text-[#666]">|</span>
          <a href="https://github.com/wireless25/crush-sandbox" target="_blank" rel="noopener noreferrer" class="text-[#999] hover:text-[#ffb000] transition-colors">GITHUB</a>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="pt-16 px-4">
      <!-- Hero Section -->
      <section class="max-w-7xl mx-auto py-16 md:py-24">
        <div class="grid md:grid-cols-2 gap-12 items-start">
          <!-- Left: Title & Description -->
          <div class="space-y-8">
            <div class="space-y-4">
              <h1 class="text-5xl md:text-7xl font-bold text-[#ffb000] leading-none">
                CRUSH CLI SANDBOX
              </h1>
              <h2 class="text-3xl md:text-4xl font-bold text-[#e0e0e0] leading-tight">
                with Docker and Git Worktree Support
              </h2>
            </div>

            <p class="text-[#999] text-lg leading-relaxed max-w-lg border-l-4 border-[#ffb000] pl-6">
              Work on multiple git branches simultaneously with isolated Crush CLI sandboxes in secure Docker containers. Perfect for AI-assisted parallel development.
            </p>

            <div class="flex flex-wrap gap-4">
              <a href="https://github.com/wireless25/crush-sandbox" target="_blank" rel="noopener noreferrer" 
                 class="inline-flex items-center gap-3 px-6 py-4 bg-[#ffb000] text-[#0a0a0a] font-bold hover:bg-[#ffcc00] transition-colors border-4 border-[#ffb000]">
                <span>VIEW SOURCE</span>
              </a>
              <a href="#installation" 
                 class="inline-flex items-center justify-center px-6 py-4 border-4 border-[#333] text-[#e0e0e0] font-bold hover:border-[#ffb000] hover:text-[#ffb000] transition-colors">
                INSTALL
              </a>
            </div>
          </div>

          <!-- Right: Terminal Preview -->
          <div class="relative">
            <div class="bg-[#111] border-2 border-[#333]">
              <!-- Terminal Header -->
              <div class="flex items-center gap-2 px-4 py-3 border-b border-[#333] bg-[#0d0d0d]">
                <span class="w-3 h-3 bg-[#ff5f56]"></span>
                <span class="w-3 h-3 bg-[#ffb000]"></span>
                <span class="w-3 h-3 bg-[#00ca4e]"></span>
                <span class="ml-4 text-xs text-[#666]">crush-sandbox — zsh</span>
              </div>
              
              <!-- Terminal Body -->
              <div class="p-6 text-sm space-y-3">
                <div class="flex gap-3">
                  <span class="text-[#ffb000]">➜</span>
                  <span class="text-[#666]">~</span>
                  <span class="text-[#e0e0e0]">crush-sandbox run --worktree feat/oauth2</span>
                </div>
                <div class="text-[#999] pl-6"> ● Container created: crush-sandbox-eecfd1734918-feat/oauth2</div>
                <div class="text-[#999] pl-6"> ● Cache volume created: crush-cache-eecfd1734918</div>
                <div class="text-[#999] pl-6"> ● Crush CLI installed successfully</div>
                <div class="text-[#999] pl-6"> ● Setup Crush configuration...</div>
                <div class="flex gap-3 pt-2">
                  <span class="text-[#ffb000]">➜</span>
                  <span class="text-[#666]">~</span>
                  <span class="animate-pulse text-[#ffb000]">█</span>
                </div>
              </div>
            </div>

            <!-- Decorative Corner -->
            <div class="absolute -top-2 -right-2 w-0 h-0 border-t-4 border-r-4 border-[#ffb000]"></div>
          </div>
        </div>
      </section>

      <!-- Features Grid -->
      <section class="max-w-7xl mx-auto py-16">
        <div class="border-b-4 border-[#333] pb-4 mb-12">
          <span class="text-xs text-[#ffb000] tracking-widest uppercase">// Features</span>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          <!-- Feature 1: WORKTREE (PRIMARY) -->
          <div class="p-6 border-2 border-[#ffb000] hover:border-[#ffb000] transition-colors group bg-[#0f0a00]">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">01</span>
              <span class="text-xs text-[#666] border border-[#ffb000] px-2 py-1">PRIMARY</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Git Worktrees</h3>
            <p class="text-[#999] text-sm leading-relaxed">Work on multiple branches simultaneously without git conflicts. Isolated environments for parallel AI development.</p>
          </div>

          <!-- Feature 2: CONTAINER -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">02</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CONTAINER</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Isolation</h3>
            <p class="text-[#999] text-sm leading-relaxed">Per-worktree Docker containers with crash isolation, shared caches across worktrees, and non-root user security.</p>
          </div>

          <!-- Feature 3: CACHE -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">03</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CACHE</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Per-Workspace Caching</h3>
            <p class="text-[#999] text-sm leading-relaxed">Persistent npm and pnpm caches per workspace. Fast installs every time.</p>
          </div>

          <!-- Feature 4 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">04</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">AUTO</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Crush CLI Install</h3>
            <p class="text-[#999] text-sm leading-relaxed">Automatically installs Crush CLI on first use via npm global install.</p>
          </div>

          <!-- Feature 5 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">05</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">GIT</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Git Config Passthrough</h3>
            <p class="text-[#999] text-sm leading-relaxed">Reads ~/.gitconfig and passes user.name and user.email to container.</p>
          </div>

          <!-- Feature 6 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">06</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">SECURE</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Security Hardening</h3>
            <p class="text-[#999] text-sm leading-relaxed">Resource limits, capability dropping, and non-root user for reduced attack surface.</p>
          </div>
        </div>
      </section>

      <!-- Installation -->
      <section id="installation" class="max-w-7xl mx-auto py-16">
        <div class="border-b-4 border-[#333] pb-4 mb-12">
          <span class="text-xs text-[#ffb000] tracking-widest uppercase">// Installation</span>
        </div>

        <div class="space-y-8">
          <!-- Method 1: npm global install (RECOMMENDED) -->
          <div class="border-2 border-[#ffb000] bg-[#0f0a00]">
            <div class="flex items-center gap-3 px-4 py-3 border-b-2 border-[#ffb000] bg-[#ffb000]">
              <span class="text-[#0a0a0a] font-bold text-sm">RECOMMENDED</span>
            </div>
            <div class="p-6">
              <div class="flex items-start justify-between mb-4">
                <div>
                  <h3 class="text-xl font-bold text-[#ffb000] mb-2">npm global install</h3>
                  <p class="text-[#999] text-sm">global npm installation for crush-sandbox.</p>
                </div>
              </div>

              <div class="relative group/code">
                <button
                  @click="copyToClipboard('npm install -g crush-sandbox', 'npm-global')"
                  class="absolute top-2 right-2 z-10 p-2 border border-[#333] bg-[#1a1a1a] hover:border-[#ffb000] hover:text-[#ffb000] transition-colors"
                  aria-label="Copy to clipboard">
                  <span v-if="copiedCode !== 'npm-global'" class="text-xs">COPY</span>
                  <span v-else class="text-xs text-green-400">COPIED</span>
                </button>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">npm install -g crush-sandbox</code>
                </div>
              </div>
            </div>
          </div>

          <!-- Method 2: One-Command Wrapper Install -->
          <div class="border-2 border-[#222]">
            <div class="p-6">
              <h3 class="text-xl font-bold text-[#e0e0e0] mb-4">Install script (single command)</h3>
              <p class="text-[#999] text-sm mb-6">Install the crush-sandbox script directly on your system</p>

              <div class="relative group/code">
                <button
                  @click="copyToClipboard('curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null\nsudo chmod +x /usr/local/bin/crush-sandbox\nln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox', 'one-cmd')"
                  class="absolute top-2 right-2 z-10 p-2 border border-[#333] bg-[#1a1a1a] hover:border-[#ffb000] hover:text-[#ffb000] transition-colors"
                  aria-label="Copy to clipboard">
                  <span v-if="copiedCode !== 'one-cmd'" class="text-xs">COPY</span>
                  <span v-else class="text-xs text-green-400">COPIED</span>
                </button>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null</code>
                  <br>
                  <code class="text-[#e0e0e0]">sudo chmod +x /usr/local/bin/crush-sandbox</code>
                  <br>
                  <code class="text-[#e0e0e0]">ln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox</code>
                </div>
              </div>
            </div>
          </div>

          <!-- Method 2: Manual -->
          <div class="border-2 border-[#222]">
            <div class="p-6">
              <h3 class="text-xl font-bold text-[#e0e0e0] mb-4">Manual Installation</h3>
              <p class="text-[#999] text-sm mb-6">Download and install step-by-step. Review the script first.</p>

              <div class="space-y-4">
                <div class="relative group/code">
                  <div class="flex items-center justify-between mb-2">
                    <span class="text-xs text-[#ffb000]">STEP 1: DOWNLOAD</span>
                    <button 
                      @click="copyToClipboard('curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush', 'manual-1')"
                      class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                      aria-label="Copy">
                      {{ copiedCode === 'manual-1' ? 'COPIED' : 'COPY' }}
                    </button>
                  </div>
                  <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
                    <code class="text-[#e0e0e0]">curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush</code>
                  </div>
                </div>

                <div class="relative group/code">
                  <div class="flex items-center justify-between mb-2">
                    <span class="text-xs text-[#ffb000]">STEP 2: EXECUTABLE</span>
                    <button 
                      @click="copyToClipboard('chmod +x docker-sandbox-crush', 'manual-2')"
                      class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                      aria-label="Copy">
                      {{ copiedCode === 'manual-2' ? 'COPIED' : 'COPY' }}
                    </button>
                  </div>
                  <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
                    <code class="text-[#e0e0e0]">chmod +x docker-sandbox-crush</code>
                  </div>
                </div>

                <div class="relative group/code">
                  <div class="flex items-center justify-between mb-2">
                    <span class="text-xs text-[#ffb000]">STEP 3: MOVE TO PATH</span>
                    <button 
                      @click="copyToClipboard('sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox', 'manual-3')"
                      class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                      aria-label="Copy">
                      {{ copiedCode === 'manual-3' ? 'COPIED' : 'COPY' }}
                    </button>
                  </div>
                  <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
                    <code class="text-[#e0e0e0]">sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox</code>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Method 3: From Clone -->
          <div class="border-2 border-[#222]">
            <div class="p-6">
              <h3 class="text-xl font-bold text-[#e0e0e0] mb-4">Install from Clone</h3>
              <p class="text-[#999] text-sm mb-6">Already cloned? Use the built-in install command.</p>

              <div class="relative group/code">
                <button 
                  @click="copyToClipboard('./docker-sandbox-crush install', 'from-clone')"
                  class="absolute top-2 right-2 z-10 p-2 border border-[#333] bg-[#1a1a1a] hover:border-[#ffb000] hover:text-[#ffb000] transition-colors"
                  aria-label="Copy to clipboard">
                  <span v-if="copiedCode !== 'from-clone'" class="text-xs">COPY</span>
                  <span v-else class="text-xs text-green-400">COPIED</span>
                </button>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
                  <code class="text-[#e0e0e0]">./docker-sandbox-crush install</code>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Prerequisites & Verify -->
        <div class="grid md:grid-cols-2 gap-6 mt-8">
          <div class="p-6 border-2 border-[#222]">
            <h4 class="text-lg font-bold text-[#ffb000] mb-4 flex items-center gap-2">
              <span>[!]</span> PREREQUISITES
            </h4>
            <ul class="space-y-3 text-sm">
              <li class="flex items-start gap-3 text-[#e0e0e0]">
                <span class="text-[#ffb000] mt-1">›</span>
                <span><strong class="text-[#ffb000]">macOS</strong> (primary target)</span>
              </li>
              <li class="flex items-start gap-3 text-[#e0e0e0]">
                <span class="text-[#ffb000] mt-1">›</span>
                <span><strong class="text-[#ffb000]">Docker Desktop</strong> installed and running</span>
              </li>
              <li class="flex items-start gap-3 text-[#e0e0e0]">
                <span class="text-[#ffb000] mt-1">›</span>
                <span><strong class="text-[#ffb000]">npm</strong> (comes with Node.js, required for npm global install)</span>
              </li>
              <li class="flex items-start gap-3 text-[#e0e0e0]">
                <span class="text-[#ffb000] mt-1">›</span>
                <span><strong class="text-[#ffb000]">curl</strong> or <strong class="text-[#ffb000]">wget</strong> for downloading</span>
              </li>
            </ul>
          </div>

          <div class="p-6 border-2 border-[#222]">
            <h4 class="text-lg font-bold text-[#ffb000] mb-4 flex items-center gap-2">
              <span>[✓]</span> VERIFY INSTALLATION
            </h4>
            <p class="text-[#999] text-sm mb-4">Check that crush-sandbox is working:</p>
            <div class="relative group/code">
              <button 
                @click="copyToClipboard('crush-sandbox --version', 'verify')"
                class="absolute top-2 right-2 z-10 p-2 border border-[#333] bg-[#1a1a1a] hover:border-[#ffb000] hover:text-[#ffb000] transition-colors"
                aria-label="Copy to clipboard">
                <span v-if="copiedCode !== 'verify'" class="text-xs">COPY</span>
                <span v-else class="text-xs text-green-400">COPIED</span>
              </button>
              <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
                <code class="text-[#e0e0e0]">crush-sandbox --version</code>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Git Worktrees Section -->
      <section class="max-w-7xl mx-auto py-16">
        <div class="border-b-4 border-[#ffb000] pb-4 mb-12">
          <span class="text-xs text-[#ffb000] tracking-widest uppercase">// Git Worktrees</span>
        </div>

        <div class="space-y-12">
          <!-- What are Worktrees -->
          <div class="p-6 border-2 border-[#222]">
            <h3 class="text-2xl font-bold text-[#ffb000] mb-4">What are Git Worktrees?</h3>
            <p class="text-[#999] text-sm mb-6 leading-relaxed">
              Git worktrees allow you to check out multiple branches simultaneously in different directories.
            </p>

            <div class="grid md:grid-cols-2 gap-4 mb-6">
              <div class="p-4 border border-[#333]">
                <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">Traditional Git</h4>
                <ul class="space-y-2 text-sm text-[#999]">
                  <li class="flex items-start gap-2"><span class="text-red-400">✗</span><span>Work on one feature at a time</span></li>
                  <li class="flex items-start gap-2"><span class="text-red-400">✗</span><span>Stash or commit to switch branches</span></li>
                  <li class="flex items-start gap-2"><span class="text-red-400">✗</span><span>Slow context switching (30-60s)</span></li>
                  <li class="flex items-start gap-2"><span class="text-red-400">✗</span><span>Crush limited to current branch</span></li>
                </ul>
              </div>

              <div class="p-4 border-2 border-[#ffb000] bg-[#0f0a00]">
                <h4 class="text-lg font-bold text-[#ffb000] mb-2">With Worktrees</h4>
                <ul class="space-y-2 text-sm text-[#999]">
                  <li class="flex items-start gap-2"><span class="text-green-400">✓</span><span>Multiple branches simultaneously</span></li>
                  <li class="flex items-start gap-2"><span class="text-green-400">✓</span><span>Instant switching</span></li>
                  <li class="flex items-start gap-2"><span class="text-green-400">✓</span><span>Perfect for AI agents</span></li>
                  <li class="flex items-start gap-2"><span class="text-green-400">✓</span><span>Isolated development environments</span></li>
                </ul>
              </div>
            </div>

            <div class="bg-[#111] border-2 border-[#333] p-4 font-mono text-xs overflow-x-auto">
              <pre class="text-[#999]">my-project/              # Main workspace (main branch)
├── src/
├── .worktrees/          # Worktree directory
│   ├── feature-login/   # Worktree 1 (feature/login branch)
│   ├── fix-bug-123/      # Worktree 2 (bugfix/123 branch)
│   └── api-refactor/      # Worktree 3 (refactor/api branch)
└── package.json</pre>
            </div>
          </div>

          <!-- Worktree Commands -->
          <div class="p-6 border-2 border-[#222]">
            <h3 class="text-2xl font-bold text-[#ffb000] mb-4">Worktree Commands</h3>
            <div class="space-y-4">
              <div class="relative group/code">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs text-[#ffb000]">CREATE WORKTREE (AUTO-GENERATED NAME)</span>
                  <button
                    @click="copyToClipboard('crush-sandbox run --worktree', 'web-worktree-1')"
                    class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                    aria-label="Copy">
                    {{ copiedCode === 'web-worktree-1' ? 'COPIED' : 'COPY' }}
                  </button>
                </div>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">crush-sandbox run --worktree</code>
                </div>
              </div>

              <div class="relative group/code">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs text-[#ffb000]">CREATE WORKTREE (CUSTOM NAME)</span>
                  <button
                    @click="copyToClipboard('crush-sandbox run --worktree feature-login', 'web-worktree-2')"
                    class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                    aria-label="Copy">
                    {{ copiedCode === 'web-worktree-2' ? 'COPIED' : 'COPY' }}
                  </button>
                </div>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">crush-sandbox run --worktree feature-login</code>
                </div>
              </div>

              <div class="relative group/code">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs text-[#ffb000]">LIST WORKTREES</span>
                  <button
                    @click="copyToClipboard('crush-sandbox list-worktrees', 'web-worktree-3')"
                    class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                    aria-label="Copy">
                    {{ copiedCode === 'web-worktree-3' ? 'COPIED' : 'COPY' }}
                  </button>
                </div>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">crush-sandbox list-worktrees</code>
                </div>
              </div>

              <div class="relative group/code">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs text-[#ffb000]">REMOVE WORKTREE</span>
                  <button
                    @click="copyToClipboard('crush-sandbox remove-worktree feature-login', 'web-worktree-4')"
                    class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                    aria-label="Copy">
                    {{ copiedCode === 'web-worktree-4' ? 'COPIED' : 'COPY' }}
                  </button>
                </div>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">crush-sandbox remove-worktree feature-login</code>
                </div>
              </div>

              <div class="relative group/code">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs text-[#ffb000]">FORCE REMOVE (WITH UNCOMMITTED CHANGES)</span>
                  <button
                    @click="copyToClipboard('crush-sandbox remove-worktree feature-login --force', 'web-worktree-5')"
                    class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                    aria-label="Copy">
                    {{ copiedCode === 'web-worktree-5' ? 'COPIED' : 'COPY' }}
                  </button>
                </div>
                <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono overflow-x-auto">
                  <code class="text-[#e0e0e0]">crush-sandbox remove-worktree feature-login --force</code>
                </div>
              </div>
            </div>
          </div>

          <!-- Why Worktrees -->
          <div class="p-6 border-2 border-[#222]">
            <h3 class="text-2xl font-bold text-[#ffb000] mb-4">Why Worktrees Matter for AI Development</h3>
            <div class="grid md:grid-cols-2 gap-6">
              <div class="space-y-3">
                <div class="flex items-start gap-3">
                  <span class="text-[#ffb000] text-2xl">1</span>
                  <div>
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-1">Parallel Development</h4>
                    <p class="text-[#999] text-sm">Work on multiple features simultaneously without context switching</p>
                  </div>
                </div>

                <div class="flex items-start gap-3">
                  <span class="text-[#ffb000] text-2xl">2</span>
                  <div>
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-1">No Git Conflicts</h4>
                    <p class="text-[#999] text-sm">Each worktree is isolated - no stashing or committing needed</p>
                  </div>
                </div>

                <div class="flex items-start gap-3">
                  <span class="text-[#ffb000] text-2xl">3</span>
                  <div>
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-1">AI Agent Isolation</h4>
                    <p class="text-[#999] text-sm">Crush generates code in one worktree, you review in another</p>
                  </div>
                </div>
              </div>

              <div class="space-y-3">
                <div class="flex items-start gap-3">
                  <span class="text-[#ffb000] text-2xl">4</span>
                  <div>
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-1">Instant Switching</h4>
                    <p class="text-[#999] text-sm">Jump between worktrees (no git checkout)</p>
                  </div>
                </div>

                <div class="flex items-start gap-3">
                  <span class="text-[#ffb000] text-2xl">5</span>
                  <div>
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-1">Isolated Environments</h4>
                    <p class="text-[#999] text-sm">Each worktree has its own Crush sandbox (crash-safe) and shared npm/pnpm cache</p>
                  </div>
                </div>

                <div class="flex items-start gap-3">
                  <span class="text-[#ffb000] text-2xl">6</span>
                  <div>
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-1">Safe Experimentation</h4>
                    <p class="text-[#999] text-sm">Test risky changes in worktree without affecting main</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Docker Containerization Section -->
      <section class="max-w-7xl mx-auto py-16">
        <div class="border-b-4 border-[#ffb000] pb-4 mb-12">
          <span class="text-xs text-[#ffb000] tracking-widest uppercase">// Docker Containerization</span>
        </div>

        <div class="space-y-12">
          <!-- Why Docker -->
          <div class="p-8 border-2 border-[#ffb000] bg-[#0f0a00] relative overflow-hidden">
            <div class="absolute top-0 right-0 w-64 h-64 border-4 border-[#ffb000] rounded-full opacity-5 translate-x-32 -translate-y-32"></div>
            <div class="relative">
              <h3 class="text-4xl font-bold text-[#ffb000] mb-6">Why Dockerize Crush CLI?</h3>
              <p class="text-[#999] text-base leading-relaxed mb-8 max-w-3xl">
                Dockerizing the Crush CLI agent transforms AI-assisted development from a local tool into an isolated, reproducible, and secure environment. It's not just about convenience—it's about creating production-grade development workflows that scale.
              </p>

              <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div class="p-5 border border-[#ffb000] bg-[#0a0a0a]">
                  <div class="flex items-center gap-3 mb-3">
                    <span class="text-3xl font-bold text-[#ffb000]">01</span>
                    <h4 class="text-lg font-bold text-[#e0e0e0]">Crash Isolation</h4>
                  </div>
                  <p class="text-[#999] text-sm">AI agents experiment freely. Code crashes, tests fail, dependencies break but your host system stays pristine.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <div class="flex items-center gap-3 mb-3">
                    <span class="text-3xl font-bold text-[#ffb000]">02</span>
                    <h4 class="text-lg font-bold text-[#e0e0e0]">Read only access</h4>
                  </div>
                  <p class="text-[#999] text-sm">The agent runs in the sandbox without access to your host machine (outside the current workspace). Configs are mounted read only. Just use the --yolo flag without fear.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <div class="flex items-center gap-3 mb-3">
                    <span class="text-3xl font-bold text-[#ffb000]">03</span>
                    <h4 class="text-lg font-bold text-[#e0e0e0]">Workspace mounting</h4>
                  </div>
                  <p class="text-[#999] text-sm">Your workspace directory is mounted into the container at the same absolute path. File paths in error messages match your host and scripts with hard-coded paths work as expected</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <div class="flex items-center gap-3 mb-3">
                    <span class="text-3xl font-bold text-[#ffb000]">04</span>
                    <h4 class="text-lg font-bold text-[#e0e0e0]">Security Hardening</h4>
                  </div>
                  <p class="text-[#999] text-sm">Non-root user, dropped capabilities, resource limits. AI agents run in a sandbox, not your entire system.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <div class="flex items-center gap-3 mb-3">
                    <span class="text-3xl font-bold text-[#ffb000]">05</span>
                    <h4 class="text-lg font-bold text-[#e0e0e0]">Parallel Development</h4>
                  </div>
                  <p class="text-[#999] text-sm">Multiple Crush sessions, multiple containers. True parallel AI development without interference.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <div class="flex items-center gap-3 mb-3">
                    <span class="text-3xl font-bold text-[#ffb000]">06</span>
                    <h4 class="text-lg font-bold text-[#e0e0e0]">Instant Reset</h4>
                  </div>
                  <p class="text-[#999] text-sm">Mess up? Start fresh. One command rebuilds the environment. No manual cleanup required.</p>
                </div>
              </div>
            </div>
          </div>

          <!-- How It Works -->
          <div class="p-8 border-2 border-[#222]">
            <h3 class="text-4xl font-bold text-[#ffb000] mb-6">How It Works</h3>
            <p class="text-[#999] text-base leading-relaxed mb-8">
              crush-sandbox orchestrates Docker containers with intelligent workspace mounting, cache management, and automatic Crush CLI installation. Here's the magic behind the curtain:
            </p>

            <div class="space-y-8">
              <!-- Step 1 -->
              <div class="flex gap-6 items-start">
                <div class="flex-shrink-0 w-16 h-16 bg-[#ffb000] text-[#0a0a0a] flex items-center justify-center font-bold text-2xl">01</div>
                <div class="flex-1">
                  <h4 class="text-xl font-bold text-[#e0e0e0] mb-3">Container Creation</h4>
                  <p class="text-[#999] text-sm mb-4">A new Docker container is spawned with your project mounted inside. The container runs as a non-root user with dropped Linux capabilities for security.</p>
                </div>
              </div>

              <!-- Step 2 -->
              <div class="flex gap-6 items-start">
                <div class="flex-shrink-0 w-16 h-16 bg-[#ffb000] text-[#0a0a0a] flex items-center justify-center font-bold text-2xl">02</div>
                <div class="flex-1">
                  <h4 class="text-xl font-bold text-[#e0e0e0] mb-3">Volume Mounting</h4>
                  <p class="text-[#999] text-sm mb-4">Your project directory is mounted read-write into the container. Changes inside the container reflect instantly on your host system.</p>
                </div>
              </div>

              <!-- Step 3 -->
              <div class="flex gap-6 items-start">
                <div class="flex-shrink-0 w-16 h-16 bg-[#ffb000] text-[#0a0a0a] flex items-center justify-center font-bold text-2xl">03</div>
                <div class="flex-1">
                  <h4 class="text-xl font-bold text-[#e0e0e0] mb-3">Cache Management</h4>
                  <p class="text-[#999] text-sm mb-4">Per-workspace cache volumes persist across worktree containers and sessions. npm and pnpm install blazing fast every time — no redownloading packages.</p>
                </div>
              </div>

              <!-- Step 4 -->
              <div class="flex gap-6 items-start">
                <div class="flex-shrink-0 w-16 h-16 bg-[#ffb000] text-[#0a0a0a] flex items-center justify-center font-bold text-2xl">04</div>
                <div class="flex-1">
                  <h4 class="text-xl font-bold text-[#e0e0e0] mb-3">Automatic Crush CLI Install</h4>
                  <p class="text-[#999] text-sm mb-4">On first run, Crush CLI is installed globally inside the container via npm. Subsequent sessions use the cached installation.</p>
                </div>
              </div>

              <!-- Step 5 -->
              <div class="flex gap-6 items-start">
                <div class="flex-shrink-0 w-16 h-16 bg-[#ffb000] text-[#0a0a0a] flex items-center justify-center font-bold text-2xl">05</div>
                <div class="flex-1">
                  <h4 class="text-xl font-bold text-[#e0e0e0] mb-3">Git Configuration Passthrough</h4>
                  <p class="text-[#999] text-sm mb-4">Your git identity is automatically passed into the container. Commits made by Crush CLI use your real name and email.</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Security Features -->
          <div class="p-8 border-2 border-[#222]">
            <h3 class="text-4xl font-bold text-[#ffb000] mb-6">Security Architecture</h3>
            <p class="text-[#999] text-base leading-relaxed mb-8">
              Docker containers run with security-hardened defaults. AI agents execute code in a sandboxed environment with minimal attack surface.
            </p>

            <div class="grid md:grid-cols-2 gap-6">
              <div class="space-y-4">
                <div class="p-5 border-2 border-[#ffb000] bg-[#0f0a00]">
                  <h4 class="text-lg font-bold text-[#ffb000] mb-2">Non-Root User</h4>
                  <p class="text-[#999] text-sm">Container runs as your host UID/GID. No root privileges inside the container.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">Capability Dropping</h4>
                  <p class="text-[#999] text-sm">All Linux capabilities dropped. No CAP_NET_RAW, no CAP_SYS_ADMIN, nothing.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">No New Privileges</h4>
                  <p class="text-[#999] text-sm">Processes cannot gain additional privileges even if exploited.</p>
                </div>
              </div>

              <div class="space-y-4">
                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">Read-Only System</h4>
                  <p class="text-[#999] text-sm">Container filesystem is read-write only for workspace. Base system is immutable.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">Resource Limits</h4>
                  <p class="text-[#999] text-sm">CPU and memory limits prevent runaway processes from consuming host resources.</p>
                </div>

                <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                  <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">Ephemeral by Default</h4>
                  <p class="text-[#999] text-sm">Containers are deleted on exit (--rm flag). No residual processes or artifacts.</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Container Lifecycle -->
          <div class="p-8 border-2 border-[#222]">
            <h3 class="text-4xl font-bold text-[#ffb000] mb-6">Container Lifecycle</h3>
            <p class="text-[#999] text-base leading-relaxed mb-8">
              From creation to cleanup, every step is automated. You focus on code, crush-sandbox handles the infrastructure.
            </p>

            <div class="relative">
              <div class="absolute left-8 top-0 bottom-0 w-0.5 bg-[#333]"></div>
              <div class="space-y-8">
                <!-- Phase 1 -->
                <div class="relative pl-20">
                  <div class="absolute left-4 w-8 h-8 bg-[#ffb000] border-4 border-[#0a0a0a] rounded-full flex items-center justify-center">
                    <span class="text-[#0a0a0a] font-bold text-xs">1</span>
                  </div>
                  <div class="p-5 border border-[#ffb000] bg-[#0f0a00]">
                    <h4 class="text-lg font-bold text-[#ffb000] mb-2">INIT</h4>
                    <p class="text-[#999] text-sm">Container created with workspace mounted at the same absolute
                      path. Cache volumes attached. Environment variables set.</p>
                  </div>
                </div>

                <!-- Phase 2 -->
                <div class="relative pl-20">
                  <div class="absolute left-4 w-8 h-8 bg-[#ffb000] border-4 border-[#0a0a0a] rounded-full flex items-center justify-center">
                    <span class="text-[#0a0a0a] font-bold text-xs">2</span>
                  </div>
                  <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">SETUP</h4>
                    <p class="text-[#999] text-sm">Crush CLI installed (if not cached). Git configuration applied. Working directory set.</p>
                  </div>
                </div>

                <!-- Phase 3 -->
                <div class="relative pl-20">
                  <div class="absolute left-4 w-8 h-8 bg-[#ffb000] border-4 border-[#0a0a0a] rounded-full flex items-center justify-center">
                    <span class="text-[#0a0a0a] font-bold text-xs">3</span>
                  </div>
                  <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">EXECUTE</h4>
                    <p class="text-[#999] text-sm">Crush CLI runs. AI agent reads/writes code. Builds, tests, modifies—all inside the container.</p>
                  </div>
                </div>

                <!-- Phase 4 -->
                <div class="relative pl-20">
                  <div class="absolute left-4 w-8 h-8 bg-[#ffb000] border-4 border-[#0a0a0a] rounded-full flex items-center justify-center">
                    <span class="text-[#0a0a0a] font-bold text-xs">4</span>
                  </div>
                  <div class="p-5 border border-[#333] bg-[#0a0a0a]">
                    <h4 class="text-lg font-bold text-[#e0e0e0] mb-2">EXIT</h4>
                    <p class="text-[#999] text-sm">Crush CLI exits. Container is stopped. Cache volumes persist for next session.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Examples -->
      <section id="examples" class="max-w-7xl mx-auto py-16">
        <div class="border-b-4 border-[#333] pb-4 mb-12">
          <span class="text-xs text-[#ffb000] tracking-widest uppercase">// Usage Examples</span>
        </div>

        <div class="grid md:grid-cols-2 gap-4">
          <!-- Worktree Example 1 -->
          <div class="p-6 border-2 border-[#ffb000] hover:border-[#ffb000] transition-colors group bg-[#0f0a00]">
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center gap-2">
                <span class="text-xs text-[#666] border border-[#ffb000] px-2 py-1">WORKTREE</span>
                <span class="text-xs text-[#ffb000]">FEATURE</span>
              </div>
              <button
                @click="copyToClipboard('crush-sandbox run --worktree feature-login', 'web-ex-1')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'web-ex-1' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Create Worktree</h3>
            <p class="text-[#999] text-sm mb-4">Create isolated worktree for parallel development. Perfect for AI-assisted feature work.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox run --worktree feature-login</code>
            </div>
          </div>

          <!-- Worktree Example 2 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center gap-2">
                <span class="text-xs text-[#666] border border-[#333] px-2 py-1">WORKTREE</span>
                <span class="text-xs text-[#666]">LIST</span>
              </div>
              <button
                @click="copyToClipboard('crush-sandbox list-worktrees', 'web-ex-2')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'web-ex-2' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">List Worktrees</h3>
            <p class="text-[#999] text-sm mb-4">Show all worktrees and their branches. Marked with (current) for active worktree.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox list-worktrees</code>
            </div>
          </div>

          <!-- Example: List Containers -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">MANAGE</span>
              <button
                @click="copyToClipboard('crush-sandbox list-containers', 'web-ex-list-containers')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                <span v-if="copiedCode !== 'web-ex-list-containers'">COPY</span>
                <span v-else class="text-green-400">COPIED</span>
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">List Containers</h3>
            <p class="text-[#999] text-sm mb-4">Show all containers for the repository (main + all worktrees) with status indicators.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox list-containers</code>
            </div>
          </div>

          <!-- Example 3 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">BASIC</span>
              <button
                @click="copyToClipboard('crush-sandbox run', 'web-ex-3')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'web-ex-3' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Start Crush CLI</h3>
            <p class="text-[#999] text-sm mb-4">Launch Crush CLI in isolated Docker container with automatic workspace caching.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox run</code>
            </div>
          </div>

          <!-- Worktree Example 3 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center gap-2">
                <span class="text-xs text-[#666] border border-[#333] px-2 py-1">WORKTREE</span>
                <span class="text-xs text-[#666]">REMOVE</span>
              </div>
              <button
                @click="copyToClipboard('crush-sandbox remove-worktree feature-login', 'web-ex-4')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'web-ex-4' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Remove Worktree</h3>
            <p class="text-[#999] text-sm mb-4">Clean up worktree after merging feature. Use --force to remove with uncommitted changes.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox remove-worktree feature-login</code>
            </div>
          </div>

          <!-- Example 4 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">DEBUG</span>
              <button
                @click="copyToClipboard('crush-sandbox run --shell', 'web-ex-5')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'web-ex-5' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Shell inside container</h3>
            <p class="text-[#999] text-sm mb-4">Start interactive shell inside container for debugging and working on the sandbox.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox run --shell</code>
            </div>
          </div>

          <!-- Example 5 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CUSTOM</span>
              <button
                @click="copyToClipboard('DOCKER_SANDBOX_IMAGE=node:22-bookworm crush-sandbox run', 'web-ex-6')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'web-ex-6' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Custom Docker Image</h3>
            <p class="text-[#999] text-sm mb-4">Use different Node.js version or custom base image.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">DOCKER_SANDBOX_IMAGE=node:20-bookworm crush-sandbox run</code>
            </div>
          </div>
        </div>
      </section>

      <!-- Footer -->
      <footer class="max-w-7xl mx-auto py-16 border-t-2 border-[#222]">
        <div class="flex flex-col md:flex-row items-center justify-between gap-6">
          <div class="text-center md:text-left">
            <span class="text-[#ffb000] font-bold text-lg">crush-sandbox</span>
            <p class="text-[#666] text-xs mt-2">Docker sandbox for the Crush CLI</p>
          </div>
          <div class="flex items-center gap-6 text-xs">
            <a href="https://github.com/wireless25/crush-sandbox" target="_blank" rel="noopener noreferrer" class="text-[#999] hover:text-[#ffb000] transition-colors">GITHUB</a>
            <span class="text-[#333]">MIT LICENSE</span>
          </div>
        </div>
      </footer>
    </main>
  </div>
</template>
