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
        search: {
          search: App.utility.getParameterByName('search')
        },
        serverSide: true
      });
      $.fn.DataTable.ext.pager.numbers_length = 4;
    }
  }

  $(document).on('ready', function() {
    App.dataTables.defaults();
    console.log('DataTables ready.');
  });

}).call(this);
