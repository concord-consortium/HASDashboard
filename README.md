# Teacher Dashboard reporting for HAS

### Development
1. Have `dashboard_report` branches of both LARA and RIGSE checked out.
1. Run RIGSE on port 9000, run LARA on port 3000.
1. Install dependencies: `yarn`
1. Run development server: `webpack-dev-server`


## TODO:
* Actual documentation
* Add rollbars logging
* Get correct GA token


## API  & Fake Data documentation ##


### Get the student runs from LARA for a given page eg: `LARA/api/v1/dashboard_runs`:

      @apiCall
        url: @urlHelper.dashRunsUrl(@state.laraBaseUrl)
        data:
          page_id: pageId,
          endpoint_urls: dataHelpers.getEndpointUrls(@state.studentsPortalInfo)
          submissions_created_after: @getPageDataTimestamp(pageId)
        dataType: "jsonp"
        success: handleRunsData

Dashboard run sample data (response from LARA):

    [
      {
        "endpoint_url": "pfw5tda9m4eosqj",
        "last_page_id": 1,
        "group_id": null,
        "submissions": [
          {
            "id": 397,
            "group_id": null,
            "created_at": 1496697234813,
            "answers": [
              {
                "question_index": 21,
                "answer": {
                  "page": "Page 3",
                  "pageId": 3,
                  "pageIndex": 0,
                  "tryCount": 1,
                  "numQuestions": 4,
                  "answers": [
                    {
                      "question_index": 5,
                      "feedback": "feedback text from c-rater here",
                      "feedback_type": "Embeddable::FeedbackItem",
                      "score": 0,
                      "max_score": 0
                    },…
                  ]
                }
              }, …
          }, …
        ]
      }, …
    ]


### Get all the (most recent) student answers for a sequence: `LARA/api/v1/dashboard_runs_all`
TBD: This will take an regular run or sequence run as an argument in LARA
Fake Data Generation: `../data/fake_runs.coffee` `#allSequenceAnswers`
Fake Data Sample: `../data/sample-lara-all-sequence-answers.json`

All Answers sample data (response from LARA):

    [
        {
          "endpoint_url": "b83lt1rex2punm4",
          "answers": [
            {
              "page": "Page 1",
              "pageId": 1,
              "pageIndex": 0,
              "tryCount": 0,
              "numQuestions": 4,
              "answers": []
            }, …
          ]
        }, …
    ]

### Get the structure (TOC) for a sequence: `LARA/api/v1/dashboard_toc/#{resources}/#{id}`
See:`setSequence` in `app.coffee`
Fake Data Generation: `../data/fake_sequence.coffee`
Fake Data Sample: `../data/sample-lara-sequence.json`

      @apiCall
        url: tocUrl
        success: setSequence
        dataType: "jsonp"
        errorContext: "loading table of contents"

TOC sample data (response from LARA):

      {
        "name": "Sample Sequence",
        "url": "https://localhost:3000/sequences/123",
        "activities": [
          {
            "name": "Fake activity 1",
            "url": "/activities/1",
            "id": 1,
            "pages": [
              {
                "name": "Page 1",
                "id": 1,
                "url": "/activities/1/pages/1",
                "questions": [
                  {
                    "index": 1,
                    "name": "Multiple Choice Question element",
                    "prompt": "why does ..."
                  }, …
                ]
              }, …
            ]
          }, …
        ]
      }





### Get the Offering data from the portal (Students & etc.) `PORTAL/api/v1/offerings`:
See `class API::V1::Offering` and `report/external_report` in portal for more info.
See: `setOffering` in `app.coffee`
Fake Data Generation: `../data/fake_offering.coffee`

Offering Sample data(response from portal)

    {
      "activity_url": "http://concordfake.org/activities/123",
      "students": [
        {
          "name": "Kareem Nima",
          "username": "kareemnima90",
          "endpoint_url": "x3r1stgl2pqbf6k"
        },
       …
        {
          "name": "Luna Nima",
          "username": "lunanima579",
          "endpoint_url": "fdtiq23x4167ncs"
        }
      ]
    }