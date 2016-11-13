module Divisions.Commands exposing(..)

import Json.Decode as Decode exposing ((:=))
import Task
import Http

import Divisions.Models exposing (Division)
import Archers.Models exposing (Archer)
import Results.Models exposing (Result)

import Divisions.Messages exposing (..)

getDivisionsAPIUrl : String
getDivisionsAPIUrl =
  -- "http://localhost:4000/divisions"
  "https://norgescup.bueskyting.no/api/scoreboard"


getAllDivisions : Cmd Msg
getAllDivisions =
  Http.get divisionListDecoder getDivisionsAPIUrl
    |> Task.perform GetAllDivisionsFail GetAllDivisionsDone

divisionDecoder : Decode.Decoder Division
divisionDecoder =
  Decode.object2 Division
    ("division" := Decode.string)
    ("archers" := archerListDecoder)


archerDecoder : Decode.Decoder Archer
archerDecoder =
  Decode.object5 Archer
    ("name" := Decode.string)
    ("total" := Decode.int)
    ("club" := Decode.string)
    ("individual_results" := resultListDecoder)
    ("id" := Decode.string)

resultDecoder : Decode.Decoder Results.Models.Result
resultDecoder =
  Decode.object4 Result
    ("competition_id" := Decode.string)
    ("location" := Decode.string)
    ("date" := Decode.string)
    ("result" := Decode.int)


divisionListDecoder : Decode.Decoder (List Division)
divisionListDecoder =
  Decode.list divisionDecoder

resultListDecoder : Decode.Decoder (List Results.Models.Result)
resultListDecoder =
  Decode.list resultDecoder

archerListDecoder : Decode.Decoder (List Archer)
archerListDecoder =
  Decode.list archerDecoder

