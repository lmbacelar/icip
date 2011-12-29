# Access global objects through Application.
window.Application ||= {}

jQuery ->
  # Draw box around item location
  $('.location_link, .location_box').each ->
    l = $(@).data().location
    Application.drawBox $(@), $("#image_#{l.image_id}"), l.x1, l.y1, l.x2, l.y2

  # Set item image_location on location click
  $('.location_link').click ->
    l = $(@).data().location
    $('#checkpoint_image_location').val("#{l.name}, on image ##{l.image_id}")
