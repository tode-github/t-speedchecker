local displayUI = false

local policeVehicles = Config.Vehicles

for _, vehicle in ipairs(policeVehicles) do
    print("Available police vehicle: " .. vehicle)
end

function IsPoliceVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    for _, policeModel in ipairs(policeVehicles) do
        if model == GetHashKey(policeModel) then
            return true
        end
    end
    return false
end


function ToggleUI(show)
    displayUI = show
    SendNUIMessage({ type = "toggle", display = displayUI })
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local playerVehicle = GetVehiclePedIsIn(playerPed, false)
            
            if IsPoliceVehicle(playerVehicle) then
                if not displayUI then
                    ToggleUI(true)
                end
                
                local currentSpeed = GetEntitySpeed(playerVehicle) * 3.6 
                local coords = GetEntityCoords(playerVehicle)
                local forwardVector = GetEntityForwardVector(playerVehicle)
                local forwardCoords = coords + forwardVector * 55 
                local vehicleInFront = GetVehicleInDirection(coords, forwardCoords)

                local speedOfFrontVehicle = 0
                local licensePlate = "INGEN"
                if vehicleInFront then
                    speedOfFrontVehicle = GetEntitySpeed(vehicleInFront) * 3.6 
                    licensePlate = GetVehicleNumberPlateText(vehicleInFront) 
                end

                SendNUIMessage({
                    type = "update",
                    currentSpeed = math.floor(currentSpeed),
                    frontSpeed = math.floor(speedOfFrontVehicle),
                    licensePlate = licensePlate
                })
            else
                if displayUI then
                    ToggleUI(false)
                end
            end
        else
            if displayUI then
                ToggleUI(false)
            end
        end
    end
end)


function GetVehicleInDirection(coordFrom, coordTo)
    local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end
