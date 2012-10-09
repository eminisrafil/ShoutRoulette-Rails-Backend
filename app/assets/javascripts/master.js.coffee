$ ->

  $('#popular-topics li, #all-topics li').on 'click', ->
    $(@).find('.pulldown').slideToggle()

  $('.pulldown > *').on 'click', (e) -> e.stopPropagation()

  $('.disabled').on 'click', (e) -> e.preventDefault()

  prompt_social = setTimeout (-> $('.social').fadeIn()), 5000

  num = Math.round(Math.random() * 5) + 1
  $('#video1').css background: "url(/img/rage#{num}.jpg)"