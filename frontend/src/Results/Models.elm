module Results.Models exposing(..)

import Date

type alias Result =
  {
    competitionId : String,
    location : String,
    date : String,
    points : Int
  }
