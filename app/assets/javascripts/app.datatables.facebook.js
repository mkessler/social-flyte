(function() {
  this.App || (this.App = {});

  App.dataTables.facebook = {
    comments: function() {
      var table = $('#facebook-comments-table').DataTable({
        language: {
          info: '<small><i class="fa fa-flag" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Comments</small>'
        },
        order: [
          [3, 'desc']
        ]
      });
      $('#facebook-comments-search').on('keyup', function() {
        table.search(this.value).draw();
      });
    },
    reactions: function() {
      var table = $('#facebook-reactions-table').DataTable({
        language: {
          info: '<small><i class="fa fa-flag" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Reactions</small>'
        },
        order: [
          [1, 'asc']
        ]
      });
      $('#facebook-reactions-search').on('keyup', function() {
        table.search(this.value).draw();
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.facebook.comments();
    App.dataTables.facebook.reactions();
  });

}).call(this);
