import Vue                  from 'vue'
import SlotMachineContainer from './container.vue'
import VueResource          from 'vue-resource'

Vue.use(VueResource);

const slotMachine = new Vue({
  el:     '#SlotMachine',
  render: (h) => h(SlotMachineContainer)
});
