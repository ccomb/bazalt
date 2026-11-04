module Event.AddPage exposing (Flags, Model, Msg, Step, match, page)

import Configuration.Zone.View exposing (displayZone)
import Date
import DateTime.View
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (Element, column, fill, none, row, spacing, text, width)
import Expression.Eval as Eval
import Expression.Input
import Expression.Rational as Rational
import Expression.RationalInput as RationalInput exposing (RationalInput)
import Flow
import Group.Group as Group
import Group.Input exposing (inputGroups)
import Ident.Identifiable exposing (getIdentifiers)
import Ident.Identifier as Identifier
import Ident.Input exposing (inputIdentifiers)
import Maybe.Extra
import Message
import Ontology.Configuration.Zone exposing (Zone(..))
import Ontology.Event.Event exposing (Event)
import Ontology.EventType.EventType exposing (EventType)
import Ontology.Expression exposing (Expression)
import Ontology.Flow exposing (Flow(..))
import Ontology.Group.Link exposing (Link)
import Ontology.Hierarchy.Type as HType
import Ontology.Ident.Identifier exposing (Identifier)
import Ontology.Payload as Payload
import Ontology.Process.Process exposing (Process)
import Ontology.Process.Reconcile exposing (Reconciliation)
import Ontology.Resource.Resource exposing (Resource)
import Ontology.Scope exposing (Scope(..))
import Ontology.Type as Type
import Ontology.Typed.Type as TType
import Ontology.Value.Value exposing (Value)
import Prng.Uuid as Uuid exposing (Uuid)
import Process.Reconcile as Reconcile exposing (fromAllocations, toAllocations)
import Random.Pcg.Extended as Random exposing (Seed)
import Route exposing (Route, redirect)
import Scope.State exposing (containsScope)
import Shared
import Spa.Page
import State exposing (State)
import Time exposing (millisToPosix)
import Util exposing (andMapR, checkAllOk, checkEmptyDict, checkMaybe, chooseIfSingleton, third)
import Value.Input exposing (inputValues)
import Value.Valuable exposing (getValues)
import Value.Value as Value
import View exposing (View, closeMenu, floatingContainer, h1, p)
import View.FlatSelect exposing (flatSelect)
import View.MultiSelect exposing (multiSelect)
import View.Step as Step exposing (Step(..), buttons)


type alias Flags =
    { route : Route
    , uuid : Maybe Uuid
    , tuuid : Maybe String
    , related : Maybe Uuid
    }


type alias Model =
    { route : Route
    , isNew : Bool
    , uuid : Uuid
    , seed : Seed
    , resUuid : Uuid
    , processTypes : Dict String Uuid
    , processes : Dict String Uuid -- the list of processes this event will be part of
    , eventType : Maybe EventType
    , provider : Maybe Uuid
    , receiver : Maybe Uuid
    , resourceType : Maybe Uuid -- the type that will be used to create the resource
    , resource : Maybe Uuid -- the created or existing resource (as inflow or outflow)
    , qty : Maybe Expression
    , allocations : List ( Uuid, RationalInput ) -- a temporary partial allocation of this event to a process
    , calendar : DateTime.View.Model
    , identifiers : Dict String Identifier
    , resIdentifiers : Dict String Identifier
    , values : Dict String Value
    , resValues : Dict String Value
    , gsubmodel : Group.Input.Model
    , resgsubmodel : Group.Input.Model
    , warning : String
    , step : Step.Step Step
    , steps : List (Step.Step Step)
    }


type Step
    = StepProcess
    | StepProcessTypes
    | StepType
    | StepProvider
    | StepReceiver
    | StepResource
    | StepAllocate
    | StepDate
    | StepIdentifiers
    | StepValues
    | StepGroups


type Msg
    = SelectType (Maybe Uuid)
    | SelectProcessTypes (List Uuid)
    | SelectProcesses (List Uuid)
    | SelectProvider (Maybe Uuid)
    | SelectReceiver (Maybe Uuid)
    | SelectResource (Maybe Uuid)
    | SelectResourceType (Maybe Uuid)
    | InputQty Expression
    | InputPartialProcesses (List ( Uuid, RationalInput ))
    | InputIdentifier Identifier
    | InputResIdentifier Identifier
    | InputValue Value
    | InputResValue Value
    | GroupMsg Group.Input.Msg
    | ResGroupMsg Group.Input.Msg
    | Button Step.Msg
    | CalendarMsg DateTime.View.Msg


