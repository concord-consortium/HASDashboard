rollbar = require 'rollbar-browser'

# Guess environment based on the URL.
# Note that we use S3 deployment that follows some patterns:
# - production code is deployed to the top-level dir
# - branches are deployed to /branch/<branch-name> dir
# - versions are deployed to /version/<version-num> dir
env = 'production'
if window.location.hostname == 'localhost'
  env = 'local'
else if branch = window.location.pathname.match /branch\/(.*)\//
  env = 'branch-' + branch[1]
else if version = window.location.pathname.match /version\/(.*)\//
  env = 'version-' + version[1]

config = {
  accessToken: '1be1724ac7f640a28f28d4891a94fd1a',
  captureUncaught: true,
  payload: {
    environment: env,
    host: window.location.host
  }
}

rollbar.init config
