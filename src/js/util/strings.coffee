strings =
  "~REPORT": "Argument Report"
  "~MODULE_SUMMARY": "Module Summary"

stringFor = (key) ->
  return strings[key] || key

module.exports= stringFor