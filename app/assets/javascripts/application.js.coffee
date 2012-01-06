//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require globals

# Access global objects through Application.
window.Application ||= {}

jQuery ->
  # Highlight flash notice
  $('#flash_notice').hide()
  $('#flash_notice').fadeIn()

  # Highlight flash error
  $('#flash_error').effect 'pulsate', { times: 3}, 500

  # Highlight form error messages
  $('.error_messages').effect 'pulsate', { times: 3}, 500

  # Show hide groups icon
  $('.group .title .icons a.down').hide()
  # Hide groups
  $('.group .title .icons a.up').click (e) ->
    e.preventDefault()
    $(@).parent().parent().siblings().hide('fast')
    $(@).hide()
    $(@).siblings('a.down').show()
  # Show groups
  $('.group .title .icons a.down').click (e) ->
    e.preventDefault()
    $(@).parent().parent().siblings().show('fast')
    $(@).hide()
    $(@).siblings('a.up').show()

  # Draw box around item location.
  # Window load garantees images are loaded and their position is acurately reported
  $(window).load ->
    $('.location_link, .location_box').each ->
      l = $(@).data().location
      Application.drawBox $(@), $("#image_#{l.image_id}"), l.x1, l.y1, l.x2, l.y2
