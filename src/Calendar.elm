module Calendar exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, div, h2, h4, span, b, text)
import Html.CssHelpers
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Calendar.View as View exposing (View)
import Date exposing (Date)
import List.Extra
import MainCss
import Task


-- Css helpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bodhi"



-- Model


type alias Model =
    { today : Date
    , selected : Date
    , view : View
    }


init : ( Model, Cmd Msg )
init =
    let
        view =
            View.default

        model =
            { today = view
            , selected = view
            , view = view
            }
    in
        ( model, Task.perform NewDateToday Date.now )



-- Msg


type Msg
    = NewDateToday Date
    | NextMonth
    | PrevMonth



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewDateToday date ->
            ( { model
                | today = date
                , selected = date
                , view = View.fromDate date
              }
            , Cmd.none
            )

        NextMonth ->
            ( { model
                | view =
                    View.next model.view
              }
            , Cmd.none
            )

        PrevMonth ->
            ( { model
                | view = View.prev model.view
              }
            , Cmd.none
            )



-- View


view : Model -> Html Msg
view model =
    block [ MainCss.Calendar ]
        [ header model.view
        , dayLabels
        , dates model
        ]


block : List MainCss.Classes -> List (Html msg) -> Html msg
block classes content =
    div [ class classes ]
        content


header : View -> Html Msg
header view =
    block [ MainCss.Header ]
        [ changeMonthButton "<" PrevMonth
        , block [ MainCss.HeaderLabel ]
            [ h4 [] [ text <| toString <| View.year view ]
            , h2 [] [ text <| monthName <| View.month view ]
            ]
        , changeMonthButton ">" NextMonth
        ]


changeMonthButton : String -> Msg -> Html Msg
changeMonthButton label msg =
    Button.button
        [ Button.outlineSecondary
        , Button.onClick msg
        , Button.attrs [ class [ MainCss.HeaderButton ] ]
        ]
        [ text label ]


dayLabels : Html msg
dayLabels =
    block [ MainCss.DayLabels ] <|
        List.map dayLabel <|
            [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" ]


dayLabel : String -> Html msg
dayLabel label =
    block [ MainCss.DayLabel ]
        [ text label ]


dates : Model -> Html msg
dates model =
    let
        view =
            model.view

        weeks =
            List.map (dateRow model) <| View.weeks view
    in
        block [ MainCss.Dates ]
            weeks


dateRow : Model -> List Date -> Html msg
dateRow model dates =
    block [ MainCss.DateRow ] <|
        List.map (dateTile model) dates


dateTile : Model -> Date -> Html msg
dateTile model date =
    let
        contentClasses =
            filterClasses
                [ True
                , model.today == date
                , model.selected == date
                , View.month model.view /= Date.month date
                ]
                [ MainCss.CellContent
                , MainCss.Today
                , MainCss.Selected
                , MainCss.WrongMonth
                ]
    in
        block [ MainCss.DateCell ]
            [ block contentClasses
                [ text <| toString <| Date.day date ]
            ]


filterClasses : List Bool -> List MainCss.Classes -> List MainCss.Classes
filterClasses filters classes =
    let
        list =
            List.Extra.zip filters classes

        iter list =
            case list of
                ( filter, class ) :: rest ->
                    case filter of
                        True ->
                            class :: iter rest

                        False ->
                            iter rest

                [] ->
                    []
    in
        iter list


monthName : Date.Month -> String
monthName month =
    case month of
        Date.Jan ->
            "Januar"

        Date.Feb ->
            "Februar"

        Date.Mar ->
            "Mar"

        Date.Apr ->
            "April"

        Date.May ->
            "May"

        Date.Jun ->
            "June"

        Date.Jul ->
            "July"

        Date.Aug ->
            "August"

        Date.Sep ->
            "September"

        Date.Oct ->
            "October"

        Date.Nov ->
            "November"

        Date.Dec ->
            "December"
