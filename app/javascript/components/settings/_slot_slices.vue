<template>
  <v-container>
    <v-layout row-sm column child-flex-sm>
      <v-flex sm3 class="description">
        <h6>Slot slices</h6>
        <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eaque, praesentium?</small>
        <div class="mt-3"></div>
        <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Impedit omnis quibusdam ullam velit vero voluptatem.</small>
      </v-flex>
      <v-flex sm9>
        <v-card>
          <v-data-table
            v-bind:headers="slot_slices.headers"
            :items="slot_slices.items"
            v-model="slot_slices.items"
            hide-actions
          >
            <template slot="items" scope="props">
              <td class="text-xs-left">{{ props.index + 1 }}</td>
              <td class="text-xs-left">
                <v-select v-bind:items="slot_slices.allowedTypes" v-model="props.item.type" hide-details single-line></v-select>
              </td>
              <td class="text-xs-left">{{ props.item.label }}</td>
              <td class="text-xs-left">
                <v-edit-dialog
                  v-on:click="focus()"
                >
                  {{ props.item.code }}

                  <v-text-field
                    slot="input"
                    label="Edit code"
                    v-model="props.item.code"
                  ></v-text-field>
                </v-edit-dialog>
              </td>
              <td class="text-xs-right">{{ props.item.gravity }}</td>
            </template>
          </v-data-table>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    props: ['slot_slices']
  }
</script>