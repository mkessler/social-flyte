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
        } else {
          alert('Authentication cancelled. Please try again.');
        }
      });
    },
    setToken: function(response) {
      $.ajax({
        url: '/facebook_tokens/create_or_update',
        type: 'POST',
        data: {
          facebook_token: {
            network_user_id: response.authResponse.userID,
            token: response.authResponse.accessToken
          }
        },
        dataType: 'json',
        success: function(data){
          console.log(data);
          $('#new_post button, #post-sync-trigger').removeAttr('disabled');
        }
      });
    },
    status: function() {
      FB.getLoginStatus(function(response) {
        if (response.status === 'connected') {
          App.facebook.setToken(response);
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
    userLoggedOut: function(status) {
      if (status === 'not_authorized') {
        $('#connected-facebook span').html('Status: Not Connected <button type="button" class="btn light-blue btn-sm waves-effect waves-light facebook-login">Connect</button>');
      } else {
        $('#connected-facebook span').html('Status: Logged Out <button type="button" class="btn light-blue btn-sm waves-effect waves-light facebook-login">Log In</button>');
      }
      $('#new_post button[type="submit"]').replaceWith('<button type="button" class="btn default-color facebook-login waves-effect waves-light"><i class="fa fa-check-circle-o left" aria-hidden="true"></i> Submit</button>');
      $('#post-sync-trigger').replaceWith('<button type="button" class="btn default-color facebook-login waves-effect waves-light"><i class="fa fa-refresh left" aria-hidden="true"></i> Sync Now</button>');
    }
  };

}).call(this);
