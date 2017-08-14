<template>
  <div id="slotMachineContainer">
    <div id="ReelContainer">
      <div id="reel1" class="reel"></div>
      <div id="reel2" class="reel"></div>
      <div id="reel3" class="reel"></div>
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
      <span id="bet">             {{ min_bet }}</span>
      <span id="dayWinnings">     {{ day_winnings }}</span>
      <span id="lifetimeWinnings">{{ lifetime_winnings }}</span>
      <div  id="betSpinUp"></div>
      <div  id="betSpinDown"></div>
    </div>

    <div id="spinButton"></div>
  </div>
</template>


<script>
  export default {
    data: function() {
      return {
        credits: 10,
        min_bet: 1,
        day_winnings: 0,
        lifetime_winnings: 500
      }
    },

    mounted: function () {
      console.log("hahahahahahah hello from vue!!!")
    }
  }
</script>
