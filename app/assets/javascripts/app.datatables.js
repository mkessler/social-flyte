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
          info: '<small><i class="fa fa-list deep-orange-text" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Records</small>',
          infoFiltered: '<br/><small><i class="fa fa-filter deep-orange-text" aria-hidden="true"></i> Filtered from _MAX_ Records</small>',
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
                return 'Details for '+data[0]+' '+data[1];
              }
            }),
            renderer: $.fn.dataTable.Responsive.renderer.tableAll({
              tableClass: 'table'
            })
          }
        },
        search: {
          search: App.utility.getParameterByName('search')
        },
        serverSide: true
      });
      $.fn.DataTable.ext.pager.numbers_length = 4;
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
