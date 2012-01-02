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

  # Set item image_location on location click
  if $('.image_locator').length > 0
    $('.location_link').click ->
      # Get location data
      l = $(@).data().location
      $(@).val("#{l.name}, on image ##{l.image_id}")

  # Filter select checkpoints options on location click
  if $("#tasc_checkpoint_id").length > 0
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
      # If prompt is valid re-insert it
      if $("#tasc_checkpoint_id option").size() > 1
        $("#tasc_checkpoint_id").prepend(prompt)
