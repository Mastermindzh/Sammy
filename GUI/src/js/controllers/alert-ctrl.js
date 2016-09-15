/**
 * Alerts Controller
 */

app.controller('AlertsCtrl', ['$scope','Alert', AlertsCtrl]);

function AlertsCtrl($scope, Alert) {

    $scope.alerts = Alert.alerts;

    $scope.closeAlert = function(index) {
       Alert.closeAlert(index);
    };

}