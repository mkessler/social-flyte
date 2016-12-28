(function() {
  this.App || (this.App = {});

  App.dataTables ={
    defaults: function() {
      $.extend( $.fn.dataTable.defaults, {
        autoWidth: false,
        deferRender: true,
        language: {
          aria: {
            paginate: {
              first:    'First',
              previous: 'Previous',
              next:     'Next',
              last:     'Last'
            }
          },
          info: '<small><i class="fa fa-flag" aria-hidden="true"></i> Displaying _START_ - _END_ of _TOTAL_ Records</small>'
        },
        lengthChange: false
      });
    }
  }

  $(document).on('ready', function() {
    App.dataTables.defaults();
    console.log('DataTables ready.');
  });

}).call(this);
