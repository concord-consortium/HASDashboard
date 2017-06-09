configs =
  0:
    tocUrl: (base, resources, id) -> "#{base}/#{resources}/#{id}/dashboard_toc"
    dashRunsUrl: (base) -> "#{base}/runs/dashboard"
    allSequenceRunsUrl: (base) -> "#{base}/api/v1/dashboard_runs_all"
  1:
    tocUrl: (base, resources, id) -> "#{base}/api/v1/dashboard_toc/#{resources}/#{id}"
    dashRunsUrl: (base) -> "#{base}/api/v1/dashboard_runs"
    allSequenceRunsUrl: (base) -> "#{base}/api/v1/dashboard_runs_all"

class UrlHelper
  constructor: (@version=0) ->

  tocUrl: (base, resources, id) ->
    configs[@version].tocUrl(base,resources,id)

  dashRunsUrl: (base) ->
    configs[@version].dashRunsUrl(base)

  allSequenceRunsUrl: (base) ->
    configs[@version].allSequenceRunsUrl(base)

module.exports = UrlHelper