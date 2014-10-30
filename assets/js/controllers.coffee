angular = require('angular')
require('./dependencies/angular-datepicker.js')
require('./../styles/dependencies/angular-datepicker.css')


angular.module('PuntersBotApp.controllers', ['datePicker'])
  .controller 'HomeController', require('./controllers/home_controller.coffee')
  .controller 'SimulationController', require('./controllers/simulation_controller.coffee')
