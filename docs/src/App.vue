<script setup lang="ts">
import { ref } from 'vue'

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
          <span class="text-[#666]">v0.5.0</span>
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
                DOCKER SANDBOX
              </h1>
              <h2 class="text-3xl md:text-4xl font-bold text-[#e0e0e0] leading-tight">
                for the Crush CLI
              </h2>
            </div>

            <p class="text-[#999] text-lg leading-relaxed max-w-lg border-l-4 border-[#ffb000] pl-6">
              Isolate your Crush CLI development in secure Docker containers with per-workspace persistent caching for fast builds.
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
                  <span class="text-[#e0e0e0]">crush-sandbox run</span>
                </div>
                <div class="text-[#999] pl-6">[OK] Container created: crush-sandbox-a3f8b2c</div>
                <div class="text-[#999] pl-6">[OK] Cache mounted: /workspace-cache</div>
                <div class="text-[#999] pl-6">[OK] Crush CLI installed: v1.2.3</div>
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
          <!-- Feature 1 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">01</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CONTAINER</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Isolation</h3>
            <p class="text-[#999] text-sm leading-relaxed">Per-workspace Docker containers with resource limits and non-root user security.</p>
          </div>

          <!-- Feature 2 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">02</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CACHE</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Per-Workspace Caching</h3>
            <p class="text-[#999] text-sm leading-relaxed">Persistent npm and pnpm caches per workspace. Fast installs every time.</p>
          </div>

          <!-- Feature 3 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">03</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">AUTO</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Crush CLI Install</h3>
            <p class="text-[#999] text-sm leading-relaxed">Automatically installs Crush CLI on first use via npm global install.</p>
          </div>

          <!-- Feature 4 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">04</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">GIT</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Git Config Passthrough</h3>
            <p class="text-[#999] text-sm leading-relaxed">Reads ~/.gitconfig and passes user.name and user.email to container.</p>
          </div>

          <!-- Feature 5 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">05</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">SECURE</span>
            </div>
            <h3 class="text-xl font-bold text-[#e0e0e0] mb-3">Credential Scanning</h3>
            <p class="text-[#999] text-sm leading-relaxed">Optional gitleaks scanning before container starts. Warns if secrets detected.</p>
          </div>

          <!-- Feature 6 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors group">
            <div class="flex items-start justify-between mb-4">
              <span class="text-2xl text-[#ffb000]">06</span>
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">HARDENED</span>
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

      <!-- Examples -->
      <section id="examples" class="max-w-7xl mx-auto py-16">
        <div class="border-b-4 border-[#333] pb-4 mb-12">
          <span class="text-xs text-[#ffb000] tracking-widest uppercase">// Usage Examples</span>
        </div>

        <div class="grid md:grid-cols-2 gap-4">
          <!-- Example 1 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">BASIC</span>
              <button 
                @click="copyToClipboard('crush-sandbox run', 'ex-1')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'ex-1' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Start Crush CLI</h3>
            <p class="text-[#999] text-sm mb-4">Launch Crush CLI in isolated Docker container with automatic workspace caching.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox run</code>
            </div>
          </div>

          <!-- Example 2 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">DEBUG</span>
              <button 
                @click="copyToClipboard('crush-sandbox run --shell', 'ex-2')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'ex-2' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Debug with Shell</h3>
            <p class="text-[#999] text-sm mb-4">Start interactive shell inside container for debugging.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox run --shell</code>
            </div>
          </div>

          <!-- Example 3 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CLEAN</span>
              <button 
                @click="copyToClipboard('crush-sandbox clean', 'ex-3')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'ex-3' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Clean Workspace</h3>
            <p class="text-[#999] text-sm mb-4">Remove sandbox container and cache volume to start fresh.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox clean</code>
            </div>
          </div>

          <!-- Example 4 -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors">
            <div class="flex items-center justify-between mb-4">
              <span class="text-xs text-[#666] border border-[#333] px-2 py-1">CUSTOM</span>
              <button 
                @click="copyToClipboard('DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run', 'ex-4')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors"
                aria-label="Copy">
                {{ copiedCode === 'ex-4' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Custom Docker Image</h3>
            <p class="text-[#999] text-sm mb-4">Use different Node.js version or custom base image.</p>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run</code>
            </div>
          </div>

          <!-- Example 5 - Full width -->
          <div class="p-6 border-2 border-[#222] hover:border-[#ffb000] transition-colors md:col-span-2">
            <div class="flex flex-col md:flex-row md:items-start justify-between mb-4 gap-4">
              <div>
                <div class="flex items-center gap-2 mb-2">
                  <span class="text-xs text-[#666] border border-[#333] px-2 py-1">SECURE</span>
                  <span class="text-xs text-[#ffb000]">CREDENTIAL SCAN</span>
                </div>
                <h3 class="text-lg font-bold text-[#e0e0e0] mb-2">Scan Before Launch</h3>
                <p class="text-[#999] text-sm">Scan workspace for exposed credentials with gitleaks before starting container.</p>
              </div>
              <button 
                @click="copyToClipboard('crush-sandbox run --cred-scan', 'ex-5')"
                class="text-xs text-[#999] hover:text-[#ffb000] transition-colors whitespace-nowrap"
                aria-label="Copy">
                {{ copiedCode === 'ex-5' ? 'COPIED' : 'COPY' }}
              </button>
            </div>
            <div class="bg-[#0a0a0a] border-2 border-[#222] p-4 text-sm font-mono">
              <code class="text-[#e0e0e0]">crush-sandbox run --cred-scan</code>
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
