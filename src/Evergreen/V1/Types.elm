module Evergreen.V1.Types exposing (..)

import Lamdera


type MessageType
    = Joined Lamdera.ClientId
    | Left Lamdera.ClientId
    | Message Lamdera.ClientId String


type alias FrontendModel =
    { colors : List MessageType
    }


type alias BackendModel =
    { colors : List MessageType
    }


type FrontendMsg
    = SendColor String
    | Noop


type ToBackend
    = MsgSubmitted String


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId


type ToFrontend
    = HistoryReceived (List MessageType)
    | MessageReceived MessageType
