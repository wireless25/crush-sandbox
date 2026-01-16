<script setup lang="ts">
import { ref, onMounted } from 'vue'

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
  <div class="min-h-screen bg-[var(--bg-primary)] text-[var(--text-primary)]">
    <header class="fixed top-0 left-0 right-0 z-50 backdrop-blur-sm bg-[var(--bg-primary)]/90 border-b border-[var(--border-color)]">
      <div class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="w-9 h-9 rounded border border-[var(--accent-cyan)] flex items-center justify-center">
            <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
            </svg>
          </div>
          <div class="flex flex-col">
            <span class="text-lg font-medium font-mono tracking-tight">crush-sandbox</span>
            <span class="text-[10px] font-mono text-[var(--text-secondary)] uppercase tracking-widest">Docker wrapper</span>
          </div>
        </div>

        <a
          href="https://github.com/wireless25/crush-sandbox"
          target="_blank"
          rel="noopener noreferrer"
          class="inline-flex items-center gap-2 px-4 py-2 border border-[var(--border-color)] hover:border-[var(--accent-cyan)] text-sm font-mono transition-colors duration-200"
        >
          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
          </svg>
          <span>github</span>
        </a>
      </div>
    </header>

    <main class="pt-24 pb-16 px-6">
      <section class="max-w-6xl mx-auto py-16 md:py-24">
        <div class="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
          <div class="space-y-8">
            <div class="inline-flex items-center gap-2 px-3 py-1 border border-[var(--accent-sage)]/50 bg-[var(--accent-sage-dim)]">
              <span class="w-1.5 h-1.5 rounded-full bg-[var(--accent-sage)]"/>
              <span class="text-xs font-mono text-[var(--accent-sage)]">v0.5.0</span>
            </div>

            <h1 class="text-5xl md:text-6xl lg:text-7xl font-medium leading-[1.1] tracking-tight">
              <span class="block">crush-sandbox</span>
              <span class="block text-lg md:text-xl lg:text-2xl font-mono text-[var(--text-secondary)] mt-4 tracking-normal">
                Docker sandbox for the Crush CLI
              </span>
            </h1>

            <p class="text-lg text-[var(--text-secondary)] leading-relaxed max-w-lg font-light">
              Isolate your Crush CLI development in secure Docker containers. Persistent package caches per workspace keep builds fast.
            </p>

            <div class="flex flex-col sm:flex-row gap-3">
              <a
                href="#installation"
                class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-[var(--accent-cyan)] text-[var(--bg-primary)] rounded font-medium font-mono hover:bg-[var(--accent-cyan)]/90 transition-colors"
              >
                <span>Get Started</span>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </a>
              <a
                href="https://github.com/wireless25/crush-sandbox"
                target="_blank"
                rel="noopener noreferrer"
                class="inline-flex items-center justify-center gap-2 px-6 py-3 border border-[var(--border-color)] text-[var(--text-primary)] rounded font-medium font-mono hover:border-[var(--accent-cyan)]/50 transition-colors"
              >
                <span>View Source</span>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                </svg>
              </a>
            </div>
          </div>

          <div class="relative">
            <div class="bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded overflow-hidden">
              <div class="flex items-center gap-2 px-4 py-2.5 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                <div class="flex gap-1.5">
                  <span class="w-2.5 h-2.5 rounded-full border border-[var(--text-secondary)]/40"/>
                  <span class="w-2.5 h-2.5 rounded-full border border-[var(--text-secondary)]/40"/>
                  <span class="w-2.5 h-2.5 rounded-full border border-[var(--text-secondary)]/40"/>
                </div>
                <span class="ml-2 text-xs font-mono text-[var(--text-secondary)]">~/projects</span>
              </div>
              <div class="p-5 font-mono text-sm space-y-2.5">
                <div class="flex items-center gap-2">
                  <span class="text-[var(--accent-sage)]">$</span>
                  <span class="text-[var(--text-primary)]">crush-sandbox run</span>
                </div>
                <div class="text-[var(--text-secondary)] pl-4 text-xs">
                  → Container created: crush-sandbox-8f3d2a1
                </div>
                <div class="text-[var(--text-secondary)] pl-4 text-xs">
                  → Cache mounted: /workspace-cache (persistent)
                </div>
                <div class="text-[var(--text-secondary)] pl-4 text-xs">
                  → Crush CLI installed: v0.5.0
                </div>
                <div class="text-[var(--accent-sage)] pl-4 text-xs">
                  ✓ Ready
                </div>
                <div class="flex items-center gap-2 pt-1">
                  <span class="text-[var(--accent-sage)]">$</span>
                  <span class="text-[var(--accent-cyan)] animate-pulse">█</span>
                </div>
              </div>
            </div>

            <div class="absolute -top-3 -right-3 w-20 h-20 bg-[var(--accent-cyan)]/5 rounded blur-3xl"/>
          </div>
        </div>
      </section>

      <section class="max-w-6xl mx-auto py-16 md:py-24">
        <div class="text-center mb-12">
          <div class="inline-block px-3 py-1 mb-4 border border-[var(--border-color)] rounded">
            <span class="text-xs font-mono text-[var(--text-secondary)] uppercase tracking-widest">Features</span>
          </div>
          <h2 class="text-3xl md:text-4xl font-medium tracking-tight">
            Built for <span class="text-[var(--accent-cyan)]">isolated</span> development
          </h2>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div class="group relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="w-10 h-10 mb-4 flex items-center justify-center">
                <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
                </svg>
              </div>
              <h3 class="text-base font-medium mb-2 font-mono">Container Isolation</h3>
              <p class="text-sm text-[var(--text-secondary)] leading-relaxed">
                Per-workspace containers ensure clean, isolated environments
              </p>
            </div>
          </div>

          <div class="group relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="w-10 h-10 mb-4 flex items-center justify-center">
                <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
              </div>
              <h3 class="text-base font-medium mb-2 font-mono">Persistent Caching</h3>
              <p class="text-sm text-[var(--text-secondary)] leading-relaxed">
                npm and pnpm caches persist per workspace
              </p>
            </div>
          </div>

          <div class="group relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="w-10 h-10 mb-4 flex items-center justify-center">
                <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
              </div>
              <h3 class="text-base font-medium mb-2 font-mono">Auto Install</h3>
              <p class="text-sm text-[var(--text-secondary)] leading-relaxed">
                Crush CLI installed automatically on first use
              </p>
            </div>
          </div>

          <div class="group relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="w-10 h-10 mb-4 flex items-center justify-center">
                <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                </svg>
              </div>
              <h3 class="text-base font-medium mb-2 font-mono">Git Config</h3>
              <p class="text-sm text-[var(--text-secondary)] leading-relaxed">
                User.name and email passed to container
              </p>
            </div>
          </div>

          <div class="group relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="w-10 h-10 mb-4 flex items-center justify-center">
                <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
              </div>
              <h3 class="text-base font-medium mb-2 font-mono">Credential Scan</h3>
              <p class="text-sm text-[var(--text-secondary)] leading-relaxed">
                Optional gitleaks scanning before launch
              </p>
            </div>
          </div>

          <div class="group relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="w-10 h-10 mb-4 flex items-center justify-center">
                <svg class="w-5 h-5 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 class="text-base font-medium mb-2 font-mono">Security</h3>
              <p class="text-sm text-[var(--text-secondary)] leading-relaxed">
                Resource limits, non-root user, capability dropping
              </p>
            </div>
          </div>
        </div>
      </section>

      <section id="installation" class="max-w-6xl mx-auto py-16 md:py-24">
        <div class="text-center mb-12">
          <div class="inline-block px-3 py-1 mb-4 border border-[var(--border-color)] rounded">
            <span class="text-xs font-mono text-[var(--text-secondary)] uppercase tracking-widest">Installation</span>
          </div>
          <h2 class="text-3xl md:text-4xl font-medium tracking-tight">
            Get running in <span class="text-[var(--accent-cyan)]">under a minute</span>
          </h2>
        </div>

        <div class="space-y-4">
          <div class="relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative flex flex-col lg:flex-row gap-6">
              <div class="flex-1 space-y-3">
                <div class="flex items-center justify-between">
                  <h3 class="text-lg font-medium font-mono">One-Command Install</h3>
                  <span class="px-2 py-0.5 text-xs font-mono border border-[var(--accent-cyan)]/50 bg-[var(--accent-cyan-dim)] text-[var(--accent-cyan)] rounded">RECOMMENDED</span>
                </div>
                <p class="text-sm text-[var(--text-secondary)]">
                  Fastest method. Just run and you're ready.
                </p>
              </div>

              <div class="lg:w-1/2">
                <div class="relative group/code">
                  <button
                    @click="copyToClipboard('curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null\nsudo chmod +x /usr/local/bin/crush-sandbox\nln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox', 'one-cmd')"
                    class="absolute top-2 right-2 z-10 p-1.5 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'one-cmd'"
                      class="w-3.5 h-3.5 text-[var(--text-primary)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg
                      v-else
                      class="w-3.5 h-3.5 text-[var(--accent-sage)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                  <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                    <div class="flex items-center gap-2 px-3 py-1.5 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                      <div class="flex gap-1">
                        <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                      </div>
                      <span class="ml-2 text-[10px] font-mono text-[var(--text-secondary)]">bash</span>
                    </div>
                    <pre class="p-3 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null
