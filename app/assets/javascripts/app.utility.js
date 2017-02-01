(function() {
  this.App || (this.App = {});

  App.utility ={
    alert: function(args={}) {
      $('<div class="row">'+
          '<div class="groala-alert col-lg-12 mb-3" style="display:none;">'+
            '<div class="card '+args.class+' text-xs-center z-depth-1">'+
              '<div class="card-block">'+
                '<span class="white-text">'+
                  '<i class="fa fa-'+args.icon+' fa-lg fa-fw"></i> '+
                  args.message+
                '</span>'+
              '</div>'+
            '</div>'+
          '</div>'+
        '</div>'
      ).insertAfter($('.dashboard-title-wrapper'));
      $('.groala-alert').slideDown();
      $('html, body').animate({
        scrollTop: $('.groala-alert').offset().top - 80
      }, 2000);
    },
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
