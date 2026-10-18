-- Servicio para obtener la interfaz del jugador
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Crear la interfaz principal (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServiceButtonGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Crear el FRAME de la SOMBRA (el borde negro de atrás)
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "Shadow"
shadowFrame.Size = UDim2.new(0, 300, 0, 64) -- Mismo tamaño que el botón
shadowFrame.Position = UDim2.new(0.5, -150, 0.5, -28) -- Posición base
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Color negro puro
shadowFrame.BorderSizePixel = 0
shadowFrame.ZIndex = 1 -- Se asegura de estar detrás del botón
shadowFrame.Parent = screenGui

-- Redondear las esquinas de la sombra
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12) -- Ajusta el radio según tu preferencia
shadowCorner.Parent = shadowFrame

-- Desplazar la sombra unos píxeles hacia abajo y a la derecha
shadowFrame.Position = shadowFrame.Position + UDim2.new(0, 6, 0, 6) -- El "6, 6" es el desplazamiento

-- 3. Crear el BOTÓN principal (el azul con texto)
local button = Instance.new("TextButton")
button.Name = "CreateServiceButton"
button.Size = UDim2.new(0, 300, 0, 64)
button.Position = UDim2.new(0.5, -150, 0.5, -28) -- Misma posición base que la sombra
button.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Azul brillante como el de la imagen
button.BorderSizePixel = 0
button.Text = "+   Create your first service" -- Texto con el símbolo "+"
button.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
button.TextSize = 22
button.Font = Enum.Font.GothamBold
button.ZIndex = 2 -- Se asegura de estar ENCIMA de la sombra
button.Parent = screenGui

-- Redondear las esquinas del botón (mismo radio que la sombra)
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = button

-- (Opcional) Añadir un borde interior sutil para dar más profundidad
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Thickness = 2
buttonStroke.Color = Color3.fromRGB(0, 0, 0)
buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
buttonStroke.Parent = button
