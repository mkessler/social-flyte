(function() {
  this.App || (this.App = {});

  App.dataTables ={
    defaults: function() {
      $.extend( $.fn.dataTable.defaults, {
        autoWidth: false,
        dom: '<rt><"text-xs-center" p><"text-xs-center" i><"clear">',
        deferRender: true,
        drawCallback: function(settings) {
          $('#'+settings.sTableId+'_paginate ul.pagination').wrap('<nav/>');
          $('#'+settings.sTableId+'_paginate ul.pagination li a').addClass('waves-effect');
          $('table tbody [data-toggle="tooltip"]').tooltip();
          if (settings._iRecordsDisplay < settings._iDisplayLength) {
            $('#'+settings.sTableId+'_paginate').hide();
          } else {
            $('#'+settings.sTableId+'_paginate').show();
          }
        },
        initComplete: function(settings, json) {
          var table = this.api();
          App.dataTables.history(table);
          App.dataTables.search(table, '#'+settings.sTableId+'-search');
          $('#'+settings.sTableId).fadeTo(2000, 1);
        },
        language: {
          aria: {
            paginate: {
              first:    'First',
              previous: 'Previous',
              next:     'Next',
              last:     'Last'
            }
          },
          emptyTable: 'No data available!',
          info: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> _START_ - _END_ of _TOTAL_ Records</span>',
          infoEmpty: '<span class="tag tag-default"><i class="fa fa-list" aria-hidden="true"></i> 0 Records</span>',
          infoFiltered: '<span class="tag tag-default"><i class="fa fa-filter" aria-hidden="true"></i> Filtered from _MAX_ Records</span>',
          paginate: {
            next: '<i class="fa fa-chevron-right" aria-hidden="true"></i>',
            previous: '<i class="fa fa-chevron-left" aria-hidden="true"></i>'
          },
          processing: '<i class="fa fa-refresh fa-spin fa-5x fa-fw"></i><span class="sr-only">Loading...</span>'
        },
        lengthChange: false,
        pageLength: 10,
        processing: true,
        responsive: {
          details: {
            display: $.fn.dataTable.Responsive.display.modal({
              header: function (row) {
                var data = row.data();
                return 'Details';
              }
            }),
            renderer: function (api, rowIdx, columns) {
              var data = $.map(columns, function (col, i){
                return '<tr data-dt-row="'+col.rowIndex+'" data-dt-column="'+col.columnIndex+'">'+
                  '<td>'+col.title+'</td>'+
                  '<td>'+col.data+'</td>'+
                '</tr>'
              }).join('');

              return $('<table class="table groala-break-word" />').append(data);
            }
          }
        },
        search: {
          search: App.utility.getParameterByName('search') !== null ? App.utility.getParameterByName('search') : ''
        },
        serverSide: true
      });
      $.fn.DataTable.ext.pager.numbers_length = 5;
    },
    flagToggle: function($el, status, update_link) {
      var table = $('#groala-flagged-interactions-table').DataTable();
      table.ajax.reload();
      $el.attr('href', update_link);
      $('input:checkbox', $el).prop('checked', status);
    },
    history: function(table) {
      table.on( 'xhr', function () {
        var data = table.ajax.params();
        if (data.search.value == null || data.search.value == '') {
          history.pushState('', '', window.location.href.split("?")[0]);
        } else {
          history.pushState('', '', '?search='+data.search.value);
        }
      });
    },
    search: function(table, id) {
      $(id).on('keyup', function() {
        table.search(this.value).draw();
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.defaults();
    console.log('DataTables ready.');
  });

}).call(this);
