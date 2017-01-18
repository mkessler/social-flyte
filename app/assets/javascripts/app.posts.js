(function() {
  this.App || (this.App = {});

  App.posts ={
    poll: function(statuses) {
      if (statuses === undefined) statuses = [];

      $.get(location.pathname+'/sync_status.json').done(function(data) {
        if (statuses.indexOf(data.status) < 0) location.reload(true);
      }).always(function() {
        setTimeout(function() {
          App.posts.poll(statuses);
        }, 5000);
      });
    },
    sync: function() {
      App.posts.syncAlert();
      $.post(location.pathname+'/sync_post.json').done(function(data) {
        App.posts.poll(['queued', 'working']);
      });
    },
    syncAlert: function() {
      $('<div class="post-sync-alert col-lg-12 mb-3" style="display:none;"><div class="card card-warning text-xs-center z-depth-1"><div class="card-block"><span class="white-text"><i class="fa fa-refresh fa-spin fa-lg fa-fw"></i> Sync started! We\'ll refresh this page when your sync is complete.</span></div></div></div>').insertAfter($('.post-timestamp'));
      $('.post-sync-alert').slideDown();
    }
  }

  $(document).on('ready', function() {
    console.log('Posts ready.');
  });

}).call(this);
