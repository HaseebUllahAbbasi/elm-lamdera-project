module Frontend exposing (Model, app)

import Browser.Dom as Dom
import Debug exposing (toString)
import Html exposing (Html, button, div,span, input, text)
import Html.Attributes exposing (autofocus, id, placeholder, style, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as D
import Lamdera
import Task
import Types exposing (..)



app =
    Lamdera.frontend
        { init = \_ _ -> init
        , update = update
        , updateFromBackend = updateFromBackend
        , view =
            \model ->
                { title = "Muliplayer Spots"
                , body = [ view model ]
                }
        , subscriptions = \m -> Sub.none
        , onUrlChange = \_ -> Noop
        , onUrlRequest = \_ -> Noop
        }


type alias Model =
    FrontendModel


init : ( Model, Cmd FrontendMsg )
init =
    ( { colors = []  }, Cmd.none )



update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        

        SendColor color ->
            ( {   colors = model.colors }
            , Cmd.batch
                [ Lamdera.sendToBackend (MsgSubmitted color)
                , scrollColorsToBottom
                ]
            )
    
        -- Empty msg that does no operations
        Noop ->
            ( model, Cmd.none )


{-| This is the added update function. It handles all colors that can arrive from the backend.
-}
updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        HistoryReceived colors ->
            ( { model | colors = colors }, Cmd.batch [ scrollColorsToBottom ] )

        MessageReceived message ->
            ( { model | colors = message :: model.colors }, Cmd.batch [ scrollColorsToBottom ] )


view : Model -> Html FrontendMsg
view model =
    div (style "padding" "10px" :: fontStyles)
        [ model.colors
            |> List.reverse
            |> List.map viewColor
            |> div
                [ id "message-box"
                , style "min-height" "200px"
                , style "border" "1px solid black"
                , style "overflow" "auto"
                -- , style "margin-bottom" "15px"
                ]
        , colorPallate model SendColor
        ]


colorPallate : Model -> (String -> FrontendMsg) -> Html FrontendMsg
colorPallate model msg =
        div [ style "font-style" "italic", style "border" "1px solid black"  ]
            [ 
            button  [ onClick (SendColor "pink"), style "background-color" "pink",style "border-radius" "30px",  style "min-width" "30px", style "min-height" "30px",style "display" "inline-block", style "margin" "10px"  ][ text "" ],
            button [ onClick (SendColor "lightblue"), style "background-color" "lightblue",style "border-radius" "30px",  style "min-width" "30px", style "min-height" "30px",style "display" "inline-block", style "margin" "10px"  ][ text "" ],
            button [ onClick (SendColor "hotpink"), style "background-color" "hotpink",style "border-radius" "30px",  style "min-width" "30px", style "min-height" "30px",style "display" "inline-block", style "margin" "10px"  ][ text "" ],
            button [ onClick (SendColor "lightgreen"), style "background-color" "lightgreen ",style "border-radius" "30px",  style "min-width" "30px", style "min-height" "30px",style "display" "inline-block", style "margin" "10px"  ][ text "" ],
            button [ onClick (SendColor "silver"), style "background-color" "silver",style "border-radius" "30px",  style "min-width" "30px", style "min-height" "30px",style "display" "inline-block", style "margin" "10px"  ][ text "" ]
            ]
        


viewColor : MessageType -> Html msg
viewColor msg =
    case msg of
        Joined clientId ->
            span [ style "font-style" "italic" ] [ text " " ]

        Left clientId ->
            span [ style "font-style" "italic" ] [ text " " ]

        Message clientId color ->
            span [ style "background-color" color,style "border-radius" "30px",  style "min-width" "30px", style "min-height" "30px",style "display" "inline-block", style "margin" "10px"  ][ text "" ]


fontStyles : List (Html.Attribute msg)
fontStyles =
    [ style "font-family" "Helvetica", style "font-size" "14px", style "line-height" "1.5" ]


scrollColorsToBottom : Cmd FrontendMsg
scrollColorsToBottom =
    Dom.getViewportOf "message-box"
        |> Task.andThen (\info -> Dom.setViewportOf "message-box" 0 info.scene.height)
        |> Task.attempt (\_ -> Noop)




