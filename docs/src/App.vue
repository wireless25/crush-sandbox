<script setup lang="ts">
import { ref, onMounted } from 'vue'

const isDark = ref(false)
const copiedCode = ref<string | null>(null)

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches

  isDark.value = savedTheme === 'dark' || (!savedTheme && systemPrefersDark)

  if (isDark.value) {
    document.documentElement.classList.add('dark')
  }

  const savedDarkMode = localStorage.getItem('darkMode')
  if (savedDarkMode === 'true' || (!savedDarkMode && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    isDark.value = true
    document.documentElement.classList.add('dark')
  }
})

const toggleDarkMode = () => {
  isDark.value = !isDark.value
  if (isDark.value) {
    document.documentElement.classList.add('dark')
    localStorage.setItem('darkMode', 'true')
  } else {
    document.documentElement.classList.remove('dark')
    localStorage.setItem('darkMode', 'false')
  }
}

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
  <div
    class="min-h-screen transition-colors duration-300 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 text-slate-100"
  >
    <header
      class="fixed top-0 left-0 right-0 z-50 backdrop-blur-xl bg-slate-900/90 border-b border-slate-700/50 shadow-lg"
    >
      <div
        class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between"
      >
        <div
          class="flex items-center gap-3 group"
        >
          <div
            class="w-10 h-10 rounded-lg bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center shadow-lg shadow-amber-500/20 group-hover:shadow-amber-500/40 transition-all duration-300 group-hover:scale-105"
          >
            <svg
              class="w-6 h-6 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
              />
            </svg>
          </div>
          <span
            class="text-xl font-bold bg-gradient-to-r from-amber-400 to-orange-400 bg-clip-text text-transparent group-hover:from-amber-300 group-hover:to-orange-300 transition-all duration-300"
          >
            crush-sandbox
          </span>
        </div>

        <button
          @click="toggleDarkMode"
          class="p-2 rounded-lg bg-slate-800/50 hover:bg-slate-700/50 transition-all duration-200 border border-slate-700/50 hover:border-amber-500/50"
          :class="{ 'ring-2 ring-amber-500/50': isDark }"
          aria-label="Toggle dark mode"
        >
          <svg
            v-if="isDark"
            class="w-5 h-5 text-amber-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
            />
          </svg>
          <svg
            v-else
            class="w-5 h-5 text-slate-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
            />
          </svg>
        </button>
      </div>
    </header>

    <main
      class="pt-24 pb-16 px-6"
    >
      <section
        class="max-w-6xl mx-auto py-16 md:py-24 lg:py-32"
      >
        <div
          class="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center"
        >
          <div
            class="space-y-8"
          >
            <div
              class="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-amber-500/30 bg-amber-500/5"
            >
              <span
                class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"
              />
              <span
                class="text-sm text-amber-400 font-mono"
              >
                v0.5.0
              </span>
            </div>

            <h1
              class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight tracking-tight"
            >
              <span
                class="block text-slate-100 mb-2"
              >
                crush-sandbox
              </span>
              <span
                class="block text-xl md:text-2xl lg:text-3xl font-normal text-amber-500/90 font-mono"
              >
                &gt; Docker sandbox for the Crush CLI with per-workspace caching
              </span>
            </h1>

            <p
              class="text-lg md:text-xl text-slate-400 leading-relaxed max-w-xl"
            >
              Isolate your Crush CLI development environment in secure Docker containers. Persistent npm and pnpm caches per workspace keep builds fast while maintaining clean separation.
            </p>

            <div
              class="flex flex-col sm:flex-row gap-4"
            >
              <a
                href="https://github.com/wireless25/crush-sandbox"
                target="_blank"
                rel="noopener noreferrer"
                class="inline-flex items-center justify-center gap-3 px-6 py-3.5 bg-amber-500 text-slate-900 rounded-lg font-semibold hover:bg-amber-400 transition-colors duration-200 group"
              >
                <svg
                  class="w-5 h-5 group-hover:scale-110 transition-transform duration-200"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                  />
                </svg>
                View on GitHub
              </a>
              <a
                href="#installation"
                class="inline-flex items-center justify-center px-6 py-3.5 border border-slate-700 text-slate-300 rounded-lg font-medium hover:border-amber-500/50 hover:text-amber-400 transition-colors duration-200"
              >
                Get Started
              </a>
            </div>
          </div>

          <div
            class="relative"
          >
            <div
              class="relative bg-slate-900/80 border border-slate-700/50 rounded-xl overflow-hidden shadow-2xl"
            >
              <div
                class="flex items-center gap-2 px-4 py-3 bg-slate-800/50 border-b border-slate-700/50"
              >
                <div
                  class="flex gap-1.5"
                >
                  <span
                    class="w-3 h-3 rounded-full bg-red-500/80"
                  />
                  <span
                    class="w-3 h-3 rounded-full bg-amber-500/80"
                  />
                  <span
                    class="w-3 h-3 rounded-full bg-green-500/80"
                  />
                </div>
                <span
                  class="ml-2 text-xs text-slate-500 font-mono"
                >
                  crush-sandbox — zsh
                </span>
              </div>
              <div
                class="p-6 font-mono text-sm space-y-3"
              >
                <div
                  class="flex items-center gap-2"
                >
                  <span
                    class="text-green-500"
                  >
                    ➜
                  </span>
                  <span
                    class="text-cyan-400"
                  >
                    ~
                  </span>
                  <span
                    class="text-amber-400"
                  >
                    crush-sandbox run
                  </span>
                </div>
                <div
                  class="text-slate-400 pl-5"
                >
                  ✓ Docker container created
                </div>
                <div
                  class="text-slate-400 pl-5"
                >
                  ✓ Cache volume mounted at /workspace-cache
                </div>
                <div
                  class="text-slate-400 pl-5"
                >
                  ✓ Crush CLI installed
                </div>
                <div
                  class="flex items-center gap-2 pt-2"
                >
                  <span
                    class="text-green-500"
                  >
                    ➜
                  </span>
                  <span
                    class="text-cyan-400"
                  >
                    ~
                  </span>
                  <span
                    class="animate-pulse"
                  >
                    █
                  </span>
                </div>
              </div>
            </div>

            <div
              class="absolute -top-4 -right-4 w-24 h-24 bg-amber-500/10 rounded-full blur-2xl"
            />
            <div
              class="absolute -bottom-4 -left-4 w-32 h-32 bg-cyan-500/10 rounded-full blur-2xl"
            />
          </div>
        </div>
      </section>

      <section
        class="max-w-6xl mx-auto py-16 md:py-24 relative"
      >
        <div
          class="absolute top-20 right-10 w-64 h-64 bg-amber-500/5 rounded-full blur-3xl"
        />
        <div
          class="absolute bottom-20 left-10 w-48 h-48 bg-cyan-500/5 rounded-full blur-3xl"
        />

        <div
          class="relative"
        >
          <div
            class="flex items-center justify-center gap-3 mb-8"
          >
            <div
              class="h-px w-16 bg-gradient-to-r from-transparent to-amber-500/50"
            />
            <span
              class="text-sm font-mono text-amber-500/80 uppercase tracking-widest"
            >
              Why Choose crush-sandbox
            </span>
            <div
              class="h-px w-16 bg-gradient-to-l from-transparent to-amber-500/50"
            />
          </div>

          <h2
            class="text-3xl md:text-4xl lg:text-5xl font-bold mb-4 text-center text-slate-100"
          >
            Built for
            <span
              class="block md:inline mt-2 md:mt-0 bg-gradient-to-r from-amber-400 via-amber-500 to-amber-600 bg-clip-text text-transparent"
            >
              serious development
            </span>
          </h2>

          <p
            class="text-slate-400 text-center max-w-2xl mx-auto mb-16 text-lg"
          >
            Every feature designed to keep your environments isolated, your builds fast, and your workflow seamless.
          </p>

          <div
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5"
          >
            <div
              class="group relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-amber-500/40 transition-all duration-300 hover:shadow-xl hover:shadow-amber-500/5 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-amber-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-amber-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="relative"
              >
                <div
                  class="w-14 h-14 rounded-xl bg-gradient-to-br from-amber-500/20 to-amber-600/10 flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300 border border-amber-500/20"
                >
                  <svg
                    class="w-7 h-7 text-amber-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4"
                    />
                  </svg>
                </div>
                <h3
                  class="text-xl font-bold mb-3 text-slate-100 group-hover:text-amber-400 transition-colors duration-300"
                >
                  Container Isolation
                </h3>
                <p
                  class="text-slate-400 leading-relaxed text-sm"
                >
                  Run Crush CLI in isolated Docker containers with per-workspace isolation for clean environments
                </p>
              </div>
            </div>

            <div
              class="group relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-purple-500/40 transition-all duration-300 hover:shadow-xl hover:shadow-purple-500/5 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-purple-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-purple-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="relative"
              >
                <div
                  class="w-14 h-14 rounded-xl bg-gradient-to-br from-purple-500/20 to-purple-600/10 flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300 border border-purple-500/20"
                >
                  <svg
                    class="w-7 h-7 text-purple-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                    />
                  </svg>
                </div>
                <h3
                  class="text-xl font-bold mb-3 text-slate-100 group-hover:text-purple-400 transition-colors duration-300"
                >
                  Per-Workspace Caching
                </h3>
                <p
                  class="text-slate-400 leading-relaxed text-sm"
                >
                  Persistent npm and pnpm caches per workspace, speeding up installs and builds
                </p>
              </div>
            </div>

            <div
              class="group relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-green-500/40 transition-all duration-300 hover:shadow-xl hover:shadow-green-500/5 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-green-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-green-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="relative"
              >
                <div
                  class="w-14 h-14 rounded-xl bg-gradient-to-br from-green-500/20 to-green-600/10 flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300 border border-green-500/20"
                >
                  <svg
                    class="w-7 h-7 text-green-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
                    />
                  </svg>
                </div>
                <h3
                  class="text-xl font-bold mb-3 text-slate-100 group-hover:text-green-400 transition-colors duration-300"
                >
                  Auto Install Crush
                </h3>
                <p
                  class="text-slate-400 leading-relaxed text-sm"
                >
                  Crush CLI installed automatically on first use via npm global install
                </p>
              </div>
            </div>

            <div
              class="group relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-cyan-500/40 transition-all duration-300 hover:shadow-xl hover:shadow-cyan-500/5 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-cyan-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-cyan-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="relative"
              >
                <div
                  class="w-14 h-14 rounded-xl bg-gradient-to-br from-cyan-500/20 to-cyan-600/10 flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300 border border-cyan-500/20"
                >
                  <svg
                    class="w-7 h-7 text-cyan-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
                    />
                  </svg>
                </div>
                <h3
                  class="text-xl font-bold mb-3 text-slate-100 group-hover:text-cyan-400 transition-colors duration-300"
                >
                  Git Config Passthrough
                </h3>
                <p
                  class="text-slate-400 leading-relaxed text-sm"
                >
                  Automatically passes your git user.name and user.email to the container
                </p>
              </div>
            </div>

            <div
              class="group relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-red-500/40 transition-all duration-300 hover:shadow-xl hover:shadow-red-500/5 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-red-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-red-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="relative"
              >
                <div
                  class="w-14 h-14 rounded-xl bg-gradient-to-br from-red-500/20 to-red-600/10 flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300 border border-red-500/20"
                >
                  <svg
                    class="w-7 h-7 text-red-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                    />
                  </svg>
                </div>
                <h3
                  class="text-xl font-bold mb-3 text-slate-100 group-hover:text-red-400 transition-colors duration-300"
                >
                  Credential Scanning
                </h3>
                <p
                  class="text-slate-400 leading-relaxed text-sm"
                >
                  Optional credential scanning with gitleaks before starting the container
                </p>
              </div>
            </div>

            <div
              class="group relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-amber-500/40 transition-all duration-300 hover:shadow-xl hover:shadow-amber-500/5 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-amber-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-amber-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="relative"
              >
                <div
                  class="w-14 h-14 rounded-xl bg-gradient-to-br from-amber-500/20 to-amber-600/10 flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300 border border-amber-500/20"
                >
                  <svg
                    class="w-7 h-7 text-amber-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>
                <h3
                  class="text-xl font-bold mb-3 text-slate-100 group-hover:text-amber-400 transition-colors duration-300"
                >
                  Security Hardening
                </h3>
                <p
                  class="text-slate-400 leading-relaxed text-sm"
                >
                  Resource limits, non-root user, and capability dropping for attack surface reduction
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section
        id="installation"
        class="max-w-6xl mx-auto py-16 md:py-24 relative"
      >
        <div
          class="absolute top-20 left-10 w-64 h-64 bg-amber-500/5 rounded-full blur-3xl"
        />
        <div
          class="absolute bottom-20 right-10 w-48 h-48 bg-purple-500/5 rounded-full blur-3xl"
        />

        <div
          class="relative"
        >
          <div
            class="flex items-center justify-center gap-3 mb-8"
          >
            <div
              class="h-px w-16 bg-gradient-to-r from-transparent to-amber-500/50"
            />
            <span
              class="text-sm font-mono text-amber-500/80 uppercase tracking-widest"
            >
              Installation
            </span>
            <div
              class="h-px w-16 bg-gradient-to-l from-transparent to-amber-500/50"
            />
          </div>

          <h2
            class="text-3xl md:text-4xl lg:text-5xl font-bold mb-4 text-center text-slate-100"
          >
            Get up and running in
            <span
              class="block md:inline mt-2 md:mt-0 bg-gradient-to-r from-amber-400 via-amber-500 to-amber-600 bg-clip-text text-transparent"
            >
              under a minute
            </span>
          </h2>

          <p
            class="text-slate-400 text-center max-w-2xl mx-auto mb-16 text-lg"
          >
            Choose the installation method that works best for your workflow. All methods require Docker Desktop for Mac.
          </p>

          <div
            class="space-y-8"
          >
            <div
              class="relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-amber-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-amber-500/5 to-transparent opacity-0 hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-amber-500/10 rounded-full blur-2xl opacity-0 hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative flex flex-col lg:flex-row gap-6"
              >
                <div
                  class="flex-1 space-y-4"
                >
                  <div
                    class="flex items-center gap-3"
                  >
                    <div
                      class="w-10 h-10 rounded-lg bg-gradient-to-br from-amber-500/20 to-amber-600/10 flex items-center justify-center border border-amber-500/20"
                    >
                      <svg
                        class="w-5 h-5 text-amber-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M13 10V3L4 14h7v7l9-11h-7z"
                        />
                      </svg>
                    </div>
                    <h3
                      class="text-2xl font-bold text-slate-100"
                    >
                      One-Command Installation
                    </h3>
                  </div>
                  <p
                    class="text-slate-400 text-sm leading-relaxed"
                  >
                    The fastest way to get started. Just run this single command and you're ready to go.
                  </p>

                  <div
                    class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full border border-amber-500/30 bg-amber-500/5 w-fit"
                  >
                    <span
                      class="text-xs text-amber-400 font-mono font-semibold"
                    >
                      RECOMMENDED
                    </span>
                  </div>
                </div>

                <div
                  class="lg:w-1/2"
                >
                  <div
                    class="relative group/code"
                  >
                    <button
                      @click="copyToClipboard('curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null\nsudo chmod +x /usr/local/bin/crush-sandbox\nln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox', 'one-cmd')"
                      class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-amber-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                      aria-label="Copy to clipboard"
                    >
                      <svg
                        v-if="copiedCode !== 'one-cmd'"
                        class="w-4 h-4 text-slate-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      <svg
                        v-else
                        class="w-4 h-4 text-green-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </button>
                    <div
                      class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                    >
                      <div
                        class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                      >
                        <div
                          class="flex gap-1.5"
                        >
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                          />
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                          />
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                          />
                        </div>
                        <span
                          class="ml-2 text-xs text-slate-500 font-mono"
                        >
                          bash
                        </span>
                      </div>
                      <pre
                        class="p-4 text-sm font-mono overflow-x-auto"
                      ><code class="text-slate-300">curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush | sudo tee /usr/local/bin/crush-sandbox > /dev/null
