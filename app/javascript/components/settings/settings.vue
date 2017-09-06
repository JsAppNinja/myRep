<template>
  <v-app light toolbar class="settings">

    <v-toolbar class="primary" dark fixed>
      <v-container>
        <v-toolbar-title>
          SlotMachine

          <transition name="header-btn">
            <v-btn dark small primary flat class="header-btn white--text" v-if="show_plans" @click="show_plans = !show_plans">
              <v-icon class="white--text">chevron_left</v-icon>
              Back
            </v-btn>
          </transition>

          <transition name="header-btn" appear>
            <v-btn dark small class="red darken-1 header-btn header-upgrade-btn" v-if="show_settings" @click="show_settings = !show_settings">
              Upgrade
            </v-btn>
          </transition>
        </v-toolbar-title>
      </v-container>
    </v-toolbar>

    <!-- <main> gives some space so that navbar will not overlap settings -->
    <!-- all settings -->
    <transition name="slide-fade" v-on:after-leave="show_plans = !show_plans" appear>
      <main v-if="show_settings">

        <!-- General settings -->
        <General v-bind:general="general"></General>

        <v-container>
          <v-layout row transition="slide-x-transition">
            <v-divider></v-divider>
          </v-layout>
        </v-container>


        <!-- Triggers -->
        <Triggers v-bind:triggers="popup_config"
                  :service_fields="service_fields"
                  :component_preloader="!data_loaded"
        ></Triggers>


        <v-container>
          <v-layout row>
            <v-divider></v-divider>
          </v-layout>
        </v-container>

        <!-- Campaigns -->
        <Campaigns v-bind:campaigns="campaigns"></Campaigns>


        <v-container>
          <v-layout row>
            <v-divider></v-divider>
          </v-layout>
        </v-container>

        <!-- Branding -->
        <Branding v-bind:branding="branding"></Branding>

        <v-container>
          <v-layout row>
            <v-divider></v-divider>
          </v-layout>
        </v-container>

        <!-- Slot slices -->
        <SlotSlices v-bind:slot_slices="slices"></SlotSlices>

        <v-container>
          <v-layout row>
            <v-divider></v-divider>
          </v-layout>
        </v-container>

        <!-- Collected emails -->
        <CollectedEmails></CollectedEmails>


        <!-- Other stuff -->
      </main>
    </transition>


    <!-- bying page -->
    <transition name="slide-fade" v-on:after-leave="show_settings = !show_settings">
      <main v-if="show_plans">
        <Pricing v-bind:general="general"></Pricing>
      </main>
    </transition>

    <!-- Save button -->

    <v-fab-transition appear>
      <v-btn fab dark large primary fixed bottom right @click="updateSettings()" v-show="show_settings">
        <v-progress-circular indeterminate class="white--text" v-if="!data_saved"></v-progress-circular>
        <v-icon dark v-if="data_saved">save</v-icon>
      </v-btn>
    </v-fab-transition>


    <!-- Snackbar -->

    <v-snackbar :timeout="snackbar.timeout" v-model="snackbar.show"
                :success="snackbar.type === 'success'" :info="snackbar.type === 'info'"
                :warning="snackbar.type === 'warning'" :error="snackbar.type === 'error'"
                :primary="snackbar.type === 'primary'" :secondary="snackbar.type === 'secondary'">

      {{snackbar.text}}
      <v-btn dark flat @click.native="snackbar.show = false">{{snackbar.button_text}}</v-btn>

    </v-snackbar>
  </v-app>
</template>

<script>
import General         from './_general'
import Triggers        from './_triggers'
import Campaigns       from './_campaigns'
import Branding        from './_branding'
import SlotSlices      from './_slot_slices'
import CollectedEmails from './_collected_emails'
import Pricing         from './_pricing'

