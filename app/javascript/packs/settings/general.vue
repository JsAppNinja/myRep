<!-- General settings component -->

<template>
  <v-container>
    <v-layout row-sm column child-flex-sm>
      <v-flex sm3 class="description">
        <h6>General</h6>
      </v-flex>
      <v-flex sm9>
        <v-card>
          <v-card-title>
            <v-layout row-sm flex-row column child-flex-sm>
              <v-flex sm5>
                <v-text-field name="input-1" label="Shop URL" v-model="general.shopify_domain" disabled></v-text-field>
              </v-flex>
              <v-flex sm5 offset-sm1>
                <v-text-field name="input-1" label="Shop ID" v-model="general.id" disabled></v-text-field>
              </v-flex>
            </v-layout>
            <v-layout row-sm flex-row column child-flex-sm>
              <v-flex sm5>
                <v-switch label="Enable wheel"
                          v-bind:disabled="!general.resolved || freeze_switch"
                          v-model="general.enabled"
                          color="info"
                          hint="This value updates on every change"
                          persistent-hint
                ></v-switch>
              </v-flex>
              <v-flex sm5 offset-sm1>
                <v-btn info flat class="preview-btn"
                       v-bind:disabled="!general.resolved"
                       @click="openLink()"
                >
                  Live Preview
                </v-btn>
              </v-flex>
            </v-layout>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-title>
            <v-layout row class="flex-row">
              <v-flex sm12>
                <h6>Analytics</h6>
              </v-flex>
            </v-layout>
            <v-layout row-sm column child-flex-sm class="analytics flex-row">
              <v-flex sm4>
                <div class="subheading">Displayed</div>
                <h6 class="primary--text" v-if="general.resolved">{{general.analytics.displayed}}</h6>
                <h6 class="primary--text" v-if="!general.resolved">...</h6>
              </v-flex>
              <v-flex sm4>
                <div class="subheading">Spinned</div>
                <h6 class="primary--text" v-if="general.resolved">{{general.analytics.spinned}}</h6>
                <h6 class="primary--text" v-if="!general.resolved">...</h6>
              </v-flex>
              <v-flex sm4>
                <div class="subheading">Rejected</div>
                <h6 class="primary--text" v-if="general.resolved">{{general.analytics.rejected}}</h6>
                <h6 class="primary--text" v-if="!general.resolved">...</h6>
              </v-flex>
              <v-flex sm4>
                <div class="subheading">Conversion rate</div>
                <h6 class="primary--text" v-if="general.resolved">{{general.analytics.conversion_rate}} %</h6>
                <h6 class="primary--text" v-if="!general.resolved">... %</h6>
              </v-flex>
            </v-layout>
          </v-card-title>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    props: ['general'],

    data: function() {
      return {
        freeze_switch: false
      }
    },

    watch: {
      'general.enabled': function () {
        if (this.general.resolved === true) {
          this.freeze_switch = true;
          this.$http
              .put(
                "/api/internal/v1/shop",
                { shop: this.general }
              )
              .then(
                resp => {
                  this.freeze_switch = false;
                  this.general.enabled = resp.body.enabled
                },
                err  => { console.log(err) }
              )
        }
      }
    },

    methods: {
      openLink: function () {
        window.open('https://' + this.general.shopify_domain, '_blank')
      }
    }
  }
</script>


<style lang="scss" scoped>
  .analytics {
    padding: 10px;
    text-align: center;
    background-color: #FAFAFA;
    border-radius: 2px;

    h6 {
      color: #1976D2;
      padding-top: 10px;
    }
  }

  .preview-btn {
    top: 8px;
  }
</style>