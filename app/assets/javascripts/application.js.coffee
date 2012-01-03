//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require globals

# Access global objects through Application.
window.Application ||= {}

jQuery ->
  # Show / Hide groups
  # TODO:
  # show / hide up / down icon accordingly
  $('.group').children('.title').click ->
    $(@).siblings().toggle('fast')

  # Draw box around item location.
  # Window load garantees images are loaded and their position is acurately reported
  $(window).load ->
    $('.location_link, .location_box').each ->
      l = $(@).data().location
      Application.drawBox $(@), $("#image_#{l.image_id}"), l.x1, l.y1, l.x2, l.y2
