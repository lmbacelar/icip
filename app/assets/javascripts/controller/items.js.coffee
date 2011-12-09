# Access global objects through Application.
window.Application ||= {}

jQuery ->
  $('#item_part_number').autocomplete
    minLength: 3,
    source: $('#item_part_number').data('autocomplete-source')

  # Draw box around item location
  $('.location_link, .location_box').each ->
    l = $(@).data().location
    Application.drawBox $(@), $('.selector'), l.x1, l.y1, l.x2, l.y2

  # Set item image_location on location click
  $('.location_link').click ->
    l = $(@).data().location
    $('#item_image_location').val("#{l.name}, on image ##{l.image_id}")


