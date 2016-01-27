_ = require 'lodash'

# Combines runs data provided by LARA and students data provided by Portal.
exports.getStudentsData = (runs, studentsPortalInfo) ->
  students = getBasicStudentData runs, studentsPortalInfo
  students = filterOutNonCRaterScores students
  students = addGroupsMembers students
  students

exports.getEndpointUrls = (studentsPortalInfo) ->
# Some students might have endpoint URL equal to null
# (it means they haven't started activity yet).
  _.compact(_.map studentsPortalInfo, (s) -> s.endpoint_url)

# Note that LARA doesn't return student names or user names.
getBasicStudentData = (runs, studentsPortalInfo) ->
  runByEndpointUrl = {}
  _.each runs, (r) -> runByEndpointUrl[r.endpoint_url] = r
  studentByNameCount = {}
  _.each studentsPortalInfo, (s) ->
    studentByNameCount[s.name] ||= 0
    studentByNameCount[s.name] += 1
  _.map studentsPortalInfo, (s) ->
    runData = runByEndpointUrl[s.endpoint_url] || {}
    {
      # Handle case when multiple students have the same name. Add unique username.
      name: if studentByNameCount[s.name] == 1 then s.name else "#{s.name} (#{s.username})"
      username: s.username
      lastPageId: runData.last_page_id
      submissions: runData.submissions
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
