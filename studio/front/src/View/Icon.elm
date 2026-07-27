module View.Icon exposing (agent, commitment, config, contract, event, group, process, resource)

import Element exposing (Element)
import Svg
import Svg.Attributes as A


resource : Svg.Svg msg
resource =
    Svg.svg
        [ A.width "17.574711mm"
        , A.height "17.574951mm"
        , A.viewBox "0 0 17.574711 17.574951"
        , A.version "1.1"
        , A.id "svg5"
        ]
        [ Svg.defs
            [ A.id "defs"
            ]
            []
        , Svg.g
            [ A.id "layer1"
            , A.transform "translate(-29.542797,-18.006565)"
            ]
            [ Svg.path
                [ A.id "rect111"
                , A.style "fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:4;stroke-linejoin:round"
                , A.d "m 31.542797,20.006565 h 13.574952 l -7.158803,8.15195 7.158803,5.423002 h -13.574952 z"
                ]
                []
            ]
        ]


event : Svg.Svg msg
event =
    Svg.svg
        [ A.width "18.195723mm"
        , A.height "18.049154mm"
        , A.viewBox "0 0 18.195723 18.049154"
        , A.version "1.1"
        , A.id "svg5"
        ]
        [ Svg.defs
            [ A.id "defs2"
            ]
            [ Svg.marker
                [ A.style "overflow:visible"
                , A.id "RoundedArrow"
                , A.refX "0"
                , A.refY "0"
                , A.orient "auto-start-reverse"
                , A.markerWidth "1.735"
                , A.markerHeight "1.6772331"
                , A.viewBox "0 0 6.1347524 5.9304951"
                , A.preserveAspectRatio "xMidYMid"
                ]
                [ Svg.path
                    [ A.transform "scale(0.7)"
                    , A.d "m -0.21114562,-4.1055728 6.42229122,3.21114561 a 1,1 90 0 1 0,1.78885438 l -6.42229122,3.21114561 a 1.236068,1.236068 31.717474 0 1 -1.78885438,-1.1055728 v -6 a 1.236068,1.236068 148.28253 0 1 1.78885438,-1.1055728 z"
                    , A.style "fill:context-stroke;fill-rule:evenodd;stroke:none"
                    , A.id "path1367"
                    ]
                    []
                ]
            ]
        , Svg.g
            [ A.id "layer1"
            , A.transform "translate(-59.580048,-17.458541)"
            ]
            [ Svg.path
                [ A.id "path4988"
                , A.style "opacity:0.9;fill:none;stroke:#000000;stroke-width:4;stroke-linejoin:round;marker-end:url(#RoundedArrow);stop-color:#000000"
                , A.d "m 69.600937,33.436898 c -3.460725,0.495421 -6.759276,-1.628699 -7.740119,-4.984292 -0.980843,-3.355593 0.6544,-6.921866 3.837133,-8.368334 3.182733,-1.446468 6.944748,-0.333106 8.827645,2.612528"
                ]
                []
            ]
        ]


agent : Svg.Svg msg
agent =
    Svg.svg
        [ A.width "17.574705mm"
        , A.height "17.574705mm"
        , A.viewBox "0 0 17.574705 17.574705"
        , A.version "1.1"
        , A.id "svg5"
        ]
        [ Svg.defs
            [ A.id "defs"
            ]
            []
        , Svg.g
            [ A.id "layer1"
            , A.transform "translate(-86.115221,-18.006812)"
            ]
            [ Svg.path
                [ A.id "rect4835"
                , A.style "fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:4;stroke-linejoin:round"
                , A.d "m 94.902574,20.006565 6.787476,13.574952 h -13.574953 z"
                ]
                []
            ]
        ]


config : Svg.Svg msg
config =
    Svg.svg
        [ A.width "17.102297mm"
        , A.height "18.210421mm"
        , A.viewBox "0 0 17.102297 18.210421"
        , A.version "1.1"
        , A.id "svg5"
        ]
        [ Svg.defs
            [ A.id "defs"
            ]
            []
        , Svg.g
            [ A.id "layer1"
            , A.transform "translate(-111.66448,-18.006812)"
            ]
            [ Svg.path
                [ A.id "path6929"
                , A.style "fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:4;stroke-linejoin:round"
                , A.d "m 113.64597,34.238243 4.27589,-4.846479 z"
                ]
                []
            , Svg.path
                [ A.id "path7520"
                , A.style "opacity:1;fill:none;stroke:#000000;stroke-width:4;stroke-linecap:round;stroke-linejoin:round;stop-color:#000000"
                , A.d "m 126.76678,25.303098 c 0,2.925056 -2.37122,5.296283 -5.29628,5.296286 -2.92506,2e-6 -5.29629,-2.371226 -5.29629,-5.296286 0,-2.92506 2.37123,-5.296288 5.29629,-5.296286"
                ]
                []
            ]
        ]
