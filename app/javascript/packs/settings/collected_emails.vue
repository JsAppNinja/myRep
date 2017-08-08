<template>
  <v-container>
    <v-layout row-sm column child-flex-sm>
      <v-flex sm3 class="description">
        <h6>Collected emails</h6>
        <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eaque, praesentium?</small>
        <div class="mt-3"></div>
        <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Impedit omnis quibusdam ullam velit vero voluptatem.</small>
      </v-flex>
      <v-flex sm9>
        <v-card>
          <v-data-table
            v-bind:headers="collected_emails.headers"
            :items="collected_emails.items"
            hide-actions
          >
            <template slot="items" scope="props">
              <td class="text-xs-left">{{ props.index + 1 }}</td>
              <td>{{ props.item.email }}</td>
              <td>{{ props.item.page }}</td>
            </template>
          </v-data-table>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    props: ['collected_emails']
  }
</script>
