module Archers.Models exposing(..)

import Results.Models exposing(Result)

type alias Archer =
  {
    name : String,
    totalPoints : Int,
    club : String,
    individualResults : List Results.Models.Result
  }
