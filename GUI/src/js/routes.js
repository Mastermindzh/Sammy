'use strict';

app.config(['$stateProvider', '$urlRouterProvider',
    function($stateProvider, $urlRouterProvider) {

        // For unmatched routes
        $urlRouterProvider.otherwise('/');

        // Application routes
        $stateProvider
            .state('index', {
                url: '/',
                templateUrl: 'templates/dashboard.html'
            })
            .state('cpu', {
                url: '/cpu',
                templateUrl: 'templates/cpu.html'
            }).state('mem', {
                url: '/mem',
                templateUrl: 'templates/mem.html'
            });
    }
]);