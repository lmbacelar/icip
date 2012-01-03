jQuery ->
  $('#item_part_number').autocomplete
    minLength: 3,
    source: $('#item_part_number').data('autocomplete-source')

  # Set item image_location on location click
  $('.location_link').click ->
    # Get location data
    l = $(@).data().location
    $('#item_image_location').val("#{l.name}, on image ##{l.image_id}")
    $('#item_image_location').parent().effect 'highlight', {}, 500
