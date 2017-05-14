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
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Campaigns</span>'
        },
        processing: false,
        serverSide: false
      });
    },
    flagged_interactions: function(network_column_visibility) {
      $('#groala-flagged-interactions-table').DataTable({
        ajax: $('#groala-flagged-interactions-table').data('source'),
        columns: [
          { data: 'network', width: '5%' },
          { data: 'class', width: '15%' },
          { data: 'user', width: '25%' },
          { data: 'content' },
          { data: 'posted_at', width: '15%' },
        ],
        columnDefs: [
          {
            targets: 0,
            data: 'network',
            visible: network_column_visibility == 'show' ? true : false,
            render: function ( data, type, full, meta ) {
              return App.utility.networkIcon(data);
            }
          },
          {
            targets: 2,
            data: 'user',
            render: function ( data, type, full, meta ) {
              return '<a class=" groala-standard-link" target="_blank" href="'+data.url+'">'+data.name+'</a>';
            }
          },
          {
            targets: 3,
            data: 'content',
            render: function ( data, type, full, meta ) {
              var output;

              if (full.class == 'Comment') {
                if (data.attachment.url !== null && data.attachment.image !== null) {
                  output = '<div class="media">' +
                    '<a href="'+data.attachment.url+'" class="media-left" target="_blank">' +
                      '<img class="media-object" src="'+data.attachment.image+'" alt="Comment Media">' +
                    '</a>' +
                    '<br class="hidden-sm-up">' +
                    '<div class="media-body">'+data.message+'</div>' +
                  '</div>';
                } else {
                  output = data.message;
                }
              } else if (full.class == 'Reaction') {
                output = '<span class="facebook-reaction '+data.category+'"></span>';
              }

              return output;
            }
          },
          {
            targets: 4,
            data: 'posted_at',
            render: function ( data, type, full, meta ) {
              if(data.time == 'Not Available') {
                return data.time;
              } else {
                return data.time + '<br/><small>'+data.date+'</small>';
              }
            }
          }
        ],
        language: {
          emptyTable: 'No interactions flagged!',
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Flagged Interactions</span>'
        },
        order: [
          [2, 'asc']
        ]
      });
    },
    invitations: function() {
      $('#groala-invitations-table').DataTable({
        columns: [
          null,
          { width: '10%' }
        ],
        language: {
          emptyTable: 'No invitations sent!',
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Invitations</span>'
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
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Organizations</span>'
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
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Posts</span>'
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
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Users</span>'
        },
        processing: false,
        serverSide: false
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.groala.campaigns();
    App.dataTables.groala.invitations();
    App.dataTables.groala.organizations();
    App.dataTables.groala.posts();
    App.dataTables.groala.users();
  });

}).call(this);
