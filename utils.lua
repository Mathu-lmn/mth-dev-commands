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
    local maxDim, minDim = GetModelDimensions(model)

    local corners = {
        GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, minDim.z),
        GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, minDim.z),
        GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, minDim.z),
        GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, minDim.z),
        GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, maxDim.z),
        GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, maxDim.z),
        GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, maxDim.z),
        GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, maxDim.z)
    }

    for i = 1, 4 do
        local nextIndex = (i % 4) + 1
        DrawLine(corners[i].x, corners[i].y, corners[i].z, corners[nextIndex].x, corners[nextIndex].y, corners[nextIndex].z, 255, 0, 0, 255)
    end

    for i = 5, 8 do
        local nextIndex = ((i - 4) % 4) + 5
        DrawLine(corners[i].x, corners[i].y, corners[i].z, corners[nextIndex].x, corners[nextIndex].y, corners[nextIndex].z, 255, 0, 0, 255)
    end

    for i = 1, 4 do
        DrawLine(corners[i].x, corners[i].y, corners[i].z, corners[i + 4].x, corners[i + 4].y, corners[i + 4].z, 255, 0, 0, 255)
    end
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
