module Divisions.Update exposing(..)

import Divisions.Messages exposing(Msg(..))

import Divisions.Models exposing (Division)
import Debug exposing (log)

update : Msg -> List Division -> (List Division, Cmd Msg)
update message divisions =
  case message of
    GetAllDivisionsDone newDivisions ->
      ( newDivisions, Cmd.none)
    GetAllDivisionsFail error ->
      log (toString error)
      ( divisions, Cmd.none)