sudo chmod +x /usr/local/bin/crush-sandbox
ln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox</code></pre>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative flex flex-col lg:flex-row gap-6">
              <div class="flex-1 space-y-3">
                <h3 class="text-lg font-medium font-mono">Manual Install</h3>
                <p class="text-sm text-[var(--text-secondary)]">
                  Step-by-step if you prefer reviewing first.
                </p>
              </div>

              <div class="lg:w-1/2 space-y-3">
                <div class="relative group/code">
                  <button
                    @click="copyToClipboard('curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush', 'manual-1')"
                    class="absolute top-2 right-2 z-10 p-1.5 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'manual-1'"
                      class="w-3.5 h-3.5 text-[var(--text-primary)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg
                      v-else
                      class="w-3.5 h-3.5 text-[var(--accent-sage)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                  <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                    <div class="flex items-center justify-between px-3 py-1.5 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                      <div class="flex items-center gap-2">
                        <div class="flex gap-1">
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        </div>
                        <span class="ml-2 text-[10px] font-mono text-[var(--text-secondary)]">Step 1</span>
                      </div>
                      <span class="text-[10px] font-mono text-[var(--accent-cyan)]">Download</span>
                    </div>
                    <pre class="p-3 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush</code></pre>
                  </div>
                </div>

                <div class="relative group/code">
                  <button
                    @click="copyToClipboard('chmod +x docker-sandbox-crush', 'manual-2')"
                    class="absolute top-2 right-2 z-10 p-1.5 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'manual-2'"
                      class="w-3.5 h-3.5 text-[var(--text-primary)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg
                      v-else
                      class="w-3.5 h-3.5 text-[var(--accent-sage)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                  <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                    <div class="flex items-center justify-between px-3 py-1.5 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                      <div class="flex items-center gap-2">
                        <div class="flex gap-1">
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        </div>
                        <span class="ml-2 text-[10px] font-mono text-[var(--text-secondary)]">Step 2</span>
                      </div>
                      <span class="text-[10px] font-mono text-[var(--accent-cyan)]">Executable</span>
                    </div>
                    <pre class="p-3 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">chmod +x docker-sandbox-crush</code></pre>
                  </div>
                </div>

                <div class="relative group/code">
                  <button
                    @click="copyToClipboard('sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox', 'manual-3')"
                    class="absolute top-2 right-2 z-10 p-1.5 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'manual-3'"
                      class="w-3.5 h-3.5 text-[var(--text-primary)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg
                      v-else
                      class="w-3.5 h-3.5 text-[var(--accent-sage)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                  <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                    <div class="flex items-center justify-between px-3 py-1.5 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                      <div class="flex items-center gap-2">
                        <div class="flex gap-1">
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                          <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        </div>
                        <span class="ml-2 text-[10px] font-mono text-[var(--text-secondary)]">Step 3</span>
                      </div>
                      <span class="text-[10px] font-mono text-[var(--accent-cyan)]">Move to PATH</span>
                    </div>
                    <pre class="p-3 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox</code></pre>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="relative p-6 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative flex flex-col lg:flex-row gap-6">
              <div class="flex-1 space-y-3">
                <h3 class="text-lg font-medium font-mono">Install from Clone</h3>
                <p class="text-sm text-[var(--text-secondary)]">
                  Already cloned? Use built-in install.
                </p>
              </div>

              <div class="lg:w-1/2">
                <div class="relative group/code">
                  <button
                    @click="copyToClipboard('./docker-sandbox-crush install', 'from-clone')"
                    class="absolute top-2 right-2 z-10 p-1.5 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'from-clone'"
                      class="w-3.5 h-3.5 text-[var(--text-primary)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg
                      v-else
                      class="w-3.5 h-3.5 text-[var(--accent-sage)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                  <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                    <div class="flex items-center gap-2 px-3 py-1.5 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                      <div class="flex gap-1">
                        <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                        <span class="w-1.5 h-1.5 rounded border border-[var(--text-secondary)]/40"/>
                      </div>
                      <span class="ml-2 text-[10px] font-mono text-[var(--text-secondary)]">bash</span>
                    </div>
                    <pre class="p-3 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">./docker-sandbox-crush install</code></pre>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="mt-8 p-5 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded">
          <div class="flex items-start gap-2 mb-4">
            <svg class="w-4 h-4 text-[var(--accent-cyan)] mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h4 class="text-sm font-medium font-mono">Prerequisites</h4>
          </div>
          <ul class="space-y-2 text-sm text-[var(--text-secondary)]">
            <li class="flex items-start gap-2">
              <span class="text-[var(--accent-cyan)]">›</span>
              <span>macOS (primary target)</span>
            </li>
            <li class="flex items-start gap-2">
              <span class="text-[var(--accent-cyan)]">›</span>
              <span>Docker Desktop installed and running</span>
            </li>
            <li class="flex items-start gap-2">
              <span class="text-[var(--accent-cyan)]">›</span>
              <span>curl or wget for downloading</span>
            </li>
          </ul>
        </div>
      </section>

      <section id="examples" class="max-w-6xl mx-auto py-16 md:py-24">
        <div class="text-center mb-12">
          <div class="inline-block px-3 py-1 mb-4 border border-[var(--border-color)] rounded">
            <span class="text-xs font-mono text-[var(--text-secondary)] uppercase tracking-widest">Usage</span>
          </div>
          <h2 class="text-3xl md:text-4xl font-medium tracking-tight">
            Common <span class="text-[var(--accent-cyan)]">patterns</span>
          </h2>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <div class="group relative p-5 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-2">
                  <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-4 h-4 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="text-sm font-medium font-mono">Start Crush CLI</h3>
                    <span class="text-xs text-[var(--text-secondary)]">Basic usage</span>
                  </div>
                </div>
              </div>

              <p class="text-xs text-[var(--text-secondary)] mb-3 leading-relaxed">
                Launch Crush CLI inside isolated container with workspace caching.
              </p>

              <div class="relative group/code">
                <button
                  @click="copyToClipboard('crush-sandbox run', 'ex-1')"
                  class="absolute top-2 right-2 z-10 p-1 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                  aria-label="Copy to clipboard"
                >
                  <svg
                    v-if="copiedCode !== 'ex-1'"
                    class="w-3 h-3 text-[var(--text-primary)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  <svg
                    v-else
                    class="w-3 h-3 text-[var(--accent-sage)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
                <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                  <div class="flex items-center gap-2 px-3 py-1 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                    <div class="flex gap-1">
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                    </div>
                    <span class="ml-2 text-[9px] font-mono text-[var(--text-secondary)]">bash</span>
                  </div>
                  <pre class="p-2.5 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">crush-sandbox run</code></pre>
                </div>
              </div>
            </div>
          </div>

          <div class="group relative p-5 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-2">
                  <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-4 h-4 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="text-sm font-medium font-mono">Debug Shell</h3>
                    <span class="text-xs text-[var(--text-secondary)]">Interactive</span>
                  </div>
                </div>
              </div>

              <p class="text-xs text-[var(--text-secondary)] mb-3 leading-relaxed">
                Get interactive shell for debugging or exploration.
              </p>

              <div class="relative group/code">
                <button
                  @click="copyToClipboard('crush-sandbox run --shell', 'ex-2')"
                  class="absolute top-2 right-2 z-10 p-1 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                  aria-label="Copy to clipboard"
                >
                  <svg
                    v-if="copiedCode !== 'ex-2'"
                    class="w-3 h-3 text-[var(--text-primary)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  <svg
                    v-else
                    class="w-3 h-3 text-[var(--accent-sage)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
                <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                  <div class="flex items-center gap-2 px-3 py-1 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                    <div class="flex gap-1">
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                    </div>
                    <span class="ml-2 text-[9px] font-mono text-[var(--text-secondary)]">bash</span>
                  </div>
                  <pre class="p-2.5 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">crush-sandbox run --shell</code></pre>
                </div>
              </div>
            </div>
          </div>

          <div class="group relative p-5 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-2">
                  <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-4 h-4 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="text-sm font-medium font-mono">Clean Up</h3>
                    <span class="text-xs text-[var(--text-secondary)]">Reset workspace</span>
                  </div>
                </div>
              </div>

              <p class="text-xs text-[var(--text-secondary)] mb-3 leading-relaxed">
                Remove container and cache volume to start fresh.
              </p>

              <div class="relative group/code">
                <button
                  @click="copyToClipboard('crush-sandbox clean', 'ex-3')"
                  class="absolute top-2 right-2 z-10 p-1 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                  aria-label="Copy to clipboard"
                >
                  <svg
                    v-if="copiedCode !== 'ex-3'"
                    class="w-3 h-3 text-[var(--text-primary)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  <svg
                    v-else
                    class="w-3 h-3 text-[var(--accent-sage)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
                <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                  <div class="flex items-center gap-2 px-3 py-1 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                    <div class="flex gap-1">
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                    </div>
                    <span class="ml-2 text-[9px] font-mono text-[var(--text-secondary)]">bash</span>
                  </div>
                  <pre class="p-2.5 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">crush-sandbox clean</code></pre>
                </div>
              </div>
            </div>
          </div>

          <div class="group relative p-5 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative">
              <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-2">
                  <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-4 h-4 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="text-sm font-medium font-mono">Custom Image</h3>
                    <span class="text-xs text-[var(--text-secondary)]">Flexible</span>
                  </div>
                </div>
              </div>

              <p class="text-xs text-[var(--text-secondary)] mb-3 leading-relaxed">
                Use different Node.js version or custom base image.
              </p>

              <div class="relative group/code">
                <button
                  @click="copyToClipboard('DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run', 'ex-4')"
                  class="absolute top-2 right-2 z-10 p-1 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                  aria-label="Copy to clipboard"
                >
                  <svg
                    v-if="copiedCode !== 'ex-4'"
                    class="w-3 h-3 text-[var(--text-primary)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  <svg
                    v-else
                    class="w-3 h-3 text-[var(--accent-sage)]"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </button>
                <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                  <div class="flex items-center gap-2 px-3 py-1 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                    <div class="flex gap-1">
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                    </div>
                    <span class="ml-2 text-[9px] font-mono text-[var(--text-secondary)]">bash</span>
                  </div>
                  <pre class="p-2.5 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run</code></pre>
                </div>
              </div>
            </div>
          </div>

          <div class="group relative p-5 bg-[var(--bg-secondary)] border border-[var(--border-color)] rounded hover:border-[var(--accent-cyan)]/50 transition-all duration-300 lg:col-span-2">
            <div class="absolute inset-0 bg-gradient-to-br from-[var(--accent-cyan-dim)] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
            <div class="relative flex flex-col lg:flex-row gap-5">
              <div class="flex-1">
                <div class="flex items-center gap-2 mb-3">
                  <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-4 h-4 text-[var(--accent-cyan)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                    </svg>
                  </div>
                  <div>
                    <h3 class="text-sm font-medium font-mono">Credential Scan</h3>
                    <span class="text-xs text-[var(--text-secondary)]">Security check</span>
                  </div>
                </div>

                <p class="text-xs text-[var(--text-secondary)] mb-3 leading-relaxed">
                  Scan workspace with gitleaks before launch. Prompts if secrets detected.
                </p>

                <div class="flex items-center gap-1.5 text-[10px] text-[var(--text-secondary)]">
                  <svg class="w-3 h-3 text-[var(--accent-coral)]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                  </svg>
                  <span>Requires gitleaks image (auto-pulled)</span>
                </div>
              </div>

              <div class="lg:w-auto lg:min-w-[320px]">
                <div class="relative group/code">
                  <button
                    @click="copyToClipboard('crush-sandbox run --cred-scan', 'ex-5')"
                    class="absolute top-2 right-2 z-10 p-1 rounded bg-[var(--bg-tertiary)] border border-[var(--border-color)] hover:border-[var(--accent-cyan)]/50 transition-all duration-200 opacity-70 group-hover/code:opacity-100"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'ex-5'"
                      class="w-3 h-3 text-[var(--text-primary)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <svg
                      v-else
                      class="w-3 h-3 text-[var(--accent-sage)]"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </button>
                  <div class="bg-[var(--bg-primary)] rounded border border-[var(--border-color)] overflow-hidden">
                    <div class="flex items-center gap-2 px-3 py-1 bg-[var(--bg-tertiary)] border-b border-[var(--border-color)]">
                      <div class="flex gap-1">
                        <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                        <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                        <span class="w-1 h-1 rounded border border-[var(--text-secondary)]/40"/>
                      </div>
                      <span class="ml-2 text-[9px] font-mono text-[var(--text-secondary)]">bash</span>
                    </div>
                    <pre class="p-2.5 text-xs font-mono overflow-x-auto"><code class="text-[var(--text-primary)]">crush-sandbox run --cred-scan</code></pre>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="border-t border-[var(--border-color)] py-12 px-6">
      <div class="max-w-6xl mx-auto text-center">
        <div class="flex items-center justify-center gap-2 mb-4">
          <span class="text-sm font-mono">crush-sandbox</span>
          <span class="text-[var(--text-secondary)]">·</span>
          <span class="text-xs text-[var(--text-secondary)] font-mono">v0.5.0</span>
        </div>
        <p class="text-xs text-[var(--text-secondary)]">
          Isolated development environments for the Crush CLI
        </p>
      </div>
    </footer>
  </div>
</template>
