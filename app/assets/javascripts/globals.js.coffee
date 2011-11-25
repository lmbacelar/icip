# Global Scoped Objects
#

# Access global objects through Application.
#
window.Application ||= {}

# Defines sort criteria for numbers.
#
# USAGE:
#  (object).sort(Application.sortNumbers)
#
Application.sortNumbers = (a,b) -> a-b

# Draws element 'el', on coordinates 'x1,y1,x2,y2' referenced to
# element 'ref'.
#
# USAGE:
#  drawBox $('element'), $('ref_element'), 0, 0, 10, 10
#
Application.drawBox = (el, ref, x1, y1, x2, y2) ->
  # Multiplication forces numeric addition.
  x1 = x1*1 + ref.position().left*1
  x2 = x2*1 + ref.position().left*1
  y1 = y1*1 + ref.position().top*1
  y2 = y2*1 + ref.position().top*1
  el.css('left', "#{x1}px")
  el.css('top', "#{y1}px")
  el.css('width', "#{Math.abs(x2-x1-3)}px")
  el.css('height', "#{Math.abs(y2-y1-3)}px")
