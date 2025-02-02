import { mount } from 'svelte'
import './styles/Global.css'
import Interface from './Interface.svelte'
// import { debugData } from './utils/debugData'

// debugData([{ action: 'taskbar', data: { size: 10, time: 3 } }])

const app = mount(Interface, {
  target: document.getElementById('app')!,
})

export default app
