module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Divisions.Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    DivisionMsg subMsg ->
      let
        (updatedDivisions, cmd) =
          Divisions.Update.update subMsg model.divisions
      in
        ( { model | divisions = updatedDivisions }, Cmd.map DivisionMsg cmd )
