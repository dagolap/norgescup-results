module Main exposing (..)

import Html.App
import View exposing (view)
import Update exposing (update)
import Models exposing (Model, initialModel)
import Messages exposing (Msg(..))

init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


main =
  Html.App.program
  {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }
