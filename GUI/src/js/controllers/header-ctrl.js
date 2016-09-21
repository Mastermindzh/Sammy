/**
 * Header controller
 */

app.controller('HeaderCtrl', ['$scope','$rootScope','$location','Config','$http', HeaderCtrl]);

function HeaderCtrl($scope,$rootScope,$location,Config,$http) {

    $scope.update = function() {
        var url = $location.url();

        switch(url){
            case "/mem":
                $scope.currentPage = "Memory information";
            break;
            case "/cpu":
                $scope.currentPage = "Processor information";
            break;
            default:
                $scope.currentPage = "Dashboard";
            break;
        }

        $scope.crumbs = [];
        $scope.crumbs = url.split("/");
    };

    $scope.shutdown = function(){
        $http.get(Config.url + '/system/shutdown');
    }
    $scope.reboot = function(){
        $http.get(Config.url + '/system/reboot');
    }

    $scope.update();

    $rootScope.$on('$stateChangeStart',
    function(event, toState, toParams, fromState, fromParams){
        $scope.update();
    })



}