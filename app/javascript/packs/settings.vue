<template>
  <v-app light>

    <!-- General settings -->

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
                  <v-text-field name="input-1" label="Shop URL" v-model="shopUrl"></v-text-field>
                </v-flex>
                <v-flex sm5 offset-sm1>
                  <v-text-field name="input-1" label="Shop ID" v-model="shopId"></v-text-field>
                </v-flex>
              </v-layout>
              <v-layout row-sm flex-row column child-flex-sm>
                <v-flex sm5>
                  <v-switch label="Enable wheel" v-model="enabled" color="info" hide-details></v-switch>
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
                  <h6 class="primary--text">{{analytics.displayed}}</h6>
                </v-flex>
                <v-flex sm4>
                  <div class="subheading">Spinned</div>
                  <h6 class="primary--text">{{analytics.spinned}}</h6>
                </v-flex>
                <v-flex sm4>
                  <div class="subheading">Rejected</div>
                  <h6 class="primary--text">{{analytics.rejected}}</h6>
                </v-flex>
                <v-flex sm4>
                  <div class="subheading">Conversion rate</div>
                  <h6 class="primary--text">{{analytics.conversionRate}} %</h6>
                </v-flex>
              </v-layout>
            </v-card-title>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>

    <v-container>
      <v-layout row>
        <v-divider></v-divider>
      </v-layout>
    </v-container>

    <!-- Triggers -->

    <v-container>
      <v-layout row-sm column child-flex-sm>
        <v-flex sm3 class="description">
          <h6>Triggers</h6>
          <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eaque, praesentium?</small>
          <div class="mt-3"></div>
          <small>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Impedit omnis quibusdam ullam velit vero voluptatem.</small>
        </v-flex>
        <v-flex sm9>
          <v-card class="card-last-child-padd">
            <v-card-title>
              <v-layout row-md flex-row column child-flex-md>
                <v-flex md6 class="pb-3">
                  <v-switch
                    label="Show on desktop computers"
                    v-model="popup_config.desktop_enabled"
                    color="info"
                    hide-details
                  ></v-switch>

                  <v-divider></v-divider>

                  <v-switch
                    v-bind:disabled="!popup_config.desktop_enabled"
                    label="On user's leave intent"
                    v-model="popup_config.desktop_show_on_leave"
                    color="info"
                    hint="When mouse leaves browser's viewport"
                    persistent-hint
                  ></v-switch>

                  <v-layout row-sm column child-flex-sm>
                    <v-flex sm4 class="triggers-after-switch-width">
                      <v-switch
                        v-bind:disabled="!popup_config.desktop_enabled"
                        label="After"
                        v-model="popup_config.desktop_show_on_timeout"
                        color="info"
                        hide-details
                      ></v-switch>
                    </v-flex>

                    <v-flex sm4>
                      <v-text-field
                        v-bind:disabled="!popup_config.desktop_enabled || !popup_config.desktop_show_on_timeout"
                        name="triggers-desktop-after-seconds"
                        v-model="popup_config.desktop_show_timeout"
                        suffix="seconds"
                      ></v-text-field>
                    </v-flex>
                  </v-layout>
                </v-flex>

                <v-flex md6 class="pb-3">
                  <v-switch
                    label="Show on tablets and mobile"
                    v-model="popup_config.tablet_enabled"
                    color="info"
                    hide-details
                  ></v-switch>

                  <v-divider></v-divider>

                  <v-switch
                    v-bind:disabled="!popup_config.tablet_enabled"
                    label="On user's leave intent"
                    v-model="popup_config.tablet_show_on_leave"
                    color="info"
                    hint="When users suddenly scrolls upwards"
                    persistent-hint
                  ></v-switch>

                  <v-layout row-sm column child-flex-sm>
                    <v-flex sm4 class="triggers-after-switch-width">
                      <v-switch
                        v-bind:disabled="!popup_config.tablet_enabled"
                        label="After"
                        v-model="popup_config.tablet_show_on_timeout"
                        color="primary"
                        hide-details
                      ></v-switch>
                    </v-flex>

                    <v-flex sm4>
                      <v-text-field
                        v-bind:disabled="!popup_config.tablet_enabled || !popup_config.tablet_show_on_timeout"
                        name="triggers-mobile-after-seconds"
                        v-model="popup_config.tablet_show_timeout"
                        suffix="seconds"
                      ></v-text-field>
                    </v-flex>
                  </v-layout>
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
                      v-model="popup_config.show_days_timeout"
                      suffix="days"
                    ></v-text-field>
                  </v-flex>
                </v-flex>

                <v-flex sm12>
                  <p>Show it again to everyone no matter how many days have passed.</p>
                  <v-btn info small class="ma-0">Reset cookies for all users</v-btn>
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
                <tr v-for="(uriRule, index) in popup_config.uri_filters">
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
                      v-model="uriRule.value"
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
            <v-card-text>
              <v-btn
                absolute
                dark
                fab
                bottom
                right
                success
                @click="addUriRule()"
              >
                <v-icon>add</v-icon>
              </v-btn>
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>

    <v-container>
      <v-layout row>
        <v-divider></v-divider>
      </v-layout>
    </v-container>

    <!-- Campaigns -->

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

    <v-container>
      <v-layout row>
        <v-divider></v-divider>
      </v-layout>
    </v-container>

    <!-- Branding -->

    <v-container>
      <v-layout row-sm column child-flex-sm>
        <v-flex sm3 class="description">
          <h6>Branding</h6>
          <small>Make it your own. Use this segment to customize the design of Wheel so it matches your general store look.</small>
          <div class="mt-3"></div>
          <small>Why? So it doesnt interrupt the user journey.</small>
        </v-flex>
        <v-flex sm9>
          <v-card>
            <v-card-title>
              <v-layout row class="flex-row">
                <v-flex sm7>
                  <span>Big logo</span>
                  <br>
                  <small>380 x 80px, png image</small>
                  <br>
                  <v-btn primary small class="ml-0">Upload</v-btn>
                  <div class="lg-preview"></div>
                </v-flex>

                <v-flex sm5>
                  <span>Small logo</span>
                  <br>
                  <small>180 x 180px, png image</small>
                  <br>
                  <v-btn primary small class="ml-0">Upload</v-btn>
                  <div class="sm-preview"></div>
                </v-flex>
              </v-layout>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title class="pb-0">
              <v-layout row class="flex-row mb-4">
                <v-flex sm12>
                  <v-text-field
                    name="title-text"
                    label="Title text"
                    v-model="branding.titleText"
                    hint="Use \b to emphasize text and \n for line breaks."
                    persistent-hint
                  >
                  </v-text-field>
                </v-flex>
              </v-layout>

              <v-layout row class="flex-row">
                <v-flex sm6>
                  <v-text-field
                    name="guiding-text"
                    label="Guiding text"
                    multi-line
                    rows="3"
                    auto-grow
                    v-model="branding.guidingText">
                  </v-text-field>
                </v-flex>
                <v-flex sm6>
                  <v-text-field
                    name="guiding-text"
                    label="Disclaimer text"
                    multi-line
                    rows="3"
                    auto-grow
                    v-model="branding.disclaimerText">
                  </v-text-field>
                </v-flex>
              </v-layout>
            </v-card-title>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>

    <v-container>
      <v-layout row>
        <v-divider></v-divider>
      </v-layout>
    </v-container>

    <!-- Slot slices -->

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
              v-bind:headers="slices.headers"
              :items="slices.items"
              v-model="slices.items"
              hide-actions
            >
              <template slot="items" scope="props">
                <td class="text-xs-left">{{ props.index + 1 }}</td>
                <td class="text-xs-left">
                  <v-select v-bind:items="slices.allowedTypes" v-model="props.item.type" hide-details single-line></v-select>
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

    <v-container>
      <v-layout row>
        <v-divider></v-divider>
      </v-layout>
    </v-container>

    <!-- Collected emails -->

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
              v-bind:headers="emails.headers"
              :items="emails.items"
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
  </v-app>
