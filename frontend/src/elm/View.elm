module View exposing (..)


import Html exposing (..)
import Html.Attributes exposing (class, src, href)
import Html.App

import Messages exposing (Msg(..))
import Divisions.List
import Models exposing (Model)



view : Model -> Html Msg
view model =
  div [ class "container-fluid" ] [
    h1 [ class "text-center" ] [ text "Resultater Norgescup 2016-2017" ],
    page model,
    div [ class "jumbotron info-message" ] [
      p [] [text "Resultatene på denne siden oppdateres automatisk samme dag som resultater fra de aktuelle stevnene legges ut på terminlisten." ],
      p [] [text "Ved feil eller mangler i resultatene eller resultatoversikten forøvrig: kontakt ", a [ href "mailto:dag.olav.prestegarden@bueskyting.no" ] [ text "dag.olav.prestegarden@bueskyting.no" ]]
    ]
  ]
page : Model -> Html Msg
page model =
  Html.App.map DivisionMsg (Divisions.List.view model.divisions)
