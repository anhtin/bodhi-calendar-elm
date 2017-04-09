-- Adapted from https://github.com/isee15/Lunar-Solar-Calendar-Converter


module LuniSolar exposing (Lunar, Solar, solarFromDate, solarToLunar)

import Array exposing (Array)
import Bitwise
import Date exposing (Date)
import Date.Extra.Core as DateExtra


type alias Lunar =
    { isLeap : Bool
    , year : Int
    , month : Int
    , day : Int
    }


type alias Solar =
    { year : Int
    , month : Int
    , day : Int
    }


solarFromDate : Date -> Solar
solarFromDate date =
    { year = Date.year date
    , month = Date.month date |> DateExtra.monthToInt
    , day = Date.day date
    }


solarToLunar : Solar -> Lunar
solarToLunar solar =
    let
        extract : Int -> Array Int -> Int
        extract index array =
            case Array.get index array of
                Just value ->
                    value

                Nothing ->
                    -- This shouldn't happen, pray for success
                    0

        data =
            List.foldl Bitwise.or
                0
                [ Bitwise.shiftLeftBy 9 solar.year
                , Bitwise.shiftLeftBy 5 solar.month
                , solar.day
                ]

        index =
            let
                index =
                    solar.year - (extract 0 solarArray)
            in
                if extract index solarArray > data then
                    index - 1
                else
                    index

        solarElem =
            extract index solarArray

        y =
            getBitInt solarElem 12 9

        m =
            getBitInt solarElem 4 5

        d =
            getBitInt solarElem 5 0

        offset =
            (solarToInt solar) - (solarToInt { year = y, month = m, day = d })

        days =
            extract index lunarArray

        leap =
            getBitInt days 4 13

        lunarY =
            index + extract 0 solarArray

        ( lunarM, lunarD, isLeap ) =
            let
                iter : Int -> Int -> Int -> ( Int, Int )
                iter count offset month =
                    if count < 0 then
                        ( month, offset )
                    else
                        let
                            dm =
                                if getBitInt days 1 count == 1 then
                                    30
                                else
                                    29
                        in
                            if offset > dm then
                                iter (count - 1) (offset - dm) (month + 1)
                            else
                                ( month, offset )
            in
                case iter 12 offset 1 of
                    ( month, day ) ->
                        if leap /= 0 && month > leap then
                            if month == leap + 1 then
                                ( month - 1, day, True )
                            else
                                ( month, day, False )
                        else
                            ( month, day, False )
    in
        { isLeap = isLeap
        , year = lunarY
        , month = lunarM
        , day = lunarD
        }


