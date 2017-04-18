module Main exposing (..)

import Scenic exposing (programWithFlags, ProgramWithFlags, Outcome(..))
import Navigation exposing (Location)
import Html.Events exposing (onClick)
import UrlParser exposing ((</>), (<?>), s, int, stringParam, top, string, map, Parser)
import Html exposing (Html, text, button, div)


type alias RoutingOutcome =
    Outcome Page


type Route
    = AlohaRoute
    | OtherRoute
    | NotFoundRoute


possibleRoutes : Parser (Route -> x) x
possibleRoutes =
    UrlParser.oneOf
        [ map AlohaRoute top
        , map OtherRoute (s "other")
        ]


parseRoute : Location -> Route
parseRoute location =
    UrlParser.parsePath possibleRoutes location
        |> Maybe.withDefault NotFoundRoute


type Msg
    = NoOp
    | GoToPage Page


type alias InitFlags =
    {}


type Page
    = WelcomePage
    | OtherPage
    | MenuPage


main : Program InitFlags (Scenic.LayoutState Page) (Scenic.Msg Page Msg)
main =
    Scenic.programWithFlags
        { view = view
        , init = initWithFlags
        , update = update
        , subscriptions =
            (\page -> Sub.none)
        , pageToRoute = pageToRoute
        , routeToPage = routeToPage
        , parseRoute = parseRoute
        }


pageToRoute : Page -> Route
pageToRoute page =
    NotFoundRoute


routeToPage : Route -> Page
routeToPage route =
    WelcomePage


update : Msg -> Page -> ( Page, Cmd Msg, RoutingOutcome )
update msg page =
    case msg of
        GoToPage newPage ->
            ( page, Cmd.none, ChangePage newPage )

        _ ->
            ( page, Cmd.none, KeepCurrentPage )


transitionButton : Page -> Html Msg
transitionButton page =
    button [ onClick <| GoToPage page ] [ text <| ("Go to " ++ toString page) ]


view : Page -> Html Msg
view page =
    case page of
        MenuPage ->
            div [] [ text "MENU", transitionButton OtherPage ]

        WelcomePage ->
            div [] [ text "WELCOME", transitionButton MenuPage ]

        OtherPage ->
            div [] [ text "OTHER", transitionButton WelcomePage ]


subscriptions : Page -> Sub Msg
subscriptions page =
    Sub.none


initWithFlags : InitFlags -> Route -> ( Page, Cmd Msg, RoutingOutcome )
initWithFlags flags route =
    let
        _ =
            Debug.log "Booting with flags" (toString flags)

        --
        -- route =
        --     parseRoute location
        --
        -- _ =
        --     Debug.log "Booting with location" (toString location)
        --
        -- _ =
        --     Debug.log "Booting with route" (toString route)
        --
        -- ( page, redirectMsg ) =
        --     case flags.apiKey of
        --         Just apiKey ->
        --             Routing.privatePageOfRoute apiKey route
        --
        --         Nothing ->
        --             Routing.publicPageOfRoute route
        --
        -- ( updatedPage, initialCmd ) =
        --     update redirectMsg <|
        --         { layout = CurrentPageOnly page }
    in
        ( WelcomePage, Cmd.none, KeepCurrentPage )
