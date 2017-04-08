module MainCss exposing (..)

import Css exposing (..)
import Css.Colors exposing (black, gray)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)


type Classes
    = App
    | Calendar
    | Header
    | HeaderButton
    | HeaderLabel
    | DayLabels
    | DayLabel
    | Dates
    | DateRow
    | DateCell
    | CellContent
    | Selected
    | Today
    | WrongMonth


css =
    (stylesheet << namespace "bodhi")
        [ class App
            [ minWidth (px 500)
            , height (pct 100)
            , padding (px 5)
            ]
        , class Calendar
            [ height (pct 100)
            ]
        , class Header
            [ displayFlex
            , alignItems center
            , justifyContent spaceAround
            , textAlign center
            ]
        , class HeaderButton
            []
        , class HeaderLabel
            [ width (pct 60)
            ]
        , class DayLabels
            [ displayFlex
            , justifyContent spaceAround
            , height (Css.em 5)
            ]
        , class DayLabel
            [ displayFlex
            , alignItems center
            , justifyContent center
            , borderBottom3 (px 1) solid grayOutline
            , fontWeight bold
            , width (pct 100)
            ]
        , class Dates
            [ displayFlex
            , flexDirection column
            , justifyContent spaceAround
            , padding zero
            , height (pct 100)
            ]
        , class DateRow
            [ displayFlex
            , justifyContent spaceAround
            , height (pct 100)
            ]
        , class DateCell
            [ displayFlex
            , flexGrow (int 1)
            , alignItems center
            , justifyContent center
            , borderBottom3 (px 1) solid grayOutline
            ]
        , class CellContent
            [ displayFlex
            , alignItems center
            , justifyContent center
            , width (Css.em 5)
            , height (Css.em 5)
            , hover
                [ backgroundColor discreteColor
                , borderRadius (pct 50)
                , color black
                ]
            ]
        , class Selected
            [ displayFlex
            , alignItems center
            , justifyContent center
            , backgroundColor lightColor
            , borderRadius (pct 500)
            , fontWeight bold
            , width (Css.em 5)
            , height (Css.em 5)
            ]
        , class Today
            [ fontStyle italic
            , fontWeight bold
            ]
        , class WrongMonth
            [ color gray
            , fontStyle italic
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
