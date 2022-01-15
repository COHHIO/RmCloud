$('#body-console').ready(function(){

var add = setInterval(function() {
  var out = document.getElementById('body-console')
    // allow 1px inaccuracy by adding 1
    var isScrolledToBottom = out.scrollHeight - out.clientHeight >= out.scrollTop;
    console.log(out.scrollHeight - out.clientHeight,  out.scrollTop);

    // scroll to bottom if isScrolledToBotto
    if(isScrolledToBottom)
      out.scrollTop = out.scrollHeight - out.clientHeight;
}, 1000);
})

$('#body-run').ready(function(){
  $('#body-run').click(function() {$('#controls button[data-card-widget="collapse"]').trigger('click')})
})
