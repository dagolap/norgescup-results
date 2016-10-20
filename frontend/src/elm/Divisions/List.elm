module Divisions.List exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)

import String exposing (words, toLower, join)


import Divisions.Messages exposing (..)

import Divisions.Models exposing (Division)
import Archers.Models exposing (Archer)
import Results.Models exposing (Result)


sanitize : String -> String
sanitize str =
  join "-" (List.map toLower (words str))

view : List Division -> Html Msg
view divisions =
  divisionList divisions

divisionList : List Division -> Html Msg
divisionList divisions =
  div [ class "row auto-clear" ] (List.map divisionRow divisions)

divisionRow : Division -> Html Msg
divisionRow division =
  div [ class "col-xs-12 col-md-6 col-lg-4"] [
    h1 [ class "text-center" ] [ text division.division ],
    div [ id ((sanitize division.division) ++ "-" ++ "accordion"), class "panel-group" ] (List.map (\a -> archerItem division.division a) (List.reverse (List.sortBy .totalPoints division.archers)))
  ]

archerItem : String -> Archer -> Html Msg
archerItem divisionName archer =
  let
    collapseId = "collapse-" ++ (sanitize divisionName) ++ "-" ++ (sanitize archer.name)
  in
    div [ class "panel panel-default" ] [
      div [ class "panel-heading" ] [
        h4 [ class "panel-title" ] [
          a [ href ("#" ++ collapseId), attribute "data-toggle" "collapse", attribute "data-parent" ("#" ++ (sanitize divisionName) ++ "-accordion") ] [
            span [ ] [ text archer.name ],
            span [ class "pull-right" ] [ text (toString archer.totalPoints) ]
          ]
        ]
      ],
      div [ id collapseId, class "panel-collapse collapse" ] [
        div [ class "panel-body" ] (List.map resultItem archer.results)
      ]
    ]

resultItem : Results.Models.Result -> Html Msg
resultItem result =
  div [ class "col-xs-12 col-md-4 col-lg-4" ] [
    div [ class "panel panel-default" ] [
      div [ class "panel-heading" ] [
        h6 [ class "text-center panel-title" ] [
          text result.date
        ]
      ],
      div [ class "panel-body" ] [
        span [] [ text result.location ],
        span [ class "pull-right" ] [ text(toString result.points) ]
      ]
    ]
  ]
