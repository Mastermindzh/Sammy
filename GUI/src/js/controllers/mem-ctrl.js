/**
 * Mem Controller
 */

app.controller('MemCtrl', ['$scope','$http','$interval','Config', 'Alert', MemCtrl]);

    function MemCtrl($scope, $http,$interval, Config,Alert) {
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


        $scope.getMemLoad = function() {
             $http.get(Config.url + '/mem/load')
            .success(function(data, status, headers, config) {
                $scope.memLoad = data;
                $scope.currentPercentage = (($scope.memLoad['Mem:'].used.slice(0,-1) / $scope.memLoad['Mem:'].total.slice(0,-1)) * 100);
                $scope.currentSwapPercentage = (($scope.memLoad['Swap:'].used.slice(0,-1) / $scope.memLoad['Swap:'].total.slice(0,-1)) * 100);
            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger", "fa-exclamation-triangle","Can't fetch memory load");
            })
        };

        $scope.getMemLoad();
        $interval($scope.getMemLoad, 1000);



    }