solarToInt : Solar -> Int
solarToInt { year, month, day } =
    -- Inaccurate for dates before October 1582
    let
        m =
            (month + 9) % 12

        y =
            year - (m // 10)
    in
        365 * y + y // 4 - y // 100 + y // 400 + (m * 306 + 5) // 10 + (day - 1)


getBitInt : Int -> Int -> Int -> Int
getBitInt data length shift =
    let
        mask =
            (Bitwise.shiftLeftBy length 1) - 1 |> Bitwise.shiftLeftBy shift
    in
        Bitwise.and data mask |> Bitwise.shiftRightBy shift


lunarArray : Array Int
lunarArray =
    Array.fromList
        [ 1887
        , 0x1694
        , 0x16AA
        , 0x4AD5
        , 0x0AB6
        , 0xC4B7
        , 0x04AE
        , 0x0A56
        , 0xB52A
        , 0x1D2A
        , 0x0D54
        , 0x75AA
        , 0x156A
        , 0x0001096D
        , 0x095C
        , 0x14AE
        , 0xAA4D
        , 0x1A4C
        , 0x1B2A
        , 0x8D55
        , 0x0AD4
        , 0x135A
        , 0x495D
        , 0x095C
        , 0xD49B
        , 0x149A
        , 0x1A4A
        , 0xBAA5
        , 0x16A8
        , 0x1AD4
        , 0x52DA
        , 0x12B6
        , 0xE937
        , 0x092E
        , 0x1496
        , 0xB64B
        , 0x0D4A
        , 0x0DA8
        , 0x95B5
        , 0x056C
        , 0x12AE
        , 0x492F
        , 0x092E
        , 0xCC96
        , 0x1A94
        , 0x1D4A
        , 0xADA9
        , 0x0B5A
        , 0x056C
        , 0x726E
        , 0x125C
        , 0xF92D
        , 0x192A
        , 0x1A94
        , 0xDB4A
        , 0x16AA
        , 0x0AD4
        , 0x955B
        , 0x04BA
        , 0x125A
        , 0x592B
        , 0x152A
        , 0xF695
        , 0x0D94
        , 0x16AA
        , 0xAAB5
        , 0x09B4
        , 0x14B6
        , 0x6A57
        , 0x0A56
        , 0x0001152A
        , 0x1D2A
        , 0x0D54
        , 0xD5AA
        , 0x156A
        , 0x096C
        , 0x94AE
        , 0x14AE
        , 0x0A4C
        , 0x7D26
        , 0x1B2A
        , 0xEB55
        , 0x0AD4
        , 0x12DA
        , 0xA95D
        , 0x095A
        , 0x149A
        , 0x9A4D
        , 0x1A4A
        , 0x00011AA5
        , 0x16A8
        , 0x16D4
        , 0xD2DA
        , 0x12B6
        , 0x0936
        , 0x9497
        , 0x1496
        , 0x0001564B
        , 0x0D4A
        , 0x0DA8
        , 0xD5B4
        , 0x156C
        , 0x12AE
        , 0xA92F
        , 0x092E
        , 0x0C96
        , 0x6D4A
        , 0x1D4A
        , 0x00010D65
        , 0x0B58
        , 0x156C
        , 0xB26D
        , 0x125C
        , 0x192C
        , 0x9A95
        , 0x1A94
        , 0x1B4A
        , 0x4B55
        , 0x0AD4
        , 0xF55B
        , 0x04BA
        , 0x125A
        , 0xB92B
        , 0x152A
        , 0x1694
        , 0x96AA
        , 0x15AA
        , 0x00012AB5
        , 0x0974
        , 0x14B6
        , 0xCA57
        , 0x0A56
        , 0x1526
        , 0x8E95
        , 0x0D54
        , 0x15AA
        , 0x49B5
        , 0x096C
        , 0xD4AE
        , 0x149C
        , 0x1A4C
        , 0xBD26
        , 0x1AA6
        , 0x0B54
        , 0x6D6A
        , 0x12DA
        , 0x0001695D
        , 0x095A
        , 0x149A
        , 0xDA4B
        , 0x1A4A
        , 0x1AA4
        , 0xBB54
        , 0x16B4
        , 0x0ADA
        , 0x495B
        , 0x0936
        , 0xF497
        , 0x1496
        , 0x154A
        , 0xB6A5
        , 0x0DA4
        , 0x15B4
        , 0x6AB6
        , 0x126E
        , 0x0001092F
        , 0x092E
        , 0x0C96
        , 0xCD4A
        , 0x1D4A
        , 0x0D64
        , 0x956C
        , 0x155C
        , 0x125C
        , 0x792E
        , 0x192C
        , 0xFA95
        , 0x1A94
        , 0x1B4A
        , 0xAB55
        , 0x0AD4
        , 0x14DA
        , 0x8A5D
        , 0x0A5A
        , 0x0001152B
        , 0x152A
        , 0x1694
        , 0xD6AA
        , 0x15AA
        , 0x0AB4
        , 0x94BA
        , 0x14B6
        , 0x0A56
        , 0x7527
        , 0x0D26
        , 0xEE53
        , 0x0D54
        , 0x15AA
        , 0xA9B5
        , 0x096C
        , 0x14AE
        , 0x8A4E
        , 0x1A4C
        , 0x00011D26
        , 0x1AA4
        , 0x1B54
        , 0xCD6A
        , 0x0ADA
        , 0x095C
        , 0x949D
        , 0x149A
        , 0x1A2A
        , 0x5B25
        , 0x1AA4
        , 0xFB52
        , 0x16B4
        , 0x0ABA
        , 0xA95B
        , 0x0936
        , 0x1496
        , 0x9A4B
        , 0x154A
        , 0x000136A5
        , 0x0DA4
        , 0x15AC
        ]


solarArray : Array Int
solarArray =
    Array.fromList
        [ 1887
        , 0x000EC04C
        , 0x000EC23F
        , 0x000EC435
        , 0x000EC649
        , 0x000EC83E
        , 0x000ECA51
        , 0x000ECC46
        , 0x000ECE3A
        , 0x000ED04D
        , 0x000ED242
        , 0x000ED436
        , 0x000ED64A
        , 0x000ED83F
        , 0x000EDA53
        , 0x000EDC48
        , 0x000EDE3D
        , 0x000EE050
        , 0x000EE244
        , 0x000EE439
        , 0x000EE64D
        , 0x000EE842
        , 0x000EEA36
        , 0x000EEC4A
        , 0x000EEE3E
        , 0x000EF052
        , 0x000EF246
        , 0x000EF43A
        , 0x000EF64E
        , 0x000EF843
        , 0x000EFA37
        , 0x000EFC4B
        , 0x000EFE41
        , 0x000F0054
        , 0x000F0248
        , 0x000F043C
        , 0x000F0650
        , 0x000F0845
        , 0x000F0A38
        , 0x000F0C4D
        , 0x000F0E42
        , 0x000F1037
        , 0x000F124A
        , 0x000F143E
        , 0x000F1651
        , 0x000F1846
        , 0x000F1A3A
        , 0x000F1C4E
        , 0x000F1E44
        , 0x000F2038
        , 0x000F224B
        , 0x000F243F
        , 0x000F2653
        , 0x000F2848
        , 0x000F2A3B
        , 0x000F2C4F
        , 0x000F2E45
        , 0x000F3039
        , 0x000F324D
        , 0x000F3442
        , 0x000F3636
        , 0x000F384A
        , 0x000F3A3D
        , 0x000F3C51
        , 0x000F3E46
        , 0x000F403B
        , 0x000F424E
        , 0x000F4443
        , 0x000F4638
        , 0x000F484C
        , 0x000F4A3F
        , 0x000F4C52
        , 0x000F4E48
        , 0x000F503C
        , 0x000F524F
        , 0x000F5445
        , 0x000F5639
        , 0x000F584D
        , 0x000F5A42
        , 0x000F5C35
        , 0x000F5E49
        , 0x000F603E
        , 0x000F6251
        , 0x000F6446
        , 0x000F663B
        , 0x000F684F
        , 0x000F6A43
        , 0x000F6C37
        , 0x000F6E4B
        , 0x000F703F
        , 0x000F7252
        , 0x000F7447
        , 0x000F763C
        , 0x000F7850
        , 0x000F7A45
        , 0x000F7C39
        , 0x000F7E4D
        , 0x000F8042
        , 0x000F8254
        , 0x000F8449
        , 0x000F863D
        , 0x000F8851
        , 0x000F8A46
        , 0x000F8C3B
        , 0x000F8E4F
        , 0x000F9044
        , 0x000F9237
        , 0x000F944A
        , 0x000F963F
        , 0x000F9853
        , 0x000F9A47
        , 0x000F9C3C
        , 0x000F9E50
        , 0x000FA045
        , 0x000FA238
        , 0x000FA44C
        , 0x000FA641
        , 0x000FA836
        , 0x000FAA49
        , 0x000FAC3D
        , 0x000FAE52
        , 0x000FB047
        , 0x000FB23A
        , 0x000FB44E
        , 0x000FB643
        , 0x000FB837
        , 0x000FBA4A
        , 0x000FBC3F
        , 0x000FBE53
        , 0x000FC048
        , 0x000FC23C
        , 0x000FC450
        , 0x000FC645
        , 0x000FC839
        , 0x000FCA4C
        , 0x000FCC41
        , 0x000FCE36
        , 0x000FD04A
        , 0x000FD23D
        , 0x000FD451
        , 0x000FD646
        , 0x000FD83A
        , 0x000FDA4D
        , 0x000FDC43
        , 0x000FDE37
        , 0x000FE04B
        , 0x000FE23F
        , 0x000FE453
        , 0x000FE648
        , 0x000FE83C
        , 0x000FEA4F
        , 0x000FEC44
        , 0x000FEE38
        , 0x000FF04C
        , 0x000FF241
        , 0x000FF436
        , 0x000FF64A
        , 0x000FF83E
        , 0x000FFA51
        , 0x000FFC46
        , 0x000FFE3A
        , 0x0010004E
        , 0x00100242
        , 0x00100437
        , 0x0010064B
        , 0x00100841
        , 0x00100A53
        , 0x00100C48
        , 0x00100E3C
        , 0x0010104F
        , 0x00101244
        , 0x00101438
        , 0x0010164C
        , 0x00101842
        , 0x00101A35
        , 0x00101C49
        , 0x00101E3D
        , 0x00102051
        , 0x00102245
        , 0x0010243A
        , 0x0010264E
        , 0x00102843
        , 0x00102A37
        , 0x00102C4B
        , 0x00102E3F
        , 0x00103053
        , 0x00103247
        , 0x0010343B
        , 0x0010364F
        , 0x00103845
        , 0x00103A38
        , 0x00103C4C
        , 0x00103E42
        , 0x00104036
        , 0x00104249
        , 0x0010443D
        , 0x00104651
        , 0x00104846
        , 0x00104A3A
        , 0x00104C4E
        , 0x00104E43
        , 0x00105038
        , 0x0010524A
        , 0x0010543E
        , 0x00105652
        , 0x00105847
        , 0x00105A3B
        , 0x00105C4F
        , 0x00105E45
        , 0x00106039
        , 0x0010624C
        , 0x00106441
        , 0x00106635
        , 0x00106849
        , 0x00106A3D
        , 0x00106C51
        , 0x00106E47
        , 0x0010703C
        , 0x0010724F
        , 0x00107444
        , 0x00107638
        , 0x0010784C
        , 0x00107A3F
        , 0x00107C53
        , 0x00107E48
        ]
