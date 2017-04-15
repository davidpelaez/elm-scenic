module Main exposing (..)

import Types.App exposing (Msg, Model, LayoutState(CurrentPageOnly), Page(WelcomePage))
import Updaters.Main exposing (update)
import Views.Main exposing (rootView)
import Types.App exposing (Model, Msg)
import Html exposing (Html)


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


view : Model -> Html Msg
view model =
    rootView model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    CurrentPageOnly WelcomePage ! []
