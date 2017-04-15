module Views.Main exposing (rootView)

import Html exposing (..)
import Types.App exposing (..)
import Html.Attributes exposing (class, id)
import Html.Keyed as Keyed exposing (node)


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


renderPage : Page -> Html Msg
renderPage page =
    case page of
        MenuPage ->
            text "This is the welcome page...."

        WelcomePage ->
            text "This is the welcome page...."

        NotFoundPage ->
            text "Not founf or lacking permissions"