page : Shared.Model -> Spa.Page.Page Flags Shared.Msg (View Msg) Model Msg
page s =
    Spa.Page.element
        { init = init s
        , update = update s
        , view = view
        , subscriptions = \_ -> Sub.none
        }


match : Route -> Maybe Flags
match route =
    case route of
        Route.Entity Route.Event (Route.Add p) ->
            Just { route = route, uuid = Nothing, tuuid = p.type_, related = Maybe.andThen Uuid.fromString p.related }

        Route.Entity Route.Event (Route.Edit p) ->
            Just { route = route, uuid = Uuid.fromString p.uuid, tuuid = p.type_, related = Nothing }

        _ ->
            Nothing


toProcessTypes : State -> Maybe Uuid -> Dict String Uuid
toProcessTypes s muuid =
    -- return the processTypes corresponding to an eventType
    s.processTypes
        |> Dict.filter
            (\_ pt ->
                muuid |> Maybe.map (\et -> List.member et pt.eventTypes) |> Maybe.withDefault False
            )
        |> Dict.values
        |> List.map (\pt -> ( Uuid.toString pt.uuid, pt.uuid ))
        |> Dict.fromList


init : Shared.Model -> Flags -> ( Model, Effect Shared.Msg Msg )
init s f =
    let
        ( newUuid, newSeed ) =
            Random.step Uuid.generator s.currentSeed

        ( newResUuid, newResSeed ) =
            Random.step Uuid.generator newSeed

        isNew =
            f.uuid == Nothing

        ( initgroups, initcmd ) =
            Group.Input.init s Dict.empty

        met =
            f.tuuid |> Maybe.andThen Uuid.fromString |> Maybe.andThen (\uid -> Dict.get (Uuid.toString uid) s.state.eventTypes)

        mrt =
            chooseIfSingleton
                (s.state.resourceTypes
                    |> Dict.filter (\_ rt -> met |> Maybe.map (\et -> containsScope s.state.types (IsItem (Type.HType rt.what) rt.uuid) et.resources) |> Maybe.withDefault True)
                    |> Dict.map (\_ rt -> rt.uuid)
                    |> Dict.values
                )

        resource =
            met
                |> Maybe.map .createResource
                |> Maybe.andThen
                    (\create ->
                        if create then
                            Just newResUuid

                        else
                            chooseIfSingleton
                                (s.state.resources
                                    |> Dict.filter (\_ r -> met |> Maybe.map (\ct -> containsScope s.state.types (IsItem (Type.TType r.what) r.uuid) ct.resources) |> Maybe.withDefault True)
                                    |> Dict.values
                                    |> List.map .uuid
                                )
                    )

        ( calinit, calcmd ) =
            DateTime.View.init True s.zone <| Date.fromPosix s.zone <| millisToPosix 0

        adding =
            { route = f.route
            , isNew = isNew
            , processes = f.related |> Maybe.map (\r -> Dict.singleton (Uuid.toString r) r) |> Maybe.withDefault Dict.empty
            , eventType = met
            , processTypes = toProcessTypes s.state (Maybe.map .uuid met)
            , provider =
                chooseIfSingleton
                    (s.state.agents
                        |> Dict.filter (\_ a -> met |> Maybe.map (\et -> containsScope s.state.types (IsItem (Type.TType a.what) a.uuid) et.providers) |> Maybe.withDefault True)
                        |> Dict.map (\_ a -> a.uuid)
                        |> Dict.values
                    )
            , receiver =
                chooseIfSingleton
                    (s.state.agents
                        |> Dict.filter (\_ a -> met |> Maybe.map (\et -> containsScope s.state.types (IsItem (Type.TType a.what) a.uuid) et.receivers) |> Maybe.withDefault True)
                        |> Dict.map (\_ a -> a.uuid)
                        |> Dict.values
                    )
            , resourceType = mrt
            , resource = resource
            , qty = Maybe.map .qty met
            , allocations = f.related |> Maybe.map (\r -> [ ( r, "0" ) ]) |> Maybe.withDefault []
            , calendar = calinit
            , uuid = newUuid
            , resUuid = newResUuid
            , seed = newResSeed
            , identifiers = getIdentifiers s.state (Type.TType TType.Event) newUuid (Maybe.map .uuid met) True
            , resIdentifiers = getIdentifiers s.state (Type.TType TType.Resource) newResUuid mrt True
            , values = getValues s.state.types s.state.valueTypes s.state.values (Type.TType TType.Event) newUuid (Maybe.map .uuid met) True
            , resValues = getValues s.state.types s.state.valueTypes s.state.values (Type.TType TType.Resource) newUuid mrt True
            , gsubmodel = initgroups
            , resgsubmodel = initgroups
            , warning = ""
            , step = Step.Step StepProcessTypes
            , steps =
                [ Step.Step StepProcessTypes
                , Step.Step StepType
                , Step.Step StepProcess
                , Step.Step StepProvider
                , Step.Step StepReceiver
                , Step.Step StepResource
                , Step.Step StepAllocate
                , Step.Step StepDate
                , Step.Step StepIdentifiers
                , Step.Step StepValues
                , Step.Step StepGroups
                ]
            }
    in
    f.uuid
        |> Maybe.map
            (\uuid ->
                let
                    event =
                        Dict.get (Uuid.toString uuid) s.state.events

                    realType =
                        Dict.get (Uuid.toString uuid) s.state.types |> Maybe.andThen third

                    reconciliations =
                        s.state.reconciliations |> Reconcile.filterByEvent uuid

                    groups =
                        Group.groupsOf s.state.grouped uuid |> List.map (\i -> ( Uuid.toString i, i )) |> Dict.fromList

                    resgroups =
                        event
                            |> Maybe.map (.flow >> Flow.uuidOf)
                            |> Maybe.map
                                (\ruuid ->
                                    Group.groupsOf s.state.grouped ruuid
                                        |> List.map (\i -> ( Uuid.toString i, i ))
                                        |> Dict.fromList
                                )
                            |> Maybe.withDefault Dict.empty

                    ( editgroups, editcmd ) =
                        Group.Input.init s groups

                    ( reseditgroups, reseditcmd ) =
                        Group.Input.init s resgroups

                    caledit =
                        event |> Maybe.map .when |> Maybe.withDefault (millisToPosix 0) |> Date.fromPosix s.zone |> DateTime.View.init False s.zone

                    processes =
                        reconciliations |> Dict.values |> List.map (\r -> ( Uuid.toString r.process, r.process )) |> Dict.fromList
                in
                ( { adding
                    | processes = processes
                    , processTypes =
                        Dict.values processes
                            |> List.filterMap (\p -> Dict.get (Uuid.toString p) s.state.types |> Maybe.andThen third)
                            |> List.map (\t -> ( Uuid.toString t, t ))
                            |> Dict.fromList
                    , uuid = uuid
                    , eventType = realType |> Maybe.andThen (\puuid -> Dict.get (Uuid.toString puuid) s.state.eventTypes)
                    , provider = event |> Maybe.map .provider
                    , receiver = event |> Maybe.map .receiver
                    , resource = event |> Maybe.map (.flow >> Flow.uuidOf)
                    , qty = event |> Maybe.map .qty
                    , allocations = toAllocations reconciliations
                    , calendar = Tuple.first caledit
                    , identifiers = getIdentifiers s.state (Type.TType TType.Event) uuid realType False
                    , values = getValues s.state.types s.state.valueTypes s.state.values (Type.TType TType.Event) uuid realType False
                    , gsubmodel = editgroups
                    , resgsubmodel = reseditgroups
                  }
                , Effect.batch [ closeMenu f s.menu, Effect.map GroupMsg (Effect.fromCmd editcmd), Effect.map ResGroupMsg (Effect.fromCmd reseditcmd) ]
                )
            )
        |> Maybe.withDefault
            ( adding
            , Effect.batch
                [ closeMenu f s.menu
                , Effect.fromCmd <| Cmd.map CalendarMsg calcmd
                , Effect.map GroupMsg (Effect.fromCmd initcmd)
                ]
            )


