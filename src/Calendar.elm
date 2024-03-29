module Calendar exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, div, h2, h4, text)
import Html.CssHelpers
import Html.Events exposing (onClick)
import Bootstrap.Button as Button
import Calendar.View as View exposing (View)
import Date exposing (Date)
import MainCss exposing (Classes(..))
import Task
import Utilities exposing (conditionFilter)
import LuniSolar exposing (..)


-- Css helpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bodhi"



-- Model


type alias Model =
    { today : Date
    , selected : Date
    , view : View
    , vegetarianDays : List Int
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
            , vegetarianDays = [ 1, 8, 14, 15, 18, 23, 24, 27, 29, 30 ]
            }
    in
        ( model, Task.perform NewDateToday Date.now )



-- Msg


type Msg
    = NewDateToday Date
    | NextMonth
    | PrevMonth
    | SelectDate Date



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

        SelectDate date ->
            ( { model
                | selected = date
              }
            , Cmd.none
            )



-- View


view : Model -> Html Msg
view model =
    block [ Calendar ]
        (List.intersperse separator
            [ header model.view
            , dates model
            , events model
            ]
        )


block : List Classes -> List (Html msg) -> Html msg
block classes content =
    div [ class classes ]
        content


separator : Html msg
separator =
    block [ Separator ] []


header : View -> Html Msg
header view =
    let
        changeMonthButton : String -> Msg -> Html Msg
        changeMonthButton label msg =
            Button.button
                [ Button.outlineSecondary
                , Button.onClick msg
                , Button.attrs [ class [ MonthButton ] ]
                ]
                [ text label ]

        month =
            block [ MonthHeader ]
                [ changeMonthButton "<" PrevMonth
                , block [ MonthLabel ]
                    [ h4 [] [ text <| toString <| View.year view ]
                    , h2 [] [ text <| monthName <| View.month view ]
                    ]
                , changeMonthButton ">" NextMonth
                ]

        dayLabel : String -> Html msg
        dayLabel label =
            block [ DayLabel ]
                [ text label ]

        week =
            block [ WeekHeader ] <|
                List.map dayLabel <|
                    [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" ]
    in
        block [ Header ]
            [ month
            , week
            ]


dates : Model -> Html Msg
dates model =
    let
        view =
            model.view

        weeks =
            List.map (dateRow model) <| View.weeks view
    in
        block [ Dates ]
            (List.intersperse separator weeks)


dateRow : Model -> List Date -> Html Msg
dateRow model dates =
    block [ DateRow ] <|
        List.map (dateTile model) dates


dateTile : Model -> Date -> Html Msg
dateTile model date =
    let
        lunar =
            LuniSolar.solarToLunar <| LuniSolar.solarFromDate date

        isVegetarian =
            List.member lunar.day model.vegetarianDays

        isWrongMonth =
            View.month model.view /= Date.month date

        isToday =
            model.today == date

        isSelected =
            model.selected == date

        cellClasses =
            CellContent
                :: conditionFilter
                    [ ( Today, isToday )
                    , ( Vegetarian, isVegetarian )
                    , ( WrongMonth, isWrongMonth )
                    , ( Selected, isSelected )
                    ]
    in
        div [ class [ DateCell ], onClick <| SelectDate date ]
            [ block cellClasses
                [ block [ CellSolar ]
                    [ text <| toString <| Date.day date ]
                , block [ CellLunar ]
                    [ text <| toString lunar.day ]
                ]
            ]


events : Model -> Html msg
events model =
    block [ EventList ]
        []


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
