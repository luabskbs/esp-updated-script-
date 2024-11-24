-- Parent this LocalScript to StarterPlayerScripts or a similar location

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- Variables
local highlightEnabled = true
local highlightInstances = {}
local menuOpen = true

-- Function to create the highlight menu
local function createMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0.5, -100, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = screenGui

    -- UICorner for rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)  -- Rounded corners
    corner.Parent = frame

    -- Toggle Highlight Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 180, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.Text = "Toggle Highlight"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    toggleButton.Parent = frame

    -- Close/Open Menu Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 180, 0, 40)
    closeButton.Position = UDim2.new(0, 10, 0, 60)
    closeButton.Text = "Close Menu"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Parent = frame

    -- UICorner for the buttons (optional, to make them rounded)
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = toggleButton
    buttonCorner.Parent = closeButton

    -- Button functionality to toggle highlight
    toggleButton.MouseButton1Click:Connect(function()
        highlightEnabled = not highlightEnabled
        if highlightEnabled then
            toggleButton.Text = "Disable Highlight"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            enableHighlighting()
        else
            toggleButton.Text = "Enable Highlight"
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            disableHighlighting()
        end
    end)

    -- Button functionality to close/open the menu
    closeButton.MouseButton1Click:Connect(function()
        if menuOpen then
            frame.Visible = false
            closeButton.Text = "Open Menu"
        else
            frame.Visible = true
            closeButton.Text = "Close Menu"
        end
        menuOpen = not menuOpen
    end)
end

-- Function to highlight all players
local function highlightPlayer(player)
    -- Check if the player's character exists
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Create a Highlight instance
                local highlight = Instance.new("Highlight")
                highlight.Adornee = part
                highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow highlight
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Red outline
                highlight.Parent = part

                -- Store highlight instance to manage it later
                table.insert(highlightInstances, highlight)
            end
        end
    end
end

-- Function to enable highlighting for all players
local function enableHighlighting()
    for _, player in ipairs(Players:GetPlayers()) do
        highlightPlayer(player)
    end
end

-- Function to disable highlighting for all players
local function disableHighlighting()
    for _, highlight in ipairs(highlightInstances) do
        highlight:Destroy()
    end
    highlightInstances = {} -- Reset the stored highlights
end

-- Loop through all players in the game and apply highlights if enabled
local function updateHighlights()
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if highlightEnabled then
                highlightPlayer(player)
            end
        end)
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        if highlightEnabled then
            highlightPlayer(player)
        end
    end
end

-- Create the menu
createMenu()

-- Update highlights when players join
updateHighlights()