update : Shared.Model -> Msg -> Model -> ( Model, Effect Shared.Msg Msg )
update s msg model =
    case msg of
        SelectType muuid ->
            let
                met =
                    muuid |> Maybe.andThen (\uid -> Dict.get (Uuid.toString uid) s.state.eventTypes)
            in
            ( { model
                | eventType = met
                , qty = Maybe.map .qty met
                , provider =
                    chooseIfSingleton
                        (s.state.agents
                            |> Dict.filter (\_ a -> met |> Maybe.map (\et -> containsScope s.state.types (IsItem (Type.TType a.what) a.uuid) et.providers) |> Maybe.withDefault True)
                            |> Dict.map (\_ a -> a.uuid)
                            |> Dict.values
                        )
                , receiver =
                    chooseIfSingleton
                        (s.state.agents
                            |> Dict.filter (\_ a -> met |> Maybe.map (\et -> containsScope s.state.types (IsItem (Type.TType a.what) a.uuid) et.receivers) |> Maybe.withDefault True)
                            |> Dict.map (\_ a -> a.uuid)
                            |> Dict.values
                        )
                , identifiers = getIdentifiers s.state (Type.TType TType.Event) model.uuid muuid True
                , values = getValues s.state.types s.state.valueTypes s.state.values (Type.TType TType.Event) model.uuid muuid True
              }
            , Effect.none
            )

        SelectProcesses uuids ->
            let
                allocations =
                    uuids
                        |> List.map
                            (\p -> ( p, "" ))
            in
            ( { model
                | processes = uuids |> List.map (\u -> ( Uuid.toString u, u )) |> Dict.fromList
                , allocations = allocations
              }
            , Effect.none
            )

        SelectProcessTypes pts ->
            ( { model | processTypes = pts |> List.map (\pt -> ( Uuid.toString pt, pt )) |> Dict.fromList }, Effect.none )

        SelectProvider uuid ->
            ( { model | provider = uuid }, Effect.none )

        SelectReceiver uuid ->
            ( { model | receiver = uuid }, Effect.none )

        InputQty qty ->
            ( { model | qty = Just qty }, Effect.none )

        SelectResource uuid ->
            ( { model | resource = uuid }, Effect.none )

        SelectResourceType muuid ->
            ( { model
                | resourceType = muuid
                , resIdentifiers = getIdentifiers s.state (Type.TType TType.Resource) model.resUuid muuid True
                , resValues = getValues s.state.types s.state.valueTypes s.state.values (Type.TType TType.Resource) model.resUuid muuid True
                , resource =
                    model.eventType
                        |> Maybe.map .createResource
                        |> Maybe.andThen
                            (\create ->
                                if create then
                                    Just model.resUuid

                                else
                                    chooseIfSingleton
                                        (s.state.resources
                                            |> Dict.filter (\_ r -> model.eventType |> Maybe.map (\ct -> containsScope s.state.types (IsItem (Type.TType r.what) r.uuid) ct.resources) |> Maybe.withDefault True)
                                            |> Dict.values
                                            |> List.map .uuid
                                        )
                            )
              }
            , Effect.none
            )

        InputPartialProcesses allocations ->
            ( { model
                | allocations = allocations
              }
            , Effect.none
            )

        CalendarMsg submsg ->
            let
                mdlcmd =
                    DateTime.View.update submsg model.calendar
            in
            ( { model | calendar = Tuple.first mdlcmd }
            , Effect.fromCmd <| Cmd.map CalendarMsg <| Tuple.second mdlcmd
            )

        InputIdentifier i ->
            ( { model | identifiers = Dict.insert (Identifier.compare i) i model.identifiers }, Effect.none )

        InputResIdentifier i ->
            ( { model | resIdentifiers = Dict.insert (Identifier.compare i) i model.resIdentifiers }, Effect.none )

        InputValue v ->
            ( { model | values = Dict.insert (Value.compare v) v model.values }, Effect.none )

        InputResValue v ->
            ( { model | resValues = Dict.insert (Value.compare v) v model.resValues }, Effect.none )

        GroupMsg submsg ->
            let
                ( submodel, subcmd ) =
                    Group.Input.update submsg model.gsubmodel
            in
            ( { model | gsubmodel = submodel }, Effect.fromCmd <| subcmd )

        ResGroupMsg submsg ->
            let
                ( submodel, subcmd ) =
                    Group.Input.update submsg model.resgsubmodel
            in
            ( { model | resgsubmodel = submodel }, Effect.fromCmd <| subcmd )

        Button Step.Added ->
            case validate s.state model of
                Ok ( e, created ) ->
                    ( model
                    , Effect.batch
                        [ Shared.dispatchMany s
                            ((Payload.AddedEvent e :: List.map Payload.AddedResource (Maybe.Extra.toList created))
                                ++ List.map Payload.AddedIdentifier (Dict.values model.identifiers)
                                ++ List.map Payload.AddedIdentifier (Dict.values model.resIdentifiers)
                                ++ List.map Payload.AddedValue (Dict.values model.values)
                                ++ List.map Payload.AddedValue (Dict.values model.resValues)
                                ++ List.map (\uuid -> Payload.Grouped (Link (Type.TType TType.Event) e.uuid uuid)) (Dict.values <| Group.Input.added model.gsubmodel)
                                ++ List.map (\uuid -> Payload.Ungrouped (Link (Type.TType TType.Event) e.uuid uuid)) (Dict.values <| Group.Input.removed model.gsubmodel)
                                ++ List.map (\uuid -> Payload.Grouped (Link (Type.TType TType.Resource) (Flow.uuidOf e.flow) uuid)) (Dict.values <| Group.Input.added model.resgsubmodel)
                                ++ List.map (\uuid -> Payload.Ungrouped (Link (Type.TType TType.Resource) (Flow.uuidOf e.flow) uuid)) (Dict.values <| Group.Input.removed model.resgsubmodel)
                                ++ (if Dict.isEmpty model.processes then
                                        model.processTypes
                                            |> Dict.foldl (always (Shared.uuidAggregator model.seed)) []
                                            |> List.concatMap
                                                (\( nextUuid, _, pt ) ->
                                                    [ Payload.AddedProcess <| Process TType.Process nextUuid pt
                                                    , Payload.Reconciled <| Reconciliation Rational.one e.uuid nextUuid
                                                    ]
                                                )

                                    else
                                        List.map Payload.Reconciled <| Dict.values (fromAllocations model.uuid model.allocations)
                                   )
                            )

                        -- renew the Seed to avoid conflict due to uuidAggregator
                        , Effect.fromCmd <| Message.renewSeed ()
                        , Effect.fromCmd <| redirect s.navkey (Route.Entity Route.Event (Route.View { uuid = Uuid.toString model.uuid, type_ = model.eventType |> Maybe.map (.uuid >> Uuid.toString) }))
                        ]
                    )

                Err err ->
                    ( { model | warning = err }, Effect.none )

        Button stepmsg ->
            Step.update s stepmsg model
                |> (\( x, y ) -> ( x, Effect.map Button y ))


