(function() {
  this.App || (this.App = {});

  App.utility ={
    getParameterByName: function(name, url) {
      if (!url) {
        url = window.location.href;
      }
      name = name.replace(/[\[\]]/g, "\\$&");
      var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
          results = regex.exec(url);
      if (!results) return null;
      if (!results[2]) return '';
      return decodeURIComponent(results[2].replace(/\+/g, " "));
    }
  }

  $(document).on('ready', function() {
    console.log('Utility ready.');
  });

}).call(this);
