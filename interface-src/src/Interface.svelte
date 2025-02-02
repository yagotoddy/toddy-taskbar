<script lang="ts">
  import { fade } from 'svelte/transition'
  import { useNuiEvent } from "./utils/useNuiEvent"
  import { fetchNui } from './utils/fetchNui'

  let visible = $state(false)
  let game = $state(false)

  let progress = $state(0)
  let sizeBar = $state(10)
  let positionBar = $state(0)
  let timeBar = $state(3)

  interface Taskbar { size?: number, time?: number }

  useNuiEvent<Taskbar>('taskbar',(data) => {
    visible = true

    let time = 3
    if (data.time && typeof data.time === 'number') {
      time = data.time
    }
    timeBar = time

    let size = 10
    if (data.size && typeof data.size === 'number') {
      if (data.size >= 1 && data.size <= 100) {
        size = data.size
      }
    }
    sizeBar = size

    let position = Math.floor(Math.random() * 101)
    positionBar = Math.min(100 - sizeBar,position)
  })

  $effect(() => {
    let interval: number

    if (visible && game) {
      progress = 0
      interval = setInterval(() => {
        progress++

        if (progress >= 100) {
          fetchNui('result',false).catch(() => {})
          game = false
          visible = false
          progress = 0
        }
      },(timeBar * 1000) / 100)
    }

    return () => clearInterval(interval)
  })

  const handleKeydown = (event: KeyboardEvent) => {
    if (!visible || !game) return

    if (event.key === 'e') {
      const result = progress >= positionBar && progress <= Math.min(100,positionBar + sizeBar)
      fetchNui('result',result).catch(() => {})

      game = false
      visible = false
      progress = 0
    }
  }
</script>

<svelte:window onkeydown={handleKeydown} />

{#if visible}
  <div
    transition:fade={{ duration: 300 }}
    onintroend={() => game = true}
    class="absolute left-1/2 -translate-x-1/2 bottom-32 bg-neutral-800 p-4 rounded flex flex-col gap-2"
  >
    <div class="h-10 rounded bg-neutral-600 relative">
      <div
        style="left: {positionBar}%; width: {sizeBar}%"
        class="absolute h-full bg-neutral-400"
      ></div>
  
      <div
        style="left: {progress}%"
        class="absolute h-full w-[1%] bg-neutral-200"
      ></div>
    </div>
  
    <p class="text-sm text-white/60 font-medium">Pressione E quando a linha alcançar a barra.</p>
  </div>
{/if}