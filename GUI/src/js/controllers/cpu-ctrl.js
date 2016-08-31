/**
 * CPU Controller
 */

app.controller('CpuCtrl', ['$scope','$http','$interval','Config','Alert', CpuCtrl]);

    function CpuCtrl($scope, $http, $interval, Config, Alert) {

        $scope.temps =[

        ];

        // load cpuTemp
        $scope.getCpuTemp = function() {
             $http.get(Config.url + '/cpu/temp')
            .success(function(data, status, headers, config) {
              if($scope.temps.length >= 60){
                $scope.temps.shift();
              }
              $scope.temps.push(data.temperatures);
              $scope.cputemploading = false;
            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger", "fa-exclamation-triangle","Can't fetch CPU temperatures");
            })
        };

        // load cpuLoad
        $scope.getCpuLoad = function() {
             $http.get(Config.url + '/cpu/load')
            .success(function(data, status, headers, config) {
              $scope.load = data;
                $scope.loadloading = false;
            })
            .error(function(data, status, headers, config) {
                Alert.addAlert("danger", "fa-exclamation-triangle","Can't fetch CPU load");
            })
        };

        // load cpuInfo
        $scope.loading = true;

        $http.get(Config.url + '/cpu/info')
            .success(function(data, status, headers, config) {
              $scope.cpuinfo = data;
              $scope.loading = false;
            })
            .error(function(data, status, headers, config) {
                Alert.addAlert("danger", "fa-exclamation-triangle","Can't fetch CPU information");
        });

        // Get temperature every second
        $scope.cputemploading = true;
        $scope.getCpuTemp()
        $interval($scope.getCpuTemp, 1000);

        // Get load info every 5 seconds
        $scope.loadloading = true;
        $scope.getCpuLoad()
        $interval($scope.getCpuLoad, 5000);






    }





