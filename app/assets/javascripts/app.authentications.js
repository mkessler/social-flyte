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
        }
      });
    }
  }

}).call(this);