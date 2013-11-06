# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


console.log("shoutroulette://ShoutRoulette.com" +"<%= @path %>");
// window.location = "shoutroulette://ShoutRoulette.com" + "<%= @path %>";
$("#itunes-download-button").click(function() {
  window.location ="itms-apps://itunes.apple.com/artist/appmosys/id331687329"
});
var now = new Date().valueOf();
setTimeout(function () {
    if (new Date().valueOf() - now > 3000) return;
    //ios 7
    //window.location =  "itms-apps://itunes.apple.com/app/id353372460"
	
    //"https://itunes.apple.com/us/app/sleep-cycle-alarm-clock/id320606217?mt=8&v0=WWW-NAUS-ITSTOP100-PAIDAPPS&ign-mpt=uo%3D4";
    
}, 2000);
window.location = "shoutroulette://ShoutRoulette.com" + "<%= @path %>";