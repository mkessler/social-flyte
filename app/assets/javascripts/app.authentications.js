(function() {
  this.App || (this.App = {});

  App.authentications = {
    create: function(args={}) {
      $.ajax({
        url: '/authentications',
        type: 'POST',
        data: {
          authentication: {
            network_id: args.network_id,
            network_user_id: args.response.userID,
            token: args.response.accessToken,
            expires_at: args.response.expiresIn
          }
        },
        dataType: 'json',
        success: function(data){
          console.log(data);
          if ($('#connected-facebook span').length) {
            $('.facebook-login').remove();
            $('#connected-facebook span').html('Status: Connected <i class="fa fa-check-circle-o fa-lg fa-fw green-text"></i>');
          }
          if ($('#new_post').length) {
            $('#new_post').submit();
          }
          if ($('#sync-info').length) {
            App.posts.sync();
          }
        }
      });
    }
  }

}).call(this);
