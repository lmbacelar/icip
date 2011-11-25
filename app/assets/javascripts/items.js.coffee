# Access global objects through Application.
window.Application ||= {}

jQuery ->
  $('#item_part_number').autocomplete
    minLength: 3,
    source: $('#item_part_number').data('autocomplete-source')

  $('#item_location').autocomplete
    minLength: 3,
    source: $('#item_location').data('autocomplete-source')
