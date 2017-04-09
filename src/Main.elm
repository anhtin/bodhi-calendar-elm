module Main exposing (..)

import Html exposing (Html, div)
import Calendar exposing (init, view)
import Html.CssHelpers
import MainCss exposing (Classes(App))


-- Css helpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bodhi"



-- Model


type alias Model =
    { calendar : Calendar.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( calendarModel, cmd ) =
            Calendar.init
    in
        ( { calendar = calendarModel
          }
        , Cmd.map CalendarMsg cmd
        )



-- Msg


type Msg
    = CalendarMsg Calendar.Msg



-- Subscriptions


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CalendarMsg msg ->
            let
                ( calendarMsg, cmd ) =
                    Calendar.update msg model.calendar
            in
                ( { model | calendar = calendarMsg }
                , Cmd.map CalendarMsg cmd
                )



-- View


view : Model -> Html Msg
view model =
    div [ class [ App ] ]
        [ Html.map CalendarMsg (Calendar.view model.calendar)
        ]



-- Program


main : Program Never Model Msg
main =
    (Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
    )
