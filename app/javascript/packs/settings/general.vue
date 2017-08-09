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
                <v-text-field name="input-1" label="Shop URL" v-model="general.shopUrl"></v-text-field>
              </v-flex>
              <v-flex sm5 offset-sm1>
                <v-text-field name="input-1" label="Shop ID" v-model="general.shopId"></v-text-field>
              </v-flex>
            </v-layout>
            <v-layout row-sm flex-row column child-flex-sm>
              <v-flex sm5>
                <v-switch label="Enable wheel" v-model="general.enabled" color="info" hide-details></v-switch>
              </v-flex>
              <v-flex sm5 offset-sm1>
                <v-btn info flat class="preview-btn">Live Preview</v-btn>
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
                <h6 class="primary--text">{{general.analytics.displayed}}</h6>
              </v-flex>
              <v-flex sm4>
                <div class="subheading">Spinned</div>
                <h6 class="primary--text">{{general.analytics.spinned}}</h6>
              </v-flex>
              <v-flex sm4>
                <div class="subheading">Rejected</div>
                <h6 class="primary--text">{{general.analytics.rejected}}</h6>
              </v-flex>
              <v-flex sm4>
                <div class="subheading">Conversion rate</div>
                <h6 class="primary--text">{{general.analytics.conversionRate}} %</h6>
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
    props: ['general']
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