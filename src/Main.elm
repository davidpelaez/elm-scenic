module Main exposing (..)

import Scenic exposing (programWithFlags, ProgramWithFlags, Outcome(..))
import Navigation exposing (Location)
import Html.Events exposing (onClick)
import UrlParser exposing ((</>), (<?>), s, int, stringParam, top, string, map, Parser)
import Html exposing (Html, text, button, div)
import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top)


--
-- xarvh
-- [4:32 PM]
-- I think so
--
-- [4:32]
-- why do you have a `routeToPage` and a `parseRoute`?
--
-- [4:33]
-- rather than, say a `locationToPage`?
--
-- davidpelaez [4:34 PM]
-- maybe only locationToPage and the reverse are needed. The idea is that you have a way from a URL into a page and when you change to a page that should become a URL.


type alias RoutingOutcome =
    Outcome Page



--
-- type Route
--     = AlohaRoute
--     | OtherRoute
--     | NotFoundRoute
--
--
-- parseRoute : Location -> Route
-- parseRoute location =
--     UrlParser.parsePath possibleRoutes location
--         |> Maybe.withDefault NotFoundRoute
--


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
        , pageToUrl = pageToUrl
        , parseLocation = parseLocation
        }


parseLocation : Location -> Page
parseLocation location =
    UrlParser.parsePath possibleRoutes location
        |> Maybe.withDefault OtherPage


possibleRoutes : Parser (Page -> x) x
possibleRoutes =
    Url.oneOf
        [ Url.map WelcomePage top
        , Url.map MenuPage (s "menu")
        , Url.map OtherPage (s "other")
        ]


pageToUrl : Page -> String
pageToUrl page =
    case page of
        WelcomePage ->
            "/"

        OtherPage ->
            "/other"

        MenuPage ->
            "/menu"



-- pageToRoute : Page -> Route
-- pageToRoute page =
--     NotFoundRoute
--
-- routeToPage : Route -> Page
-- routeToPage route =
--     WelcomePage


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


initWithFlags : InitFlags -> Location -> ( Page, Cmd Msg, RoutingOutcome )
initWithFlags flags location =
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
        ( parseLocation location, Cmd.none, KeepCurrentPage )