view : Model -> View Msg
view model =
    { title = "Adding an Event"
    , attributes = []
    , element = viewContent model
    , route = model.route
    }


checkStep : Model -> Result String ()
checkStep model =
    case model.step of
        Step StepType ->
            checkMaybe (Maybe.map .uuid model.eventType) "You must select an Event Type" |> Result.map (\_ -> ())

        Step StepProvider ->
            checkMaybe model.provider "You must select a Provider" |> Result.map (\_ -> ())

        Step StepReceiver ->
            checkMaybe model.receiver "You must select a Receiver" |> Result.map (\_ -> ())

        Step StepResource ->
            model.resourceType
                |> Result.fromMaybe "You must select a Resource or ResourceType"
                |> Result.map (\_ -> ())

        Step StepAllocate ->
            checkAllOk (Tuple.second >> Rational.fromString >> Result.map (always ())) model.allocations

        Step StepProcessTypes ->
            checkEmptyDict model.processTypes "You must choose at least one Process Types" |> Result.map (\_ -> ())

        Step _ ->
            Ok ()


validate : State -> Model -> Result String ( Event, Maybe Resource )
validate s model =
    -- the flow is a new resource when the event type creates one, else an existing resource
    -- similar to haskell: f <$> a <*> b <*> c <*> d ...
    -- we apply multiple partial applications until we have the full value
    let
        qty =
            checkMaybe model.qty "The quantity is invalid"

        created =
            if Maybe.map .createResource model.eventType == Just True then
                Result.map2 (Resource TType.Resource model.resUuid)
                    (Result.fromMaybe "You must select a Resource Type" model.resourceType)
                    (qty |> Result.andThen (Eval.exeval s { context = ( Type.TType TType.Event, model.uuid ) } s.values))
                    |> Result.map Just

            else
                Ok Nothing

        resource =
            created
                |> Result.andThen
                    (Maybe.map Ok
                        >> Maybe.withDefault
                            (checkMaybe model.resource "You must select or create a Resource"
                                |> Result.andThen (\uuid -> Dict.get (Uuid.toString uuid) s.resources |> Result.fromMaybe "The selected Resource does not exist")
                            )
                    )

        e =
            Result.map
                (Event TType.Event model.uuid (DateTime.View.toPosix model.calendar))
                qty
                |> andMapR (checkMaybe (Maybe.map .uuid model.eventType) "You must select an Event Type")
                |> andMapR (checkMaybe model.provider "You must select a Provider")
                |> andMapR (checkMaybe model.receiver "You must select a Receiver")
                |> andMapR (Result.map ResourceFlow resource)
    in
    Result.map2 Tuple.pair e created


