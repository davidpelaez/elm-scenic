module Main exposing (..)

import Scenic exposing (programWithFlags, Transition(..), ProgramWithFlags, Outcome(..))
import Navigation exposing (Location)
import Html.Events exposing (onClick)
import UrlParser exposing ((</>), (<?>), s, int, stringParam, top, string, map, Parser)
import Html exposing (Html, text, button, div)
import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top)


type alias RoutingOutcome =
    Outcome Page


type Msg
    = NoOp
    | GoToPage Page Transition


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


update : Msg -> Page -> ( Page, Cmd Msg, RoutingOutcome )
update msg page =
    case msg of
        GoToPage newPage transition ->
            ( page, Cmd.none, ChangePage newPage transition )

        _ ->
            ( page, Cmd.none, KeepCurrentPage )


transitionButton : Page -> Html Msg
transitionButton page =
    button [ onClick <| GoToPage page SlideInRight ] [ text <| ("Go to " ++ toString page) ]


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
