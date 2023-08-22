module Types exposing (..)

import Lamdera exposing (ClientId, SessionId)


type alias FrontendModel =
    { colors : List MessageType, messageFieldContent : String }


type alias BackendModel =
    { colors : List MessageType }


type FrontendMsg
    = 
     SendColor String
    | Noop



type ToBackend
    = MsgSubmitted String


type BackendMsg
    = ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    


type ToFrontend
    = HistoryReceived (List MessageType)
    | MessageReceived MessageType
    

type MessageType
    = 
    Joined ClientId
    | Left ClientId
    | Message ClientId String