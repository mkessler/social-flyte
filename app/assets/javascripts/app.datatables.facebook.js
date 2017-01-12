(function() {
  this.App || (this.App = {});

  App.dataTables.facebook = {
    comments: function() {
      $('#facebook-comments-table').DataTable({
        ajax: $('#facebook-comments-table').data('source'),
        columns: [
          { data: 'like_count', width: '10%', className: 'text-xs-center' },
          { data: 'user', width: '15%' },
          { data: 'comment', className: 'groala-break-word' },
          { data: 'posted_at', width: '15%', className: 'text-xs-center' },
          { data: 'flagged', width: '10%', className: 'text-xs-center' }
        ],
        columnDefs: [
          {
            targets: 1,
            data: 'user',
            render: function ( data, type, full, meta ) {
              return '<a class="light-blue-text groala-standard-link" target="_blank" href="'+data.url+'">'+data.name+'</a>';
            }
          },
          {
            targets: 2,
            data: 'comment',
            render: function ( data, type, full, meta ) {
              var output;
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
              return output;
            }
          },
          {
            targets: 3,
            data: 'posted_at',
            render: function ( data, type, full, meta ) {
              return data.time + '<br/><small>'+data.date+'</small>';
            }
          },
          {
            targets: 4,
            data: 'flagged',
            render: function ( data, type, full, meta ) {
              var tooltip = data.status ? 'Unflag' : 'Flag';
              var flagged_class = data.status ? 'orange-text' : '';
              return '<a class="flag-element grey-text" data-toggle="tooltip" data-placement="top" title="'+tooltip+'" data-remote="true" data-method="put" rel="nofollow" href="'+data.url+'">' +
                '<i class="fa fa-flag '+flagged_class+'" aria-hidden="true"></i>' +
              '</a>';
            }
          }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Comments</small>'
        },
        order: [
          [3, 'desc']
        ]
      });
    },
    reactions: function() {
      $('#facebook-reactions-table').DataTable({
        ajax: $('#facebook-reactions-table').data('source'),
        columns: [
          { data: 'category', width: '10%', className: 'text-xs-center' },
          { data: 'user' },
          { data: 'flagged', width: '10%', className: 'text-xs-center' }
        ],
        columnDefs: [
          {
            targets: 0,
            data: 'category',
            render: function ( data, type, full, meta ) {
              return '<span class="facebook-reaction '+data+'"></span>';
            }
          },
          {
            targets: 1,
            data: 'user',
            render: function ( data, type, full, meta ) {
              return '<a class="light-blue-text groala-standard-link" target="_blank" href="'+data.url+'">'+data.name+'</a>';
            }
          },
          {
            targets: 2,
            data: 'flagged',
            render: function ( data, type, full, meta ) {
              var tooltip = data.status ? 'Unflag' : 'Flag';
              var flagged_class = data.status ? 'orange-text' : '';
              return '<a class="flag-element grey-text" data-toggle="tooltip" data-placement="top" title="'+tooltip+'" data-remote="true" data-method="put" rel="nofollow" href="'+data.url+'">' +
                '<i class="fa fa-flag '+flagged_class+'" aria-hidden="true"></i>' +
              '</a>';
            }
          }
        ],
        language: {
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Reactions</small>'
        },
        order: [
          [1, 'asc']
        ]
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.facebook.comments();
    App.dataTables.facebook.reactions();
  });

}).call(this);
