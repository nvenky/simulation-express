angular = require('angular')

angular.module('PuntersBotApp.controllers', [])
  .controller 'HomeController', require('./controllers/home_controller.coffee')
  .controller 'SimulationController', require('./controllers/simulation_controller.coffee')
