jQuery ->

  # helper functions
  sortNumbers = (a,b) -> a-b
  drawBox = (el, x1, y1, x2, y2) ->
    # Force numeric addition
    x1 = x1*1 + el.position().left*1
    x2 = x2*1 + el.position().left*1
    y1 = y1*1 + el.position().top*1
    y2 = y2*1 + el.position().top*1
    $('.location_box').css('left', "#{x1}px")
    $('.location_box').css('top', "#{y1}px")
    $('.location_box').css('width', "#{Math.abs(x2-x1-3)}px")
    $('.location_box').css('height', "#{Math.abs(y2-y1-3)}px")
  # add location_box
  $('<div></div>').appendTo('.locator').addClass('location_box')

  # set vars based on form or show values
  d=$('#data_attributes').data()
  x=[d.location.x1, d.location.x2]
  y=[d.location.y1, d.location.y2]

  # show/hide helper on locator hover
  $('.locator').hover ->
    $('.locator_form').toggle()
    $('.locator_helper').toggle()

  drawBox $('.locator'), x[0], y[0], x[1], y[1]


  # selectable events
  $('.locator').selectable
    start: (e, ui) ->
      $('.location_box').hide()
      x[0]=e.originalEvent.pageX - $('.locator').offset().left*1
      y[0]=e.originalEvent.pageY - $('.locator').offset().top*1
      false
    stop: (e) ->
      x[1]=e.originalEvent.pageX - $('.locator').offset().left*1
      y[1]=e.originalEvent.pageY - $('.locator').offset().top*1
      x.sort(sortNumbers) && y.sort(sortNumbers)
      $('#location_x1').val(x[0])
      $('#location_y1').val(y[0])
      $('#location_x2').val(x[1])
      $('#location_y2').val(y[1])
      drawBox $(@), x[0], y[0], x[1], y[1]
      $('.location_box').show()
