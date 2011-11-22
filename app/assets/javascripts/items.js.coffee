jQuery ->
  $('#item_part_number').autocomplete
    minLength: 3,
    source: $('#item_part_number').data('autocomplete-source')


