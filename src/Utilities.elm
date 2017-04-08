module Utilities exposing (..)


conditionFilter : List ( a, Bool ) -> List a
conditionFilter list =
    case list of
        ( item, condition ) :: rest ->
            case condition of
                True ->
                    item :: conditionFilter rest

                False ->
                    conditionFilter rest

        [] ->
            []
