module Models exposing (..)


import Divisions.Models exposing (Division)

type alias Model =
  {
    divisions : List Division
  }


initialModel : Model
initialModel =
  {
    divisions = []
  }

