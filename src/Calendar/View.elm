module Calendar.View exposing (..)

import Date exposing (Date)
import Date.Extra.Core as DateExtra
import Date.Extra.Duration as DateDuration


-- Model


type alias View =
    Date



-- Constants


default : View
default =
    DateExtra.fromTime 0



-- Conversions


fromDate : Date -> View
fromDate date =
    DateExtra.toFirstOfMonth date



-- Extractions


startDate : View -> Date
startDate view =
    let
        daysFromStart =
            (DateExtra.isoDayOfWeek <| Date.dayOfWeek view) - 1
    in
        DateDuration.add DateDuration.Day -daysFromStart view


year : View -> Int
year view =
    Date.year view


month : View -> Date.Month
month view =
    Date.month view


weeks : View -> List (List Date)
weeks view =
    let
        date =
            startDate view

        addDays delta =
            DateDuration.add DateDuration.Day delta date

        week num =
            let
                start =
                    num * 7

                end =
                    start + 6
            in
                List.map addDays <| List.range start end
    in
        List.map week <| List.range 0 4



-- Utilities


next : View -> View
next view =
    DateDuration.add DateDuration.Month 1 view


prev : View -> View
prev view =
    DateDuration.add DateDuration.Month -1 view
