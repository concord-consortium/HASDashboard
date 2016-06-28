configs =
  0:
    tocUrl: (base, resources, id) -> "#{base}/#{resources}/#{id}/dashboard_toc"
    dashRunsUrl: (base) -> "#{base}/runs/dashboard"
  1:
    tocUrl: (base, resources, id) -> "#{base}/api/v1/dashboard_toc/#{resources}/#{id}"
    dashRunsUrl: (base) -> "#{base}/api/v1/dashboard_runs"

class UrlHelper
  constructor: (@version=0) ->

  tocUrl: (base, resources, id) ->
    configs[@version].tocUrl(base,resources,id)

  dashRunsUrl: (base) ->
    configs[@version].dashRunsUrl(base)

module.exports = UrlHelper