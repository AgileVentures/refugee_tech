module Api::V1::ActivitiesDoc
  extend Apipie::DSL::Concern

  api :GET, '/v1/activities', 'Get activity feed'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:
  [
    {
      "id":"1660157410904515_1665662493687340",
      "from":{
        "name":"Project Unify",
        "category":"Non-Profit Organization",
        "id":"1660157410904515"
      },
      "to":{
        "data":[
          {
            "name":"TRINE",
            "category":"Energy/Utility",
            "category_list":[
              {
                "id":"213577718658733",
                "name":"Investing Service"
              },
              {
                "id":"358483060859947",
                "name":"Startup"
              }
            ],
            "id":"869559659722349"
          }
        ]
      },
      "with_tags":{
        "data":[
          {
            "name":"Hanna Lindquist",
            "id":"10207445266344214"
          }
        ]
      },
      "message":"Last, but not least, to be introduced is our communications nerd...",
      "message_tags":{
        "296":[
          {
            "id":"869559659722349",
            "name":"TRINE",
            "type":"page",
            "offset":296,
            "length":5
          }
        ]
      },
      "story":"Project Unify with Hanna Lindquist at Sardinia Bay Nature Reserve.",
      "picture":"https://scontent.xx.fbcdn.net/hphotos-xat1/v/t1.0-0/s130x130/942809_1665662493687340_2569512325413414183_n.jpg?oh=c09b0b039402806ffb1e382bbb5a54bf\u0026oe=57575FFE",
      "link":"https://www.facebook.com/projectunifygbg/photos/a.1661082224145367.1073741828.1660157410904515/1665662493687340/?type=3",
      "name":"Timeline Photos",
      "icon":"https://www.facebook.com/images/icons/photo.gif",
      "actions":[
        {
          "name":"Share",
          "link":"https://www.facebook.com/1660157410904515/posts/1665662493687340"
        }
      ],
      "privacy":{
        "value":"",
        "description":"",
        "friends":"",
        "allow":"",
        "deny":""
      },
      "place":{
        "id":"174397302692886",
        "name":"Sardinia Bay Nature Reserve",
        "location":{
          "city":"Port Elizabeth",
          "country":"South Africa",
          "latitude":-34.0086079998,
          "longitude":25.5475680011,
          "zip":"6070"
        }
      },
      "type":"facebook",
      "status_type":"added_photos",
      "object_id":"1665662493687340",
      "created_time":"2016-02-07T19:23:54+0000",
      "updated_time":"2016-02-07T19:23:54+0000",
      "shares":{
        "count":1
      },
      "is_hidden":false,
      "is_expired":false,
      "likes":{
        "data":[
          {
            "id":"1359036403",
            "name":"Thomas Ochman"
          }
        ],
        "paging":{
          "cursors":{
            "after":"MTAxNTMzNTA5MjUyNDIzMjE=",
            "before":"MTM1OTAzNjQwMw=="
          }
        }
      },
      "comments":{
        "data":[
          {
            "id":"1671207373132852_1671269369793319",
            "from":{
              "name":"Mårten Westlund",
              "id":"10154087088918900"
            },
            "message":"Thanks for a row of interesting ideas and presentations.",
            "can_remove":false,
            "created_time":"2016-02-24T19:53:31+0000",
            "like_count":1,
            "user_likes":false
          }
        ],
        "paging":{
          "cursors":{
            "after":"WTI5dGJXVnVkRjlqZFhKemIzSTZNVFkzTVRVek1qRXhNekV3TURNM09Eb3hORFUyTkRFek5EYzA=",
            "before":"WTI5dGJXVnVkRjlqZFhKemIzSTZNVFkzTVRJMk9UTTJPVGM1TXpNeE9Ub3hORFUyTXpRek5qRXg="
          }
        }

    },
    ....
  ]
  )

  def index
  end
end
