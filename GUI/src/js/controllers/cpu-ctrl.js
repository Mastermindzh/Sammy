/**
 * CPU Controller
 */

app.controller('CpuCtrl', ['$scope','$http','$interval','Config','Alert', CpuCtrl]);

    function CpuCtrl($scope, $http, $interval, Config, Alert) {

        $scope.temps =[

        ];

        $scope.labels = ['Core 0', 'Core 1', 'Core 2', 'Core 3'];
        $scope.loadLabels = ["Load", "Available"];
        $scope.data = [];

        // load cpuTemp
        $scope.getCpuTemp = function() {
             $http.get(Config.url + '/cpu/temp')
            .success(function(data, status, headers, config) {
              if($scope.temps.length >= 60){
                $scope.temps.shift();

              }
              $scope.temps.push(data.temperatures);

              $scope.cputemploading = false;


                $scope.arrItem = [];
                var counter = 0;
                while(data.temperatures[counter] != null){
                    $scope.arrItem.push(data.temperatures[counter].slice(1,-4));
                    counter++;
                }
                $scope.data = $scope.arrItem;

            })
            .error(function(data, status, headers, config) {
              Alert.addAlert("danger", "fa-exclamation-triangle","Can't fetch CPU temperatures");
            })
        };

        // load cpuLoad
        $scope.getCpuLoad = function() {
             $http.get(Config.url + '/cpu/load')
            .success(function(data, status, headers, config) {
              data.load_array.percentage = parseFloat(data.load_array.percentage.slice(0, -1)).toFixed(2) + "%";
              $scope.load = data;
              $scope.loadData = [parseInt(data.load_array.percentage,10), 100 - parseInt(data.load_array.percentage,10)];
              $scope.currentPercentage = data.load_array.percentage.slice(0,-1);
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
        $scope.getCpuTemp();
        $interval($scope.getCpuTemp, 1000);

        // Get load info every 5 seconds
        $scope.loadloading = true;
        $scope.getCpuLoad();
        $interval($scope.getCpuLoad, 5000);

}




