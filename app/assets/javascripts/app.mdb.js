(function() {
  this.App || (this.App = {});

  App.mdb = function() {
    if ($('.button-collapse').length > 0) {
      $('#sidenav-overlay').remove();
      $('.button-collapse').sideNav();
      var el = document.querySelector('.custom-scrollbar');
      Ps.initialize(el);
    }
  };

  $(document).on('turbolinks:load', function() {
    App.mdb();
    console.log('MDB ready.');
  });

}).call(this);
