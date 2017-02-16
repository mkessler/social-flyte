(function() {
  this.App || (this.App = {});

  App.facebook = {
    init: function(id) {
      FB.init({
        appId: id,
        status: false,
        cookie: true,
        xfbml: true
      });
    },
    loadSDK: function() {
      (function(d){
        var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement('script'); js.id = id; js.async = true;
        js.src = "//connect.facebook.net/en_US/all.js";
        ref.parentNode.insertBefore(js, ref);
      }(document));
    },
    login: function(args) {
      FB.login(function(response) {
        if (response.authResponse) {
          App.facebook.setToken(response);
          App.facebook.userLoggedIn();
        } else {
          alert('Authentication cancelled. Please try again.');
        }
      });
    },
    setToken: function(response) {
      App.networkTokens.set({
        network: 'facebook',
        token: response.authResponse.accessToken,
        expires_at: response.authResponse.expiresIn
      });
    },
    status: function() {
      FB.getLoginStatus(function(response) {
        if (response.status === 'connected') {
          var uid = response.authResponse.userID;
          var accessToken = response.authResponse.accessToken;
          App.facebook.setToken(response);
          $('#connected-facebook span').html('Status: Connected <i class="fa fa-check-circle-o fa-lg fa-fw green-text"></i>');
          $('#new_post button, #post-sync-trigger').removeAttr('disabled');
        } else if (response.status === 'not_authorized') {
          // the user is logged in to Facebook,
          // but has not authenticated your app
          App.facebook.userLoggedOut(response.status);
        } else {
          // the user isn't logged in to Facebook.
          App.facebook.userLoggedOut();
        }
      });
      $('body').on('click', '.facebook-login', function(){
        App.facebook.login();
      });
    },
    userLoggedIn: function() {
      if ($('#connected-facebook span').length) {
        $('.facebook-login').remove();
        $('#connected-facebook span').html('Status: Connected <i class="fa fa-check-circle-o fa-lg fa-fw green-text"></i>');
      }
      if ($('#new_post').length) {
        $('#new_post').submit();
      }
      if ($('#last-sync').length) {
        App.posts.sync();
      }
    },
    userLoggedOut: function(status) {
      if (status === 'not_authorized') {
        $('#connected-facebook span').html('Status: Not Connected <button type="button" class="btn light-blue btn-sm waves-effect waves-light facebook-login">Connect</button>');
      } else {
        $('#connected-facebook span').html('Status: Logged Out <button type="button" class="btn light-blue btn-sm waves-effect waves-light facebook-login">Log In</button>');
      }
      $('#new_post button[type="submit"]').replaceWith('<button type="button" class="btn green accent-4 facebook-login waves-effect waves-light"><i class="fa fa-check-circle-o left" aria-hidden="true"></i> Submit</button>');
      $('#post-sync-trigger').replaceWith('<button type="button" class="btn green accent-4 facebook-login waves-effect waves-light"><i class="fa fa-refresh left" aria-hidden="true"></i> Sync Now</button>');
    }
  };

}).call(this);