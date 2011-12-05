# Access global objects through Application.
window.Application ||= {}

jQuery ->
  $('#item_part_number').autocomplete
    minLength: 3,
    source: $('#item_part_number').data('autocomplete-source')

  # set vars based on form or show values
  $('.location_link, .location_box').each ->
    l = $(@).data().location
    Application.drawBox $(@), $('.selector'), l.x1, l.y1, l.x2, l.y2

  $('.location_link').click ->
    #alert 'clicked location ' + $(@).data().location.name + ', id=' + $(@).data().location.id + ', on image_id=' + $(@).data().location.image_id
    l = $(@).data().location
    console.log "#{l.name}, on image ##{l.image_id}"

    $('#item_image_location').val("#{l.name}, on image ##{l.image_id}")


