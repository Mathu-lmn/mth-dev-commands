local coords = false

RegisterCommand("devcoords", function()
    coords = not coords
    if coords then
        Citizen.CreateThread(function()
            while coords do
                Citizen.Wait(0)
                local entity = IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsIn(PlayerPedId(), false) or PlayerPedId()
                local x, y, z = table.unpack(GetEntityCoords(entity, true))

                local roundx = tonumber(string.format("%.2f", x))
                local roundy = tonumber(string.format("%.2f", y))
                local roundz = tonumber(string.format("%.2f", z))

                DrawTxt("~r~X:~s~ "..roundx, 0.32, 0.05)
                DrawTxt("~r~Y:~s~ "..roundy, 0.38, 0.05)
                DrawTxt("~r~Z:~s~ "..roundz, 0.445, 0.05)

                local heading = GetEntityHeading(entity)
                local roundh = tonumber(string.format("%.2f", heading))
                DrawTxt("~r~H:~s~ "..roundh, 0.50, 0.05)

                local rx,ry,rz = table.unpack(GetEntityRotation(PlayerPedId(), 1))
                DrawTxt("~r~RX:~s~ "..tonumber(string.format("%.2f", rx)), 0.38, 0.08)
                DrawTxt("~r~RY:~s~ "..tonumber(string.format("%.2f", ry)), 0.44, 0.08)
                DrawTxt("~r~RZ:~s~ "..tonumber(string.format("%.2f", rz)), 0.495, 0.08)

                local speed = GetEntitySpeed(PlayerPedId())
                local rounds = tonumber(string.format("%.2f", speed))
                DrawTxt("~r~Player Speed: ~s~"..rounds, 0.40, 0.92)

                local health = GetEntityHealth(PlayerPedId())
                DrawTxt("~r~Player Health: ~s~"..health, 0.40, 0.95)

                local camRotX = GetGameplayCamRot(2).x
                DrawTxt("~r~CR X: ~s~"..tonumber(string.format("%.2f", camRotX)), 0.36, 0.88)

                local camRotY = GetGameplayCamRot(2).y
                DrawTxt("~r~CR Y: ~s~"..tonumber(string.format("%.2f", camRotY)), 0.44, 0.88)

                local camRotZ = GetGameplayCamRot(2).z
                DrawTxt("~r~CR Z: ~s~"..tonumber(string.format("%.2f", camRotZ)), 0.51, 0.88)

                local veheng = GetVehicleEngineHealth(GetVehiclePedIsUsing(PlayerPedId()))
                local vehbody = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    local vehenground = tonumber(string.format("%.2f", veheng))
                    local vehbodround = tonumber(string.format("%.2f", vehbody))

                    DrawTxt("~r~Engine Health: ~s~"..vehenground, 0.015, 0.76)

                    DrawTxt("~r~Body Health: ~s~"..vehbodround, 0.015, 0.73)
                    local state = Entity(GetVehiclePedIsUsing(PlayerPedId())).state
                    DrawTxt("~r~Vehicle Fuel: ~s~"..tonumber(string.format("%.2f", GetVehicleFuelLevel(GetVehiclePedIsUsing(PlayerPedId())))) .. " - " .. state.fuel , 0.015, 0.70)
                end
            end
        end)
    end
end, false)

local showProps = false

RegisterCommand("devprops", function()
    showProps = not showProps
    if showProps then
        Citizen.CreateThread(function()
            while showProps do
                Citizen.Wait(0)
                local pPed = PlayerPedId()
                for k, v in pairs(GetGamePool("CObject")) do
                    if DoesEntityExist(v) then
                        local coords = GetEntityCoords(v)
                        local dst = #(GetEntityCoords(pPed) - coords)
                        if dst <= 15.0 then
                            if IsEntityOnScreen(v) then
                                -- show a box around the prop, draw a text with the prop hash
                                local x, y, z = table.unpack(GetEntityCoords(v))
                                local rx, ry, rz = table.unpack(GetEntityRotation(v, 2))
                                local hash = GetEntityModel(v)

                                DrawText3D(x, y, z, "Hash: " .. hash .. "\nName : ".. GetEntityArchetypeName(v) .."\nCoords: " .. x .. ", " .. y .. ", " .. z .. "\nRotation: " .. rx .. ", " .. ry .. ", " .. rz)
                                DrawBoxAroundEntity(v)
                            end
                        end
                    end
                end
            end
        end)
    end
end, false)

