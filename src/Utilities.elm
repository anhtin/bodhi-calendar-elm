module Utilities exposing (..)

import List.Extra


conditionFilter : List Bool -> List a -> List a
conditionFilter conditions items =
    let
        list =
            List.Extra.zip conditions items

        iter list =
            case list of
                ( condition, item ) :: rest ->
                    case condition of
                        True ->
                            item :: iter rest

                        False ->
                            iter rest

                [] ->
                    []
    in
        iter list
