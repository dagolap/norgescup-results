module Archers.Models exposing(..)

import Results.Models exposing(Result)

type alias Archer =
  {
    name : String,
    totalPoints : Int,
    individualResults : List Results.Models.Result
  }
