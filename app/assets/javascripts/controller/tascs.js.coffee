# Access global objects through Application.
window.Application ||= {}

jQuery ->
  alert('js Not implemented yet!')
###  # Draw box around checkpoint location
###  $('.location_link, .location_box').each ->
###    l = $(@).data().location
###    Application.drawBox $(@), $('.selector'), l.x1, l.y1, l.x2, l.y2
###
###  # Set checkpoint on click
###  $('.location_link').click ->
###    l = $(@).data().location
###    $('#item_image_location').val("#{l.name}, on image ##{l.image_id}")
