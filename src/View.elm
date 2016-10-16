module View exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Html exposing (..)

view : Model -> Html Msg
view model =
  text model
