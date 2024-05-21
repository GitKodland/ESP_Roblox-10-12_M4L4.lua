-- Creación de GUI para el temporizador
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
local textLabel = Instance.new("TextLabel", screenGui)
-- Configuración de la GUI
textLabel.Text = ""
textLabel.TextSize = 60
textLabel.Font = Enum.Font.SourceSansBold
-- Colocación del texto TextLabel
textLabel.Position = UDim2.new(0.5, 0, 0.1, 0)
-- Almacenamiento de los nombres de los bloques Inicio y Fin
local startName = "Start"
local finishName = "Finish"

-- Creación del temporizador
local timerStarted = false
local startTime = 0

-- Una función que busca el objeto por su nombre
local function findObject(objectName)
	return game.Workspace:WaitForChild(objectName)
end

local function checkObject(object)
	while true do
		if object then
			print("Localizó el objeto: " .. object.Name)
			object.Touched:Connect(function(hit)
				if hit.Parent.Name == game.Players.LocalPlayer.Name then
					if object.Name == startName then
						timerStarted = true
						startTime = os.clock()
						textLabel.TextColor3 = Color3.new(0, 0.3, 1)
						textLabel.Text = "¡Inicio!"
					elseif object.Name == finishName and timerStarted then
						timerStarted = false
						textLabel.TextColor3 = Color3.new(1, 0, 0)
						local finishTime = os.clock()
						local raceTime = finishTime - startTime
						local seconds = math.floor(raceTime)
						local milliseconds = math.floor((raceTime - seconds) * 100)
						local timeend = string.format("%02d:%02d", seconds, milliseconds)
						textLabel.Text = "Su tiempo es: "..timeend.." segundos"
					end
				end
			end)
			return
		else
			wait(1) -- Pausa de 1 segundo antes del siguiente intento de búsqueda
		end
	end
end

-- Ejecutar una coroutina que busque el objeto Start
coroutine.wrap(function()
	local startObject = findObject(startName)
	checkObject(startObject)
end)()

-- Ejecutar una coroutina que busque el objeto Finish
coroutine.wrap(function()
	local finishObject = findObject(finishName)
	checkObject(finishObject)
end)()

-- Este código actualiza el temporizador cada centésima de segundo
while wait(0.01) do
	if timerStarted then
		local currentTime = os.clock()
		local elapsedTime = currentTime - startTime
		local seconds = math.floor(elapsedTime)
		local milliseconds = math.floor((elapsedTime - seconds) * 100)
		textLabel.Text = string.format("%02d:%02d", seconds, milliseconds)
	end
end