import Vue from 'vue'
import SlotMachineContainer from './container.vue'

const slotMachine = new Vue({
  el:     '#SlotMachine',
  render: (h) => h(SlotMachineContainer)
});
