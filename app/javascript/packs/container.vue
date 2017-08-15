<template>
  <div id="slotMachineContainer">
    <div id="ReelContainer">
      <div id="reel1" class="reel" ref="reel1"></div>
      <div id="reel2" class="reel" ref="reel2"></div>
      <div id="reel3" class="reel" ref="reel3"></div>
      <div id="reelOverlay"></div>
    </div>

    <div id="loggedOutMessage" style="display: none;"><span class="large">Sorry, you have been logged off.</span><br />
      <b>No bids</b> have been deducted from this spin, because you're not logged in anymore.
      Please <a href="/login">login</a> and try again.
    </div>

    <div id="failedRequestMessage" style="display: none;"><span class="large">Sorry, we're unable to display your spin because your connection to our server was lost. </span><br />
      Rest assured that your spin was not wasted.
      Please check your connection and <a href="#" onclick="window.location.reload();">refresh</a> to try again.
    </div>

    <div id="customError" style="display: none;"></div>

    <div id="betContainer">
      <span id="lastWin"></span>
      <span id="credits">         {{ credits }}</span>
      <span id="bet">             {{ current_bet }}</span>
      <span id="dayWinnings">     {{ day_winnings }}</span>
      <span id="lifetimeWinnings">{{ lifetime_winnings }}</span>
      <div  id="betSpinUp" @click="changeBetValue(1)"></div>
      <div  id="betSpinDown" @click="changeBetValue(-1)"></div>
    </div>

    <div id="spinButton" @click="spin()" v-bind:class="{ disabled: slot_machine.spinning }"></div>
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
          bounce_height: 200,
          bounce_time: 1000
        }
      }
    },

    methods: {
      changeBetValue: function(delta) {
        if (this.current_bet + delta >= minBet && this.current_bet + delta <= this.credits ) {
          this.current_bet += delta
        }
      },

      spin: function() {
        var slot_machine = this.slot_machine;
        var self = this;

        if (slot_machine.spinning) { return false; }

        slot_machine.spinning = true;
        // slot_machine.show_won_state(true);

        this.credits -= this.current_bet;

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
          window.setTimeout(function(){ self.stopReelSpin(1, spinData.reels[0]); }, baseTimeout);
          baseTimeout += slot_machine.second_reel_stop_time;
          window.setTimeout(function(){ self.stopReelSpin(2, spinData.reels[1]); }, baseTimeout);
          baseTimeout += slot_machine.third_reel_stop_time;
          window.setTimeout(function(){ self.stopReelSpin(3, spinData.reels[2]); }, baseTimeout);

          baseTimeout += slot_machine.payout_stop_time; // This must be related to the timing of the final animation. Make it a bit less, so the last reel is still bouncing when it lights up
          window.setTimeout(function(){ self.endSpin(spinData); }, baseTimeout);
        }

        var FirstReelTimeoutHit = false;
        var spinData = null;

        window.setTimeout(function(){ FirstReelTimeoutHit = true; if (spinData != null) { fnStopReelsAndEndSpin(); } }, slot_machine.first_reel_stop_time);

        // TODO: rewrite ajax requests with vue-resource

        spinData = {
          reels: [1, 2, 3],
          prize: { id: 2, payout_credits: 0, payout_winnings: 100 }
        }
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
          document.querySelector('#lastWin').html("");
        }
      },

      endSpin: function(data) {
        if (data.prize != null) {
          this.showWonState(true, data.prize.id, data.prize.winType);
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
        console.log(finalPosition);

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
