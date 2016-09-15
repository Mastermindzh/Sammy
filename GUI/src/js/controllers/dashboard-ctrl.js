/**
 * Dashboard Controller
 */


app

.controller('DashboardCtrl', ['$scope','$http','Config','Alert', DashboardCtrl]);

    function DashboardCtrl($scope, $http, Config, Alert) {

        $scope.cpuloading = true;
        $scope.memloading = true;
        $scope.sysloading = true;

        $http.get(Config.url + '/cpu/info')
            .success(function(data, status, headers, config) {
              $scope.cpuinfo = data.cpu_info;
              $scope.cpuloading = false;
            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger","fa-exclamation-triangle","Can't fetch CPU information");
        });

         $http.get(Config.url + '/mem/load')
            .success(function(data, status, headers, config) {
              $scope.meminfo = data['Mem:'];
              $scope.memloading = false;
            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger","fa-exclamation-triangle","Can't fetch memory information");
        });

          $http.get(Config.url + '/sysinfo')
            .success(function(data, status, headers, config) {
              $scope.sysinfo = data;
              $scope.sysloading = false;
            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger","fa-exclamation-triangle","Can't fetch system information.");
        });


    }