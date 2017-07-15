(function() {
  this.App || (this.App = {});

  App.charts = {
    bar: function(element, data) {
      var ctx = element.getContext('2d');
      new Chart(ctx).Bar(
        data,
        App.charts.options
      );
    },
    doughnut: function(element, data) {
      var ctx = element.getContext('2d');
      new Chart(ctx).Doughnut(
        data,
        App.charts.options
      );
    },
    options: {
      responsive: true
    },
    pie: function(element, data) {
      var ctx = element.getContext('2d');
      new Chart(ctx).Pie(
        data,
        App.charts.options
      );
    }
  }

  $(document).on('ready', function() {
    console.log('Charts ready.');
  });

}).call(this);
