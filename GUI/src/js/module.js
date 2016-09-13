
var app = angular.module('Sammy-gui', ['ui.bootstrap', 'ui.router', 'ngCookies', 'chart.js'])

/* converts seconds date */
.filter('secondsToDateTime', [function() {
    return function(seconds) {
        return new Date(1970, 0, 1).setSeconds(seconds);
    };
}])
/* replace underscores with spaces */
.filter('underscoreToSpace', function () {
  return function (input) {
      return input.replace(/_/g, ' ');
  };
});



