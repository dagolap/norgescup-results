
module Divisions.Models exposing(..)

import Archers.Models exposing (Archer)

type alias Division =
  {
    division : String,
    archers : List Archer
  }
