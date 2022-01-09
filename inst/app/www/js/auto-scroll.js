$('#console').ready(function(){
  window.setInterval(function() {
  var elem = document.getElementById('console');
  elem.scrollTop = elem.scrollHeight;
}, 5000);
})
