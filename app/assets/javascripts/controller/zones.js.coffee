# Access global objects through Application.
window.Application ||= {}

jQuery ->
  # Draws location box links on respective locations
  $('.location_link').each ->
    l = $(@).data().location
    console.log l
    Application.drawBox $(@), $('.selector'), l.x1, l.y1, l.x2, l.y2
