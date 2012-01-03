jQuery ->
  $('#checkpoint_part_number').autocomplete
    minLength: 3,
    source: $('#checkpoint_part_number').data('autocomplete-source')

  # Highlight Help
  $('#checkpoint_location_help').effect 'pulsate', {times:2}, 500

  # Set item image_location on location click
  $('.location_link').click ->
    # Get location data
    l = $(@).data().location
    $('#checkpoint_image_location').val("#{l.name}, on image ##{l.image_id}")
    $('#checkpoint_image_location').parent().effect 'highlight', {}, 500
