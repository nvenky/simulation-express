module.exports = ['$scope', ($scope) ->
      require('./../../styles/homepage.scss')
      require('./../../styles/pricing.scss')
      require('./../dependencies/jquery.easing.1.3.js')
      $('body').addClass('homepage')

      scrollHandler = ->
            if $(".navbar").offset().top > 30
              $(".navbar-fixed-top").addClass("top-nav-collapse")
            else
              $(".navbar-fixed-top").removeClass("top-nav-collapse")

      $scope.$on "$destroy", ->
         $('body').removeClass('homepage')
         #$(document).off('scroll', scrollHandler)


      $scope.$on "$viewContentLoaded", ->
         $('a.page-scroll').bind 'click', (event) ->
            $anchor = $(this)
            $('html, body').stop().animate({scrollTop: $($anchor.attr('href')).offset().top}, 1500, 'easeInOutExpo')
            event.preventDefault()
         $('.homepage .navbar-collapse ul li a').click ->
            $('.homepage .navbar-toggle:visible').click()
  ]
