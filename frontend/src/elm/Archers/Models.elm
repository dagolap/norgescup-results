module Archers.Models exposing(..)

import Results.Models exposing(Result)

type alias Archer =
  {
    name : String,
    totalPoints : Int,
    club : String,
    results : List Results.Models.Result,
    archer_id : String
  }
