# Access global objects through Application.
window.Application ||= {}

jQuery ->
  # set vars based on form or show values
  $('.location_link').each ->
    l = $(@).data().location
    Application.drawBox $(@), $('.selector'), l.x1, l.y1, l.x2, l.y2