local bones = {
    ["SKEL_ROOT"] = 0,
    ["FB_R_Brow_Out_000"] = 1356,
    ["SKEL_L_Toe0"] = 2108,
    ["MH_R_Elbow"] = 2992,
    ["SKEL_L_Finger01"] = 4089,
    ["SKEL_L_Finger02"] = 4090,
    ["SKEL_L_Finger31"] = 4137,
    ["SKEL_L_Finger32"] = 4138,
    ["SKEL_L_Finger41"] = 4153,
    ["SKEL_L_Finger42"] = 4154,
    ["SKEL_L_Finger11"] = 4169,
    ["SKEL_L_Finger12"] = 4170,
    ["SKEL_L_Finger21"] = 4185,
    ["SKEL_L_Finger22"] = 4186,
    ["RB_L_ArmRoll"] = 5232,
    ["IK_R_Hand"] = 6286,
    ["RB_R_ThighRoll"] = 6442,
    ["SKEL_R_Clavicle"] = 10706,
    ["FB_R_Lip_Corner_000"] = 11174,
    ["SKEL_Pelvis"] = 11816,
    ["IK_Head"] = 12844,
    ["SKEL_L_Foot"] = 14201,
    ["MH_R_Knee"] = 16335,
    ["FB_LowerLipRoot_000"] = 17188,
    ["FB_R_Lip_Top_000"] = 17719,
    ["SKEL_L_Hand"] = 18905,
    ["FB_R_CheekBone_000"] = 19336,
    ["FB_UpperLipRoot_000"] = 20178,
    ["FB_L_Lip_Top_000"] = 20279,
    ["FB_LowerLip_000"] = 20623,
    ["SKEL_R_Toe0"] = 20781,
    ["FB_L_CheekBone_000"] = 21550,
    ["MH_L_Elbow"] = 22711,
    ["SKEL_Spine0"] = 23553,
    ["RB_L_ThighRoll"] = 23639,
    ["PH_R_Foot"] = 24806,
    ["SKEL_Spine1"] = 24816,
    ["SKEL_Spine2"] = 24817,
    ["SKEL_Spine3"] = 24818,
    ["FB_L_Eye_000"] = 25260,
    ["SKEL_L_Finger00"] = 26610,
    ["SKEL_L_Finger10"] = 26611,
    ["SKEL_L_Finger20"] = 26612,
    ["SKEL_L_Finger30"] = 26613,
    ["SKEL_L_Finger40"] = 26614,
    ["FB_R_Eye_000"] = 27474,
    ["SKEL_R_Forearm"] = 28252,
    ["PH_R_Hand"] = 28422,
    ["FB_L_Lip_Corner_000"] = 29868,
    ["SKEL_Head"] = 31086,
    ["IK_R_Foot"] = 35502,
    ["RB_Neck_1"] = 35731,
    ["IK_L_Hand"] = 36029,
    ["SKEL_R_Calf"] = 36864,
    ["RB_R_ArmRoll"] = 37119,
    ["FB_Brow_Centre_000"] = 37193,
    ["SKEL_Neck_1"] = 39317,
    ["SKEL_R_UpperArm"] = 40269,
    ["FB_R_Lid_Upper_000"] = 43536,
    ["RB_R_ForeArmRoll"] = 43810,
    ["SKEL_L_UpperArm"] = 45509,
    ["FB_L_Lid_Upper_000"] = 45750,
    ["MH_L_Knee"] = 46078,
    ["FB_Jaw_000"] = 46240,
    ["FB_L_Lip_Bot_000"] = 47419,
    ["FB_Tongue_000"] = 47495,
    ["FB_R_Lip_Bot_000"] = 49979,
    ["SKEL_R_Thigh"] = 51826,
    ["SKEL_R_Foot"] = 52301,
    ["IK_Root"] = 56604,
    ["SKEL_R_Hand"] = 57005,
    ["SKEL_Spine_Root"] = 57597,
    ["PH_L_Foot"] = 57717,
    ["SKEL_L_Thigh"] = 58271,
    ["FB_L_Brow_Out_000"] = 58331,
    ["SKEL_R_Finger00"] = 58866,
    ["SKEL_R_Finger10"] = 58867,
    ["SKEL_R_Finger20"] = 58868,
    ["SKEL_R_Finger30"] = 58869,
    ["SKEL_R_Finger40"] = 58870,
    ["PH_L_Hand"] = 60309,
    ["RB_L_ForeArmRoll"] = 61007,
    ["SKEL_L_Forearm"] = 61163,
    ["FB_UpperLip_000"] = 61839,
    ["SKEL_L_Calf"] = 63931,
    ["SKEL_R_Finger01"] = 64016,
    ["SKEL_R_Finger02"] = 64017,
    ["SKEL_R_Finger31"] = 64064,
    ["SKEL_R_Finger32"] = 64065,
    ["SKEL_R_Finger41"] = 64080,
    ["SKEL_R_Finger42"] = 64081,
    ["SKEL_R_Finger11"] = 64096,
    ["SKEL_R_Finger12"] = 64097,
    ["SKEL_R_Finger21"] = 64112,
    ["SKEL_R_Finger22"] = 64113,
    ["SKEL_L_Clavicle"] = 64729,
    ["FACIAL_facialRoot"] = 65068,
    ["IK_L_Foot"] = 65245,
}

local showBones = false

RegisterCommand("devbones", function()
    showBones = not showBones
    if showBones then
        Citizen.CreateThread(function()
            while showBones do
                Citizen.Wait(0)
                local pPed = PlayerPedId()
                for k, v in pairs(bones) do
                    local coords = GetPedBoneCoords(pPed, v, 0.0, 0.0, 0.0)
                    DrawText3D(coords.x, coords.y, coords.z, k)
                end
            end
        end)
    end
end, false)

local showTrafficNodes = false

RegisterCommand("devtraffic", function()
    showTrafficNodes = not showTrafficNodes
    if showTrafficNodes then
        Citizen.CreateThread(function()
            while showTrafficNodes do
                Citizen.Wait(0)
                for i = 0, 20 do
                    local node, outPos = GetNthClosestVehicleNode(GetEntityCoords(PlayerPedId()), i, 0, 0.0, 0.0)
                    if node ~= 0 then
                        local streetHash = GetStreetNameAtCoord(outPos.x, outPos.y, outPos.z)
                        local streetName = GetStreetNameFromHashKey(streetHash)
                        DrawMarker(28, outPos.x, outPos.y, outPos.z, 0.0, 0.0, 0.0, 0, 0, 0, 5.0, 5.0, 5.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                        DrawText3D(outPos.x, outPos.y, outPos.z, streetName)
                    end
                end
            end
        end)
    end
end, false)

local MaterialHash = {
    none = -1,
    unk = -1775485061,
    concrete = 1187676648,
    concrete_pothole = 359120722,
    concrete_dusty = -1084640111,
    tarmac = 282940568,
    tarmac_painted = -1301352528,
    tarmac_pothole = 1886546517,
    rumble_strip = -250168275,
    breeze_block = -954112554,
    rock = -840216541,
    rock_mossy = -124769592,
    stone = 765206029,
    cobblestone = 576169331,
    brick = 1639053622,
    marble = 1945073303,
    paving_slab = 1907048430,
    sandstone_solid = 592446772,
    sandstone_brittle = 1913209870,
    sand_loose = -1595148316,
    sand_compact = 510490462,
    sand_wet = 909950165,
    sand_track = -1907520769,
    sand_underwater = -1136057692,
    sand_dry_deep = 509508168,
    sand_wet_deep = 1288448767,
    ice = -786060715,
    ice_tarmac = -1931024423,
    snow_loose = -1937569590,
    snow_compact = -878560889,
    snow_deep = 1619704960,
    snow_tarmac = 1550304810,
    gravel_small = 951832588,
    gravel_large = 2128369009,
    gravel_deep = -356706482,
    gravel_train_track = 1925605558,
    dirt_track = -1885547121,
    mud_hard = -1942898710,
    mud_pothole = 312396330,
    mud_soft = 1635937914,
    mud_underwater = -273490167,
    mud_deep = 1109728704,
    marsh = 223086562,
    marsh_deep = 1584636462,
    soil = -700658213,
    clay_hard = 1144315879,
    clay_soft = 560985072,
    grass_long = -461750719,
    grass = 1333033863,
    grass_short = -1286696947,
    hay = -1833527165,
    bushes = 581794674,
    twigs = -913351839,
    leaves = -2041329971,
    woodchips = -309121453,
    tree_bark = -1915425863,
    metal_solid_small = -1447280105,
    metal_solid_medium = -365631240,
    metal_solid_large = 752131025,
    metal_hollow_small = 15972667,
    metal_hollow_medium = 1849540536,
    metal_hollow_large = -583213831,
    metal_chainlink_small = 762193613,
    metal_chainlink_large = 125958708,
    metal_corrugated_iron = 834144982,
    metal_grille = -426118011,
    metal_railing = 2100727187,
    metal_duct = 1761524221,
    metal_garage_door = -231260695,
    metal_manhole = -754997699,
    wood_solid_small = -399872228,
    wood_solid_medium = 555004797,
    wood_solid_large = 815762359,
    wood_solid_polished = 126470059,
    wood_floor_dusty = -749452322,
    wood_hollow_small = 1993976879,
    wood_hollow_medium = -365476163,
    wood_hollow_large = -925419289,
    wood_chipboard = 1176309403,
    wood_old_creaky = 722686013,
    wood_high_density = -1742843392,
    wood_lattice = 2011204130,
    ceramic = -1186320715,
    roof_tile = 1755188853,
    roof_felt = -1417164731,
    fibreglass = 1354180827,
    tarpaulin = -642658848,
    plastic = -2073312001,
    plastic_hollow = 627123000,
    plastic_high_density = -1625995479,
    plastic_clear = -1859721013,
    plastic_hollow_clear = 772722531,
    plastic_high_density_clear = -1338473170,
    fibreglass_hollow = -766055098,
    rubber = -145735917,
    rubber_hollow = -783934672,
    linoleum = 289630530,
    laminate = 1845676458,
    carpet_solid = 669292054,
    carpet_solid_dusty = 158576196,
    carpet_floorboard = -1396484943,
    cloth = 122789469,
    plaster_solid = -574122433,
    plaster_brittle = -251888898,
    cardboard_sheet = 236511221,
    cardboard_box = -1409054440,
    paper = 474149820,
    foam = 808719444,
    feather_pillow = 1341866303,
    polystyrene = -1756927331,
    leather = -570470900,
    tvscreen = 1429989756,
    slatted_blinds = 673696729,
    glass_shoot_through = 937503243,
    glass_bulletproof = 244521486,
    glass_opaque = 1500272081,
    perspex = -1619794068,
    car_metal = -93061983,
    car_plastic = 2137197282,
    car_softtop = -979647862,
    car_softtop_clear = 2130571536,
    car_glass_weak = 1247281098,
    car_glass_medium = 602884284,
    car_glass_strong = 1070994698,
    car_glass_bulletproof = -1721915930,
    car_glass_opaque = 513061559,
    water = 435688960,
    blood = 5236042,
    oil = -634481305,
    petrol = -1634184340,
    fresh_meat = 868733839,
    dried_meat = -1445160429,
    emissive_glass = 1501078253,
    emissive_plastic = 1059629996,
    vfx_metal_electrified = -309134265,
    vfx_metal_water_tower = 611561919,
    vfx_metal_steam = -691277294,
    vfx_metal_flame = 332778253,
    phys_no_friction = 1666473731,
    phys_golf_ball = -1693813558,
    phys_tennis_ball = -256704763,
    phys_caster = -235302683,
    phys_caster_rusty = 2016463089,
    phys_car_void = 1345867677,
    phys_ped_capsule = -291631035,
    phys_electric_fence = -1170043733,
    phys_electric_metal = -2013761145,
    phys_barbed_wire = -1543323456,
    phys_pooltable_surface = 605776921,
    phys_pooltable_cushion = 972939963,
    phys_pooltable_ball = -748341562,
    buttocks = 483400232,
    thigh_left = -460535871,
    shin_left = 652772852,
    foot_left = 1926285543,
    thigh_right = -236981255,
    shin_right = -446036155,
    foot_right = -1369136684,
    spine0 = -1922286884,
    spine1 = -1140112869,
    spine2 = 1457572381,
    spine3 = 32752644,
    clavicle_left = -1469616465,
    upper_arm_left = -510342358,
    lower_arm_left = 1045062756,
    hand_left = 113101985,
    clavicle_right = -1557288998,
    upper_arm_right = 1501153539,
    lower_arm_right = 1777921590,
    hand_right = 2000961972,
    neck = 1718294164,
    head = -735392753,
    animal_default = 286224918,
    car_engine = -1916939624,
    puddle = 999829011,
    concrete_pavement = 2015599386,
    brick_pavement = -1147361576,
    phys_dynamic_cover_bound = -2047468855,
    vfx_wood_beer_barrel = 998201806,
    wood_high_friction = -2140087047,
    rock_noinst = 127813971,
    bushes_noinst = 1441114862,
    metal_solid_road_surface = -729112334,
    stunt_ramp_surface = -2088174996,
    temp_01 = 746881105,
    temp_02 = -1977970111,
    temp_03 = 1911121241,
    temp_04 = 1923995104,
    temp_05 = -1393662448,
    temp_06 = 1061250033,
    temp_07 = -1765523682,
    temp_08 = 1343679702,
    temp_09 = 1026054937,
    temp_10 = 63305994,
    temp_11 = 47470226,
    temp_12 = 702596674,
    temp_13 = -1637485913,
    temp_14 = -645955574,
    temp_15 = -1583997931,
    temp_16 = -1512735273,
    temp_17 = 1011960114,
    temp_18 = 1354993138,
    temp_19 = -801804446,
    temp_20 = -2052880405,
    temp_21 = -1037756060,
    temp_22 = -620388353,
    temp_23 = 465002639,
    temp_24 = 1963820161,
    temp_25 = 1952288305,
    temp_26 = -1116253098,
    temp_27 = 889255498,
    temp_28 = -1179674098,
    temp_29 = 1078418101,
    temp_30 = 13626292
}

local showMaterial = false

RegisterCommand("devground", function()
    showMaterial = not showMaterial
    if showMaterial then
        Citizen.CreateThread(function()
            while showMaterial do
                Citizen.Wait(0)
                local pPed = PlayerPedId()
                local coords = GetEntityCoords(pPed)
                local handle = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z - 2.0, 339, pPed, 0)
                local _, _, _, _, materialHash = GetShapeTestResultIncludingMaterial(handle)
                local materialName = nil
                for k, v in pairs(MaterialHash) do
                    if v == materialHash then
                        materialName = k
                        break
                    end
                end
                DrawText3D(coords.x, coords.y, coords.z, tostring(materialName or materialHash))
            end
        end)
    end
end, false)


-- UTILS --


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function DrawBoxAroundEntity(entity)
    local model = GetEntityModel(entity)
    local maxDim , minDim = GetModelDimensions(model)
    local a = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, minDim.z)
    local b = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, minDim.z)
    local c = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, minDim.z)
    local d = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, minDim.z)
    local e = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, maxDim.z)
    local f = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, maxDim.z)
    local g = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, maxDim.z)
    local h = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, maxDim.z)
    DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, 255, 0, 0, 255)
    DrawLine(b.x, b.y, b.z, c.x, c.y, c.z, 255, 0, 0, 255)
    DrawLine(c.x, c.y, c.z, d.x, d.y, d.z, 255, 0, 0, 255)
    DrawLine(d.x, d.y, d.z, a.x, a.y, a.z, 255, 0, 0, 255)
    DrawLine(e.x, e.y, e.z, f.x, f.y, f.z, 255, 0, 0, 255)
    DrawLine(f.x, f.y, f.z, g.x, g.y, g.z, 255, 0, 0, 255)
    DrawLine(g.x, g.y, g.z, h.x, h.y, h.z, 255, 0, 0, 255)
    DrawLine(h.x, h.y, h.z, e.x, e.y, e.z, 255, 0, 0, 255)
    DrawLine(a.x, a.y, a.z, e.x, e.y, e.z, 255, 0, 0, 255)
    DrawLine(b.x, b.y, b.z, f.x, f.y, f.z, 255, 0, 0, 255)
    DrawLine(c.x, c.y, c.z, g.x, g.y, g.z, 255, 0, 0, 255)
    DrawLine(d.x, d.y, d.z, h.x, h.y, h.z, 255, 0, 0, 255)
end

function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(true)
	SetTextScale(0.0, 0.4)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	EndTextCommandDisplayText(x, y)
end
