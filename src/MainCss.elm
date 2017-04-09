module MainCss exposing (..)

import Css exposing (..)
import Css.Colors exposing (black)
import Css.Namespace exposing (namespace)


type Classes
    = App
    | Calendar
    | Header
    | MonthHeader
    | MonthButton
    | MonthLabel
    | WeekHeader
    | DayLabel
    | Dates
    | DateRow
    | DateCell
    | CellContent
    | CellSolar
    | CellLunar
    | Selected
    | Today
    | WrongMonth
    | Vegetarian
    | EventList
    | Separator


css =
    (stylesheet << namespace "bodhi")
        [ class App
            [ height (pct 100)
            , minHeight (px 500)
            , paddingTop (px 20)
            ]
        , class Calendar
            [ displayFlex
            , flexDirection column
            , justifyContent spaceAround
            , height (pct 100)
            ]
        , class Header
            [ displayFlex
            , flexBasis (px 1)
            , flexGrow (int 1)
            , flexDirection column
            , justifyContent spaceAround
            ]
        , class MonthHeader
            [ displayFlex
            , alignItems center
            , justifyContent spaceAround
            , textAlign center
            ]
        , class MonthButton
            []
        , class MonthLabel
            [ width (pct 60)
            ]
        , class WeekHeader
            [ displayFlex
            , justifyContent spaceAround
            ]
        , class DayLabel
            [ displayFlex
            , alignItems center
            , justifyContent center
            , fontWeight bold
            , width (pct 100)
            ]
        , class Dates
            [ displayFlex
            , flexDirection column
            , justifyContent spaceAround
            , flexBasis (px 1)
            , flexGrow (int 3)
            , padding2 (px 5) zero
            ]
        , class DateRow
            [ displayFlex
            , justifyContent spaceAround
            ]
        , class DateCell
            [ displayFlex
            , alignItems center
            , justifyContent center
            , height (pct 100)
            , width (pct 100)
            ]
        , class CellContent
            [ displayFlex
            , alignItems center
            , justifyContent center
            , width (em 2.5)
            , height (em 2.5)
            , property "user-select" "none"
            ]
        , class CellSolar
            []
        , class CellLunar
            [ fontSize (em 0.5)
            , fontStyle italic
            , marginTop (em -1)
            ]
        , class Selected
            [ displayFlex
            , alignItems center
            , justifyContent center
            , backgroundColor secondaryColor
            , borderRadius (pct 500)
            , color (rgb 255 255 255)
            , fontWeight bold
            ]
        , class Today
            [ fontStyle italic
            , fontWeight bold
            , textShadow4 (px 1) (px 1) (px 1) black
            ]
        , class WrongMonth
            [ opacity (num 0.5)
            ]
        , class Vegetarian
            [ color discreteColor
            , fontWeight bold
            ]
        , class EventList
            [ flexBasis (px 1)
            , flexGrow (int 2)
            ]
        , class Separator
            [ borderBottom3 (px 1) solid grayOutline
            , height (px 1)
            , width (pct 100)
            ]
        ]


grayOutline : Color
grayOutline =
    hex "b5bfce"


primaryColor : Color
primaryColor =
    hex "535f2f"


secondaryColor : Color
secondaryColor =
    hex "7f5d53"


lightColor : Color
lightColor =
    hex "d9c4b3"


discreteColor : Color
discreteColor =
    hex "a1b182"
