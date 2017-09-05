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
              <td class="text-xs-left">{{ props.index + collectionStartsAt }}</td>
              <td>{{ props.item.email }}</td>
              <td>{{ props.item.url }}</td>
            </template>
          </v-data-table>
          <div class="datatable__actions">
            <div class="datatable__actions__select">
              Rows per page:
              <v-select v-bind:items="allowed_per_page" v-model="per_page" hide-details class="per-page-selector"></v-select>
            </div>

            <div class="datatable__actions__pagination">{{ collectionStartsAt }}-{{ collectionEndsAt }} of {{ totalCount }}</div>

            <v-btn flat icon v-bind:disabled="meta.prev_page" @click="prevPage()">
              <v-icon>chevron_left</v-icon>
            </v-btn>
            <v-btn flat icon v-bind:disabled="meta.next_page" @click="nextPage()">
              <v-icon>chevron_right</v-icon>
            </v-btn>
          </div>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  export default {

    data: function () {
      return {
        collected_emails: {
          headers: [
            { text: "№",     value: "index", align: 'left',  sortable: false },
            { text: "Email", value: "email", align: 'left',  sortable: false },
            { text: "Page",  value: "page",  align: 'left',  sortable: false }
          ],
          items: []
        },
        per_page: 25,
        allowed_per_page: [25, 50, 100],
        meta: {}
      }
    },

    mounted: function () {
      this.getPopupSubmits()
    },

    computed: {
      totalCount: function () { return this.meta.total_count },

      collectionStartsAt: function () {
        return ( (this.meta.current_page - 1) * this.meta.per_page + 1 )
      },

      collectionEndsAt: function () {
        return (this.meta.current_page - 1) * this.meta.per_page + this.collected_emails.items.length
      }
    },

    watch: {
      per_page: function(new_per_page) {
        this.getPopupSubmits(this.meta.current_page, new_per_page)
      }
    },

    methods: {
      nextPage: function () {
        this.getPopupSubmits(this.meta.current_page + 1, this.per_page)
      },

      prevPage: function () {
        this.getPopupSubmits(this.meta.current_page - 1, this.per_page)
      },

      getPopupSubmits: function(page, per_page) {
        // recalculate page value if user jumps to last page
        // with per_page value 25 and then changes per_page to 50 or more
        if (page * per_page > this.meta.total_count) {
          page = Math.ceil(this.meta.total_count / per_page)
        }

        this.$http
            .get(
              "/api/internal/v1/popup_submits",
              { params: { page: page, per_page: per_page } })
            .then(resp => {
              this.collected_emails.items = resp.body.popup_submits;
              this.meta = resp.body.meta
            })
      }
    },
  }
</script>

<style>
  .datatable__actions {
    border-top: 1px solid rgba(128, 128, 128, 0.5);
  }
  .datatable__actions .input-group__details {
    display: none !important;
  }
</style>
