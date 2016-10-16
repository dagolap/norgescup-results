module Divisions.List exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Divisions.Models exposing (Division)
import Archers.Models exposing (Archer)
import Divisions.Messages exposing (..)

view : List Division -> Html Msg
view divisions =
  div [] [
    h1 [] [ text "divisions" ],
    divisionList divisions
  ]


divisionList : List Division -> Html Msg
divisionList divisions =
  div [ class "row" ] [
      div [ class "col-md-12" ] (List.map divisionRow divisions)
    ]
divisionRow : Division -> Html Msg
divisionRow division =
  div[ class "archers" ] [
    h1 [] [ text division.division ],
    ul[] (List.map archerItem division.archers)
    ]

archerItem : Archer -> Html Msg
archerItem archer =
  li[] [ text archer.name ]
