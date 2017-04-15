module Updaters.Main exposing (update)

import Task
import Process
import Time exposing (Time, millisecond)
import Types.App exposing (Page, Model, Msg(..), LayoutState(..))
import Task


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep (time * millisecond)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            -- Debug.log "processing msg" (toString msg)
            "a"

        -- --
        -- _ =
        --     Debug.log "Transition Step" <| Transit.getStep model.transition
    in
        case msg of
            SetLayoutState newLayout ->
                let
                    nextCmd =
                        case newLayout of
                            CurrentPageOnly current ->
                                Cmd.none

                            NextPageWillEnter current next ->
                                --delay 100 (SetLayoutState (NextPageEntering current next))
                                -- let
                                --     nextMsg =
                                --         SetLayoutState (NextPageEntering current next)
                                -- in
                                --     Task.succeed (nextMsg)
                                --         |> Task.perform identity
                                delay 1000 (SetLayoutState (CurrentPageOnly next))

                    -- NextPageEntering current next ->
                    --     delay 1000 (SetLayoutState (NextPageEntered current next))
                    --
                    -- NextPageEntered current next ->
                    --     delay 1000 (SetLayoutState (CurrentPageOnly next))
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
