# Access global objects through Application.
window.Application ||= {}

jQuery ->
  ##  # table hover shows item location
  ##  $('#items_table tr').mouseenter ->
  ##    x=[$(@).children('[name^="x1"]').text(), $(@).children('[name^="x2"]').text()]
  ##    y=[$(@).children('[name^="y1"]').text(), $(@).children('[name^="y2"]').text()]
  ##    imageOffsetX=$("##{$(@).children('[name^="image_id"]').text()}").position().top
  ##    drawBox imageOffsetX, x[0], y[0], x[1], y[1]
  ##    $('.item_location').show()
  ##  $('#items_table tr').mouseleave ->
  ##    $('.item_location').hide()

  ##  $('.selector').dblclick (e) ->
  ##    window.location = "#{window.location.href.slice(window.location.href.indexOf('/zones/'))}/items?image_id=#{$(@).attr('id')}&x=#{e.pageX - $(@).offset().left}&y=#{e.pageY - $(@).offset().top}"
