module Main exposing (..)

import Html.App
import View exposing (view)
import Update exposing (update)
import Models exposing (Model, initialModel)
import Messages exposing (Msg(..))
import Divisions.Commands exposing (getAllDivisions)

init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.map DivisionMsg getAllDivisions)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


main : Program Never
main =
  Html.App.program
  {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }
