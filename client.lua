local tonumber = tonumber
local stringFormat = string.format

local coords = false
local showProps = false
local showBones = false
local showMaterial = false
local showTrafficNodes = false

local function devCoords()
    local playerPed, entity, entityCoords, roundx, roundy, roundz, heading, roundh,
    rotationPlayer, speed, rounds, health, camRot
    
    while coords do
        Citizen.Wait(0)
        playerPed = PlayerPedId()
        entity = IsPedInAnyVehicle(playerPed, false) and GetVehiclePedIsIn(playerPed, false) or playerPed
        entityCoords = GetEntityCoords(entity, true)

        roundx = tonumber(stringFormat("%.2f", entityCoords.x))
        roundy = tonumber(stringFormat("%.2f", entityCoords.y))
        roundz = tonumber(stringFormat("%.2f", entityCoords.z))

        DrawTxt("~r~X:~s~ "..roundx, 0.32, 0.05)
        DrawTxt("~r~Y:~s~ "..roundy, 0.38, 0.05)
        DrawTxt("~r~Z:~s~ "..roundz, 0.445, 0.05)

        heading = GetEntityHeading(entity)
        roundh = tonumber(stringFormat("%.2f", heading))
        DrawTxt("~r~H:~s~ "..roundh, 0.50, 0.05)

        rotationPlayer = GetEntityRotation(playerPed, 1)
        DrawTxt("~r~RX:~s~ "..tonumber(stringFormat("%.2f", rotationPlayer.x)), 0.38, 0.08)
        DrawTxt("~r~RY:~s~ "..tonumber(stringFormat("%.2f", rotationPlayer.y)), 0.44, 0.08)
        DrawTxt("~r~RZ:~s~ "..tonumber(stringFormat("%.2f", rotationPlayer.z)), 0.495, 0.08)

        speed = GetEntitySpeed(playerPed)
        rounds = tonumber(stringFormat("%.2f", speed))
        DrawTxt("~r~Player Speed: ~s~"..rounds, 0.40, 0.92)

        health = GetEntityHealth(playerPed)
        DrawTxt("~r~Player Health: ~s~"..health, 0.40, 0.95)

        camRot = GetGameplayCamRot(2)
        DrawTxt("~r~CR X: ~s~"..tonumber(stringFormat("%.2f", camRot.x)), 0.36, 0.88)
        DrawTxt("~r~CR Y: ~s~"..tonumber(stringFormat("%.2f", camRot.y)), 0.44, 0.88)
        DrawTxt("~r~CR Z: ~s~"..tonumber(stringFormat("%.2f", camRot.z)), 0.51, 0.88)

        if IsPedInAnyVehicle(playerPed, false) then
            local vehenground = tonumber(stringFormat("%.2f", GetVehicleEngineHealth(entity)))
            local vehbodround = tonumber(stringFormat("%.2f", GetVehicleBodyHealth(entity)))

            DrawTxt("~r~Engine Health: ~s~"..vehenground, 0.015, 0.76)

            DrawTxt("~r~Body Health: ~s~"..vehbodround, 0.015, 0.73)
            local state = Entity(entity).state
            DrawTxt("~r~Vehicle Fuel: ~s~"..tonumber(stringFormat("%.2f", GetVehicleFuelLevel(entity) .. " - " .. state.fuel , 0.015, 0.70)))
        end
    end
end

local function devProps()
    local playerPed, coords, rotation, hash, objectPool, dst,
    coords2

    while showProps do
        Citizen.Wait(0)
        playerPed = PlayerPedId()
        objectPool = GetGamePool("CObject")
        for i = 1, #objectPool do
            if DoesEntityExist(objectPool[i]) then
                coords = GetEntityCoords(objectPool[i])
                dst = #(GetEntityCoords(playerPed) - coords)

                if (dst <= 15.0) then
                    if IsEntityOnScreen(objectPool[i]) then
                        coords2 = GetEntityCoords(objectPool[i]) -- useless since it's the same as coords?
                        rotation = GetEntityRotation(objectPool[i], 2)
                        hash = GetEntityModel(objectPool[i])

                        DrawText3D(coords2.x, coords2.y, coords2.z, "Hash: " .. hash .. "\nName : ".. GetEntityArchetypeName(objectPool[i]) .."\nCoords: " .. coords2.x .. ", " .. coords2.y .. ", " .. coords2.z .. "\nRotation: " .. rotation.x .. ", " .. rotation.y .. ", " .. rotation.z)
                        DrawBoxAroundEntity(objectPool[i])
                    end
                end
            end
        end
    end
end

local function devBones()
    local playerPed, coords
    while showBones do
        Citizen.Wait(0)
        playerPed = PlayerPedId()

        for k, v in pairs(BONES) do
            coords = GetPedBoneCoords(playerPed, v, 0.0, 0.0, 0.0)
            DrawText3D(coords.x, coords.y, coords.z, k)
        end
    end
end

local function devTraffic()
    local node, outPos, streetHash, streetName
    while showTrafficNodes do
        Citizen.Wait(0)

        for i = 0, 20 do
            node, outPos = GetNthClosestVehicleNode(GetEntityCoords(PlayerPedId()), i, 0, 0.0, 0.0)

            if node ~= 0 then
                streetHash = GetStreetNameAtCoord(outPos.x, outPos.y, outPos.z)
                streetName = GetStreetNameFromHashKey(streetHash)
                DrawMarker(28, outPos.x, outPos.y, outPos.z, 0.0, 0.0, 0.0, 0, 0, 0, 5.0, 5.0, 5.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                DrawText3D(outPos.x, outPos.y, outPos.z, streetName)
            end
        end
    end
end

local function devGround()
    local playerPed, coords, handle, materialName
    local _, _, _, _, materialHash
    while showMaterial do
        Citizen.Wait(0)

        playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
        handle = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z - 2.0, 339, playerPed, 0)
        _, _, _, _, materialHash = GetShapeTestResultIncludingMaterial(handle)
        
        for k, v in pairs(MATERIAL_HASH) do
            if v == materialHash then
                materialName = k
                break
            end
        end
        DrawText3D(coords.x, coords.y, coords.z, tostring(materialName or materialHash))
    end
end

RegisterCommand("devground", function()
    showMaterial = not showMaterial
    if not showMaterial then return end
    Citizen.CreateThread(devGround)
end, false)

RegisterCommand("devtraffic", function()
    showTrafficNodes = not showTrafficNodes
    if not showTrafficNodes then return end
    Citizen.CreateThread(devTraffic)
end, false)

RegisterCommand("devcoords", function()
    coords = not coords
    if not coords then return end
    Citizen.CreateThread(devCoords)
end, false)

RegisterCommand("devprops", function()
    showProps = not showProps
    if not showProps then return end
    Citizen.CreateThread(devProps)
end, false)

RegisterCommand("devbones", function()
    showBones = not showBones
    if not showBones then return end
    Citizen.CreateThread(devBones)
end, false)