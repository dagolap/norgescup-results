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
  div [ class "row" ] (List.map divisionRow divisions)

divisionRow : Division -> Html Msg
divisionRow division =
  div[ class "col-xs-12 col-md-6 col-lg-3" ] [
    h1 [] [ text division.division ],
    ol [] (List.map (\a -> archerItem division.division a) division.archers)
    ]

archerItem : String -> Archer -> Html Msg
archerItem divisionName archer =
  let
    collapseId = "collapse-" ++ (sanitize divisionName) ++ "-" ++ (sanitize archer.name)
  in
    li[] [
      div [ class "archer" ] [
        a [ attribute "data-toggle" "collapse", attribute "data-target" ("#" ++ collapseId) ] [ text(archer.name ++ " " ++ toString(archer.totalPoints)) ],
        div [ id collapseId, class "collapse" ] [
          ul [ class "list-inline" ] (List.map resultItem archer.results)
        ]
      ]
    ]

resultItem : Results.Models.Result -> Html Msg
resultItem result =
  li[] [
    div [ class "archer-result-list-item" ] [
      h4 [] [ text result.location ],
      h4 [] [ text result.date ],
      h4 [] [ text(toString result.points) ]
    ]
  ]
