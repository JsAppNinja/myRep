<template>
  <v-container>
    <v-layout row-sm column child-flex-sm>
      <v-flex sm5 offset-sm1 plan-container>
        <v-card class="basic-plan">
          <v-card-media height="180px">
            <v-container fill-height fluid>
              <v-layout fill-height column space-between justify-space-between>
                <p class="ma-0 headline text-xs-center primary--text">Basic</p>
                <p class="ma-0 headline text-xs-center">$14.92/month</p>
                <p class="ma-0 text-xs-center">Basic includes all of these great features:</p>
              </v-layout>
            </v-container>
          </v-card-media>

          <div>
            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4">Gamification</p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4">Advanced triggers</p>
                <ul class="mb-0">
                  <li>Desktop exit intent</li>
                  <li>Mobile exit intent</li>
                  <li>Time on site trigger</li>
                  <li>Pullout tab</li>
                </ul>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4">Email integration (MailChimp, Klaviyo, Aweber)</p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Text and colour customisation </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Fully responsive </p>
              </v-flex>
            </v-card-title>
            <v-divider> </v-divider>
            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> URL specific placement or site-wide </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Basic Analytics </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Cookie duration settings </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Coupon code bar and countdown timer </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="not-included">close</v-icon>
                <p class="mb-0 mr-4">Segmentation of emails</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="not-included">close</v-icon>
                <p class="mb-0 mr-4">Multiple campaigns</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="not-included">close</v-icon>
                <p class="mb-0 mr-4">Advanced analytics</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="not-included">close</v-icon>
                <p class="mb-0 mr-4">Email validation</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="not-included">close</v-icon>
                <p class="mb-0 mr-4">Custom fields</p>
              </v-flex>
            </v-card-title>
          </div>

          <v-btn primary flat block large class="mt-2 mb-0">order now</v-btn>

        </v-card>
      </v-flex>


      <!-- ================================================= -->


      <v-flex sm5 plan-container>
        <v-card class="pro-plan">
          <v-card-media height="180px">
            <v-container fill-height fluid>
              <v-layout fill-height column space-between justify-space-between>
                <p class="ma-0 headline text-xs-center primary--text">PRO</p>
                <p class="ma-0 headline text-xs-center">$54.92/month</p>
                <p class="ma-0 text-xs-center">Pro version includes additional advanced and powerful features:</p>
              </v-layout>
            </v-container>
          </v-card-media>

          <div>
            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4">Gamification</p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4">Advanced triggers</p>
                <ul class="mb-0">
                  <li>Desktop exit intent</li>
                  <li>Mobile exit intent</li>
                  <li>Time on site trigger</li>
                  <li>Pullout tab</li>
                </ul>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4">Email integration (MailChimp, Klaviyo, Aweber)</p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Text and colour customisation </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Fully responsive </p>
              </v-flex>
            </v-card-title>
            <v-divider> </v-divider>
            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> URL specific placement or site-wide </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Basic Analytics </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Cookie duration settings </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="included">check</v-icon>
                <p class="mb-0 mr-4"> Coupon code bar and countdown timer </p>
              </v-flex>
            </v-card-title>

            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="additional">check</v-icon>
                <p class="mb-0 mr-4">Segmentation of emails</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="additional">check</v-icon>
                <p class="mb-0 mr-4">Multiple campaigns</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="additional">check</v-icon>
                <p class="mb-0 mr-4">Advanced analytics</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="additional">check</v-icon>
                <p class="mb-0 mr-4">Email validation</p>
              </v-flex>
            </v-card-title>
            <v-divider></v-divider>

            <v-card-title>
              <v-flex>
                <v-icon class="additional">check</v-icon>
                <p class="mb-0 mr-4">Custom fields</p>
              </v-flex>
            </v-card-title>
          </div>

          <v-btn success flat block large class="mt-2 mb-0">order now</v-btn>

        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<style lang="scss" scoped>

  .card {
    transition-duration: .3s;
  }

  /* from elevation-10 vuetify class */
  .card:hover {
    webkit-box-shadow: 0 6px 6px -3px rgba(0,0,0,.2),0 10px 14px 1px rgba(0,0,0,.14),0 4px 18px 3px rgba(0,0,0,.12)!important;
    box-shadow: 0 6px 6px -3px rgba(0,0,0,.2),0 10px 14px 1px rgba(0,0,0,.14),0 4px 18px 3px rgba(0,0,0,.12)!important;
  }

  .card__title {
    padding: 10px 20px;
  }

  .sm5 {
    padding: 0 20px;
  }

  .plan-container:not(:last-child) {
    margin-bottom: 50px;
  }

  .basic-plan {
    border: 1px solid rgba(25, 118, 210, 0.80);

    .column > p:last-child {
      margin-bottom: 1.5em !important;
    }

    i.not-included {
      color: #B71C1C;
    }
  }

  .pro-plan {
    border: 1px solid rgba(0, 183, 48, 0.8);

    .primary--text {
      color: #00b730 !important;
    }

    i.additional {
      color: #00b730
    }
  }

  i {
    position:   absolute;
    right:      20px;
    margin-top: -3px;
  }

  i.included {
    color: #1976d2;
  }

  .btn--block {
    border-radius: 0;
  }

  .btn--large {
    font-size: 16px;
    height: 60px;
  }
</style>
