port module Ports exposing (..)


type alias CSVPortData =
    { contents : String
    , filename : String
    }


port fileSelected : String -> Cmd msg


port fileContentRead : (CSVPortData -> msg) -> Sub msg
