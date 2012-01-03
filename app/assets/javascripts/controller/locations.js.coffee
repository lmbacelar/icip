# Access global objects through Application.
window.Application ||= {}

jQuery ->

  # add location_box
  $('<div></div>').appendTo('.locator').addClass('location_box')

  # set vars based on form or show values
  d=$('#data_attributes').data()
  x=[d.location.x1, d.location.x2]
  y=[d.location.y1, d.location.y2]

  # draw location box on image location
  Application.drawBox $('.location_box'), $('.locator'), x[0], y[0], x[1], y[1]

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
      x.sort(Application.sortNumbers) && y.sort(Application.sortNumbers)
      $('#location_x1').val(x[0])
      $('#location_y1').val(y[0])
      $('#location_x2').val(x[1])
      $('#location_y2').val(y[1])
      $('#location_x1').parent().effect 'highlight', {}, 500
      $('#location_y1').parent().effect 'highlight', {}, 500
      $('#location_x2').parent().effect 'highlight', {}, 500
      $('#location_y2').parent().effect 'highlight', {}, 500
      Application.drawBox $('.location_box'), $(@), x[0], y[0], x[1], y[1]
      $('.location_box').show()
