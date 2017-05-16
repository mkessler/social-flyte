(function() {
  this.App || (this.App = {});

  App.dataTables.facebook = {
    comments: function() {
      $('#facebook-comments-table').DataTable({
        ajax: $('#facebook-comments-table').data('source'),
        columns: [
          { data: 'like_count', width: '10%' },
          { data: 'user', width: '15%' },
          { data: 'comment', className: 'groala-break-word' },
          { data: 'posted_at', width: '15%' },
          { data: 'flagged', width: '15%', className: 'groala-flag-toggle' }
        ],
        columnDefs: [
          {
            targets: 1,
            data: 'user',
            render: function ( data, type, full, meta ) {
              return '<a class=" groala-standard-link" target="_blank" href="'+data.url+'">'+data.name+'</a>';
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
              var checked = data.status ? 'checked="checked"' : '';
              return '<a id="comment-flag-'+data.id+'" class="switch" data-remote="true" data-method="put" rel="nofollow" href="'+data.url+'">' +
                '<label class="mb-0">' +
                  '<input type="checkbox" '+checked+'>' +
                  '<span class="lever"></span>' +
                '</label>' +
              '</a>';
            }
          }
        ],
        language: {
          emptyTable: 'No comments exist!',
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Comments</span>'
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
          { data: 'category', width: '20%' },
          { data: 'user' },
          { data: 'flagged', width: '15%', className: 'groala-flag-toggle' }
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
              return '<a class=" groala-standard-link" target="_blank" href="'+data.url+'">'+data.name+'</a>';
            }
          },
          {
            targets: 2,
            data: 'flagged',
            render: function ( data, type, full, meta ) {
              var checked = data.status ? 'checked="checked"' : '';
              return '<a id="reaction-flag-'+data.id+'" class="switch" data-remote="true" data-method="put" rel="nofollow" href="'+data.url+'">' +
                '<label class="mb-0">' +
                  '<input type="checkbox" '+checked+'>' +
                  '<span class="lever"></span>' +
                '</label>' +
              '</a>';
            }
          }
        ],
        language: {
          emptyTable: 'No reactions exist!',
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Reactions</span>'
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
