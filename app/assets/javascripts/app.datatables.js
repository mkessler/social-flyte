(function() {
  this.App || (this.App = {});

  App.dataTables ={
    defaults: function() {
      $.extend( $.fn.dataTable.defaults, {
        autoWidth: false,
        deferRender: true,
        drawCallback: function(settings) {
          $('#'+settings.sTableId+'_paginate ul.pagination').wrap('<nav/>');
          $('#'+settings.sTableId+'_paginate ul.pagination li a').addClass('waves-effect');
          $('table tbody [data-toggle="tooltip"]').tooltip();
        },
        initComplete: function(settings, json) {
          var table = this.api();
          App.dataTables.history(table);
          App.dataTables.search(table, '#'+settings.sTableId+'-search');
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
          info: '<small><i class="fa fa-list orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Records</small>',
          infoFiltered: '<br/><small><i class="fa fa-filter orange-text" aria-hidden="true"></i> Filtered from _MAX_ Records</small>',
          paginate: {
            next: 'Next',
            previous: 'Prev'
          }
        },
        lengthChange: false,
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
      $.fn.DataTable.ext.pager.numbers_length = 4;
    },
    flagToggle: function($el, status) {
      var tooltip = status ? 'Unflag' : 'Flag'
      if (status == true) {
        $el.find('i').addClass('orange-text');
      } else {
        $el.find('i').removeClass('orange-text');
      }

      $el.tooltip('hide')
        .attr('data-original-title', tooltip)
        .tooltip('fixTitle')
        .tooltip('show');
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
