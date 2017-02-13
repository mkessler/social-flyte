(function() {
  this.App || (this.App = {});

  App.posts ={
    messages: {
      error: ['pink', 'exclamation-triangle', 'Error - There was an error trying to sync your post.'],
      success: ['green accent-4', 'refresh fa-spin', 'Syncing - This page will automatically refresh when your sync is complete.']
    },
    disableButton: function() {
      $('#post-sync-trigger').addClass('grey').removeClass('green accent-4').attr({
        'id': '',
        'disabled': true
      });
    },
    poll: function(statuses) {
      if (statuses === undefined) statuses = [];

      $.get(location.pathname+'/sync_status.json').done(function(data) {
        if (statuses.indexOf(data.status) < 0) location.reload(true);
      }).error(function(data) {
        App.utility.alert({
          class: App.posts.messages.error[0],
          icon: App.posts.messages.error[1],
          message: App.posts.messages.error[2]
        });
      }).always(function() {
        setTimeout(function() {
          App.posts.poll(statuses);
        }, 5000);
      });
    },
    sync: function() {
      $.post(location.pathname+'/sync_post.json').done(function(data) {
        App.utility.alert({
          class: App.posts.messages.success[0],
          icon: App.posts.messages.success[1],
          message: App.posts.messages.success[2]
        });
        App.posts.poll(['queued', 'working']);
        App.posts.disableButton();
      }).error(function(data) {
        App.utility.alert({
          class: App.posts.messages.error[0],
          icon: App.posts.messages.error[1],
          message: App.posts.messages.error[2]
        });
      });
    }
  }

  $(document).on('ready', function() {
    console.log('Posts ready.');
  });

}).call(this);
