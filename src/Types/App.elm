module Types.App exposing (..)


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
    | NotFoundPage
    | MenuPage
