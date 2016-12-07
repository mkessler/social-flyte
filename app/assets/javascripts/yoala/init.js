$(document).ready(function(){
  //Bootstrap
  Yoala.bootstrap.utility.init();

  // Facebook
  window.fbAsyncInit = function() {
    Yoala.authentication.facebook.init();
  }
  Yoala.authentication.facebook.loadSDK();
});
