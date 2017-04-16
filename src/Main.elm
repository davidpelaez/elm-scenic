module Main exposing (..)

import Html exposing (Html)
import Task
import Process
import Time exposing (Time, millisecond)
import Html exposing (..)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed exposing (node)


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


type Msg
    = Log String
    | SetLayoutState LayoutState
    | GoToPage Page


type alias Model =
    LayoutState


type LayoutState
    = CurrentPageOnly Page
    | NextPageWillEnter Page Page


type Page
    = WelcomePage
    | OtherPage
    | MenuPage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    CurrentPageOnly WelcomePage ! []


nextPageView : List (Attribute Msg) -> Page -> ( String, Html Msg )
nextPageView attributes page =
    ( "next", div (class "animated" :: class "slideInRight" :: id "next" :: attributes) [ renderPage page ] )


currentPageView : List (Attribute Msg) -> Page -> ( String, Html Msg )
currentPageView attributes page =
    ( "current", div (id "current" :: attributes) [ renderPage page ] )


rootView : LayoutState -> Html Msg
rootView layout =
    case layout of
        CurrentPageOnly current ->
            Keyed.node "div" [ class "transitionable" ] [ currentPageView [] current ]

        NextPageWillEnter current next ->
            Keyed.node "div" [ class "transitionable" ] [ currentPageView [] current, nextPageView [] next ]


transitionButton : Page -> Html Msg
transitionButton page =
    button [ onClick <| GoToPage page ] [ text <| ("Go to " ++ toString page) ]


renderPage : Page -> Html Msg
renderPage page =
    case page of
        MenuPage ->
            div [] [ text "MENU", transitionButton OtherPage ]

        WelcomePage ->
            div [] [ text "WELCOME", transitionButton MenuPage ]

        OtherPage ->
            div [] [ text "OTHER", transitionButton WelcomePage ]


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep (time * millisecond)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLayoutState newLayout ->
            let
                nextCmd =
                    case newLayout of
                        CurrentPageOnly current ->
                            Cmd.none

                        NextPageWillEnter current next ->
                            delay 1000 (SetLayoutState (CurrentPageOnly next))
            in
                newLayout ! [ nextCmd ]

        GoToPage newPage ->
            case model of
                CurrentPageOnly current ->
                    update (SetLayoutState (NextPageWillEnter current newPage)) model

                _ ->
                    model ! []

        Log x ->
            let
                _ =
                    Debug.log "LOGGING" x
            in
                model ! []
