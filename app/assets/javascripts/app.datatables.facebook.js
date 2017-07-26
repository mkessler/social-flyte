(function() {
  this.App || (this.App = {});

  App.dataTables.facebook = {
    comments: function() {
      $('#facebook-comments-table').DataTable({
        ajax: $('#facebook-comments-table').data('source'),
        columns: [
          { data: 'like_count', width: '60px', className: 'text-xs-center' },
          { data: 'user', width: '110px' },
          { data: 'comment', className: 'groala-break-word', responsivePriority: 1 },
          { data: 'posted_at', width: '85px' },
          { data: 'flagged', width: '60px', className: 'groala-flag-toggle' }
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
          { data: 'category', width: '60px', className: 'text-xs-center' },
          { data: 'user' },
          { data: 'flagged', width: '60px', className: 'groala-flag-toggle' }
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
    },
    shares: function() {
      $('#facebook-shares-table').DataTable({
        ajax: $('#facebook-shares-table').data('source'),
        columns: [
          { data: 'network_share_id', width: '60px', className: 'text-xs-center' },
          { data: 'user' },
          { data: 'flagged', width: '60px', className: 'groala-flag-toggle' }
        ],
        columnDefs: [
          {
            targets: 0,
            data: 'network_share_id',
            render: function ( data, type, full, meta ) {
              return '<a href="https://facebook.com'+data+'" target="_blank">' +
                '<i class="fa fa-share-alt" aria-hidden="true"></i>' +
              '</a>';
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
              return '<a id="share-flag-'+data.id+'" class="switch" data-remote="true" data-method="put" rel="nofollow" href="'+data.url+'">' +
                '<label class="mb-0">' +
                  '<input type="checkbox" '+checked+'>' +
                  '<span class="lever"></span>' +
                '</label>' +
              '</a>';
            }
          }
        ],
        language: {
          emptyTable: 'No shares exist!',
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Shares</span>'
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
    App.dataTables.facebook.shares();
  });

}).call(this);
