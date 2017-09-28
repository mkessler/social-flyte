(function() {
  this.App || (this.App = {});

  App.posts ={
    messages: {
      error: ['pink', 'exclamation-triangle', 'Error - There was an error trying to sync your post.'],
      success: ['default-color', 'refresh fa-spin', 'Syncing - This page will automatically refresh when your sync is complete.']
    },
    disableButton: function() {
      $('#post-sync-trigger').addClass('grey').removeClass('default-color').attr({
        'id': '',
        'disabled': true
      });
    },
    facebookPageSearch: function() {
      $('#facebook-page-search-submit').on('click', function() {
        if ($('#facebook-page-search').val().length > 0) {
          App.facebook.fetchPages(
            $('#facebook-page-search').val()
          );
        }
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
    },
    wordCloud: function($element, data) {
      $element.empty().jQCloud(
        data,
        {
          autoResize: true,
          height: $('#reactions-chart').height() + 6,
          shape: 'elliptic'
        }
      );
    }
  }

  $(document).on('ready', function() {
    console.log('Posts ready.');
  });

}).call(this);
