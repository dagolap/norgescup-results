module Divisions.List exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)


import Divisions.Messages exposing (..)

import Divisions.Models exposing (Division)
import Archers.Models exposing (Archer)
import Results.Models exposing (Result)

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
    ul[] (List.map archerItem division.archers)
    ]

archerItem : Archer -> Html Msg
archerItem archer =
  li[] [
    div [ class "archer" ] [
      h3 [] [ text archer.name ],
      ul [ class "archer-result-list" ] (List.map resultItem archer.results)
      ]
    ]

resultItem : Results.Models.Result -> Html Msg
resultItem result =
  li [] [
    div [ class "archer-result-list-item" ] [
      h4 [] [ text result.location ],
      h4 [] [ text result.date ],
      h4 [] [ text(toString result.points) ]
      ]
    ]
