jQuery ->
  # helper functions
  drawBox = (el, ref, x1, y1, x2, y2) ->
    # Force numeric addition
    x1 = x1*1 + ref.position().left*1
    x2 = x2*1 + ref.position().left*1
    y1 = y1*1 + ref.position().top*1
    y2 = y2*1 + ref.position().top*1
    el.css('left', "#{x1}px")
    el.css('top', "#{y1}px")
    el.css('width', "#{Math.abs(x2-x1-3)}px")
    el.css('height', "#{Math.abs(y2-y1-3)}px")

  # set vars based on form or show values
  $('.location_link').each ->
    l = $(@).data().location
    drawBox $(@), $('.selector'), l.x1, l.y1, l.x2, l.y2
