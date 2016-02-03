_ = require 'lodash'

# We have one run for each activity in a sequence
# They have the same endpoint_url so we need to
# find the last page by using updated_at information
# in order to generate the head-count numbers in the view
exports.getTocStudents = (runs) ->
  lastRuns = {}
  _.each runs, (run) ->
    last = lastRuns[run.endpoint_url] ||= run
    if run.updated_at > last.updated_at
      lastRuns[run.endpoint_url] = run
  _.chain(lastRuns)
  .values()
  .map( (run) ->
    {
      lastPageId: run.last_page_id
      submissions: run.submissions
      lastPageId: run.last_page_id
    }
  ).value()

# Combines runs data provided by LARA and students data provided by Portal.
exports.getStudentsData = (runs, studentsPortalInfo, page_id) ->
  page_runs = _.select runs, (r) -> _.includes r.page_ids, page_id
  students = getBasicStudentData page_runs, studentsPortalInfo
  students = filterOutNonCRaterScores students
  students = addGroupsMembers students
  students

exports.getEndpointUrls = (studentsPortalInfo) ->
# Some students might have endpoint URL equal to null
# (it means they haven't started activity yet).
  _.compact(_.map studentsPortalInfo, (s) -> s.endpoint_url)

# Note that LARA doesn't return student names or user names.
getBasicStudentData = (runs, studentsPortalInfo) ->
  runByEndpoint = {}
  _.each runs, (r) -> runByEndpoint[r.endpoint_url] = r
  studentByNameCount = {}
  _.each studentsPortalInfo, (s) ->
    studentByNameCount[s.name] ||= 0
    studentByNameCount[s.name] += 1
  _.map studentsPortalInfo, (student) ->
    run = runByEndpoint[student.endpoint_url] || {}
    {
      # Handle case when multiple students have the same name. Add unique username.
      name: if studentByNameCount[student.name] == 1 then student.name else "#{student.name} (#{student.username})"
      username: student.username
      lastPageId: run.last_page_id
      submissions: run.submissions
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
