
var slotMachine = {
	// Set the proper height for the reels in the CSS file, rule: #slotMachineContainer #ReelContainer .reel
	// Set it to 3 * stripHeight
	// Also set the top property to the initial position you want to show
	stripHeight: 720, // Update this to match the strip PNG
	alignmentOffset: 86, // Play around with this until reels are properly aligned post-spin

	firstReelStopTime: 667,
	secondReelStopTime: 575, // since first reel's stop time, not since animation beginning
	thirdReelStopTime: 568, // since second reel's stop time, not since animation beginning
	payoutStopTime: 700, // since last reel's stop time, not since animation beginning

	reelSpeedDifference: 0, // speed difference between the 3 reels
	reelSpeed1Delta: 100, // "Fast speed"
	reelSpeed1Time: 0, // How long does fast speed lasts.
	reelSpeed2Delta: 100, // Slow speed

	positioningTime: 200,
	bounceHeight: 200,
	bounceTime: 1000,

	winningsFormatPrefix: '',  // If winnings are "money", set prefix to be '$', '£', etc. If everything is unit-less, leave as is.

	spinURL: '/slots/spin.php', // point to the server component to call to get spin results.

	curBet: minBet,
	soundEnabled: true,
	sounds: {},

	spinning: false,

	init: function() {
		$('#betSpinUp').click(function() { slotMachine.change_bet(+1); });
		$('#betSpinDown').click(function() { slotMachine.change_bet(-1); });
		$('#spinButton').click(function() { slotMachine.spin(); });

		$('#soundOffButton').click(function() { slotMachine.toggle_sound(); });

		if (false && slotMachine.soundEnabled)  {
			soundManager.setup({
				url: "/js/",
				onready: function() {
					slotMachine.sounds['payout'] = soundManager.createSound({id: "payout", url: 'sounds/payout.mp3'});
					slotMachine.sounds['fastpayout'] = soundManager.createSound({id: "fastpayout", url: 'sounds/fastpayout.mp3'});
					slotMachine.sounds['spinning'] = soundManager.createSound({id: "spinning", url: 'sounds/spinning.mp3'});
				}
			});
		}

		if (slotMachine.get_balance() < minBet) {
			slotMachine.disable_spin_button();
		}
	},

	//----------------------------------------------------

	get_balance: function() {
		return parseInt($('#credits').html(), 10);
	},

	change_bet: function(delta) {
		if (slotMachine.spinning) { return; } // don't do anything while spinning.

		slotMachine.curBet += delta;
		slotMachine.curBet = Math.min(slotMachine.curBet, maxBet);
		slotMachine.curBet = Math.min(slotMachine.curBet, slotMachine.get_balance()); // Don't allow higher bet than current balance
		slotMachine.curBet = Math.max(minBet, slotMachine.curBet); // But don't allow = 0 either

		slotMachine.show_won_state(true); // Remove won state, so that they can't easily fake a screenshot to say "I bet 2 and got paid off only as 1"

		$('#bet').html(slotMachine.curBet);

		$('#prizes_list .tdPayout').each(function() {
			var $this = $(this);
			$this.html(
				($this.attr("data-payoutPrefix") || "") + parseInt($this.attr("data-basePayout"), 10) * slotMachine.curBet + ($this.attr("data-payoutSuffix") || "")
			);
		});

		if (slotMachine.get_balance() >= slotMachine.curBet) {
			slotMachine.enable_spin_button();
		}
	},

	toggle_sound: function() {
		if ($('#soundOffButton').hasClass("off")) {
			// soundManager.unmute();
		} else {
			// soundManager.mute();
		}
		$('#soundOffButton').toggleClass("off");
	},

	enable_spin_button: function() {
		$('#spinButton').removeClass("disabled");
	},

	disable_spin_button: function() {
		$('#spinButton').addClass("disabled");
	},

	//----------------------------------------------------

	spin: function() {
		// Validate that we can spin
		if ($('#spinButton').hasClass("disabled")) { return false; }
		if (slotMachine.spinning) { return false; }

		// Clean up the UI
		slotMachine.spinning = true;
		slotMachine.show_won_state(true);
		slotMachine.disable_spin_button();

		// Deduct the bet from the number of credits
		$('#credits').html(slotMachine.get_balance() - slotMachine.curBet);

		// Make the reels spin
		slotMachine._start_reel_spin(1, 0);
		slotMachine._start_reel_spin(2, slotMachine.secondReelStopTime);
		slotMachine._start_reel_spin(3, slotMachine.secondReelStopTime + slotMachine.thirdReelStopTime);

		try {
			slotMachine.sounds['spinning'].play();
		} catch(err) {}

		// We need to make the reels end spinning at a certain time, synched with the audio, independently of how long the AJAX request takes.
		// Also, we can't stop until the AJAX request comes back. So we must have a timeout for the first reel stop, and a function that makes
		//   the magic happen, and whatever happens last (this timeout, or the AJAX response) calls this function.
		// The sound timings are at: 917ms, 1492ms and 2060ms, which needs to be adjusted by the animation timings
		//   (which is why i'm setting the first one at 250ms before 917ms)

		var fnStopReelsAndEndSpin = function() {
				// Make the reels stop spinning one by one
				var baseTimeout = 0;
				window.setTimeout(function(){ slotMachine._stop_reel_spin(1, spinData.reels[0]); }, baseTimeout);
				baseTimeout += slotMachine.secondReelStopTime;
				window.setTimeout(function(){ slotMachine._stop_reel_spin(2, spinData.reels[1]); }, baseTimeout);
				baseTimeout += slotMachine.thirdReelStopTime;
				window.setTimeout(function(){ slotMachine._stop_reel_spin(3, spinData.reels[2]); }, baseTimeout);

				baseTimeout += slotMachine.payoutStopTime; // This must be related to the timing of the final animation. Make it a bit less, so the last reel is still bouncing when it lights up
				window.setTimeout(function(){ slotMachine.end_spin(spinData); }, baseTimeout);
		}

		var FirstReelTimeoutHit = false;
		var spinData = null;
		window.setTimeout(function(){ FirstReelTimeoutHit = true; if (spinData != null) { fnStopReelsAndEndSpin(); } }, slotMachine.firstReelStopTime);

		$.ajax({
			url: slotMachine.spinURL,
			type: "POST",
			data: { bet : slotMachine.curBet, windowID: windowID, machine_name: machineName},
			dataType: "json",
			timeout: 10000,
			success: function(data){
				if (!data.success) {
					slotMachine.abort_spin_abruptly();
					if (data.error == "loggedOut") {
						$('#loggedOutMessage').show();
					} else {
						alert(data.error);
					}
					return false;
				}
				spinData = data;
				if (FirstReelTimeoutHit == true) { fnStopReelsAndEndSpin(); }
			},
			error: function() {
				slotMachine.abort_spin_abruptly();
				$('#failedRequestMessage').show();
			}
		});

	},

	show_won_state: function(bWon, prize_id, win_type) {
		if (bWon) {
			if (win_type) {
				$('#PageContainer, #SlotsOuterContainer').addClass(win_type);
			} else {
				$('#PageContainer, #SlotsOuterContainer').addClass("won");
			}
			$('#trPrize_' + prize_id).addClass("won");
		} else {
			$('.trPrize').removeClass("won");
			$('#PageContainer, #SlotsOuterContainer').removeClass(); // remove all classes
			$('#lastWin').html("");
		}
	},

	end_spin: function(data) {
		if (data.prize != null) {
			slotMachine.show_won_state(true, data.prize.id, data.prize.winType);
			slotMachine._increment_payout_counter(data); // _increment_payout_counter will call end_spin_after_payout, which is where this list of things to do at the end really ends
		} else {
			slotMachine._end_spin_after_payout(data);
		}
	},

	_format_winnings_number: function(winnings) {
		if (winnings == Math.floor(winnings)) {
			return winnings;
		} else {
			return winnings.toFixed(2);
		}
	},

	// These are the things that need to be done after the payout counter stops increasing, if there is a payout
	_end_spin_after_payout: function(data) {
		// This is technically redundant, since the payout incrementer updated them, and we decreased it when spinning,
		//   but just in case something got off sync
		if (typeof data.credits != "undefined") { $('#credits').html(data.credits); }
		if (typeof data.dayWinnings != "undefined") { $('#dayWinnings').html(slotMachine.winningsFormatPrefix + slotMachine._format_winnings_number(data.dayWinnings)); }
		if (typeof data.lifetimeWinnings != "undefined") { $('#lifetimeWinnings').html(slotMachine.winningsFormatPrefix + slotMachine._format_winnings_number(data.lifetimeWinnings)); }
		if (typeof data.lastWin != "undefined") { $('#lastWin').html(data.lastWin); }

		slotMachine.spinning = false;

		if (slotMachine.get_balance() >= slotMachine.curBet) {
			slotMachine.enable_spin_button();
		}
	},

	_increment_payout_counter: function(data) {
		var currentValues = {
			credits: data.credits - data.prize.payoutCredits,
			dayWinnings: data.dayWinnings - data.prize.payoutWinnings,
			lifetimeWinnings: data.lifetimeWinnings - data.prize.payoutWinnings,
		}
		var maxDelta = Math.max(data.credits - currentValues.credits, data.dayWinnings - currentValues.dayWinnings);
		var soundName = (maxDelta > 80 ? 'fastpayout' : 'payout' );
		var tickDelay = (maxDelta > 80 ? 50 : 200 );

		try {
			slotMachine.sounds[soundName].play({ onfinish: function(){ this.play(); }});
		} catch(err) {}

		var timerID = window.setInterval(function() {
			var valueChanged = false;
			$.each(['credits', 'dayWinnings', 'lifetimeWinnings'], function(i, component){
				if (currentValues[component] < data[component]) {
					currentValues[component] += 1;
					currentValues[component] = Math.min(currentValues[component], data[component]); // make sure we don't go over, useful for decimals.

					if (component != "credits") {
						$('#' + component).html(slotMachine.winningsFormatPrefix + slotMachine._format_winnings_number(currentValues[component]));
					} else {
						$('#' + component).html(currentValues[component]);
					}
					valueChanged = true;
				}
			});

			if (!valueChanged) {
				window.clearInterval(timerID);

				try {
					slotMachine.sounds[soundName].stop();
				} catch(err) {}

				slotMachine._end_spin_after_payout(data);
			}
		}, tickDelay);
	},

	abort_spin_abruptly: function() {
		slotMachine._stop_reel_spin(1, null);
		slotMachine._stop_reel_spin(2, null);
		slotMachine._stop_reel_spin(3, null);
		try {
			slotMachine.sounds['spinning'].stop();
		} catch(err) {}
	},

	// -----------------------------------

	// timeOffset is how much time later than the previous reel we expect this reel to stop spinning.
	_start_reel_spin: function(i, timeOffset) {
		var startTime = Date.now();
		var elReel = $('#reel' + i); // cache for performance
		elReel.css({top: -(Math.random() * slotMachine.stripHeight * 2) }); // Change the initial position so that, if a screenshot is taken mid-spin, reels are mis-aligned
		var curPos = parseInt(elReel.css("top"), 10);

		var fnAnimation = function(){
			elReel.css({top: curPos});

			if (Date.now() < startTime + slotMachine.reelSpeed1Time + timeOffset) {
				curPos += slotMachine.reelSpeed1Delta;
			} else {
				curPos += slotMachine.reelSpeed2Delta;
			}
			curPos += i * slotMachine.reelSpeedDifference;
			if (curPos > 0) {curPos = -slotMachine.stripHeight * 2;}
		};
		var timerID = window.setInterval(fnAnimation, 20);
		elReel.data("spinTimer", timerID);
	},
	_stop_reel_spin: function(i, outcome) {
		var elReel = $('#reel' + i); // cache for performance
		var timerID = elReel.data("spinTimer");
		window.clearInterval(timerID);
		elReel.data("spinTimer", null);


		if (outcome != null) {
			// the whole strip repeats thrice, so we don't have to care about looping
			// alignmentOffset is kind of empirical...
			var distanceBetweenIcons = slotMachine.stripHeight / window.numIconsPerReel;
			var finalPosition = -slotMachine.stripHeight -((outcome - 1) * distanceBetweenIcons) + slotMachine.alignmentOffset;


			// Animation two: Elastic Easing
			elReel.css({ top: finalPosition - slotMachine.stripHeight })
				.animate({ top: finalPosition + slotMachine.bounceHeight}, slotMachine.positioningTime, 'linear', function() {
					elReel.animate({top: finalPosition}, slotMachine.bounceTime, 'easeOutElastic');
				});
		}
	}
};

slotMachine.init();