export default {
  components: {
    General, Triggers, Campaigns, Branding, SlotSlices, CollectedEmails, Pricing
  },

  data: function () {
    return {
      general: {
        // to show something when the data is not loaded yet
        shopify_domain: "example-shop.myshopify.com",
        id:             "...",
        enabled:        true,
        resolved:       false
      },
      popup_config:   {},
      service_fields: {},
      data_loaded:    false,
      data_saved:     true,
      snackbar: {
        show: false
      },
      show_plans:    false,
      show_settings: true,

      // example fields
      campaigns: [
        {
          active:  true,
          name:    "Awesome campaign",
          started: "sometime",
          ended:   ""
        },
        {
          active:  false,
          name:    "Not so awesome campaign",
          started: "2017-04-23",
          ended:   "2017-04-26"
        },
        {
          active:  false,
          name:    "Test campaign",
          started: "2017-05-23",
          ended:   "2017-05-26"
        }
      ],
      branding: {
        titleText:      "%storename \\bspecial bonus\\b unlocked",
        guidingText:    "You have a chance to win a nice big fat discount. Are you ready?",
        disclaimerText: "*You can spin the wheel only once.<br>* If you win, you can claim your coupon for 10 mins  only!"
      },
      slices: {
        headers: [
          { text: "№",       value: "index",   sortable: false, align: 'left' },
          { text: "Type",    value: "type",    sortable: false, align: 'left' },
          { text: "Label",   value: "label",   sortable: false, align: 'left' },
          { text: "Code",    value: "code",    sortable: false, align: 'left' },
          { text: "Gravity", value: "gravity", sortable: false }
        ],
        items: [
          { type: "Coupon", label: "Winner!", code: "000-000-000", gravity: 100 },
          { type: "Coupon", label: "Winner2", code: "000-000-000", gravity: 10 },
          { type: "Coupon", label: "Winner3", code: "000-000-000", gravity: 10 },
          { type: "Coupon", label: "Winner4", code: "000-000-000", gravity: 20 },
          { type: "Coupon", label: "Winner5", code: "000-000-000", gravity: 10 },
          { type: "Coupon", label: "Winner6", code: "000-000-000", gravity: 10 }
        ],
        allowedTypes: ["Coupon", "Image"]
      }
    }
  },

  // METHODS

  methods: {
    updateSettings: function () {
      this.data_saved = false;
      this.$http
          .put(
            "/api/internal/v1/popup_config",
            { popup_config: this.popup_config }
          )
          .then(
              resp => { this.showSnackbar({ type: 'success', text: "Successfully saved!" }) },
              err  => { console.log(err) }
          ).then(
            () => this.data_saved = true
          )
    },

    showSnackbar: function (args) {
      // to avoid influence of previous snackbar properties on a new snackbar
      // each time we make a copy of this default params with assigned args
      // to this.snackbar

      var snackbar_default = {
        show:        true,
        timeout:     6000,
        text:        '',
        type:        'secondary',
        button_text: 'Close'
      };

      this.$set(this, 'snackbar', Object.assign(snackbar_default, args))
    }
  },

  mounted: function () {
    this.$http.get("/api/internal/v1/shop")
              .then(resp => {
                this.general = resp.body.shop;
                this.general['resolved'] = true
              })

    this.$http.get("/api/internal/v1/popup_config")
             .then(resp => {
               var popup_config = resp.body.popup_config;

               // move service_fields from popup_config
               this.service_fields = popup_config.service_fields;
               delete popup_config.service_fields;

               // made a copy of new_rule for "reset to default values" feature
               // only new_draft_rule object can be changed and added to uri_filters
               this.$set(
                   this.service_fields.uri_filters,
                   'new_draft_rule',
                   Object.assign({}, this.service_fields.uri_filters.new_rule)
               );

               this.popup_config = popup_config;
               this.data_loaded = true;
             }, error => {
               console.log(error.body)
             });
  }
}
</script>


<style lang="scss" scoped>
  /* Styles that applied only for this component */

  .container {
    max-width:  1024px;
    margin:     0 auto !important;
    min-height: 1px !important;
  }

  .toolbar__title {
    margin-left: 0;
    overflow: visible;
  }

  main {
    padding-top: 80px;

    .container:last-child {
      margin-bottom: 100px !important;
    }
  }

  .header-btn > .btn__content > i {
    margin-left: -10px;
  }

  .header-btn {
    top: -1px;
    margin: 0;
    float: right;
  }

  .header-upgrade-btn {
    top: 0;
  }

  /* transitions */

  /* for content */

  .slide-fade-enter-active {
    transition: all .3s ease;
  }

  .slide-fade-leave-active {
    transition: all .3s ease;
  }

  .slide-fade-enter{
    transform: translateX(30px);
    opacity: 0;
  }

  .slide-fade-leave-to {
    transform: translateX(-30px);
    opacity: 0;
  }

  /* for header buttons */

  .header-btn-enter-active {
    transition: all .3s ease;
  }

  .header-btn-leave-active {
    transition: all .3s ease;
  }

  .header-btn-enter {
    transform: translateX(-30px);
    opacity: 0;
  }

  .header-btn-leave-to {
    transform: translateX(30px);
    opacity: 0;
  }

  /* for save button */

  .save-btn-enter-active {
    transition: all .3s ease;
  }

  .save-btn-leave-active {
    transition: all .3s ease;
  }

  .save-btn-enter{
    transform: rotate(-90deg);
    opacity: 0;
  }

  .save-btn-leave-to {
    transform: rotate(90deg);
    opacity: 0;
  }
</style>


<style lang="scss">
  /* Global styles for all child components */

  h6 { font-size: 20px !important; }

  small {
    font-size: 85%;
    color: rgba(0, 0, 0, 0.5);
  }

  thead {
    color: rgba(0, 0, 0, 0.5);
  }

  td.index {
    width: 10px;
  }

  td.fixed-width {
    width: 120px;
  }

  .table-head {
    padding-bottom: 5px;
    padding-top: 35px;

    & + .flex {
      overflow : auto;

      & > table {
        min-width : 400px;
      }
    }
  }

  .preloader {
    padding: 30px;
  }

  .description{
    padding: 20px 20px 20px 4px;
  }

  .card-last-child-padd:last-child {
    padding-bottom: 4px;
  }
</style>
