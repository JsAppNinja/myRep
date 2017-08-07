/*
*= require frontend/jquery-1.7.1.min
*= require frontend/jquery-ui-1.8.17.custom.min
*= require frontend/slots
*/

$(function() {
  $('.toggle-nav').click(function() {
    // Calling a function in case you want to expand upon this.
    toggleNav();
  });
});

/*========================================
=            CUSTOM FUNCTIONS            =
========================================*/
function toggleNav() {
  if ($('#site-wrapper').hasClass('show-nav')) {
    // Do things on Nav Close
    $('#site-wrapper').removeClass('show-nav');
  } else {
    // Do things on Nav Open
    $('#site-wrapper').addClass('show-nav');
  }
}