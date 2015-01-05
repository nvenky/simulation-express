require('./controllers.coffee')
require('./../styles/app.scss')
require('./../styles/overrides.scss')
require('./../styles/navbar.scss')

puntersBotApp = angular.module('PuntersBotApp', [
  'ngRoute',
  'PuntersBotApp.controllers'
])

puntersBotApp.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/index', {templateUrl: 'partials/homepage.html', controller: 'HomeController'})
  $routeProvider.when('/simulation', {templateUrl: 'partials/simulation.html', controller: 'SimulationController'})
  $routeProvider.otherwise({redirectTo: '/index'})
 ]
