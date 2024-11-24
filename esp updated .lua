-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = game:GetService("Workspace").CurrentCamera

-- Variables
local highlightEnabled = false
local logoUrl = "https://www.robloxlibrary.com/assets/images/thumbnail/6062375.jpg"  -- Example T-Rex logo URL
local logoSpeed = 30  -- Speed of the logo's movement
local currentCorner = "TopLeft"  -- Starting position
local highlightInstances = {}

-- Function to create and animate the T-Rex logo
local function createT_RexLogo()
    -- Create ScreenGui for the logo
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = PlayerGui

    -- Create ImageLabel (T-Rex logo)
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 100, 0, 100)  -- Set size of the logo
    logo.Position = UDim2.new(0, 10, 0, 10)  -- Initial position
    logo.Image = logoUrl  -- Set image (replace with your own logo URL)
    logo.BackgroundTransparency = 1  -- Remove background
    logo.Parent = screenGui

    -- Function to update the position based on selected corner
    local function updateLogoPosition()
        if currentCorner == "TopLeft" then
            logo.Position = UDim2.new(0, 10, 0, 10)
        elseif currentCorner == "TopRight" then
            logo.Position = UDim2.new(1, -110, 0, 10)
        elseif currentCorner == "BottomLeft" then
            logo.Position = UDim2.new(0, 10, 1, -110)
        elseif currentCorner == "BottomRight" then
            logo.Position = UDim2.new(1, -110, 1, -110)
        end
    end

    -- Function to animate the logo flowing across the screen
    local function animateLogo()
        while true do
            for i = 1, 10 do
                logo.Position = logo.Position + UDim2.new(0, logoSpeed, 0, 0)
                wait(0.02)
            end
            wait(0.5)
        end
    end

    -- Allow the user to click to change corners
    logo.MouseButton1Click:Connect(function()
        if currentCorner == "TopLeft" then
            currentCorner = "TopRight"
        elseif currentCorner == "TopRight" then
            currentCorner = "BottomRight"
        elseif currentCorner == "BottomRight" then
            currentCorner = "BottomLeft"
        else
            currentCorner = "TopLeft"
        end
        updateLogoPosition()
    end)

    -- Start the animation and update position
    animateLogo()
end

-- Function to create the GUI menu for Highlight Toggle
local function createMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 200)
    frame.Position = UDim2.new(0.5, -100, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = screenGui

    -- UICorner for rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)  -- Rounded corners
    corner.Parent = frame

    -- Toggle Highlight Button
    local toggleHighlightButton = Instance.new("TextButton")
    toggleHighlightButton.Size = UDim2.new(0, 180, 0, 40)
    toggleHighlightButton.Position = UDim2.new(0, 10, 0, 10)
    toggleHighlightButton.Text = "Enable Highlight"
    toggleHighlightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    toggleHighlightButton.Parent = frame

    -- UICorner for the buttons (optional, to make them rounded)
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = toggleHighlightButton

    -- Button functionality to toggle highlight
    toggleHighlightButton.MouseButton1Click:Connect(function()
        highlightEnabled = not highlightEnabled
        if highlightEnabled then
            toggleHighlightButton.Text = "Disable Highlight"
            toggleHighlightButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            enableHighlighting()
        else
            toggleHighlightButton.Text = "Enable Highlight"
            toggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            disableHighlighting()
        end
    end)
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

-- Function to highlight a player
local function highlightPlayer(player)
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

-- Update Highlights when a new player joins
Players.PlayerAdded:Connect(function(player)
    if highlightEnabled then
        highlightPlayer(player)
    end
end)

-- Initialize T-Rex Logo and Highlight menu
createT_RexLogo()
createMenu()