</template>

<script>
export default {
  data: function () {
    return {
      popup_config: {},
      service_fields: {},

      // example fields
      message: "Hello Vue!",
      shopUrl: "example-shop1.myshopify",
      shopId:  "142536712",
      enabled: true,
      analytics: {
        displayed: 12,
        spinned:   5,
        rejected:  1,
        conversionRate: 40
      },
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
      },
      emails: {
        headers: [
          { text: "№",     value: "index", align: 'left',  sortable: false },
          { text: "Email", value: "email", align: 'left',  sortable: false },
          { text: "Page",  value: "page",  align: 'left', sortable: false }
        ],
        items: [
          { email: "example@user1.com",  page: "/clothes" },
          { email: "example@user2.com",  page: "/smartphones" },
          { email: "example@user3.com",  page: "/clothes" },
          { email: "example@user4.com",  page: "/accessories" },
          { email: "example@user5.com",  page: "/smartphones" },
          { email: "example@user6.com",  page: "/clothes" },
          { email: "example@user7.com",  page: "/accessories" },
          { email: "example@user8.com",  page: "/clothes" },
          { email: "example@user9.com",  page: "/clothes" },
          { email: "example@user10.com", page: "/accessories" },
          { email: "example@user11.com", page: "/accessories" },
          { email: "example@user12.com", page: "/smartphones" }
        ]
      }
    }
  },

  // METHODS

  methods: {
    haveActiveCampaigns: function () {
      return this.campaigns.map(function(campaign){ return campaign.active }).indexOf(true) !== -1
    },

    havePastCampaigns: function () {
      return this.campaigns.map(function(campaign){ return campaign.active }).indexOf(false) !== -1
    },

    removeUriRule: function (uriIndex) {
      this.triggers.uri.items.splice(uriIndex, 1)
    },

    addUriRule: function () {
      var plainItem = { type: "Does", matching: "match", value: "" };
      this.popup_config.uri_filters.push(plainItem)
    }
  },

  mounted: function () {
    this.$http.get(window.location + "api/internal/v1/popup_config")
             .then(response => {
               var popup_config = response.body.shop.popup_config;
               this.service_fields = popup_config.service_fields;
               delete popup_config.service_fields;
               this.popup_config = popup_config;
             }, error => {
               console.log(error.body)
             });
  }
}
</script>

<style lang="scss" scoped>
  .container {
    max-width: 1024px;
    &:first-child {
      margin-top: 100px;
    }
  }

  .description{
    padding: 20px 20px 20px 4px;
  }

  .card-last-child-padd:last-child {
    padding-bottom: 4px;
  }

  .preview-btn {
    top: 8px;
  }

  h6 { font-size: 20px !important; }

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
      overflow: auto;

      & > table {
        min-width: 400px;
      }
    }
  }

  .flex-row {
    flex: 0 1 100%;
  }

  .lg-preview {
    height: 56px;
    width: 266px;
    background: rgba(0, 0, 0, 0.15);
  }

  .sm-preview {
    height: 56px;
    width: 56px;
    background: rgba(0, 0, 0, 0.15);
  }

  .triggers-after-switch-width {
    max-width: 90px !important;
    min-width: 90px !important;
  }
</style>
