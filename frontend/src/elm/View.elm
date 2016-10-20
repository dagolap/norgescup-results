module View exposing (..)


import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.App

import Messages exposing (Msg(..))
import Divisions.Messages
import Divisions.List
import Models exposing (Model)



view : Model -> Html Msg
view model =
  div [ class "container-fluid" ] [
    h1 [ class "text-center" ] [ text "Resultatliste NorgesCup 2016/2017" ],
    -- img [ src "/static/img/img_parallax.jpg" ] [],
    page model
  ]
page : Model -> Html Msg
page model =
  Html.App.map DivisionMsg (Divisions.List.view model.divisions)