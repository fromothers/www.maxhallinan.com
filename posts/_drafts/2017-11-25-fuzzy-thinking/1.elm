module Main exposing (..)


hexColor : Fuzzer String
hexColor =
    Fuzz.map2 (++) hash hex
