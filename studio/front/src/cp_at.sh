#!/bin/bash

for i in Resource Contract Process; do
    for p in Add List View; do
        cp AgentType/${p}Page.elm ${i}Type/
        sed -i "s/Agent/$i/g" ${i}Type/${p}Page.elm
        sed -i "s/agent/${i,,}/g" ${i}Type/${p}Page.elm
        sed -i 's/sss/sses/g' ProcessType/${p}Page.elm
        cp Agent/${p}Page.elm ${i}/
        sed -i "s/Agent/$i/g" ${i}/${p}Page.elm
        sed -i "s/agent/${i,,}/g" ${i}/${p}Page.elm
        sed -i 's/sss/sses/g' Process/${p}Page.elm
        sed -i 's/m.uuid h.uuid Dict.empty/m.uuid h.uuid (millisToPosix 0) Dict.empty/' Commitment/AddPage.elm
        sed -i 's/m.uuid h.uuid Dict.empty/m.uuid h.uuid (millisToPosix 0) Dict.empty/' Event/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.RT h/' ResourceType/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.ET h/' EventType/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.CmT h/' CommitmentType/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.CnT h/' ContractType/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.PT h/' ProcessType/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.GT h/' GroupType/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.R t/' Resource/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.E t/' Event/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.Cm t/' Commitment/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.Cn t/' Contract/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.P t/' Process/AddPage.elm
        sed -i 's/Groupable.A t/Groupable.G t/' Group/AddPage.elm
        sed -i 's/Message.AddedGroup/Message.DefinedGroup/' Group/AddPage.elm
        sed -i 's/h.uuid Dict.empty/h.uuid Empty Dict.empty/' Group/AddPage.elm
        sed -i 's/h.uuid Dict.empty/h.uuid (millisToPosix 0) Dict.empty/' Process/AddPage.elm
        sed -i 's/Route.ProcessList.*-/Route.ProcessList _-/' Process/ListPage.elm
        sed -i 's/an Group/a Group/' Group*/*Page.elm
        sed -i 's/an Commit/a Commit/' Commitment*/*Page.elm
        sed -i 's/an Contract/a Contract/' Contract*/*Page.elm
        sed -i 's/an Process/a Process/' Process*/*Page.elm
        sed -i 's/an Resource/a Resource/' Resource*/*Page.elm
        sed -i 's/import Spa.Page/import Spa.Page\nimport Time exposing (millisToPosix)/' Process/AddPage.elm Event/AddPage.elm Commitment/AddPage.elm
        sed -i 's/\nimport Time exposing (millisToPosix)\nimport Time exposing (millisToPosix)/\nimport Time exposing (millisToPosix)/' Process/AddPage.elm Event/AddPage.elm Commitment/AddPage.elm
        sed -i 's/Route.ProcessList ->/Route.ProcessList _ ->/' Process/ListPage.elm
    done
done

elm-format --yes */*Page.elm
