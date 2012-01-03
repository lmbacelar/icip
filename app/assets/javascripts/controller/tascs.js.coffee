jQuery ->
  $('#filter_checkpoints_help').effect 'pulsate', {times:2}, 500

  # Save original checkpoints and first option (prompt?)
  checkpoints = $("#tasc_checkpoint_id").html()
  prompt = $("#tasc_checkpoint_id option:first")
  $('.location_link').click ->
    # Get location data
    l = $(@).data().location
    # Restore original checkpoints
    $("#tasc_checkpoint_id").html(checkpoints)
    # Remove options not matching selected location
    $("#tasc_checkpoint_id option[data-location_name!='#{l.name}']").remove()
    # If more than one match and prompt is valid re-insert it
    if $("#tasc_checkpoint_id option").size() > 1
      console.log prompt
      if prompt.val() == ""
        $("#tasc_checkpoint_id").prepend(prompt)
    $("#tasc_checkpoint_id").parent().effect 'highlight', {}, 500
