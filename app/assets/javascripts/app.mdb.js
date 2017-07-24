(function() {
  this.App || (this.App = {});

  App.mdb = function() {
    $('[data-toggle="tooltip"]').tooltip();
    if ($('.button-collapse').length > 0) {
      $('#sidenav-overlay').remove();
      $('.button-collapse').sideNav();
      var el = document.querySelector('.custom-scrollbar');
      Ps.initialize(el);
    }
    new WOW().init();
  };

  $(document).on('ready', function() {
    App.mdb();
    console.log('MDB ready.');
  });

}).call(this);
