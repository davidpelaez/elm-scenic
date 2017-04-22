module Scenic exposing (programWithFlags, Msg, ProgramWithFlags, Outcome(..), LayoutState)

import Html exposing (Html, div, Attribute)
import Navigation exposing (Location)
import Html exposing (Html)
import Task
import Process
import Time exposing (Time, millisecond)
import Html.Attributes exposing (class, id)
import Html.Keyed as Keyed exposing (node)


type Outcome page
    = ChangePage page
    | KeepCurrentPage


type alias ProgramWithFlags flags msg page =
    { init : flags -> Location -> ( page, Cmd msg, Outcome page )
    , update : msg -> page -> ( page, Cmd msg, Outcome page )
    , subscriptions : page -> Sub msg
    , view : page -> Html msg
    , pageToUrl : page -> String
    , parseLocation : Location -> page
    }


type Msg page msg
    = LocationChange Location
    | GoToPage page
    | SetLayoutState (LayoutState page)
    | SubMsg msg


type LayoutState page
    = CurrentPageOnly page
    | NextPageWillEnter page page


nextPageView : List (Attribute (Msg page msg)) -> Html (Msg page msg) -> ( String, Html (Msg page msg) )
nextPageView attributes pageHtml =
    ( "next", div (class "animated" :: class "slideInRight" :: id "next" :: attributes) [ pageHtml ] )


currentPageView : List (Attribute (Msg page msg)) -> Html (Msg page msg) -> ( String, Html (Msg page msg) )
currentPageView attributes pageHtml =
    ( "current", div (id "current" :: attributes) [ pageHtml ] )


rootView : (page -> Html msg) -> LayoutState page -> Html (Msg page msg)
rootView childView layout =
    let
        mappedChildView page =
            childView page |> Html.map SubMsg
    in
        case layout of
            CurrentPageOnly current ->
                Keyed.node "div" [ class "transitionable" ] [ currentPageView [] (mappedChildView current) ]

            NextPageWillEnter current next ->
                Keyed.node "div" [ class "transitionable" ] [ currentPageView [] (mappedChildView current), nextPageView [] (mappedChildView next) ]


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep (time * millisecond)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


outcomeToCmd : Outcome page -> Cmd (Msg page msg)
outcomeToCmd outcome =
    case outcome of
        ChangePage newPage ->
            GoToPage newPage |> Task.perform identity << Task.succeed

        _ ->
            Cmd.none


programWithFlags : ProgramWithFlags flags msg page -> Program flags (LayoutState page) (Msg page msg)
programWithFlags desc =
    let
        wrappedInit : flags -> Location -> ( LayoutState page, Cmd (Msg page msg) )
        wrappedInit flags location =
            let
                -- initialPage : Location -> page
                -- initialPage location =
                --     desc.parseLocation location
                ( initialPage, initialCmd, routingOutcome ) =
                    desc.init flags location
            in
                ( CurrentPageOnly initialPage, Cmd.batch [ (Cmd.map SubMsg initialCmd), outcomeToCmd routingOutcome ] )

        wrappedUpdate : Msg page msg -> LayoutState page -> ( LayoutState page, Cmd (Msg page msg) )
        wrappedUpdate msg layout =
            case msg of
                SetLayoutState newLayout ->
                    newLayout
                        ! [ case newLayout of
                                CurrentPageOnly current ->
                                    Navigation.newUrl (desc.pageToUrl current)

                                NextPageWillEnter current next ->
                                    delay 1000 (SetLayoutState (CurrentPageOnly next))
                          ]

                GoToPage newPage ->
                    case layout of
                        CurrentPageOnly current ->
                            wrappedUpdate (SetLayoutState (NextPageWillEnter current newPage)) layout

                        _ ->
                            layout ! []

                SubMsg subMsg ->
                    case layout of
                        CurrentPageOnly currentPage ->
                            let
                                ( newPage, newCmd, routingOutcome ) =
                                    desc.update subMsg currentPage
                            in
                                ( layout, Cmd.batch [ (Cmd.map SubMsg newCmd), outcomeToCmd routingOutcome ] )

                        _ ->
                            layout ! []

                _ ->
                    layout ! []

        wrappedSubscriptions : LayoutState page -> Sub (Msg page msg)
        wrappedSubscriptions layout =
            -- TODO fix Sub.map SubMsg <| desc.subscriptions layout
            Sub.none

        wrappedView : LayoutState page -> Html (Msg page msg)
        wrappedView layout =
            rootView desc.view layout
    in
        Navigation.programWithFlags LocationChange
            { view = wrappedView
            , init = wrappedInit
            , update = wrappedUpdate
            , subscriptions = wrappedSubscriptions
            }
