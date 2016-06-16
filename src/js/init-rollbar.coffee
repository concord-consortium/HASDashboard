rollbar = require 'rollbar-browser'

# Guess environment based on the URL.
# Note that we use S3 deployment that follows some patterns:
# - production code is deployed to the top-level dir
# - branches are deployed to /branch/<branch-name> dir
# - versions are deployed to /version/<version-num> dir


host = window.location.hostname
path = window.location.pathname

# For localhost 127.0.0.* 168.192.* and *.local see http://regexr.com/3dl1e
localRegex = /\blocalhost|\b127\.0\.0|\b192\.168|0\.0\.0\.0|\.local\b/

versionString = switch
  when branch  = path.match /branch\/(.*)\//   then 'branch-'  + branch[1]
  when version = path.match /version\/(.*)\//  then 'version-' + version[1]
  else null

env = switch
  when host.match localRegex then 'local'
  when versionString then versionString
  else 'production'

config = {
  accessToken: '1be1724ac7f640a28f28d4891a94fd1a',
  captureUncaught: true,
  payload: {
    environment: env,
    host: window.location.host
  }
}

rollbar.init config if env != 'local'
