module Divisions.List exposing(..)

import Html exposing (..)
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
  table [] [
    thead [] [
      tr [] [
        th [] [ text "name" ],
        th [] [ text "archers" ]
        ]
      ],
      tbody [] (List.map divisionRow divisions)
    ]
divisionRow : Division -> Html Msg
divisionRow division =
  tr[] [
    -- td [] [ text (toString division.name) ],
    td [] [ text division.division ],
    td [] [
      ul[] (List.map archerItem division.archers)
      ]
    ]

archerItem : Archer -> Html Msg
archerItem archer =
  li[] [ text archer.name ]
