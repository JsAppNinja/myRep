<!-- Triggers component -->

<template>
  <v-container>
    <v-layout row-sm column child-flex-sm>
      <v-flex sm3 class="description">
        <h6>Triggers</h6>
        <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eaque, praesentium?</small>
        <div class="mt-3"></div>
        <small>
          Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aliquid consequuntur cupiditate enim hic non,
          officia reiciendis repellendus veritatis vero voluptate.
        </small>
      </v-flex>
      <v-flex sm9>

        <!-- Preloader -->

        <v-card v-if="component_preloader">
          <div class="text-xs-center preloader">
            <v-progress-circular indeterminate v-bind:size="40" class="primary--text"></v-progress-circular>
          </div>
        </v-card>

        <v-card class="card-last-child-padd" v-if="!component_preloader">
          <v-card-title>
            <v-layout row-md flex-row column child-flex-md>
              <v-flex md6 class="pb-3">
                <v-switch
                  label="Show on desktop computers"
                  v-model="triggers.desktop_enabled"
                  color="info"
                  hide-details
                ></v-switch>

                <v-divider></v-divider>

                <v-switch
                  v-bind:disabled="!triggers.desktop_enabled"
                  label="On user's leave intent"
                  v-model="triggers.desktop_show_on_leave"
                  color="info"
                  hint="When mouse leaves browser's viewport"
                  persistent-hint
                ></v-switch>

                <v-layout row-sm column child-flex-sm>
                  <v-flex sm4 class="after-switch-width">
                    <v-switch
                      v-bind:disabled="!triggers.desktop_enabled"
                      label="After"
                      v-model="triggers.desktop_show_on_timeout"
                      color="info"
                      hide-details
                    ></v-switch>
                  </v-flex>

                  <v-flex sm4>
                    <v-text-field
                      v-bind:disabled="!triggers.desktop_enabled || !triggers.desktop_show_on_timeout"
                      name="triggers-desktop-after-seconds"
                      v-model="triggers.desktop_show_timeout"
                      suffix="seconds"
                      type="number"
                      min="0"
                    ></v-text-field>
                  </v-flex>
                </v-layout>
              </v-flex>

              <v-flex md6 class="pb-3">
                <v-switch
                  label="Show on tablets and mobile"
                  v-model="triggers.tablet_enabled"
                  color="info"
                  hide-details
                ></v-switch>

                <v-divider></v-divider>

                <v-switch
                  v-bind:disabled="!triggers.tablet_enabled"
                  label="On user's leave intent"
                  v-model="triggers.tablet_show_on_leave"
                  color="info"
                  hint="When users suddenly scrolls upwards"
                  persistent-hint
                ></v-switch>

                <v-layout row-sm column child-flex-sm>
                  <v-flex sm4 class="after-switch-width">
                    <v-switch
                      v-bind:disabled="!triggers.tablet_enabled"
                      label="After"
                      v-model="triggers.tablet_show_on_timeout"
                      color="info"
                      hide-details
                    ></v-switch>
                  </v-flex>

                  <v-flex sm4>
                    <v-text-field
                      v-bind:disabled="!triggers.tablet_enabled || !triggers.tablet_show_on_timeout"
                      name="triggers-mobile-after-seconds"
                      v-model="triggers.tablet_show_timeout"
                      suffix="seconds"
                      type="number"
                      min="0"
                    ></v-text-field>
                  </v-flex>
                </v-layout>
              </v-flex>
            </v-layout>
            <v-layout flex-row row-sm column child-flex-sm>
              <v-flex md3>
                <v-radio color="info" hide-details label="Left"
                         v-model="triggers.placement" value="left">
                </v-radio>
              </v-flex>
              <v-flex md3>
                <v-radio color="info" hide-details label="Right"
                         v-model="triggers.placement" value="right">
                </v-radio>
              </v-flex>
              <v-flex md3>
                <v-radio color="info" hide-details label="Top"
                         v-model="triggers.placement" value="top">
                </v-radio>
              </v-flex>
              <v-flex md3>
                <v-radio color="info" hide-details label="Bottom"
                         v-model="triggers.placement" value="bottom">
                </v-radio>
              </v-flex>
            </v-layout>
          </v-card-title>

          <v-divider></v-divider>

          <v-card-title>
            <v-layout row-sm flex-row column child-flex-sm wrap>
              <v-flex sm12>
                <p class="mb-0">Do not show Slot machine to the same visitor again for that many days:</p>

                <v-flex sm4>
                  <v-text-field
                    name="do-not-show"
                    v-model="triggers.show_days_timeout"
                    suffix="days"
                    type="number"
                    min="0"
                  ></v-text-field>
                </v-flex>
              </v-flex>

              <v-flex sm12>
                <p>Show it again to everyone no matter how many days have passed.</p>
                <v-btn info small class="ma-0" light v-bind:disabled="disable_cookies_reset" @click="resetCookies()">Reset cookies for all users</v-btn>
              </v-flex>
            </v-layout>
          </v-card-title>

          <v-divider></v-divider>

          <v-card-title class="table-head">
            <v-layout column>
              <v-flex sm12>
                <h6>Url filtering</h6>
                <p class="mb-0">Show slot machine only on site urls that:</p>
              </v-flex>
              <v-flex row-sm flex-row column child-flex-sm wrap>
              </v-flex>
            </v-layout>
          </v-card-title>

          <v-flex sm12>
            <table class="datatable table">
              <tbody>

              <!-- Add a new rule -->
              <tr>
                <td class="text-xs-left" style="width: 115px;">
                  <v-select v-bind:items="service_fields.uri_filters.allowed_types"
                            v-model="service_fields.uri_filters.new_draft_rule.type"
                            hide-details
                            single-line
                  ></v-select>
                </td>
                <td class="text-xs-left" style="width: 140px;">
                  <v-select v-bind:items="service_fields.uri_filters.allowed_matching_types"
                            v-model="service_fields.uri_filters.new_draft_rule.matching"
                            hide-details
                            single-line
                  ></v-select>
                </td>
                <td class="text-xs-left">
                  <v-text-field
                    prefix="http://"
                    name="trigger-uri-filter"
                    v-model="service_fields.uri_filters.new_draft_rule.uri"
                    hide-details
                  ></v-text-field>
                </td>
                <td class="text-xs-right">
                  <v-btn icon dark small success class="mx-1" @click="addUriRule()">
                    <v-icon dark>add</v-icon>
                  </v-btn>
                  <v-btn icon dark small warning class="mx-1" @click="restoreUriRule()"
                         v-tooltip:left="{ html: 'Reset to default values' }"
                  >
                    <v-icon>cached</v-icon>
                  </v-btn>
                </td>
              </tr>


              <tr v-for="(uriRule, index) in triggers.uri_filters">
                <td class="text-xs-left" style="width: 115px;">
                  <v-select v-bind:items="service_fields.uri_filters.allowed_types" v-model="uriRule.type" hide-details single-line></v-select>
                </td>
                <td class="text-xs-left" style="width: 140px;">
                  <v-select v-bind:items="service_fields.uri_filters.allowed_matching_types" v-model="uriRule.matching" hide-details single-line></v-select>
                </td>
                <td class="text-xs-left">
                  <v-text-field
                    prefix="http://"
                    name="trigger-uri-filter"
                    v-model="uriRule.uri"
                    hide-details
                  ></v-text-field>
                </td>
                <td class="text-xs-right">
                  <v-btn icon dark small class="red darken-1" @click="removeUriRule(index)">
                    <v-icon dark>delete_forever</v-icon>
                  </v-btn>
                </td>
              </tr>
              </tbody>
            </table>
          </v-flex>

        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>


