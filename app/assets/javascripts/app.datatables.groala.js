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
      $('#groala-flagged-interactions-table').DataTable({
        ajax: $('#groala-flagged-interactions-table').data('source'),
        columns: [
          { data: 'network', width: '10%', className: 'text-xs-center' },
          { data: 'user' },
          { data: 'class', width: '20%', className: 'text-xs-center' }
        ],
        columnDefs: [
          {
            targets: 0,
            data: 'network',
            render: function ( data, type, full, meta ) {
              return '<i class="fa fa-'+data+'-official fa-lg" aria-hidden="true"></i>';
            }
          },
          {
            targets: 1,
            data: 'user',
            render: function ( data, type, full, meta ) {
              return '<a class="light-blue-text groala-standard-link" target="_blank" href="'+data.url+'">'+data.name+'</a>';
            }
          }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Flagged Interactions</small>'
        },
        order: [
          [1, 'asc']
        ]
        //pageLength: 3
      });
    },
    invitations: function() {
      $('#groala-invitations-table').DataTable({
        columns: [
          null,
          { width: '10%' }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Invitations</small>'
        },
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
    },
    users: function() {
      $('#groala-users-table').DataTable({
        columns: [
          null,
          { width: '10%' }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Users</small>'
        },
        processing: false,
        serverSide: false
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.groala.campaigns();
    App.dataTables.groala.flagged_interactions();
    App.dataTables.groala.invitations();
    App.dataTables.groala.organizations();
    App.dataTables.groala.posts();
    App.dataTables.groala.users();
  });

}).call(this);
