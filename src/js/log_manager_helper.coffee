_ = require "lodash"

class LogManagerHelper
  @logManagerUrl   = "//cc-log-manager.herokuapp.com/api/logs"
  @applicationName = "HASBot-Dashoard"

  constructor: (initial_data={}) ->
    @data = _.assign initial_data,
      application: LogManagerHelper.applicationName

  log: (data) ->
  if (typeof data == 'string')
      data =
        event: data
    timestamp =
      time: Date.now();
    @data = _.assign(@data,data,timestamp) # update our defaults
    try
      request = new XMLHttpRequest()
      request.open('POST', LogManagerHelper.logManagerUrl, true);
      request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
      request.send(JSON.stringify(@data));

    catch
      if console
        console.log? "Unable to log data:"
        console.dir? data


module.exports= LogManagerHelper