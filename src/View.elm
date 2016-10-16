module View exposing (..)


import Html exposing (..)
import Html.App

import Messages exposing (Msg(..))
import Divisions.Messages
import Divisions.List
import Models exposing (Model)



view : Model -> Html Msg
view model =
  div [] [
    page model
  ]
page : Model -> Html Msg
page model =
  Html.App.map DivisionMsg (Divisions.List.view model.divisions)
