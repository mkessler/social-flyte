(function() {
  this.App || (this.App = {});

  App.networkTokens = {
    set: function(args={}) {
      $.ajax({
        url: '/network_tokens/set',
        type: 'POST',
        data: {
          network: args.network,
          token: args.token,
          expires_at: args.expires_at
        },
        dataType: 'json',
        success: function(data){
          console.log(data);
        }
      });
    }
  }

}).call(this);
