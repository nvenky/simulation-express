angular = require('angular')

angular.module 'PuntersBotApp.directives', []
  .directive 'appVersion', ['version', (version) ->
     (scope, elm, attrs) ->
       elm.text(version)
   ]
