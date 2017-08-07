(function(){
  console.log('loaded.');


  var container = document.createElement("div");
  container.id = "slot-machine";
  container.height = window.innerHeight;
  container.width = 800;

  var iframe = document.createElement("iframe")
  iframe.height = window.innerHeight;
  iframe.width = 800;
  iframe.src = 'https://localhost/frontend';

  container.append(iframe)

  var style = document.createElement("link", {type: 'text/css'});
  style.rel = 'stylesheet';
  style.href = 'https://localhost/src/embedded.css';
  document.body.appendChild(style);
  document.body.appendChild(container);

}).call(this);

function toggleNav() {
  if ($('#slot-machine').hasClass('show')) {
    // Do things on Nav Close
    $('#slot-machine').removeClass('show');
  } else {
    // Do things on Nav Open
    $('#slot-machine').addClass('show');
  }
}