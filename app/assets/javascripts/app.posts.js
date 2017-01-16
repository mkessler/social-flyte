(function() {
  this.App || (this.App = {});

  App.posts ={
    poll: function(status) {
      $.get(location.pathname+'/sync_status.json').done(function(data) {
        if (data.status !== status) location.reload(true);
      }).always(function() {
        setTimeout(function() {
          App.posts.poll(status);
        }, 5000);
      });
    }
  }

  $(document).on('ready', function() {
    console.log('Posts ready.');
  });

}).call(this);
