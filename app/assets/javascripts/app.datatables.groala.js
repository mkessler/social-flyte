(function() {
  this.App || (this.App = {});

  App.dataTables.groala = {
    campaigns: function() {
      $('#groala-campaigns-table').DataTable({
        columns: [
          null,
          { width: '20%' },
          { width: '20%' },
          { width: '15%' }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Campaigns</small>'
        },
        processing: false,
        serverSide: false
      });
    },
    flagged_interactions: function() {
      $('#campaign-flagged-interactions-table').DataTable({
        columns: [
          { width: '10%' },
          null,
          { width: '20%' },
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Flagged Interactions</small>'
        },
        order: [
          [1, 'asc']
        ],
        processing: false,
        serverSide: false
      });
    },
    organizations: function() {
      $('#groala-organizations-table').DataTable({
        columns: [
          null,
          { width: '20%' },
          { width: '20%' },
          { width: '15%' }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Organizations</small>'
        },
        processing: false,
        serverSide: false
      });
    },
    posts: function() {
      $('#groala-posts-table').DataTable({
        columns: [
          null,
          { width: '20%' },
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
    App.dataTables.groala.campaigns();
    App.dataTables.groala.flagged_interactions();
    App.dataTables.groala.organizations();
    App.dataTables.groala.posts();
  });

}).call(this);
