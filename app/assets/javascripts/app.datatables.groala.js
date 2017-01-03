(function() {
  this.App || (this.App = {});

  App.dataTables.groala = {
    posts: function() {
      $('#groala-posts-table').DataTable({
        columns: [
          null,
          { width: '35%' },
          { width: '10%' }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Posts</small>'
        },
        processing: false,
        serverSide: false
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.groala.posts();
  });

}).call(this);
