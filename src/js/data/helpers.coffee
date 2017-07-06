_ = require 'lodash'

# LARA Dashbaord API can accept timestamp and optimize DB query by filtering out submissions older
# than provided timestamp. It means that we need to keep them locally and merge each time we receive new data.
submissionCache = {}

# Converts data format v1 to v2.
version1to2 = (data) ->
  {
    runs: data,
    timestamp: null
  }

# Converts data to the last supported version.
exports.toLatestVersion = (data) ->
  data.version = 1 unless data.version
  switch data.version
    when 1 then version1to2(data)
    when 2 then data

# We have one run for each activity in a sequence
# They have the same endpoint_url so we need to
# find the last page by using updated_at information
# in order to generate the head-count numbers in the view
exports.getTocStudents = (runs, studentsPortalInfo) ->
  lastRuns = {}
  _.each runs, (run) ->
    last = lastRuns[run.endpoint_url] ||= run
    if run.updated_at > last.updated_at
      lastRuns[run.endpoint_url] = run
  return getBasicStudentData(_.values(lastRuns), studentsPortalInfo)

# Combines runs data provided by LARA and students data provided by Portal.
exports.getStudentsData = (runs, studentsPortalInfo, pageId) ->
  pageRuns = _.filter runs, (r) -> _.includes r.page_ids, pageId

  mergeCachedSubmissions(runs, submissionCache, pageId)
  students = getBasicStudentData pageRuns, studentsPortalInfo
  students = filterOutNonCRaterScores students
  students = addGroupsMembers students
  students

exports.getEndpointUrls = (studentsPortalInfo) ->
# Some students might have endpoint URL equal to null
# (it means they haven't started activity yet).
  _.compact(_.map studentsPortalInfo, (s) -> s.endpoint_url)

# Modifies provided list of runs to include all the submissions from the cache.
# Cache is updated too.
mergeCachedSubmissions = (runs, submissionCache, pageId) ->
  _.each runs, (r) ->
    # Limit submissions to given endpoint (run ID) and page.
    key = r.endpoint_url + '-' + pageId || "all"
    submissionCache[key] = (submissionCache[key] || []).concat(r.submissions)
    # Ensure that submissions are unique. In most cases we shouldn't receive duplicate submissions, but it might
    # happen (e.g. we receive complete data each time - old API, fake data).
    submissionCache[key] = _.uniq submissionCache[key], 'id'
    # Finally, update provided structure to include a complete list of submissions.
    r.submissions = submissionCache[key]

# Note that LARA doesn't return student names or user names.
getBasicStudentData = (runs, studentsPortalInfo) ->
  runByEndpoint = {}
  _.each runs, (r) ->
    runs = runByEndpoint[r.endpoint_url] || []
    runByEndpoint[r.endpoint_url] = _.concat(runs, r)
  studentByNameCount = {}
  _.each studentsPortalInfo, (s) ->
    studentByNameCount[s.name] ||= 0
    studentByNameCount[s.name] += 1
  _.map studentsPortalInfo, (student) ->
    runs = runByEndpoint[student.endpoint_url] || []
    {
      # Handle case when multiple students have the same name. Add unique username.
      name: if studentByNameCount[student.name] == 1 then student.name else "#{student.name} (#{student.username})"
      username: student.username
      lastPageId: _.max(_.map(runs, 'last_page_id'))
      submissions: _.flatten(_.map(runs,'submissions'))
      allSequenceAnswers: _.flatten(_.map(runs,'allSequenceAnswers'))
    }

# Note that LARA doesn't return student names or user names.
exports.mergeAllSequenceAnswers = (runs, studentsPortalInfo) ->
  runByEndpoint = {}
  _.each runs, (r) ->
    runByEndpoint[r.endpoint_url] ||= []
    runByEndpoint[r.endpoint_url].push(r)
  studentByNameCount = {}
  _.each studentsPortalInfo, (s) ->
    studentByNameCount[s.name] ||= 0
    studentByNameCount[s.name] += 1
  _.map studentsPortalInfo, (student) ->
    _runs = runByEndpoint[student.endpoint_url] || []
    allSequenceAnswers = {}
    _.each _runs, (run) ->
      if run.answers
        _.map run.answers, (a) ->
          allSequenceAnswers[a.page] = a
    {
      # Handle case when multiple students have the same name. Add unique username.
      name: if studentByNameCount[student.name] == 1 then student.name else "#{student.name} (#{student.username})"
      username: student.username
      allSequenceAnswers: allSequenceAnswers
    }


# Do not display scores of non-CRater questions
filterOutNonCRaterScores = (students) ->
  _.each students, (student) ->
    _.each student.submissions, (s) ->
      _.each s.answers, (a) ->
        if a.feedback_type != 'CRater::FeedbackItem'
          delete a.score
  students

# LARA provides only group_id for every submission. Use that data
# to generate group members and add it to submission info.
addGroupsMembers = (students) ->
  groups = {}
  _.each students, (student) ->
    _.each student.submissions, (s) ->
      if s.group_id?
        groups[s.group_id] ||= []
        groups[s.group_id].push student.name
  # Remove duplicates.
  for groupId, group of groups
    groups[groupId] = _.uniq group
  # Add group members to submission objects.
  _.each students, (student) ->
    _.each student.submissions, (submission) ->
      # Remove student from its own group. _.without returns copy of an array.
      submission.group = _.without(groups[submission.group_id], student.name) if submission.group_id?
  students


exports.getAllQuestions = (sequence) ->
  questions = _.flatMapDeep sequence.activities, (act, actindex) ->
    pages  = _.map act.pages, (page,index) ->
      index: index+1
      pageId: page.id
      name: "#{actindex+1}-#{index+1} #{page.name }"
      questions: page.questions
    _.filter(pages, (page) -> page.questions.length > 0)


  return questions