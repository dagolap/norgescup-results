module Divisions.Messages exposing (..)

import Http
import Divisions.Models exposing (Division)

type Msg
  = GetAllDivisionsDone (List Division)
  | GetAllDivisionsFail Http.Error