sudo chmod +x /usr/local/bin/crush-sandbox
ln -s /usr/local/bin/crush-sandbox /usr/local/bin/crushbox</code></pre>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-purple-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-purple-500/5 to-transparent opacity-0 hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-purple-500/10 rounded-full blur-2xl opacity-0 hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative flex flex-col lg:flex-row gap-6"
              >
                <div
                  class="flex-1 space-y-4"
                >
                  <div
                    class="flex items-center gap-3"
                  >
                    <div
                      class="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-500/20 to-purple-600/10 flex items-center justify-center border border-purple-500/20"
                    >
                      <svg
                        class="w-5 h-5 text-purple-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
                        />
                      </svg>
                    </div>
                    <h3
                      class="text-2xl font-bold text-slate-100"
                    >
                      Manual Installation
                    </h3>
                  </div>
                  <p
                    class="text-slate-400 text-sm leading-relaxed"
                  >
                    Download and install the script step-by-step. Great if you want to review the script first.
                  </p>
                </div>

                <div
                  class="lg:w-1/2 space-y-4"
                >
                  <div
                    class="relative group/code"
                  >
                    <button
                      @click="copyToClipboard('curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush', 'manual-1')"
                      class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-purple-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                      aria-label="Copy to clipboard"
                    >
                      <svg
                        v-if="copiedCode !== 'manual-1'"
                        class="w-4 h-4 text-slate-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      <svg
                        v-else
                        class="w-4 h-4 text-green-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </button>
                    <div
                      class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                    >
                      <div
                        class="flex items-center justify-between px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                      >
                        <div
                          class="flex items-center gap-2"
                        >
                          <div
                            class="flex gap-1.5"
                          >
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                            />
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                            />
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                            />
                          </div>
                          <span
                            class="ml-2 text-xs text-slate-500 font-mono"
                          >
                            Step 1
                          </span>
                        </div>
                        <span
                          class="text-xs text-purple-400 font-mono"
                        >
                          Download
                        </span>
                      </div>
                      <pre
                        class="p-4 text-sm font-mono overflow-x-auto"
                      ><code class="text-slate-300">curl -fsSL https://raw.githubusercontent.com/wireless25/crush-sandbox/main/docker-sandbox-crush -o docker-sandbox-crush</code></pre>
                    </div>
                  </div>

                  <div
                    class="relative group/code"
                  >
                    <button
                      @click="copyToClipboard('chmod +x docker-sandbox-crush', 'manual-2')"
                      class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-purple-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                      aria-label="Copy to clipboard"
                    >
                      <svg
                        v-if="copiedCode !== 'manual-2'"
                        class="w-4 h-4 text-slate-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      <svg
                        v-else
                        class="w-4 h-4 text-green-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </button>
                    <div
                      class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                    >
                      <div
                        class="flex items-center justify-between px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                      >
                        <div
                          class="flex items-center gap-2"
                        >
                          <div
                            class="flex gap-1.5"
                          >
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                            />
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                            />
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                            />
                          </div>
                          <span
                            class="ml-2 text-xs text-slate-500 font-mono"
                          >
                            Step 2
                          </span>
                        </div>
                        <span
                          class="text-xs text-purple-400 font-mono"
                        >
                          Make executable
                        </span>
                      </div>
                      <pre
                        class="p-4 text-sm font-mono overflow-x-auto"
                      ><code class="text-slate-300">chmod +x docker-sandbox-crush</code></pre>
                    </div>
                  </div>

                  <div
                    class="relative group/code"
                  >
                    <button
                      @click="copyToClipboard('sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox', 'manual-3')"
                      class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-purple-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                      aria-label="Copy to clipboard"
                    >
                      <svg
                        v-if="copiedCode !== 'manual-3'"
                        class="w-4 h-4 text-slate-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      <svg
                        v-else
                        class="w-4 h-4 text-green-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </button>
                    <div
                      class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                    >
                      <div
                        class="flex items-center justify-between px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                      >
                        <div
                          class="flex items-center gap-2"
                        >
                          <div
                            class="flex gap-1.5"
                          >
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                            />
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                            />
                            <span
                              class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                            />
                          </div>
                          <span
                            class="ml-2 text-xs text-slate-500 font-mono"
                          >
                            Step 3
                          </span>
                        </div>
                        <span
                          class="text-xs text-purple-400 font-mono"
                        >
                          Move to PATH
                        </span>
                      </div>
                      <pre
                        class="p-4 text-sm font-mono overflow-x-auto"
                      ><code class="text-slate-300">sudo mv docker-sandbox-crush /usr/local/bin/crush-sandbox</code></pre>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="relative p-8 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-cyan-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-cyan-500/5 to-transparent opacity-0 hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-cyan-500/10 rounded-full blur-2xl opacity-0 hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative flex flex-col lg:flex-row gap-6"
              >
                <div
                  class="flex-1 space-y-4"
                >
                  <div
                    class="flex items-center gap-3"
                  >
                    <div
                      class="w-10 h-10 rounded-lg bg-gradient-to-br from-cyan-500/20 to-cyan-600/10 flex items-center justify-center border border-cyan-500/20"
                    >
                      <svg
                        class="w-5 h-5 text-cyan-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                        />
                      </svg>
                    </div>
                    <h3
                      class="text-2xl font-bold text-slate-100"
                    >
                      Install from Clone
                    </h3>
                  </div>
                  <p
                    class="text-slate-400 text-sm leading-relaxed"
                  >
                    Already cloned the repo? Use the built-in install command for convenience.
                  </p>
                </div>

                <div
                  class="lg:w-1/2"
                >
                  <div
                    class="relative group/code"
                  >
                    <button
                      @click="copyToClipboard('./docker-sandbox-crush install', 'from-clone')"
                      class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-cyan-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                      aria-label="Copy to clipboard"
                    >
                      <svg
                        v-if="copiedCode !== 'from-clone'"
                        class="w-4 h-4 text-slate-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      <svg
                        v-else
                        class="w-4 h-4 text-green-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </button>
                    <div
                      class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                    >
                      <div
                        class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                      >
                        <div
                          class="flex gap-1.5"
                        >
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                          />
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                          />
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                          />
                        </div>
                        <span
                          class="ml-2 text-xs text-slate-500 font-mono"
                        >
                          bash
                        </span>
                      </div>
                      <pre
                        class="p-4 text-sm font-mono overflow-x-auto"
                      ><code class="text-slate-300">./docker-sandbox-crush install</code></pre>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div
            class="mt-12 p-6 rounded-xl bg-slate-800/40 border border-slate-700/50"
          >
            <h4
              class="text-lg font-semibold text-slate-200 mb-4 flex items-center gap-2"
            >
              <svg
                class="w-5 h-5 text-amber-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              Prerequisites
            </h4>
            <ul
              class="space-y-2 text-slate-400 text-sm"
            >
              <li
                class="flex items-start gap-2"
              >
                <span
                  class="text-amber-500 mt-1"
                >
                  •
                </span>
                <span><strong class="text-slate-300">macOS</strong> (primary target)</span>
              </li>
              <li
                class="flex items-start gap-2"
              >
                <span
                  class="text-amber-500 mt-1"
                >
                  •
                </span>
                <span><strong class="text-slate-300">Docker Desktop</strong> installed and running</span>
              </li>
              <li
                class="flex items-start gap-2"
              >
                <span
                  class="text-amber-500 mt-1"
                >
                  •
                </span>
                <span><strong class="text-slate-300">curl</strong> or <strong class="text-slate-300">wget</strong> for downloading</span>
              </li>
              <li
                class="flex items-start gap-2"
              >
                <span
                  class="text-amber-500 mt-1"
                >
                  •
                </span>
                <span>For manual installation: write permissions to <code class="bg-slate-700/50 px-1.5 py-0.5 rounded font-mono text-slate-300">/usr/local/bin</code></span>
              </li>
            </ul>
          </div>

          <div
            class="mt-6 p-6 rounded-xl bg-slate-800/40 border border-slate-700/50"
          >
            <h4
              class="text-lg font-semibold text-slate-200 mb-4 flex items-center gap-2"
            >
              <svg
                class="w-5 h-5 text-green-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              Verify Installation
            </h4>
            <p
              class="text-slate-400 text-sm mb-4"
            >
              After installing, verify that crush-sandbox is working:
            </p>
            <div
              class="relative group/code"
            >
              <button
                @click="copyToClipboard('crush-sandbox --version', 'verify')"
                class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-green-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                aria-label="Copy to clipboard"
              >
                <svg
                  v-if="copiedCode !== 'verify'"
                  class="w-4 h-4 text-slate-300"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                  />
                </svg>
                <svg
                  v-else
                  class="w-4 h-4 text-green-400"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M5 13l4 4L19 7"
                  />
                </svg>
              </button>
              <div
                class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
              >
                <div
                  class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                >
                  <div
                    class="flex gap-1.5"
                  >
                    <span
                      class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                    />
                    <span
                      class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                    />
                    <span
                      class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                    />
                  </div>
                  <span
                    class="ml-2 text-xs text-slate-500 font-mono"
                  >
                    bash
                  </span>
                </div>
                <pre
                  class="p-4 text-sm font-mono overflow-x-auto"
                ><code class="text-slate-300">crush-sandbox --version</code></pre>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section
        id="examples"
        class="max-w-6xl mx-auto py-16 md:py-24 relative"
      >
        <div
          class="absolute top-10 right-20 w-72 h-72 bg-gradient-to-br from-cyan-500/10 to-amber-500/5 rounded-full blur-3xl"
        />
        <div
          class="absolute bottom-10 left-20 w-64 h-64 bg-gradient-to-br from-purple-500/10 to-pink-500/5 rounded-full blur-3xl"
        />

        <div
          class="relative"
        >
          <div
            class="flex items-center justify-center gap-3 mb-8"
          >
            <div
              class="h-px w-16 bg-gradient-to-r from-transparent to-cyan-500/50"
            />
            <span
              class="text-sm font-mono text-cyan-500/80 uppercase tracking-widest"
            >
              Examples
            </span>
            <div
              class="h-px w-16 bg-gradient-to-l from-transparent to-cyan-500/50"
            />
          </div>

          <h2
            class="text-3xl md:text-4xl lg:text-5xl font-bold mb-4 text-center text-slate-100"
          >
            Common
            <span
              class="block md:inline mt-2 md:mt-0 bg-gradient-to-r from-cyan-400 via-cyan-500 to-amber-500 bg-clip-text text-transparent"
            >
              usage patterns
            </span>
          </h2>

          <p
            class="text-slate-400 text-center max-w-2xl mx-auto mb-16 text-lg"
          >
            From basic workflows to advanced debugging scenarios. Copy any command and start building.
          </p>

          <div
            class="grid grid-cols-1 lg:grid-cols-2 gap-6"
          >
            <div
              class="group relative p-6 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-cyan-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-cyan-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-cyan-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative"
              >
                <div
                  class="flex items-center gap-3 mb-4"
                >
                  <div
                    class="w-10 h-10 rounded-lg bg-gradient-to-br from-cyan-500/20 to-cyan-600/10 flex items-center justify-center border border-cyan-500/20 group-hover:scale-110 transition-transform duration-300"
                  >
                    <svg
                      class="w-5 h-5 text-cyan-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                      />
                    </svg>
                  </div>
                  <div>
                    <h3
                      class="text-lg font-bold text-slate-100"
                    >
                      Start Crush CLI
                    </h3>
                    <p
                      class="text-xs text-slate-400 mt-0.5"
                    >
                      Basic usage
                    </p>
                  </div>
                </div>

                <p
                  class="text-slate-400 text-sm mb-4 leading-relaxed"
                >
                  Launch the Crush CLI inside an isolated Docker container with automatic workspace caching.
                </p>

                <div
                  class="relative group/code"
                >
                  <button
                    @click="copyToClipboard('crush-sandbox run', 'ex-1')"
                    class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-cyan-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'ex-1'"
                      class="w-4 h-4 text-slate-300"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                      />
                    </svg>
                    <svg
                      v-else
                      class="w-4 h-4 text-green-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                  </button>
                  <div
                    class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                  >
                    <div
                      class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                    >
                      <div
                        class="flex gap-1.5"
                      >
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                        />
                      </div>
                      <span
                        class="ml-2 text-xs text-slate-500 font-mono"
                      >
                        bash
                      </span>
                    </div>
                    <pre
                      class="p-4 text-sm font-mono overflow-x-auto"
                    ><code class="text-slate-300">crush-sandbox run</code></pre>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="group relative p-6 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-purple-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-purple-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-purple-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative"
              >
                <div
                  class="flex items-center gap-3 mb-4"
                >
                  <div
                    class="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-500/20 to-purple-600/10 flex items-center justify-center border border-purple-500/20 group-hover:scale-110 transition-transform duration-300"
                  >
                    <svg
                      class="w-5 h-5 text-purple-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                      />
                    </svg>
                  </div>
                  <div>
                    <h3
                      class="text-lg font-bold text-slate-100"
                    >
                      Debug with Shell
                    </h3>
                    <p
                      class="text-xs text-slate-400 mt-0.5"
                    >
                      Interactive debugging
                    </p>
                  </div>
                </div>

                <p
                  class="text-slate-400 text-sm mb-4 leading-relaxed"
                >
                  Start an interactive shell inside the container for debugging or manual exploration.
                </p>

                <div
                  class="relative group/code"
                >
                  <button
                    @click="copyToClipboard('crush-sandbox run --shell', 'ex-2')"
                    class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-purple-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'ex-2'"
                      class="w-4 h-4 text-slate-300"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                      />
                    </svg>
                    <svg
                      v-else
                      class="w-4 h-4 text-green-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                  </button>
                  <div
                    class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                  >
                    <div
                      class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                    >
                      <div
                        class="flex gap-1.5"
                      >
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                        />
                      </div>
                      <span
                        class="ml-2 text-xs text-slate-500 font-mono"
                      >
                        bash
                      </span>
                    </div>
                    <pre
                      class="p-4 text-sm font-mono overflow-x-auto"
                    ><code class="text-slate-300">crush-sandbox run --shell</code></pre>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="group relative p-6 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-amber-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-amber-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-amber-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative"
              >
                <div
                  class="flex items-center gap-3 mb-4"
                >
                  <div
                    class="w-10 h-10 rounded-lg bg-gradient-to-br from-amber-500/20 to-amber-600/10 flex items-center justify-center border border-amber-500/20 group-hover:scale-110 transition-transform duration-300"
                  >
                    <svg
                      class="w-5 h-5 text-amber-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      />
                    </svg>
                  </div>
                  <div>
                    <h3
                      class="text-lg font-bold text-slate-100"
                    >
                      Clean Up
                    </h3>
                    <p
                      class="text-xs text-slate-400 mt-0.5"
                    >
                      Reset workspace
                    </p>
                  </div>
                </div>

                <p
                  class="text-slate-400 text-sm mb-4 leading-relaxed"
                >
                  Remove the sandbox container and cache volume to start fresh with your workspace.
                </p>

                <div
                  class="relative group/code"
                >
                  <button
                    @click="copyToClipboard('crush-sandbox clean', 'ex-3')"
                    class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-amber-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'ex-3'"
                      class="w-4 h-4 text-slate-300"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                      />
                    </svg>
                    <svg
                      v-else
                      class="w-4 h-4 text-green-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                  </button>
                  <div
                    class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                  >
                    <div
                      class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                    >
                      <div
                        class="flex gap-1.5"
                      >
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                        />
                      </div>
                      <span
                        class="ml-2 text-xs text-slate-500 font-mono"
                      >
                        bash
                      </span>
                    </div>
                    <pre
                      class="p-4 text-sm font-mono overflow-x-auto"
                    ><code class="text-slate-300">crush-sandbox clean</code></pre>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="group relative p-6 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-pink-500/40 transition-all duration-300 overflow-hidden"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-pink-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-pink-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative"
              >
                <div
                  class="flex items-center gap-3 mb-4"
                >
                  <div
                    class="w-10 h-10 rounded-lg bg-gradient-to-br from-pink-500/20 to-pink-600/10 flex items-center justify-center border border-pink-500/20 group-hover:scale-110 transition-transform duration-300"
                  >
                    <svg
                      class="w-5 h-5 text-pink-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
                      />
                    </svg>
                  </div>
                  <div>
                    <h3
                      class="text-lg font-bold text-slate-100"
                    >
                      Custom Docker Image
                    </h3>
                    <p
                      class="text-xs text-slate-400 mt-0.5"
                    >
                      Flexible base image
                    </p>
                  </div>
                </div>

                <p
                  class="text-slate-400 text-sm mb-4 leading-relaxed"
                >
                  Use a different Node.js version or custom Docker image for specific project requirements.
                </p>

                <div
                  class="relative group/code"
                >
                  <button
                    @click="copyToClipboard('DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run', 'ex-4')"
                    class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-pink-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                    aria-label="Copy to clipboard"
                  >
                    <svg
                      v-if="copiedCode !== 'ex-4'"
                      class="w-4 h-4 text-slate-300"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                      />
                    </svg>
                    <svg
                      v-else
                      class="w-4 h-4 text-green-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                  </button>
                  <div
                    class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                  >
                    <div
                      class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                    >
                      <div
                        class="flex gap-1.5"
                      >
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                        />
                        <span
                          class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                        />
                      </div>
                      <span
                        class="ml-2 text-xs text-slate-500 font-mono"
                      >
                        bash
                      </span>
                    </div>
                    <pre
                      class="p-4 text-sm font-mono overflow-x-auto"
                    ><code class="text-slate-300">DOCKER_SANDBOX_IMAGE=node:20-alpine crush-sandbox run</code></pre>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="group relative p-6 rounded-2xl bg-gradient-to-br from-slate-800/60 to-slate-900/60 border border-slate-700/50 hover:border-red-500/40 transition-all duration-300 overflow-hidden lg:col-span-2"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-red-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />
              <div
                class="absolute top-0 right-0 w-20 h-20 bg-red-500/10 rounded-full blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />

              <div
                class="relative flex flex-col lg:flex-row gap-6"
              >
                <div
                  class="flex-1"
                >
                  <div
                    class="flex items-center gap-3 mb-4"
                  >
                    <div
                      class="w-10 h-10 rounded-lg bg-gradient-to-br from-red-500/20 to-red-600/10 flex items-center justify-center border border-red-500/20 group-hover:scale-110 transition-transform duration-300"
                    >
                      <svg
                        class="w-5 h-5 text-red-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                        />
                      </svg>
                    </div>
                    <div>
                      <h3
                        class="text-lg font-bold text-slate-100"
                      >
                        Credential Scanning
                      </h3>
                      <p
                        class="text-xs text-slate-400 mt-0.5"
                      >
                        Security check before launch
                      </p>
                    </div>
                  </div>

                  <p
                    class="text-slate-400 text-sm mb-4 leading-relaxed"
                  >
                    Scan your workspace for exposed credentials using gitleaks before starting the container. Prompts to continue if secrets are detected.
                  </p>

                  <div
                    class="flex items-center gap-2 text-xs text-slate-500"
                  >
                    <svg
                      class="w-4 h-4 text-amber-400"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                      />
                    </svg>
                    <span>Requires gitleaks Docker image (auto-pulled on first use)</span>
                  </div>
                </div>

                <div
                  class="lg:w-auto lg:min-w-[400px]"
                >
                  <div
                    class="relative group/code"
                  >
                    <button
                      @click="copyToClipboard('crush-sandbox run --cred-scan', 'ex-5')"
                      class="absolute top-3 right-3 z-10 p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600/50 border border-slate-600/50 hover:border-red-500/50 transition-all duration-200 group-hover/code:opacity-100 opacity-70"
                      aria-label="Copy to clipboard"
                    >
                      <svg
                        v-if="copiedCode !== 'ex-5'"
                        class="w-4 h-4 text-slate-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      <svg
                        v-else
                        class="w-4 h-4 text-green-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </button>
                    <div
                      class="bg-slate-950/80 rounded-xl border border-slate-700/50 overflow-hidden"
                    >
                      <div
                        class="flex items-center gap-2 px-4 py-2.5 bg-slate-900/50 border-b border-slate-700/50"
                      >
                        <div
                          class="flex gap-1.5"
                        >
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-red-500/80"
                          />
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-amber-500/80"
                          />
                          <span
                            class="w-2.5 h-2.5 rounded-full bg-green-500/80"
                          />
                        </div>
                        <span
                          class="ml-2 text-xs text-slate-500 font-mono"
                        >
                          bash
                        </span>
                      </div>
                      <pre
                        class="p-4 text-sm font-mono overflow-x-auto"
                      ><code class="text-slate-300">crush-sandbox run --cred-scan</code></pre>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer
      class="border-t border-slate-700/50 py-12 px-6 relative overflow-hidden"
    >
      <div
        class="absolute top-0 left-1/4 w-48 h-48 bg-amber-500/5 rounded-full blur-3xl"
      />
      <div
        class="absolute bottom-0 right-1/4 w-40 h-40 bg-cyan-500/5 rounded-full blur-3xl"
      />

      <div
        class="max-w-6xl mx-auto relative"
      >
        <div
          class="flex flex-col md:flex-row items-center justify-between gap-8"
        >
          <div
            class="flex flex-col items-center md:items-start gap-4"
          >
            <div
              class="flex items-center gap-3"
            >
              <div
                class="w-8 h-8 rounded-lg bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center shadow-lg shadow-amber-500/20"
              >
                <svg
                  class="w-4 h-4 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
                  />
                </svg>
              </div>
              <span
                class="text-lg font-bold bg-gradient-to-r from-amber-400 to-orange-400 bg-clip-text text-transparent"
              >
                crush-sandbox
              </span>
            </div>
            <p
              class="text-slate-500 text-sm max-w-md text-center md:text-left"
            >
              Docker sandbox for the Crush CLI with per-workspace caching. Secure, isolated, and fast.
            </p>
            <div
              class="flex items-center gap-2 text-xs text-slate-600 font-mono"
            >
              <span
                class="w-1.5 h-1.5 rounded-full bg-amber-500"
              />
              <span>MIT License</span>
            </div>
          </div>

          <div
            class="flex flex-col sm:flex-row items-center gap-6 sm:gap-8"
          >
            <a
              href="https://github.com/wireless25/crush-sandbox"
              target="_blank"
              rel="noopener noreferrer"
              class="group flex items-center gap-2 text-slate-400 hover:text-amber-400 transition-all duration-200 px-4 py-2 rounded-lg hover:bg-amber-500/5 border border-transparent hover:border-amber-500/20"
            >
              <svg
                class="w-5 h-5 group-hover:scale-110 transition-transform duration-200"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                />
              </svg>
              <span
                class="font-medium"
              >
                GitHub
              </span>
            </a>

            <a
              href="https://github.com/wireless25/crush-sandbox/issues"
              target="_blank"
              rel="noopener noreferrer"
              class="group flex items-center gap-2 text-slate-400 hover:text-cyan-400 transition-all duration-200 px-4 py-2 rounded-lg hover:bg-cyan-500/5 border border-transparent hover:border-cyan-500/20"
            >
              <svg
                class="w-5 h-5 group-hover:scale-110 transition-transform duration-200"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
              </svg>
              <span
                class="font-medium"
              >
                Issues
              </span>
            </a>

            <a
              href="https://github.com/wireless25/crush-sandbox/blob/main/LICENSE"
              target="_blank"
              rel="noopener noreferrer"
              class="group flex items-center gap-2 text-slate-400 hover:text-purple-400 transition-all duration-200 px-4 py-2 rounded-lg hover:bg-purple-500/5 border border-transparent hover:border-purple-500/20"
            >
              <svg
                class="w-5 h-5 group-hover:scale-110 transition-transform duration-200"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <span
                class="font-medium"
              >
                License
              </span>
            </a>
          </div>
        </div>

        <div
          class="mt-8 pt-8 border-t border-slate-700/50 flex flex-col md:flex-row items-center justify-between gap-4"
        >
          <p
            class="text-slate-600 text-sm"
          >
            Built with
            <span
              class="text-amber-500"
            >
              Vue 3
            </span>,
            <span
              class="text-cyan-500"
            >
              Vite
            </span>, and
            <span
              class="text-purple-500"
            >
              Tailwind CSS
            </span>
          </p>
          <p
            class="text-slate-600 text-xs"
          >
            © 2025 crush-sandbox. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
</style>