allocateEventToProcess : State -> List ( Uuid, RationalInput ) -> Int -> ( Uuid, RationalInput ) -> Element Msg
allocateEventToProcess s allocations index ( process, input ) =
    -- send an event to replace the allocation at index in the allocations
    row [ spacing 5 ]
        [ RationalInput.inputText Rational.fromString
            (String.fromInt index)
            (Just "amount")
            (\str ->
                InputPartialProcesses
                    (allocations
                        |> List.indexedMap
                            (\i allocation ->
                                if i == index then
                                    ( process, str )

                                else
                                    allocation
                            )
                    )
            )
            input
        , text <| "for: " ++ displayZone s SmallcardZone (Type.TType TType.Process) process
        ]


viewContent : Model -> Shared.Model -> Element Msg
viewContent model s =
    let
        step =
            case model.step of
                Step.Step StepProcessTypes ->
                    multiSelect model
                        { inputMsg = SelectProcessTypes
                        , selection = .processTypes >> Dict.values
                        , title = "Process Types: "
                        , description = "Select all the Process Types related to this new Event"
                        , toString = displayZone s.state SmallcardZone (Type.HType HType.ProcessType)
                        , empty = "There are no Process Types yet to choose from"
                        , toDesc = always ""
                        , height = 50
                        , input = \_ _ _ -> none
                        }
                    <|
                        List.map .uuid <|
                            Dict.values s.state.processTypes

                Step.Step StepProcess ->
                    multiSelect model
                        { inputMsg = SelectProcesses
                        , selection = .processes >> Dict.values
                        , title = "Processes: "
                        , description = "Select the processes that correspond to this new event. Leave empty to create a new process."
                        , toString = displayZone s.state SmallcardZone (Type.TType TType.Process)
                        , empty = "There are no processes yet to choose from"
                        , toDesc = always ""
                        , height = 50
                        , input = \_ _ _ -> none
                        }
                        -- only choose among relevant processes whose type is in the ProcessType
                        (s.state.processes
                            |> Dict.filter (\_ p -> Dict.member (Uuid.toString p.type_) model.processTypes)
                            |> Dict.values
                            |> List.map .uuid
                        )

                Step.Step StepType ->
                    flatSelect s.state
                        { what = Type.HType HType.EventType
                        , muuid = Maybe.map .uuid model.eventType
                        , onInput = SelectType
                        , title = "Type:"
                        , explain = "Select the type of the new Event:"
                        , empty = "(There are no Event Types yet to choose from)"
                        , additional = Nothing
                        }
                        (model.processTypes
                            |> Dict.values
                            |> List.filterMap (\pt -> Dict.get (Uuid.toString pt) s.state.processTypes)
                            |> List.concatMap .eventTypes
                            |> List.map (\u -> ( Uuid.toString u, u ))
                            |> Dict.fromList
                        )

                Step.Step StepProvider ->
                    Maybe.map
                        (\et ->
                            column [ spacing 20 ]
                                [ flatSelect s.state
                                    { what = Type.TType TType.Agent
                                    , muuid = model.provider
                                    , onInput = SelectProvider
                                    , title = "Provider:"
                                    , explain = "Select the provider:"
                                    , empty = "(There are no agents yet to choose from)"
                                    , additional = Nothing
                                    }
                                    (s.state.agents
                                        |> Dict.filter (\_ a -> containsScope s.state.types (IsItem (Type.TType a.what) a.uuid) et.providers)
                                        |> Dict.map (\_ a -> a.uuid)
                                    )
                                ]
                        )
                        model.eventType
                        |> Maybe.withDefault (text "This event has no type")

                Step.Step StepReceiver ->
                    Maybe.map
                        (\et ->
                            column [ spacing 20 ]
                                [ flatSelect s.state
                                    { what = Type.TType TType.Agent
                                    , muuid = model.receiver
                                    , onInput = SelectReceiver
                                    , title = "Receiver:"
                                    , explain = "Select the receiver:"
                                    , empty = "(There are no agents yet to choose from)"
                                    , additional = Nothing
                                    }
                                    (s.state.agents
                                        |> Dict.filter (\_ a -> containsScope s.state.types (IsItem (Type.TType a.what) a.uuid) et.receivers)
                                        |> Dict.map (\_ a -> a.uuid)
                                    )
                                ]
                        )
                        model.eventType
                        |> Maybe.withDefault (text "This event has no type")

                Step.Step StepResource ->
                    column [ spacing 20 ]
                        [ model.qty
                            |> Maybe.map
                                (\qty ->
                                    Expression.Input.inputExpression
                                        { onEnter = Step.nextMsg model Button Step.NextPage Step.Added
                                        , onInput = InputQty
                                        , context = ( Type.TType TType.Event, model.uuid )
                                        }
                                        s.state
                                        ( [], qty )
                                        qty
                                )
                            |> Maybe.withDefault (text "This event has no type")
                        , -- if createResource, we already know the type of the resource
                          -- (it's defined in the scope of et.resources)
                          -- If not createResource, we ask to select the resource to add in the event.
                          if Maybe.map .createResource model.eventType == Just True then
                            column [ spacing 20 ]
                                [ flatSelect s.state
                                    { what = Type.HType HType.ResourceType
                                    , muuid = model.resourceType
                                    , onInput = SelectResourceType
                                    , title = "Type:"
                                    , explain = "Choose the type of the new Resource:"
                                    , empty = "(There are no Resource Types yet to choose from)"
                                    , additional = Nothing
                                    }
                                    (s.state.resourceTypes
                                        |> Dict.filter (\_ r -> model.eventType |> Maybe.map .resources |> Maybe.map (containsScope s.state.types (IsItem (Type.HType r.what) r.uuid)) |> Maybe.withDefault False)
                                        |> Dict.map (\_ a -> a.uuid)
                                    )
                                , inputIdentifiers { onEnter = Step.nextMsg model Button Step.NextPage Step.Added, onInput = InputResIdentifier } model.resIdentifiers
                                , inputValues { onEnter = Step.nextMsg model Button Step.NextPage Step.Added, onInput = InputResValue, context = ( Type.TType TType.Resource, model.resUuid ) } s.state model.resValues
                                , Element.map ResGroupMsg <| inputGroups { type_ = Type.TType TType.Resource, mpuuid = model.resourceType } s.state model.resgsubmodel
                                ]

                          else
                            model.eventType
                                |> Maybe.map .resources
                                |> Maybe.map
                                    (\scope ->
                                        column [ spacing 20 ]
                                            [ flatSelect s.state
                                                { what = Type.TType TType.Resource
                                                , muuid = model.resource
                                                , onInput = SelectResource
                                                , title = "Resource:"
                                                , explain = "Select the resource:"
                                                , empty = "(There are no resources yet to choose from)"
                                                , additional = Nothing
                                                }
                                                (s.state.resources
                                                    |> Dict.filter (\_ r -> containsScope s.state.types (IsItem (Type.TType r.what) r.uuid) scope)
                                                    |> Dict.map (\_ r -> r.uuid)
                                                )
                                            ]
                                    )
                                |> Maybe.withDefault (text "No resource scope defined")
                        ]

                Step.Step StepAllocate ->
                    column [ spacing 20 ]
                        [ h1 "Allocation"
                        , p "What amount do you allocate on each process?"
                        , column [] <| List.indexedMap (\i pp -> allocateEventToProcess s.state model.allocations i pp) model.allocations
                        ]

                Step.Step StepDate ->
                    column [ spacing 20, width fill ]
                        [ h1 "Select a date for the event"
                        , Element.map CalendarMsg <| DateTime.View.inputDate s model.calendar
                        ]

                Step.Step StepGroups ->
                    Element.map GroupMsg <| inputGroups { type_ = Type.TType TType.Event, mpuuid = Maybe.map .uuid model.eventType } s.state model.gsubmodel

                Step.Step StepIdentifiers ->
                    inputIdentifiers { onEnter = Step.nextMsg model Button Step.NextPage Step.Added, onInput = InputIdentifier } model.identifiers

                Step.Step StepValues ->
                    inputValues
                        { onEnter = Step.nextMsg model Button Step.NextPage Step.Added
                        , onInput = InputValue
                        , context = ( Type.TType TType.Event, model.uuid )
                        }
                        s.state
                        model.values
    in
    floatingContainer s
        (Just <| Button Step.Cancel)
        "Adding an Event"
        (List.map (Element.map Button) (buttons model (checkStep model)))
        [ step
        ]
