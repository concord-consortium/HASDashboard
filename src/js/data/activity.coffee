module.exports = (activityId) ->
  "name": "Fake activity",
  "url": "/activities/#{activityId}",
  "id": activityId,
  "pages": [{
    "name": null,
    "id": 123,
    "url": "/activities/#{activityId}/pages/123",
    "questions": [{
        "index": 5,
        "name": "Multiple Choice Question element",
        "prompt": "why does ..."
      }, {
        "index": 6,
        "name": null,
        "prompt": "Explain your answer."
      }, {
        "index": 7,
        "name": "Multiple Choice Question element",
        "prompt": "How certain are you about your claim based on your explanation?"
      }, {
        "index": 8,
        "name": null,
        "prompt": "Explain what influenced your certainty rating."
      }]
  }, {
    "name": null,
    "id": 124,
    "url": "/activities/#{activityId}/pages/124",
    "questions": [{
      "index": 9,
      "name": "Multiple Choice Question element",
      "prompt": "why does ..."
    }, {
      "index": 10,
      "name": null,
      "prompt": "Explain your answer."
    }, {
      "index": 11,
      "name": "Multiple Choice Question element",
      "prompt": "How certain are you about your claim based on your explanation?"
    }, {
      "index": 12,
      "name": null,
      "prompt": "Explain what influenced your certainty rating."
    }]
  }]
