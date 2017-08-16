<template>
  <div>
    <div id="slotMachineContainer">
      <div id="ReelContainer">
        <div id="reel1" class="reel" ref="reel1"></div>
        <div id="reel2" class="reel" ref="reel2"></div>
        <div id="reel3" class="reel" ref="reel3"></div>
        <div id="reelOverlay"></div>
      </div>

      <div id="customError" :class="{ display_none: !slot_machine.error_statement }">
        <p v-for="error_message in error_messages">
          {{ error_message }}
        </p>
      </div>

      <div id="betContainer">
        <span id="lastWin"></span>
        <span id="credits">         {{ credits }}</span>
        <span id="bet">             {{ current_bet }}</span>
        <span id="dayWinnings">     {{ day_winnings }}</span>
        <span id="lifetimeWinnings">{{ lifetime_winnings }}</span>
        <div  id="betSpinUp" @click="changeBetValue(1)"></div>
        <div  id="betSpinDown" @click="changeBetValue(-1)"></div>
      </div>

      <div id="spinButton" @click="spin()" :class="{ disabled: !isSpinAllowed }"></div>
    </div>

    <div class="email-container">
      <input type="email" v-model="email.field" placeholder="email">
    </div>
  </div>
</template>


<script>
  export default {
    data: function() {
      return {
        credits: 10,
        min_bet: 1,
        day_winnings: 0,
        lifetime_winnings: 500,
        current_bet: 1,
        slot_machine: {
          spinning: false,
          error_statement: false,
          strip_height: 720,    // Update this to match the strip PNG
          alignment_offset: 86, // Play around with this until reels are properly aligned post-spin

          first_reel_stop_time: 667,
          second_reel_stop_time: 575, // since first reel's stop time, not since animation beginning
          third_reel_stop_time: 568,  // since second reel's stop time, not since animation beginning
          payout_stop_time: 700,     // since last reel's stop time, not since animation beginning

          reel_speed_difference: 0, // speed difference between the 3 reels
          reel_speed_1_delta: 100,   // "Fast speed"
          reel_speed_1_time: 0,      // How long does fast speed lasts.
          reel_speed_2_delta: 100,   // Slow speed

          positioning_rate: 1.1,   // smoothness of reels slowing down animation (should be > 1)
          bounce_height: 200
        },

        spin_data: {},

        error_messages: null,
        email: {
          invalid_emails: [],
          field: "",
          EMAIL_REGEXP: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        }
      }
    },

    computed: {
      isSpinAllowed: function() {
        return !this.slot_machine.spinning
               && this.email.EMAIL_REGEXP.test(this.email.field)
               && this.email.invalid_emails.indexOf(this.email.field) == -1;
      }
    },

    methods: {
      changeBetValue: function(delta) {
        if (this.current_bet + delta >= minBet && this.current_bet + delta <= this.credits ) {
          this.current_bet += delta;
          this.showWonState(false)
        }
      },

      spin: function() {
        if (this.isSpinAllowed == false) { return; }

        var slot_machine = this.slot_machine;
        var self = this;

        if (slot_machine.spinning) { return false; }

        slot_machine.error_statement = false;
        slot_machine.spinning = true;
        this.credits -= this.current_bet;

        this.$http
            .post(
              '/api/v1/popup_submits',
              // window.params() initialized in slot_machine.html.erb
              { popup_submit: Object.assign(window.params(), { email: this.email.field }) }
            )
            .then(
              resp => {


                this.spin_data = JSON.parse(resp.bodyText);

                self.startReelSpin(1, 0);
                self.startReelSpin(2, slot_machine.second_reel_stop_time);
                self.startReelSpin(3, slot_machine.second_reel_stop_time + slot_machine.third_reel_stop_time);

                // NOTE: Here was sounds

                // We need to make the reels end spinning at a certain time, synched with the audio, independently of how long the AJAX request takes.
                // Also, we can't stop until the AJAX request comes back. So we must have a timeout for the first reel stop, and a function that makes
                //   the magic happen, and whatever happens last (this timeout, or the AJAX response) calls this function.
                // The sound timings are at: 917ms, 1492ms and 2060ms, which needs to be adjusted by the animation timings
                //   (which is why i'm setting the first one at 250ms before 917ms)

                var fnStopReelsAndEndSpin = function() {
                  // Make the reels stop spinning one by one
                  var baseTimeout = 0;
                  window.setTimeout(function(){ self.stopReelSpin(1, self.spin_data.reels[0]); }, baseTimeout);
                  baseTimeout += slot_machine.second_reel_stop_time;
                  window.setTimeout(function(){ self.stopReelSpin(2, self.spin_data.reels[1]); }, baseTimeout);
                  baseTimeout += slot_machine.third_reel_stop_time;
                  window.setTimeout(function(){ self.stopReelSpin(3, self.spin_data.reels[2]); }, baseTimeout);

                  baseTimeout += slot_machine.payout_stop_time; // This must be related to the timing of the final animation. Make it a bit less, so the last reel is still bouncing when it lights up
                  window.setTimeout(function(){ self.endSpin(self.spin_data); }, baseTimeout);
                };

                window.setTimeout(function(){
                  fnStopReelsAndEndSpin();
                }, slot_machine.first_reel_stop_time);


              },
              err  => {
                if (err.status == 422) {
                  this.error_messages = JSON.parse(err.bodyText);
                  this.email.invalid_emails.push(this.email.field); // since server-side validation wasn't success, we don't want this email to be sent again
                }
                else {
                  // TODO: we need to delete cookies in this case so that user will be able to try again later,
                  //       and maybe restore credits and process 401 error in different way
                  this.error_messages = ["Sorry, there was a problem on our side :("]
                }

                this.slot_machine.error_statement = true;
                this.endSpin();
              }
            );
      },

      showWonState: function(bWon, prize_id, win_type) {
        // TODO: looks pretty messy, should be rewritten
        if (bWon) {
          if (win_type) {
            document.querySelector('#PageContainer, #SlotsOuterContainer').classList.add(win_type);
          } else {
            document.querySelector('#PageContainer, #SlotsOuterContainer').classList.add("won");
          }
          document.querySelector('#trPrize_' + prize_id).classList.add("won");
        } else {
          document.querySelector('.trPrize').classList.remove("won");
          document.querySelector('#PageContainer, #SlotsOuterContainer').className = ""; // remove all classes
          document.querySelector('#lastWin').innerHTML("");
        }
      },

      endSpin: function() {
        if (this.spin_data.prize !== undefined) {
          this.showWonState(true, this.spin_data.prize.id, this.spin_data.prize.winType);
        }

        this.slot_machine.spinning = false
      },


      // Animation controllers


      startReelSpin: function(i, timeOffset) {
        var slot_machine = this.slot_machine;
        var startTime = Date.now();
        var elReel = this.$refs["reel" + i];
        elReel.style.top = -(Math.random() * slot_machine.strip_height * 2); // Change the initial position so that, if a screenshot is taken mid-spin, reels are mis-aligned
        var curPos = parseInt(elReel.style.top, 10);

        var fnAnimation = function(){
          elReel.style.top = curPos;

          if (Date.now() < startTime + slot_machine.reel_speed_1_time + timeOffset) {
            curPos += slot_machine.reel_speed_1_delta;
          } else {
            curPos += slot_machine.reel_speed_2_delta;
          }
          curPos += i * slot_machine.reel_speed_difference;
          if (curPos > 0) {curPos = -slot_machine.strip_height * 2;}
        };

        var timerID = window.setInterval(fnAnimation, 20);
        elReel.dataset.spinTimer = timerID;
      },

      stopReelSpin: function(i, outcome) {
        var slot_machine = this.slot_machine;
        var elReel = this.$refs["reel" + i]; // cache for performance
        var timerID = elReel.dataset.spinTimer;
        window.clearInterval(timerID);
        elReel.dataset.spinTimer = null;


        if (outcome != null) {
          // the whole strip repeats thrice, so we don't have to care about looping
          // alignment_offset is kind of empirical...
          var distanceBetweenIcons = slot_machine.strip_height / window.numIconsPerReel;
          var finalPosition = -slot_machine.strip_height - ((outcome - 1) * distanceBetweenIcons) + slot_machine.alignment_offset;

          this._stopReelSpinAnimation(elReel, finalPosition);
        }
      },

      _stopReelSpinAnimation: function(elReel, finalPosition) {
        var slot_machine = this.slot_machine;

        elReel.style.top = finalPosition - slot_machine.strip_height;
        var delta = slot_machine.bounce_height;

        elReel.style.top = finalPosition + delta;

        var linearStop = function () {
          if (delta < 1) {
            clearInterval(linearIntervalId);
            elReel.style.top = finalPosition;
          }

          delta = (delta / slot_machine.positioning_rate);
          elReel.style.top = finalPosition + delta
        };

        var linearIntervalId = setInterval(linearStop, 10)
      }
    }
  }
</script>

<style>
  .display_none {
    display: none;
  }

  #customError {
    height   : 88px;
    overflow : auto;
  }

  .email-container {
    position : absolute;
    height   : 85px;
    bottom   : 0;
  }

  .email-container > input {
    margin-top  : 20px;
    margin-left : 280px;
    width       : 470px;
  }
</style>
