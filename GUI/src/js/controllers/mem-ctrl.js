/**
 * Mem Controller
 */

app.controller('MemCtrl', ['$scope','$http','Config', 'Alert', MemCtrl]);

    function MemCtrl($scope, $http, Config,Alert) {
        $scope.memoryloading = true;
        $http.get(Config.url + '/mem')
            .success(function(data, status, headers, config) {
              $scope.meminfo = data;
              $scope.memoryloading = false;
            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger","fa-exclamation-triangle","Can't fetch memory information");
            })
        ;
    }
