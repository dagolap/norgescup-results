module Models exposing (..)

import Date

type alias Model =
  String

type alias Result =
  {
    competitionId : Int,
    location : String,
    date : Date.Date,
    points : Int
  }

type alias Archer =
  {
    name : String,
    totalPoints : Int,
    individualResults : List Result
  }

type alias Division =
  {
    name : String,
    archers : List Archer
  }

initialModel : Model
initialModel =
  "Hello World"