<script>
  export default {
    data: function () {
      return {
        disable_cookies_reset: false
      }
    },

    props: ['triggers', 'service_fields', 'component_preloader', 'showSnackbar'],

    methods: {
      removeUriRule: function (uriIndex) {
        this.triggers.uri_filters.splice(uriIndex, 1)
      },

      addUriRule: function () {
        var newRule = Object.assign({}, this.service_fields.uri_filters.new_draft_rule);
        this.triggers.uri_filters.unshift(newRule)
      },

      restoreUriRule: function () {
        // reset the uri rule to default values

        this.$set(
          this.service_fields.uri_filters,
          'new_draft_rule',
          Object.assign({}, this.service_fields.uri_filters.new_rule)
        );
      },

      resetCookies: function () {
        this.disable_cookies_reset = true;
        this.$http
            .get('/api/internal/v1/popup_config/update_version')
            .then(
                resp => {
                  this.$parent.showSnackbar({type: 'success', text: "Successfully reset!"});
                },
                err => {
                  console.log(err)
                }
            ).then(() => { this.disable_cookies_reset = false })
      }
    }
  }
</script>

<style scoped>
  .flex-row {
    width: 100%;
  }

  .after-switch-width {
    max-width: 90px !important;
    min-width: 90px !important;
  }

  button.theme--light {
    color: #fff !important;
  }

  button.theme--light[disabled="disabled"] {
   color: rgba(0, 0, 0, .26) !important;
  }
</style>
