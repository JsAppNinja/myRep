<template>
  <v-container>
    <v-layout row-sm column child-flex-sm>
      <v-flex sm3 class="description">
        <h6>Campaigns</h6>
        <small>Key to success is testing. To test different creatives and looks, you can now use campaigns. Create a new campaign and save the old ones. You can later check the advanced analytics section to check the data from the campaigns.</small>
      </v-flex>
      <v-flex sm9>
        <v-expansion-panel expand class="white elevation-1">
          <v-expansion-panel-content>
            <div slot="header" class="expansion-header"><h6>Campaigns</h6></div>
            <v-card class="card-last-child-padd">
              <v-card-title class="pt-0">
                <v-layout row class="flex-row">
                  <v-flex sm12>
                    <small>Campaigns help you measure and organize analytics based on different events.</small>
                  </v-flex>
                </v-layout>
                <v-layout row-md column class="flex-row">
                  <v-flex sm12 class="pa-0 pt-4">
                    <v-btn info small style="float: right;">Reset cookie for all users</v-btn>
                    <v-btn primary
                           small
                           style="float: right;"
                           v-bind:class="{ success: !haveActiveCampaigns() }"
                    >
                      {{ haveActiveCampaigns() ? "close and" : "" }} start new campaign
                    </v-btn>
                  </v-flex>
                </v-layout>
              </v-card-title>
              <v-divider v-show="havePastCampaigns() || haveActiveCampaigns()"></v-divider>
              <v-card-title v-if="haveActiveCampaigns()" class="table-head">
                <v-layout row>
                  <v-flex sm12>
                    <h6 class="mb-0">Current campaign</h6>
                  </v-flex>
                </v-layout>
              </v-card-title>
              <v-flex sm12 v-if="haveActiveCampaigns()">
                <table class="datatable table">
                  <thead>
                  <tr>
                    <td>№</td>
                    <td>Name</td>
                    <td class="fixed-width">Started</td>
                    <td class="fixed-width">Ended</td>
                  </tr>
                  </thead>
                  <tbody>
                  <tr v-for="(campaign, index) in campaigns" v-if="campaign.active">
                    <td class="index">{{index + 1}}</td>
                    <td>{{campaign.name}}</td>
                    <td class="fixed-width">{{campaign.started}}</td>
                    <td class="fixed-width">-</td>
                  </tr>
                  </tbody>
                </table>
              </v-flex>
              <v-card-title v-if="havePastCampaigns()" class="table-head">
                <v-layout row>
                  <v-flex sm-12>
                    <h6 class="mb-0">Previous campaigns</h6>
                  </v-flex>
                </v-layout>
              </v-card-title>
              <v-flex sm-12 v-if="havePastCampaigns()">
                <table class="datatable table">
                  <thead>
                  <tr>
                    <td>№</td>
                    <td>Name</td>
                    <td class="fixed-width">Started</td>
                    <td class="fixed-width">Ended</td>
                  </tr>
                  </thead>
                  <tbody>
                  <tr v-for="(campaign, index) in campaigns" v-if="campaign.active == false">
                    <td class="index">{{index + 1}}</td>
                    <td>{{campaign.name}}</td>
                    <td class="fixed-width">{{campaign.started}}</td>
                    <td class="fixed-width">{{campaign.ended}}</td>
                  </tr>
                  </tbody>
                </table>
              </v-flex>
            </v-card>
          </v-expansion-panel-content>
        </v-expansion-panel>
      </v-flex>
    </v-layout>
  </v-container>
</template>


<script>
  export default {
    props: ['campaigns'],

    methods: {
      haveActiveCampaigns: function () {
        return this.campaigns.map(function(campaign){ return campaign.active }).indexOf(true) !== -1
      },

      havePastCampaigns: function () {
        return this.campaigns.map(function(campaign){ return campaign.active }).indexOf(false) !== -1
      }
    }
  }
</script>
