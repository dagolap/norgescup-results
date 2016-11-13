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
  div [ class "row auto-clear" ] (List.map divisionRow <| List.reverse <| List.sortBy (\x -> List.length x.archers) divisions)

divisionRow : Division -> Html Msg
divisionRow division =
  div [ class "col-xs-12 col-md-6 col-lg-4" ] [
    div [ class "division-box" ] [
    h2 [ class "text-center" ] [ text division.division ],
    div [ id ((sanitize division.division) ++ "-" ++ "accordion"), class "panel-group" ] (List.map (\a -> archerItem division.division a) (List.reverse (List.sortBy .totalPoints division.archers)))
    ]
  ]

getAttributes : Int -> String -> String -> List (Html.Attribute a)
getAttributes points divisionName collapseId =
  if points > 0 then
    [ class "panel-heading clickable-panel"
        , attribute "data-toggle" "collapse"
        , attribute "data-target" ("#" ++ collapseId)
        , attribute "data-parent" ("#" ++ (sanitize divisionName) ++ "-accordion")]
  else
    [ class "panel-heading" ]


archerItem : String -> Archer -> Html Msg
archerItem divisionName archer =
  let
    collapseId = "collapse-" ++ archer.archer_id
    attributes = (getAttributes archer.totalPoints divisionName collapseId)
  in
    div [ class "panel panel-default" ] [
      div attributes [
        h4 [ class "panel-title" ] [
          span [ ] [ text archer.name ],
          div [] [
            span [ class "small" ] [ text archer.club ],
            span [ class "pull-right" ] [ text (toString archer.totalPoints) ]
          ]
        ]
      ],
      div [ id collapseId, class "panel-collapse collapse" ] [
        div [ class "panel-body result-panel" ] (List.map resultItem <| List.take 3 <| List.reverse <| List.sortBy .points archer.results)
      ]
    ]

resultItem : Results.Models.Result -> Html Msg
resultItem result =
  div [ class "col-xs-12 individual-result-box" ] [
      span [ class "small" ] [ text (result.date ++ " - " ++ result.location) ],
      span [ class "pull-right small" ] [ text(toString result.points) ]
  ]
