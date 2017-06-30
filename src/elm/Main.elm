module Main exposing (..)

import Csv exposing (..)
import Html exposing (..)
import Html.Attributes exposing (checked, class, id, placeholder, src, style, title, type_, value, width)
import Html.Events exposing (..)
import Json.Decode as JD
import Ports exposing (CSVPortData, fileContentRead, fileSelected)


-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type Msg
    = CSVSelected
    | CSVParse CSVPortData


type alias CSVFile =
    { contents : String
    , filename : String
    }


type alias Errors =
    Maybe (List String)


type alias Model =
    { csvFile : Maybe CSVFile
    , csvData : Csv
    , errors : Errors
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing (Csv [] [ [] ]) Nothing, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    fileContentRead CSVParse



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CSVSelected ->
            ( model, fileSelected "CSVInput" )

        CSVParse data ->
            let
                newCSVFile =
                    { contents = data.contents
                    , filename = data.filename
                    }
            in
            case Csv.parse newCSVFile.contents of
                Ok results ->
                    ( { model | csvFile = Just newCSVFile, csvData = results, errors = Nothing }, Cmd.none )

                Err errors ->
                    ( { model | csvFile = Nothing, errors = Just errors }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "FileWrapper" ]
        [ input
            [ type_ "file"
            , id "CSVInput"
            , on "change"
                (JD.succeed CSVSelected)
            ]
            []
        , csvView model.csvFile model.csvData model.errors
        ]


csvView : Maybe CSVFile -> Csv -> Errors -> Html Msg
csvView file csvData errors =
    case file of
        Just i ->
            csvTable csvData

        Nothing ->
            ("Errors: " ++ (errors |> toString)) |> text


csvTable : Csv -> Html Msg
csvTable data =
    div []
        [ table []
            (tr []
                (List.map (\h -> th [] [ text h ]) data.headers)
                :: List.map (\r -> tr [] (List.map (\c -> td [] [ text c ]) r)) data.records
            )
        ]
