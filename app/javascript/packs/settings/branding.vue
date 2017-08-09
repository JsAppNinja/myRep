<template>
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
</template>

<script>
  export default {
    props: ['branding']
  }
</script>

<style scoped>
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
</style>
