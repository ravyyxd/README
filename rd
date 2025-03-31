local gameContextIdentifier = "gameContext"

--FAKE IDENITY

local function printIdentity()
    if _G[gameContextIdentifier] then
        print("Current identity is 6")
    else
        print("Current identity is 6")
    end
end

local function getIdenity()
    if IsRobloxOpen() then
        if _G[gameContextIdentifier] then
            print("6")
        else
            print("6")
        end
    end
end

local function setGameContext()
    _G[gameContextIdentifier] = true
end

if game then
    setGameContext()
end

_G.printIdentity = printIdentity

if _G[gameContextIdentifier] then
    printIdentity()
else
    printIdentity()
end

local function getidenity() {
    getIdenity()
}

local function hookmetamethod(target, metamethod, newfunc)
    local mt = getmetatable(target)
    if not mt then
        mt = {}
        setmetatable(target, mt)
    end

    local oldfunc = mt[metamethod]
    mt[metamethod] = newfunc

    return oldfunc
end

local function hookfunction(target, newfunc)
    local oldfunc = target
    target = newfunc

    return oldfunc
end

local exampleTable = {
    exampleMethod = function(self, arg)
        print("Original method called with argument:", arg)
    end
}

local oldIndex = hookmetamethod(exampleTable, "__index", function(self, key)
    print("__index metamethod called with key:", key)
    return rawget(self, key)
end)

local oldMethod = hookfunction(exampleTable.exampleMethod, function(self, arg)
    print("Hooked method called with argument:", arg)
    return oldMethod(self, arg)
end)

exampleTable.exampleMethod(exampleTable, "test")
exampleTable.nonexistentKey

-- init.lua

-- Define the log directory
local logDirectory = "bin/log"

-- Function to read all logs from the log directory
local function readAllLogs()
    local logs = {}
    local logFiles = {}

    -- Iterate through the log directory to find all log files
    for _, file in ipairs(listfiles(logDirectory)) do
        table.insert(logFiles, file)
    end

    -- Read the contents of each log file
    for _, file in ipairs(logFiles) do
        local logFile = io.open(file, "r")
        if logFile then
            local content = logFile:read("*all")
            table.insert(logs, content)
            logFile:close()
        end
    end

    return logs
end

-- Function to clear all logs from the console
local function clearConsole()
    -- Assuming there's a way to clear the console in Roblox
    -- This is a placeholder; you may need to implement the actual clearing logic
    print("Console cleared")
end

local function printLastLog()
    local logFiles = {}

    for _, file in ipairs(listfiles(logDirectory)) do
        table.insert(logFiles, file)
    end

    table.sort(logFiles, function(a, b)
        return os.time(os.date("!*t", os.stat(a).mtime)) > os.time(os.date("!*t", os.stat(b).mtime))
    end)

    if #logFiles > 0 then
        local lastLogFile = io.open(logFiles[1], "r")
        if lastLogFile then
            local content = lastLogFile:read("*all")
            print(content)
            lastLogFile:close()
        end
    else
        print("No logs found")
    end
end

debug.getlogs = function(action)
    if action == "CONSOLE" then
        local logs = readAllLogs()
        for _, log in ipairs(logs) do
            print(log)
        end
    elseif action == "CLEAR" then
        clearConsole()
    elseif action == "LAST:CONSOLE" then
        printLastLog()
    else
        print("Invalid action")
    end
end

local function read_logs()
    local file = io.open(LOG_FILE, "r")
    if not file then return {} end
    local logs = {}
    for line in file:lines() do
      table.insert(logs, line)
    end
    file:close()
    return logs
  end
  
  local function write_logs(logs)
    local file = io.open(LOG_FILE, "w")
    if not file then return false end
    for _, log in ipairs(logs) do
      file:write(log .. "\n")
    end
    file:close()
    return true
  end
  
  local log_types = {
    INFO = "INFO",
    WARN = "WARN",
  }
  
  local log_operations = {
    CONSOLE = "CONSOLE",
    DELETE = "DELETE",
    SPAM = "SPAM",
    ALL = "ALL",
    RESET = "RESET",
  }
  
  ratapi.debug = {}
  
  ratapi.debug.getlogs = function(operation)
    local logs = read_logs()
    local parts = string.match(operation, "([A-Z]+):([A-Z]+)%((.*)%)")
  
    if parts then
      local op_type = parts
      local op_value = parts
  
      if string.sub(operation,1,7) == "CONSOLE" then
          op_value = tonumber(string.match(operation, "%d+"))
          if logs[op_value] then
              print(logs[op_value])
          else
              print("Log not found at index " .. op_value)
          end
      elseif string.sub(operation,1,6) == "DELETE" then
          op_value = tonumber(string.match(operation, "%d+"))
          if logs[op_value] then
              table.remove(logs, op_value)
              write_logs(logs)
              print("Log deleted at index " .. op_value)
          else
              print("Log not found at index " .. op_value)
          end
      elseif string.sub(operation,1,4) == "LAST" then
        local spam_percentage = tonumber(string.match(operation, "%d+")) or 0
  
        if spam_percentage > 20 then
          spam_percentage = 20
        end
  
        local spam_duration = spam_percentage
  
        if #logs > 0 then
          local last_log = logs[#logs]
          local start_time = os.time()
          while os.time() - start_time < spam_duration do
            print(last_log)
            os.execute("sleep 1")
          end
        else
          print("No logs available to spam.")
        end
      elseif string.sub(operation,1,5) == "RESET" then
          write_logs(logs)
          print("Logs reset to print format")
      else
          print("Invalid debug operation")
      end
    else
      print("Invalid debug operation format")
    end
  end
  
  ratapi.debug.setlogs = function(operation)
      local logs = read_logs()
  
      if string.sub(operation,1,4) == "LOG:" then
          if string.find(operation, "INFO:ALL") then
              local new_logs = {}
              for _, log in ipairs(logs) do
                  table.insert(new_logs, "INFO: " .. log)
              end
              write_logs(new_logs)
              print("Logs set to INFO format")
          elseif string.find(operation, "WARN:ALL") then
              local new_logs = {}
              for _, log in ipairs(logs) do
                  table.insert(new_logs, "WARN: " .. log)
              end
              write_logs(new_logs)
              print("Logs set to WARN format")
          else
              print("Invalid log type specified")
          end
      else
          print("Invalid debug operation")
      end
  end

-- Example usage
-- debug.getlogs("CONSOLE")
-- debug.getlogs("CLEAR")
-- debug.getlogs("LAST:CONSOLE")
    

--█▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
--█▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█

function getOS()
    local os_name = string.lower(os.getenv("OS") or os.getenv("OSTYPE") or "")
    if string.find(os_name, "windows") then
      return "Windows"
    elseif string.find(os_name, "linux") then
      return "Linux"
    elseif string.find(os_name, "darwin") or string.find(os_name, "mac") then
      return "macOS"
    else
      return "Unknown"
    end
  end
  
  function isAdmin()
    if getOS() == "Windows"
      return false
    else
      return os.execute("id -u") == 0
    end
  end

function debug.gettime()
    if os.clock then
      return os.clock()
    else
      return os.time()
    end
  end

-- Kill Roblox (Use with Caution!)
function ratapi.KillRoblox()
    if API_LOCK then
        sendNotification(NOTIFICATION_TITLE, "RATAPI is locked, KillRoblox blocked.")
        return
    end
    local processList = findRobloxProcess()
    for _, process in ipairs(processList) do
        pcall(function()
            process:Kill()
        end)
    end
end

-- Check if Roblox is Open
function ratapi.IsRobloxOpen()
    local processList = findRobloxProcess()
    return #processList > 0
end

-- Returns the RATAPI Version
function ratapi.GetAPIVersion()
	return API_VERSION
end

function ratapi.runAPIversion() {
    SendNotification(NOTIFICATION_TITLE, API_VERSION)
}

-- Function to get all scripts in the game (SERVER SIDE)
function ratapi.GetAllScripts()
    local scriptList = {}
    local function recursiveSearch(instance)
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
                table.insert(scriptList, {
                    Name = child.Name,
                    ClassName = child.ClassName,
                    Path = child:GetFullName()
                })
            end
            recursiveSearch(child)
        end
    end

    recursiveSearch(game)
    return scriptList
end

-- Function to list all running services
function ratapi.ListServices()
    local services = game:GetDescendants()
    local serviceNames = {}

    for _, service in ipairs(services) do
        if service:IsA("Service") then
            table.insert(serviceNames, service.Name)
        end
    end

    return serviceNames
end

--█▀▀ █▀▀ █▄░█ █▀▀ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
--█▄█ ██▄ █░▀█ ██▄ █▀▄ █▀█ ░█░ █ █▄█ █░▀█

-- Function to force garbage collection
function ratapi.ForceGarbageCollection()
    collectgarbage("collect")
end

-- Function to create a GUI with text
function ratapi.CreateGUI(text, position, size, color)
    local createGuiScript = [[
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = screenGui
        textLabel.Text = "]]..text..[["
        textLabel.BackgroundTransparency = 0.5
        textLabel.Position = UDim2.new]]..tostring(position.X)..","..tostring(position.Y)..","..tostring(position.Width)..","..tostring(position.Height)..[[
        textLabel.Size = UDim2.new]]..tostring(size.X)..","..tostring(size.Y)..","..tostring(size.Width)..","..tostring(size.Height)..[[
        textLabel.BackgroundColor3 = Color3.new]]..tostring(color.R)..","..tostring(color.G)..","..tostring(color.B)..[[
    ]]
    ratapi.Execute(createGuiScript)
end

-- Function to convert RGB to HSV
function ratapi.RGBtoHSV(r, g, b)
    local h, s, v
    local k = 0
    if g < b then
        g, b = b, g
        k = -1
    end
    if r < g then
        r, g = g, r
        k = -2/6 - k
    end

    local chroma = r - math.min(g, b)

    if chroma ~= 0 then
        h = (g - b) / chroma
    end
    h = h + k
    h = (h - math.floor(h))

    s = chroma / (r + 1e-15)
    v = r
    return h, s, v
end

-- Function to convert HSV to RGB
function ratapi.HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r, g, b
end

-- Function to play a sound from an asset ID
function ratapi.PlaySound(soundId, volume, pitch)
    local playSoundScript = [[
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://]]..tostring(soundId)..[[
        sound.Volume = ]]..tostring(volume)..[[
        sound.Pitch = ]]..tostring(pitch)..[[
        sound.Parent = game.Players.LocalPlayer.Character
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5) -- Destroy sound after 5 seconds
    ]]
    ratapi.Execute(playSoundScript)
end

-- Function to load a string from a URL
function ratapi.HttpGet(url)
    local httpService = game:GetService("HttpService")
    local success, result = pcall(function()
        return httpService:GetAsync(url, true)
    end)

    if success then
        return result
    else
        warn("HttpGet failed: " .. result)
        return nil
    end
end

-- Function to post data to a URL
function ratapi.HttpPost(url, data)
    local httpService = game:GetService("HttpService")
    local jsonData = httpService:JsonEncode(data)
    local success, result = pcall(function()
        return httpService:PostAsync(url, jsonData)
    end)

    if success then
        return result
    else
        warn("HttpPost failed: " .. result)
        return nil
    end
end

-- Function to get the memory usage
function ratapi.GetMemoryUsage()
    local memoryUsageScript = [[
        local memory = collectgarbage("count")
        print("Memory Usage: " .. memory .. " KB")
    ]]
    ratapi.Execute(memoryUsageScript)
end

--█▀▄▀█ ▄▀█ █▄░█ █ █▀█ █░█ █░░ ▄▀█ ▀█▀ █ █▀█ █▄░█
--█░▀░█ █▀█ █░▀█ █ █▀▀ █▄█ █▄▄ █▀█ ░█░ █ █▄█ █░▀█

-- Function to respawn the player
function ratapi.RespawnPlayer()
    local respawnScript = [[
        game.Players.LocalPlayer:LoadCharacter()
    ]]
    ratapi.Execute(respawnScript)
end

function ratapi.SetWalkSpeed(speed)
    local setWalkSpeedScript = [[
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ]]..tostring(speed)..[[
    ]]
    ratapi.Execute(setWalkSpeedScript)
end

function ratapi.GetLevel()
    local getLevelScript = [[
        return game.Players.LocalPlayer.Data.Level.Value
    ]]
    return ratapi.Execute(getLevelScript)
end

function ratapi.SetLevel(level)
    local setLevelScript = [[
        game.Players.LocalPlayer.Data.Level.Value = ]]..tostring(level)..[[
    ]]
    ratapi.Execute(setLevelScript)
end

function ratapi.GetExperience()
    local getExperienceScript = [[
        return game.Players.LocalPlayer.Data.Experience.Value
    ]]
    return ratapi.Execute(getExperienceScript)
end

function ratapi.SetExperience(experience)
    local setExperienceScript = [[
        game.Players.LocalPlayer.Data.Experience.Value = ]]..tostring(experience)..[[
    ]]
    ratapi.Execute(setExperienceScript)
end

function ratapi.GetCoins()
    local getCoinsScript = [[
        return game.Players.LocalPlayer.Data.Coins.Value
    ]]
    return ratapi.Execute(getCoinsScript)
end

function ratapi.SetCoins(coins)
    local setCoinsScript = [[
        game.Players.LocalPlayer.Data.Coins.Value = ]]..tostring(coins)..[[
    ]]
    ratapi.Execute(setCoinsScript)
end

function ratapi.GetKeys()
    local getKeysScript = [[
        return game.Players.LocalPlayer.Data.Keys.Value
    ]]
    return ratapi.Execute(getKeysScript)
end

function ratapi.SetKeys(keys)
    local setKeysScript = [[
        game.Players.LocalPlayer.Data.Keys.Value = ]]..tostring(keys)..[[
    ]]
    ratapi.Execute(setKeysScript)
end

function ratapi.GetCrystals()
    local getCrystalsScript = [[
        return game.Players.LocalPlayer.Data.Crystals.Value
    ]]
    return ratapi.Execute(getCrystalsScript)
end

function ratapi.SetCrystals(crystals)
    local setCrystalsScript = [[
        game.Players.LocalPlayer.Data.Crystals.Value = ]]..tostring(crystals)..[[
    ]]
    ratapi.Execute(setCrystalsScript)
end

function ratapi.GetPoints()
    local getPointsScript = [[
        return game.Players.LocalPlayer.Data.Points.Value
    ]]
    return ratapi.Execute(getPointsScript)
end

function ratapi.SetPoints(points)
    local setPointsScript = [[
        game.Players.LocalPlayer.Data.Points.Value = ]]..tostring(points)..[[
    ]]
    ratapi.Execute(setPointsScript)
end

function ratapi.GetStars()
    local getStarsScript = [[
        return game.Players.LocalPlayer.Data.Stars.Value
    ]]
    return ratapi.Execute(getStarsScript)
end

function ratapi.SetStars(stars)
    local setStarsScript = [[
        game.Players.LocalPlayer.Data.Stars.Value = ]]..tostring(stars)..[[
    ]]
    ratapi.Execute(setStarsScript)
end

function ratapi.GetGems()
    local getGemsScript = [[
        return game.Players.LocalPlayer.Data.Gems.Value
    ]]
    return ratapi.Execute(getGemsScript)
end

function ratapi.SetGems(gems)
    local setGemsScript = [[
        game.Players.LocalPlayer.Data.Gems.Value = ]]..tostring(gems)..[[
    ]]
    ratapi.Execute(setGemsScript)
end

function ratapi.GetRubies()
    local getRubiesScript = [[
        return game.Players.LocalPlayer.Data.Rubies.Value
    ]]
    return ratapi.Execute(getRubiesScript)
end

function ratapi.SetRubies(rubies)
    local setRubiesScript = [[
        game.Players.LocalPlayer.Data.Rubies.Value = ]]..tostring(rubies)..[[
    ]]
    ratapi.Execute(setRubiesScript)
end

function ratapi.GetSapphires()
    local getSapphiresScript = [[
        return game.Players.LocalPlayer.Data.Sapphires.Value
    ]]
    return ratapi.Execute(getSapphiresScript)
end

function ratapi.SetSapphires(sapphires)
    local setSapphiresScript = [[
        game.Players.LocalPlayer.Data.Sapphires.Value = ]]..tostring(sapphires)..[[
    ]]
    ratapi.Execute(setSapphiresScript)
end

function ratapi.GetEmeralds()
    local getEmeraldsScript = [[
        return game.Players.LocalPlayer.Data.Emeralds.Value
    ]]
    return ratapi.Execute(getEmeraldsScript)
end

function ratapi.SetEmeralds(emeralds)
    local setEmeraldsScript = [[
        game.Players.LocalPlayer.Data.Emeralds.Value = ]]..tostring(emeralds)..[[
    ]]
    ratapi.Execute(setEmeraldsScript)
end

function ratapi.GetDiamonds()
    local getDiamondsScript = [[
        return game.Players.LocalPlayer.Data.Diamonds.Value
    ]]
    return ratapi.Execute(getDiamondsScript)
end

function ratapi.SetDiamonds(diamonds)
    local setDiamondsScript = [[
        game.Players.LocalPlayer.Data.Diamonds.Value = ]]..tostring(diamonds)..[[
    ]]
    ratapi.Execute(setDiamondsScript)
end

function ratapi.GetAxes()
    local getAxesScript = [[
        return game.Players.LocalPlayer.Data.Axes.Value
    ]]
    return ratapi.Execute(getAxesScript)
end

function ratapi.SetAxes(axes)
    local setAxesScript = [[
        game.Players.LocalPlayer.Data.Axes.Value = ]]..tostring(axes)..[[
    ]]
    ratapi.Execute(setAxesScript)
end

function ratapi.GetSwords()
    local getSwordsScript = [[
        return game.Players.LocalPlayer.Data.Swords.Value
    ]]
    return ratapi.Execute(getSwordsScript)
end

function ratapi.SetSwords(swords)
    local setSwordsScript = [[
        game.Players.LocalPlayer.Data.Swords.Value = ]]..tostring(swords)..[[
    ]]
    ratapi.Execute(setSwordsScript)
end

function ratapi.GetBows()
    local getBowsScript = [[
        return game.Players.LocalPlayer.Data.Bows.Value
    ]]
    return ratapi.Execute(getBowsScript)
end

function ratapi.SetBows(bows)
    local setBowsScript = [[
        game.Players.LocalPlayer.Data.Bows.Value = ]]..tostring(bows)..[[
    ]]
    ratapi.Execute(setBowsScript)
end

function ratapi.GetShields()
    local getShieldsScript = [[
        return game.Players.LocalPlayer.Data.Shields.Value
    ]]
    return ratapi.Execute(getShieldsScript)
end

function ratapi.SetShields(shields)
    local setShieldsScript = [[
        game.Players.LocalPlayer.Data.Shields.Value = ]]..tostring(shields)..[[
    ]]
    ratapi.Execute(setShieldsScript)
end

function ratapi.GetWands()
    local getWandsScript = [[
        return game.Players.LocalPlayer.Data.Wands.Value
    ]]
    return ratapi.Execute(getWandsScript)
end

function ratapi.SetWands(wands)
    local setWandsScript = [[
        game.Players.LocalPlayer.Data.Wands.Value = ]]..tostring(wands)..[[
    ]]
    ratapi.Execute(setWandsScript)
end

function ratapi.GetCrossbows()
    local getCrossbowsScript = [[
        return game.Players.LocalPlayer.Data.Crossbows.Value
    ]]
    return ratapi.Execute(getCrossbowsScript)
end

function ratapi.SetCrossbows(crossbows)
    local setCrossbowsScript = [[
        game.Players.LocalPlayer.Data.Crossbows.Value = ]]..tostring(crossbows)..[[
    ]]
    ratapi.Execute(setCrossbowsScript)
end

function ratapi.GetGrenades()
    local getGrenadesScript = [[
        return game.Players.LocalPlayer.Data.Grenades.Value
    ]]
    return ratapi.Execute(getGrenadesScript)
end

function ratapi.SetGrenades(grenades)
    local setGrenadesScript = [[
        game.Players.LocalPlayer.Data.Grenades.Value = ]]..tostring(grenades)..[[
    ]]
    ratapi.Execute(setGrenadesScript)
end

function ratapi.GetBombs()
    local getBombsScript = [[
        return game.Players.LocalPlayer.Data.Bombs.Value
    ]]
    return ratapi.Execute(getBombsScript)
end

function ratapi.SetBombs(bombs)
    local setBombsScript = [[
        game.Players.LocalPlayer.Data.Bombs.Value = ]]..tostring(bombs)..[[
    ]]
    ratapi.Execute(setBombsScript)
end

function ratapi.GetMines()
    local getMinesScript = [[
        return game.Players.LocalPlayer.Data.Mines.Value
    ]]
    return ratapi.Execute(getMinesScript)
end

function ratapi.SetMines(mines)
    local setMinesScript = [[
        game.Players.LocalPlayer.Data.Mines.Value = ]]..tostring(mines)..[[
    ]]
    ratapi.Execute(setMinesScript)
end

function ratapi.GetGrenades()
    local getGrenadesScript = [[
        return game.Players.LocalPlayer.Data.Grenades.Value
    ]]
    return ratapi.Execute(getGrenadesScript)
end

function ratapi.SetGrenades(grenades)
    local setGrenadesScript = [[
        game.Players.LocalPlayer.Data.Grenades.Value = ]]..tostring(grenades)..[[
    ]]
    ratapi.Execute(setGrenadesScript)
end

function ratapi.GetBombs()
    local getBombsScript = [[
        return game.Players.LocalPlayer.Data.Bombs.Value
    ]]
    return ratapi.Execute(getBombsScript)
end

function ratapi.SetBombs(bombs)
    local setBombsScript = [[
        game.Players.LocalPlayer.Data.Bombs.Value = ]]..tostring(bombs)..[[
    ]]
    ratapi.Execute(setBombsScript)
end

function ratapi.GetMines()
    local getMinesScript = [[
        return game.Players.LocalPlayer.Data.Mines.Value
    ]]
    return ratapi.Execute(getMinesScript)
end

function ratapi.SetMines(mines)
    local setMinesScript = [[
        game.Players.LocalPlayer.Data.Mines.Value = ]]..tostring(mines)..[[
    ]]
    ratapi.Execute(setMinesScript)
end

function ratapi.SetJumpPower(jumpPower)
    local setJumpPowerScript = [[
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = ]]..tostring(jumpPower)..[[
    ]]
    ratapi.Execute(setJumpPowerScript)
end

function ratapi.MakeInvisible()
    local makeInvisibleScript = [[
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    ]]
    ratapi.Execute(makeInvisibleScript)
end

function ratapi.MakeVisible()
    local makeVisibleScript = [[
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    ]]
    ratapi.Execute(makeVisibleScript)
end

function ratapi.ApplyForce(x, y, z)
    local applyForceScript = [[
        local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local force = Vector3.new]]..tostring(x)..","..tostring(y)..","..tostring(z)..[[
            humanoidRootPart:ApplyImpulse(force)
        end
    ]]
    ratapi.Execute(applyForceScript)
end

function ratapi.SetFieldOfView(fov)
    local setFovScript = [[
        game.Workspace.CurrentCamera.FieldOfView = ]]..tostring(fov)..[[
    ]]
    ratapi.Execute(setFovScript)
end

function ratapi.GetFieldOfView()
    ratapi.Execute("print('Field of View: ' .. game.Workspace.CurrentCamera.FieldOfView)")
end

function ratapi.LockCameraToPlayer()
    local lockCameraScript = [[
        game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        game:GetService("RunService").RenderStepped:Connect(function()
            game.Workspace.CurrentCamera.CFrame = game.Players.LocalPlayer.Character.Head.CFrame
        end)
    ]]
    ratapi.Execute(lockCameraScript)
end

function ratapi.ResetCamera()
    local resetCameraScript = [[
        game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    ]]
    ratapi.Execute(resetCameraScript)
end

function ratapi.SetDisplayName(displayName)
    local setDisplayNameScript = [[
        game.Players.LocalPlayer.DisplayName = "]]..displayName..[["
    ]]
    ratapi.Execute(setDisplayNameScript)
end

function ratapi.SetAvatar(assetId)
    local setAvatarScript = [[
        game.Players.LocalPlayer.Character:ClearAllChildren()
        local humanoid = Instance.new("Humanoid")
        humanoid.Parent = game.Players.LocalPlayer.Character
        local bodyPart = Instance.new("HumanoidDescription")
        bodyPart.Torso = ]]..assetId..[[
        bodyPart.Head = ]]..assetId..[[
        bodyPart.LeftArm = ]]..assetId..[[
        bodyPart.RightArm = ]]..assetId..[[
        bodyPart.LeftLeg = ]]..assetId..[[
        bodyPart.RightLeg = ]]..assetId..[[
        game.Players.LocalPlayer:ApplyDescription(bodyPart)
    ]]
    ratapi.Execute(setAvatarScript)
end

--█░█░█ █▀█ █▀█ █░░ █▀▄
--▀▄▀▄▀ █▄█ █▀▄ █▄▄ █▄▀

-- Function to create a beam
function ratapi.CreateBeam(part0, part1, texture, width)
    local createBeamScript = [[
        local beam = Instance.new("Beam")
        beam.Attachment0 = game.Workspace:FindFirstChild("]]..part0..[[")
        beam.Attachment1 = game.Workspace:FindFirstChild("]]..part1..[[")
        beam.Texture = "]]..texture..[["
        beam.Width0 = ]]..tostring(width)..[[
        beam.Width1 = ]]..tostring(width)..[[
        beam.Parent = workspace
    ]]
    ratapi.Execute(createBeamScript)
end

function ratapi.ChangeSkybox(front, back, left, right, up, down)
    local changeSkyboxScript = [[
        game.Lighting.SkyboxBk = "]]..back..[["
        game.Lighting.SkyboxDn = "]]..down..[["
        game.Lighting.SkyboxFt = "]]..front..[["
        game.Lighting.SkyboxLf = "]]..left..[["
        game.Lighting.SkyboxRt = "]]..right..[["
        game.Lighting.SkyboxUp = "]]..up..[["
    ]]
    ratapi.Execute(changeSkyboxScript)
end

-- Function to create a particle emitter
function ratapi.CreateParticleEmitter(parent, texture, lifetimeMin, lifetimeMax, speedMin, speedMax, sizeMin, sizeMax)
    local createParticleEmitterScript = [[
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "]]..texture..[["
        emitter.Lifetime = NumberRange.new]]..tostring(lifetimeMin)..","..tostring(lifetimeMax)..[[
        emitter.Speed = NumberRange.new]]..tostring(speedMin)..","..tostring(speedMax)..[[
        emitter.Size = NumberRange.new]]..tostring(sizeMin)..","..tostring(sizeMax)..[[
        emitter.Parent = game.Workspace:FindFirstChild("]]..parent..[[")
        emitter:Emit(100)
    ]]
    ratapi.Execute(createParticleEmitterScript)
end

-- Function to create a trail
function ratapi.CreateTrail(attachment0, attachment1, texture, lifetime)
    local createTrailScript = [[
        local trail = Instance.new("Trail")
        trail.Attachment0 = game.Workspace:FindFirstChild("]]..attachment0..[[")
        trail.Attachment1 = game.Workspace:FindFirstChild("]]..attachment1..[[")
        trail.Texture = "]]..texture..[["
        trail.Lifetime = ]]..tostring(lifetime)..[[
        trail.Parent = workspace
    ]]
    ratapi.Execute(createTrailScript)
end

-- Function to clear all decals
function ratapi.ClearDecals()
    local clearDecalsScript = [[
        for _, decal in pairs(game.Workspace:GetDescendants()) do
            if decal:IsA("Decal") then
                decal:Destroy()
            end
        end
    ]]
    ratapi.Execute(clearDecalsScript)
end

-- Function to clear all lights
function ratapi.ClearLights()
    local clearLightsScript = [[
        for _, light in pairs(game.Lighting:GetDescendants()) do
            if light:IsA("Light") then
                light:Destroy()
            end
        end
    ]]
    ratapi.Execute(clearLightsScript)
end

-- Function to change the fog end
function ratapi.SetFogEnd(fogEnd)
    local setFogEndScript = [[
        game.Lighting.FogEnd = ]]..tostring(fogEnd)..[[
    ]]
    ratapi.Execute(setFogEndScript)
end

-- Function to set the terrain height
function ratapi.SetTerrainHeight(x, y, z, height)
    local setTerrainHeightScript = [[
        local terrain = game:GetService("Terrain")
        terrain:WriteVoxels(CFrame.new]]..tostring(x)..","..tostring(y)..","..tostring(z)..[[, Vector3.new(4, 4, 4), height)
    ]]
    ratapi.Execute(setTerrainHeightScript)
end

-- Function to set the terrain material
function ratapi.SetTerrainMaterial(x, y, z, material)
    local setTerrainMaterialScript = [[
        local terrain = game:GetService("Terrain")
        local region = Region3.new(Vector3.new]]..tostring(x)..","..tostring(y)..","..tostring(z)..[[, Vector3.new]]..tostring(x + 4)..","..tostring(y + 4)..","..tostring(z + 4)..[[)
        local material = Enum.Material["]]..material..[["
        terrain:FillRegion(region, 4, material)
    ]]
    ratapi.Execute(setTerrainMaterialScript)
end

-- Function to set the water color
function ratapi.SetWaterColor(r, g, b)
    local setWaterColorScript = [[
        game.Lighting.WaterColor = Color3.new]]..tostring(r)..","..tostring(g)..","..tostring(b)..[[
    ]]
    ratapi.Execute(setWaterColorScript)
end

-- Function to set the water reflectance
function ratapi.SetWaterReflectance(reflectance)
    local setWaterReflectanceScript = [[
        game.Lighting.WaterReflectance = ]]..tostring(reflectance)..[[
    ]]
    ratapi.Execute(setWaterReflectanceScript)
end

-- Function to set the water transparency
function ratapi.SetWaterTransparency(transparency)
    local setWaterTransparencyScript = [[
        game.Lighting.WaterTransparency = ]]..tostring(transparency)..[[
    ]]
    ratapi.Execute(setWaterTransparencyScript)
end

-- Function to set the Geographic Latitude
function ratapi.SetGeographicLatitude(latitude)
    local setGeographicLatitudeScript = [[
        game:GetService("LocationService").GeographicLatitude = ]]..tostring(latitude)..[[
    ]]
    ratapi.Execute(setGeographicLatitudeScript)
end

-- Function to set the Geographic Longitude
function ratapi.SetGeographicLongitude(longitude)
    local setGeographicLongitudeScript = [[
        game:GetService("LocationService").GeographicLongitude = ]]..tostring(longitude)..[[
    ]]
    ratapi.Execute(setGeographicLongitudeScript)
end

--[[-----------------------------------------------------------------------------
-----------------------------------ITEM/TOOL MANIPULATION------------------------
-------------------------------------------------------------------------------]]

-- Function to clone a tool from the server and give it to the player
function ratapi.CloneTool(toolName)
    local cloneToolScript = [[
        local toolToClone = game.Workspace:FindFirstChild(']]..toolName..[[')
        if toolToClone then
            local clonedTool = toolToClone:Clone()
            clonedTool.Parent = game.Players.LocalPlayer.Backpack
        end
    ]]
    ratapi.Execute(cloneToolScript)
end

-- Function to destroy a tool from the player
function ratapi.DestroyTool(toolName)
    local destroyToolScript = [[
        local toolToDestroy = game.Players.LocalPlayer.Backpack:FindFirstChild(']]..toolName..[[')
        if toolToDestroy then
            toolToDestroy:Destroy()
        end
    ]]
    ratapi.Execute(destroyToolScript)
end

local function ratapi.createSimpleObject()
    local part = Instance.new("Part")

    part.Size = Vector3.new(4, 1, 2)

    part.Position = Vector3.new(0, 5, 0)

    part.BrickColor = BrickColor.new("Bright red")

    part.Parent = game.Workspace

    return part
end

local function ratapi.generateObjects(count)
    for i = 1, count do
        local obj = createSimpleObject()
        obj.Position = Vector3.new(i * 5, 5, 0)
    end
end
-- generateObjects((count))
-- Example: generateObjects(5)

-- Function to create a shield
function ratapi.CreateShield(size)
    local createShieldScript = [[
        local shield = Instance.new("Part")
        shield.Shape = Enum.PartType.Ball
        shield.Size = Vector3.new]]..tostring(size)..","..tostring(size)..","..tostring(size)..[[
        shield.Anchored = true
        shield.CanCollide = false
        shield.Transparency = 0.5
        shield.Parent = game.Workspace
        shield.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        shield.Name = "Shield"

        game:GetService("RunService").RenderStepped:Connect(function()
            shield.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end)
    ]]
    ratapi.Execute(createShieldScript)
end

-- Function to destroy the shield
function ratapi.DestroyShield()
    local destroyShieldScript = [[
        local shield = game.Workspace:FindFirstChild("Shield")
        if shield then
            shield:Destroy()
        end
    ]]
    ratapi.Execute(destroyShieldScript)
end

-- Function to equip the tool in a certain slot
function ratapi.EquipTool(toolName)
    local equipToolScript = [[
        local toolToEquip = game.Players.LocalPlayer.Backpack:FindFirstChild(']]..toolName..[[')
        if toolToEquip then
            game.Players.LocalPlayer.Character:EquipTool(toolToEquip)
        end
    ]]
    ratapi.Execute(equipToolScript)
end

-- Function to unequip the tool in a certain slot
function ratapi.UnequipTool(toolName)
    local unequipToolScript = [[
        local toolToUnequip = game.Players.LocalPlayer.Character:FindFirstChild(']]..toolName..[[')
        if toolToUnequip then
            game.Players.LocalPlayer.Character:UnequipTools()
        end
    ]]
    ratapi.Execute(unequipToolScript)
end

-- Function to create a forcefield
function ratapi.CreateForceField(duration)
    local createForceFieldScript = [[
        local forceField = Instance.new("ForceField")
        forceField.Parent = game.Players.LocalPlayer.Character
        game:GetService("Debris"):AddItem(forceField, ]]..tostring(duration)..[[)
    ]]
    ratapi.Execute(createForceFieldScript)
end

-- Function to create a barrier
function ratapi.CreateBarrier(size, color, transparency, duration)
    local createBarrierScript = [[
        local barrier = Instance.new("Part")
        barrier.Shape = Enum.PartType.Block
        barrier.Size = Vector3.new]]..tostring(size.X)..","..tostring(size.Y)..","..tostring(size.Z)..[[
        barrier.Anchored = true
        barrier.CanCollide = false
        barrier.Transparency = ]]..tostring(transparency)..[[
        barrier.Color = Color3.new]]..tostring(color.R)..","..tostring(color.G)..","..tostring(color.B)..[[
        barrier.Parent = game.Workspace
        barrier.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        game:GetService("Debris"):AddItem(barrier, ]]..tostring(duration)..[[)
    ]]
    ratapi.Execute(createBarrierScript)
end

-- Function to create a healing aura
function ratapi.CreateHealingAura(radius, healAmount)
    local createHealingAuraScript = [[
        local healingPart = Instance.new("Part")
        healingPart.Shape = Enum.PartType.Ball
        healingPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        healingPart.Anchored = true
        healingPart.CanCollide = false
        healingPart.Transparency = 0.5
        healingPart.Color = Color3.new(0, 1, 0)
        healingPart.Parent = game.Workspace
        healingPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        healingPart.Name = "HealingAura"

        local healAmount = ]]..tostring(healAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - healingPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.min(player.Character.Humanoid.Health + healAmount, player.Character.Humanoid.MaxHealth)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createHealingAuraScript)
end

-- Function to create a damage aura
function ratapi.CreateDamageAura(radius, damageAmount)
    local createDamageAuraScript = [[
        local damagePart = Instance.new("Part")
        damagePart.Shape = Enum.PartType.Ball
        damagePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        damagePart.Anchored = true
        damagePart.CanCollide = false
        damagePart.Transparency = 0.5
        damagePart.Color = Color3.new(1, 0, 0)
        damagePart.Parent = game.Workspace
        damagePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        damagePart.Name = "DamageAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - damagePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createDamageAuraScript)
end

-- Function to create a speed aura
function ratapi.CreateSpeedAura(radius, speedAmount)
    local createSpeedAuraScript = [[
        local speedPart = Instance.new("Part")
        speedPart.Shape = Enum.PartType.Ball
        speedPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        speedPart.Anchored = true
        speedPart.CanCollide = false
        speedPart.Transparency = 0.5
        speedPart.Color = Color3.new(0, 0, 1)
        speedPart.Parent = game.Workspace
        speedPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        speedPart.Name = "SpeedAura"

        local speedAmount = ]]..tostring(speedAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - speedPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.WalkSpeed = speedAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createSpeedAuraScript)
end

-- Function to create a jump aura
function ratapi.CreateJumpAura(radius, jumpAmount)
    local createJumpAuraScript = [[
        local jumpPart = Instance.new("Part")
        jumpPart.Shape = Enum.PartType.Ball
        jumpPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        jumpPart.Anchored = true
        jumpPart.CanCollide = false
        jumpPart.Transparency = 0.5
        jumpPart.Color = Color3.new(1, 1, 0)
        jumpPart.Parent = game.Workspace
        jumpPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        jumpPart.Name = "JumpAura"

        local jumpAmount = ]]..tostring(jumpAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - jumpPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.JumpPower = jumpAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createJumpAuraScript)
end

-- Function to create a gravity aura
function ratapi.CreateGravityAura(radius, gravityAmount)
    local createGravityAuraScript = [[
        local gravityPart = Instance.new("Part")
        gravityPart.Shape = Enum.PartType.Ball
        gravityPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        gravityPart.Anchored = true
        gravityPart.CanCollide = false
        gravityPart.Transparency = 0.5
        gravityPart.Color = Color3.new(0, 1, 1)
        gravityPart.Parent = game.Workspace
        gravityPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        gravityPart.Name = "GravityAura"

        local gravityAmount = ]]..tostring(gravityAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - gravityPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = player.Character.HumanoidRootPart.Velocity + Vector3.new(0, gravityAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createGravityAuraScript)
end

-- Function to create a teleport aura
function ratapi.CreateTeleportAura(radius, teleportLocation)
    local createTeleportAuraScript = [[
        local teleportPart = Instance.new("Part")
        teleportPart.Shape = Enum.PartType.Ball
        teleportPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        teleportPart.Anchored = true
        teleportPart.CanCollide = false
        teleportPart.Transparency = 0.5
        teleportPart.Color = Color3.new(1, 0, 1)
        teleportPart.Parent = game.Workspace
        teleportPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        teleportPart.Name = "TeleportAura"

        local teleportLocation = CFrame.new]]..tostring(teleportLocation.X)..","..tostring(teleportLocation.Y)..","..tostring(teleportLocation.Z)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - teleportPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.CFrame = teleportLocation
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTeleportAuraScript)
end

-- Function to create a freeze aura
function ratapi.CreateFreezeAura(radius)
    local createFreezeAuraScript = [[
        local freezePart = Instance.new("Part")
        freezePart.Shape = Enum.PartType.Ball
        freezePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        freezePart.Anchored = true
        freezePart.CanCollide = false
        freezePart.Transparency = 0.5
        freezePart.Color = Color3.new(0, 0, 0)
        freezePart.Parent = game.Workspace
        freezePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        freezePart.Name = "FreezeAura"

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - freezePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFreezeAuraScript)
end

-- Function to create a fire aura
function ratapi.CreateFireAura(radius, damageAmount)
    local createFireAuraScript = [[
        local firePart = Instance.new("Part")
        firePart.Shape = Enum.PartType.Ball
        firePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        firePart.Anchored = true
        firePart.CanCollide = false
        firePart.Transparency = 0.5
        firePart.Color = Color3.new(1, 0.5, 0)
        firePart.Parent = game.Workspace
        firePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        firePart.Name = "FireAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - firePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFireAuraScript)
end

-- Function to create a ice aura
function ratapi.CreateIceAura(radius, slowAmount)
    local createIceAuraScript = [[
        local icePart = Instance.new("Part")
        icePart.Shape = Enum.PartType.Ball
        icePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        icePart.Anchored = true
        icePart.CanCollide = false
        icePart.Transparency = 0.5
        icePart.Color = Color3.new(0, 0.5, 1)
        icePart.Parent = game.Workspace
        icePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        icePart.Name = "IceAura"

        local slowAmount = ]]..tostring(slowAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - icePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.WalkSpeed = slowAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createIceAuraScript)
end

-- Function to create a lightning aura
function ratapi.CreateLightningAura(radius, damageAmount)
    local createLightningAuraScript = [[
        local lightningPart = Instance.new("Part")
        lightningPart.Shape = Enum.PartType.Ball
        lightningPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        lightningPart.Anchored = true
        lightningPart.CanCollide = false
        lightningPart.Transparency = 0.5
        lightningPart.Color = Color3.new(1, 1, 0)
        lightningPart.Parent = game.Workspace
        lightningPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        lightningPart.Name = "LightningAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - lightningPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLightningAuraScript)
end

-- Function to create a poison aura
function ratapi.CreatePoisonAura(radius, damageAmount)
    local createPoisonAuraScript = [[
        local poisonPart = Instance.new("Part")
        poisonPart.Shape = Enum.PartType.Ball
        poisonPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        poisonPart.Anchored = true
        poisonPart.CanCollide = false
        poisonPart.Transparency = 0.5
        poisonPart.Color = Color3.new(0, 1, 0)
        poisonPart.Parent = game.Workspace
        poisonPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        poisonPart.Name = "PoisonAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - poisonPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createPoisonAuraScript)
end

-- Function to create a shockwave aura
function ratapi.CreateShockwaveAura(radius, damageAmount)
    local createShockwaveAuraScript = [[
        local shockwavePart = Instance.new("Part")
        shockwavePart.Shape = Enum.PartType.Ball
        shockwavePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        shockwavePart.Anchored = true
        shockwavePart.CanCollide = false
        shockwavePart.Transparency = 0.5
        shockwavePart.Color = Color3.new(1, 0, 0)
        shockwavePart.Parent = game.Workspace
        shockwavePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        shockwavePart.Name = "ShockwaveAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - shockwavePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createShockwaveAuraScript)
end

-- Function to create a telekinesis aura
function ratapi.CreateTelekinesisAura(radius, pullAmount)
    local createTelekinesisAuraScript = [[
        local telekinesisPart = Instance.new("Part")
        telekinesisPart.Shape = Enum.PartType.Ball
        telekinesisPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        telekinesisPart.Anchored = true
        telekinesisPart.CanCollide = false
        telekinesisPart.Transparency = 0.5
        telekinesisPart.Color = Color3.new(0, 0, 1)
        telekinesisPart.Parent = game.Workspace
        telekinesisPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        telekinesisPart.Name = "TelekinesisAura"

        local pullAmount = ]]..tostring(pullAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - telekinesisPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = (telekinesisPart.Position - player.Character.HumanoidRootPart.Position).Unit * pullAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTelekinesisAuraScript)
end

-- Function to create a levitation aura
function ratapi.CreateLevitationAura(radius, liftAmount)
    local createLevitationAuraScript = [[
        local levitationPart = Instance.new("Part")
        levitationPart.Shape = Enum.PartType.Ball
        levitationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        levitationPart.Anchored = true
        levitationPart.CanCollide = false
        levitationPart.Transparency = 0.5
        levitationPart.Color = Color3.new(1, 1, 0)
        levitationPart.Parent = game.Workspace
        levitationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        levitationPart.Name = "LevitationAura"

        local liftAmount = ]]..tostring(liftAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - levitationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = player.Character.HumanoidRootPart.Velocity + Vector3.new(0, liftAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLevitationAuraScript)
end

-- Function to create a teleportation aura
function ratapi.CreateTeleportationAura(radius, teleportLocation)
    local createTeleportationAuraScript = [[
        local teleportationPart = Instance.new("Part")
        teleportationPart.Shape = Enum.PartType.Ball
        teleportationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        teleportationPart.Anchored = true
        teleportationPart.CanCollide = false
        teleportationPart.Transparency = 0.5
        teleportationPart.Color = Color3.new(1, 0, 1)
        teleportationPart.Parent = game.Workspace
        teleportationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        teleportationPart.Name = "TeleportationAura"

        local teleportLocation = CFrame.new]]..tostring(teleportLocation.X)..","..tostring(teleportLocation.Y)..","..tostring(teleportLocation.Z)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - teleportationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.CFrame = teleportLocation
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTeleportationAuraScript)
end

-- Function to create a freeze aura
function ratapi.CreateFreezeAura(radius)
    local createFreezeAuraScript = [[
        local freezePart = Instance.new("Part")
        freezePart.Shape = Enum.PartType.Ball
        freezePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        freezePart.Anchored = true
        freezePart.CanCollide = false
        freezePart.Transparency = 0.5
        freezePart.Color = Color3.new(0, 0, 0)
        freezePart.Parent = game.Workspace
        freezePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        freezePart.Name = "FreezeAura"

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - freezePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFreezeAuraScript)
end

-- Function to create a fire aura
function ratapi.CreateFireAura(radius, damageAmount)
    local createFireAuraScript = [[
        local firePart = Instance.new("Part")
        firePart.Shape = Enum.PartType.Ball
        firePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        firePart.Anchored = true
        firePart.CanCollide = false
        firePart.Transparency = 0.5
        firePart.Color = Color3.new(1, 0.5, 0)
        firePart.Parent = game.Workspace
        firePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        firePart.Name = "FireAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - firePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFireAuraScript)
end

-- Function to create a ice aura
function ratapi.CreateIceAura(radius, slowAmount)
    local createIceAuraScript = [[
        local icePart = Instance.new("Part")
        icePart.Shape = Enum.PartType.Ball
        icePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        icePart.Anchored = true
        icePart.CanCollide = false
        icePart.Transparency = 0.5
        icePart.Color = Color3.new(0, 0.5, 1)
        icePart.Parent = game.Workspace
        icePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        icePart.Name = "IceAura"

        local slowAmount = ]]..tostring(slowAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - icePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.WalkSpeed = slowAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createIceAuraScript)
end

-- Function to create a lightning aura
function ratapi.CreateLightningAura(radius, damageAmount)
    local createLightningAuraScript = [[
        local lightningPart = Instance.new("Part")
        lightningPart.Shape = Enum.PartType.Ball
        lightningPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        lightningPart.Anchored = true
        lightningPart.CanCollide = false
        lightningPart.Transparency = 0.5
        lightningPart.Color = Color3.new(1, 1, 0)
        lightningPart.Parent = game.Workspace
        lightningPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        lightningPart.Name = "LightningAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - lightningPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLightningAuraScript)
end

-- Function to create a poison aura
function ratapi.CreatePoisonAura(radius, damageAmount)
    local createPoisonAuraScript = [[
        local poisonPart = Instance.new("Part")
        poisonPart.Shape = Enum.PartType.Ball
        poisonPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        poisonPart.Anchored = true
        poisonPart.CanCollide = false
        poisonPart.Transparency = 0.5
        poisonPart.Color = Color3.new(0, 1, 0)
        poisonPart.Parent = game.Workspace
        poisonPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        poisonPart.Name = "PoisonAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - poisonPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createPoisonAuraScript)
end

-- Function to create a shockwave aura
function ratapi.CreateShockwaveAura(radius, damageAmount)
    local createShockwaveAuraScript = [[
        local shockwavePart = Instance.new("Part")
        shockwavePart.Shape = Enum.PartType.Ball
        shockwavePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        shockwavePart.Anchored = true
        shockwavePart.CanCollide = false
        shockwavePart.Transparency = 0.5
        shockwavePart.Color = Color3.new(1, 0, 0)
        shockwavePart.Parent = game.Workspace
        shockwavePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        shockwavePart.Name = "ShockwaveAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - shockwavePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createShockwaveAuraScript)
end

-- Function to create a telekinesis aura
function ratapi.CreateTelekinesisAura(radius, pullAmount)
    local createTelekinesisAuraScript = [[
        local telekinesisPart = Instance.new("Part")
        telekinesisPart.Shape = Enum.PartType.Ball
        telekinesisPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        telekinesisPart.Anchored = true
        telekinesisPart.CanCollide = false
        telekinesisPart.Transparency = 0.5
        telekinesisPart.Color = Color3.new(0, 0, 1)
        telekinesisPart.Parent = game.Workspace
        telekinesisPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        telekinesisPart.Name = "TelekinesisAura"

        local pullAmount = ]]..tostring(pullAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - telekinesisPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = (telekinesisPart.Position - player.Character.HumanoidRootPart.Position).Unit * pullAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTelekinesisAuraScript)
end

-- Function to create a levitation aura
function ratapi.CreateLevitationAura(radius, liftAmount)
    local createLevitationAuraScript = [[
        local levitationPart = Instance.new("Part")
        levitationPart.Shape = Enum.PartType.Ball
        levitationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        levitationPart.Anchored = true
        levitationPart.CanCollide = false
        levitationPart.Transparency = 0.5
        levitationPart.Color = Color3.new(1, 1, 0)
        levitationPart.Parent = game.Workspace
        levitationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        levitationPart.Name = "LevitationAura"

        local liftAmount = ]]..tostring(liftAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - levitationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = player.Character.HumanoidRootPart.Velocity + Vector3.new(0, liftAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLevitationAuraScript)
end

-- Function to create a teleportation aura
function ratapi.CreateTeleportationAura(radius, teleportLocation)
    local createTeleportationAuraScript = [[
        local teleportationPart = Instance.new("Part")
        teleportationPart.Shape = Enum.PartType.Ball
        teleportationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        teleportationPart.Anchored = true
        teleportationPart.CanCollide = false
        teleportationPart.Transparency = 0.5
        teleportationPart.Color = Color3.new(1, 0, 1)
        teleportationPart.Parent = game.Workspace
        teleportationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        teleportationPart.Name = "TeleportationAura"

        local teleportLocation = CFrame.new]]..tostring(teleportLocation.X)..","..tostring(teleportLocation.Y)..","..tostring(teleportLocation.Z)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - teleportationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.CFrame = teleportLocation
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTeleportationAuraScript)
end

-- Function to create a freeze aura
function ratapi.CreateFreezeAura(radius)
    local createFreezeAuraScript = [[
        local freezePart = Instance.new("Part")
        freezePart.Shape = Enum.PartType.Ball
        freezePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        freezePart.Anchored = true
        freezePart.CanCollide = false
        freezePart.Transparency = 0.5
        freezePart.Color = Color3.new(0, 0, 0)
        freezePart.Parent = game.Workspace
        freezePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        freezePart.Name = "FreezeAura"

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - freezePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFreezeAuraScript)
end

-- Function to create a fire aura
function ratapi.CreateFireAura(radius, damageAmount)
    local createFireAuraScript = [[
        local firePart = Instance.new("Part")
        firePart.Shape = Enum.PartType.Ball
        firePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        firePart.Anchored = true
        firePart.CanCollide = false
        firePart.Transparency = 0.5
        firePart.Color = Color3.new(1, 0.5, 0)
        firePart.Parent = game.Workspace
        firePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        firePart.Name = "FireAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - firePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFireAuraScript)
end

-- Function to create a ice aura
function ratapi.CreateIceAura(radius, slowAmount)
    local createIceAuraScript = [[
        local icePart = Instance.new("Part")
        icePart.Shape = Enum.PartType.Ball
        icePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        icePart.Anchored = true
        icePart.CanCollide = false
        icePart.Transparency = 0.5
        icePart.Color = Color3.new(0, 0.5, 1)
        icePart.Parent = game.Workspace
        icePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        icePart.Name = "IceAura"

        local slowAmount = ]]..tostring(slowAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - icePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.WalkSpeed = slowAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createIceAuraScript)
end

-- Function to create a lightning aura
function ratapi.CreateLightningAura(radius, damageAmount)
    local createLightningAuraScript = [[
        local lightningPart = Instance.new("Part")
        lightningPart.Shape = Enum.PartType.Ball
        lightningPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        lightningPart.Anchored = true
        lightningPart.CanCollide = false
        lightningPart.Transparency = 0.5
        lightningPart.Color = Color3.new(1, 1, 0)
        lightningPart.Parent = game.Workspace
        lightningPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        lightningPart.Name = "LightningAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - lightningPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLightningAuraScript)
end

-- Function to create a poison aura
function ratapi.CreatePoisonAura(radius, damageAmount)
    local createPoisonAuraScript = [[
        local poisonPart = Instance.new("Part")
        poisonPart.Shape = Enum.PartType.Ball
        poisonPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        poisonPart.Anchored = true
        poisonPart.CanCollide = false
        poisonPart.Transparency = 0.5
        poisonPart.Color = Color3.new(0, 1, 0)
        poisonPart.Parent = game.Workspace
        poisonPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        poisonPart.Name = "PoisonAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - poisonPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createPoisonAuraScript)
end

-- Function to create a shockwave aura
function ratapi.CreateShockwaveAura(radius, damageAmount)
    local createShockwaveAuraScript = [[
        local shockwavePart = Instance.new("Part")
        shockwavePart.Shape = Enum.PartType.Ball
        shockwavePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        shockwavePart.Anchored = true
        shockwavePart.CanCollide = false
        shockwavePart.Transparency = 0.5
        shockwavePart.Color = Color3.new(1, 0, 0)
        shockwavePart.Parent = game.Workspace
        shockwavePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        shockwavePart.Name = "ShockwaveAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - shockwavePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createShockwaveAuraScript)
end

-- Function to create a telekinesis aura
function ratapi.CreateTelekinesisAura(radius, pullAmount)
    local createTelekinesisAuraScript = [[
        local telekinesisPart = Instance.new("Part")
        telekinesisPart.Shape = Enum.PartType.Ball
        telekinesisPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        telekinesisPart.Anchored = true
        telekinesisPart.CanCollide = false
        telekinesisPart.Transparency = 0.5
        telekinesisPart.Color = Color3.new(0, 0, 1)
        telekinesisPart.Parent = game.Workspace
        telekinesisPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        telekinesisPart.Name = "TelekinesisAura"

        local pullAmount = ]]..tostring(pullAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - telekinesisPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = (telekinesisPart.Position - player.Character.HumanoidRootPart.Position).Unit * pullAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTelekinesisAuraScript)
end

-- Function to create a levitation aura
function ratapi.CreateLevitationAura(radius, liftAmount)
    local createLevitationAuraScript = [[
        local levitationPart = Instance.new("Part")
        levitationPart.Shape = Enum.PartType.Ball
        levitationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        levitationPart.Anchored = true
        levitationPart.CanCollide = false
        levitationPart.Transparency = 0.5
        levitationPart.Color = Color3.new(1, 1, 0)
        levitationPart.Parent = game.Workspace
        levitationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        levitationPart.Name = "LevitationAura"

        local liftAmount = ]]..tostring(liftAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - levitationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = player.Character.HumanoidRootPart.Velocity + Vector3.new(0, liftAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLevitationAuraScript)
end

-- Function to create a teleportation aura
function ratapi.CreateTeleportationAura(radius, teleportLocation)
    local createTeleportationAuraScript = [[
        local teleportationPart = Instance.new("Part")
        teleportationPart.Shape = Enum.PartType.Ball
        teleportationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        teleportationPart.Anchored = true
        teleportationPart.CanCollide = false
        teleportationPart.Transparency = 0.5
        teleportationPart.Color = Color3.new(1, 0, 1)
        teleportationPart.Parent = game.Workspace
        teleportationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        teleportationPart.Name = "TeleportationAura"

        local teleportLocation = CFrame.new]]..tostring(teleportLocation.X)..","..tostring(teleportLocation.Y)..","..tostring(teleportLocation.Z)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - teleportationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.CFrame = teleportLocation
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTeleportationAuraScript)
end

-- Function to create a freeze aura
function ratapi.CreateFreezeAura(radius)
    local createFreezeAuraScript = [[
        local freezePart = Instance.new("Part")
        freezePart.Shape = Enum.PartType.Ball
        freezePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        freezePart.Anchored = true
        freezePart.CanCollide = false
        freezePart.Transparency = 0.5
        freezePart.Color = Color3.new(0, 0, 0)
        freezePart.Parent = game.Workspace
        freezePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        freezePart.Name = "FreezeAura"

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - freezePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFreezeAuraScript)
end

-- Function to create a fire aura
function ratapi.CreateFireAura(radius, damageAmount)
    local createFireAuraScript = [[
        local firePart = Instance.new("Part")
        firePart.Shape = Enum.PartType.Ball
        firePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        firePart.Anchored = true
        firePart.CanCollide = false
        firePart.Transparency = 0.5
        firePart.Color = Color3.new(1, 0.5, 0)
        firePart.Parent = game.Workspace
        firePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        firePart.Name = "FireAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - firePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createFireAuraScript)
end

-- Function to create a ice aura
function ratapi.CreateIceAura(radius, slowAmount)
    local createIceAuraScript = [[
        local icePart = Instance.new("Part")
        icePart.Shape = Enum.PartType.Ball
        icePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        icePart.Anchored = true
        icePart.CanCollide = false
        icePart.Transparency = 0.5
        icePart.Color = Color3.new(0, 0.5, 1)
        icePart.Parent = game.Workspace
        icePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        icePart.Name = "IceAura"

        local slowAmount = ]]..tostring(slowAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - icePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.WalkSpeed = slowAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createIceAuraScript)
end

-- Function to create a lightning aura
function ratapi.CreateLightningAura(radius, damageAmount)
    local createLightningAuraScript = [[
        local lightningPart = Instance.new("Part")
        lightningPart.Shape = Enum.PartType.Ball
        lightningPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        lightningPart.Anchored = true
        lightningPart.CanCollide = false
        lightningPart.Transparency = 0.5
        lightningPart.Color = Color3.new(1, 1, 0)
        lightningPart.Parent = game.Workspace
        lightningPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        lightningPart.Name = "LightningAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - lightningPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLightningAuraScript)
end

-- Function to create a poison aura
function ratapi.CreatePoisonAura(radius, damageAmount)
    local createPoisonAuraScript = [[
        local poisonPart = Instance.new("Part")
        poisonPart.Shape = Enum.PartType.Ball
        poisonPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        poisonPart.Anchored = true
        poisonPart.CanCollide = false
        poisonPart.Transparency = 0.5
        poisonPart.Color = Color3.new(0, 1, 0)
        poisonPart.Parent = game.Workspace
        poisonPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        poisonPart.Name = "PoisonAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - poisonPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createPoisonAuraScript)
end

-- Function to create a shockwave aura
function ratapi.CreateShockwaveAura(radius, damageAmount)
    local createShockwaveAuraScript = [[
        local shockwavePart = Instance.new("Part")
        shockwavePart.Shape = Enum.PartType.Ball
        shockwavePart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        shockwavePart.Anchored = true
        shockwavePart.CanCollide = false
        shockwavePart.Transparency = 0.5
        shockwavePart.Color = Color3.new(1, 0, 0)
        shockwavePart.Parent = game.Workspace
        shockwavePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        shockwavePart.Name = "ShockwaveAura"

        local damageAmount = ]]..tostring(damageAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - shockwavePart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.Humanoid.Health = math.max(player.Character.Humanoid.Health - damageAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createShockwaveAuraScript)
end

-- Function to create a telekinesis aura
function ratapi.CreateTelekinesisAura(radius, pullAmount)
    local createTelekinesisAuraScript = [[
        local telekinesisPart = Instance.new("Part")
        telekinesisPart.Shape = Enum.PartType.Ball
        telekinesisPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        telekinesisPart.Anchored = true
        telekinesisPart.CanCollide = false
        telekinesisPart.Transparency = 0.5
        telekinesisPart.Color = Color3.new(0, 0, 1)
        telekinesisPart.Parent = game.Workspace
        telekinesisPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        telekinesisPart.Name = "TelekinesisAura"

        local pullAmount = ]]..tostring(pullAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - telekinesisPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = (telekinesisPart.Position - player.Character.HumanoidRootPart.Position).Unit * pullAmount
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createTelekinesisAuraScript)
end

-- Function to create a levitation aura
function ratapi.CreateLevitationAura(radius, liftAmount)
    local createLevitationAuraScript = [[
        local levitationPart = Instance.new("Part")
        levitationPart.Shape = Enum.PartType.Ball
        levitationPart.Size = Vector3.new]]..tostring(radius)..","..tostring(radius)..","..tostring(radius)..[[
        levitationPart.Anchored = true
        levitationPart.CanCollide = false
        levitationPart.Transparency = 0.5
        levitationPart.Color = Color3.new(1, 1, 0)
        levitationPart.Parent = game.Workspace
        levitationPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        levitationPart.Name = "LevitationAura"

        local liftAmount = ]]..tostring(liftAmount)..[[

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player ~= game.Players.LocalPlayer then
                    local distance = (player.Character.HumanoidRootPart.Position - levitationPart.Position).Magnitude
                    if distance <= ]]..tostring(radius)..[[ then
                        player.Character.HumanoidRootPart.Velocity = player.Character.HumanoidRootPart.Velocity + Vector3.new(0, liftAmount, 0)
                    end
                end
            end
        end)
    ]]
    ratapi.Execute(createLevitationAuraScript)
end

local function generateCube(position, size)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = position
    part.Parent = workspace
    return part
end

local function generateSphere(position, radius)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
    part.Position = position
    part.Parent = workspace
    return part
end

local function generateCylinder(position, radius, height)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Cylinder
    part.Size = Vector3.new(radius * 2, height, radius * 2)
    part.Position = position
    part.Parent = workspace
    return part
end

-- Функция для генерации плоскости
local function generatePlane(position, size)
    local part = Instance.new("Part")
    part.Size = Vector3.new(size.X, 0.1, size.Y)
    part.Position = position
    part.Parent = workspace
    return part
end

local function generateRandomColor()
    return Color3.new(math.random(), math.random(), math.random())
end

local function generateRandomMaterial()
    local materials = Enum.Material.GetEnumItems()
    return materials[math.random(#materials)]
end

local function generateRandomSize(minSize, maxSize)
    return Vector3.new(math.random(minSize, maxSize), math.random(minSize, maxSize), math.random(minSize, maxSize))
end

local function generateRandomPosition(minPos, maxPos)
    return Vector3.new(math.random(minPos, maxPos), math.random(minPos, maxPos), math.random(minPos, maxPos))
end

local function generateRandomRotation()
    return Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
end

local function generateRandomText()
    local text = ""
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, math.random(5, 15) do
        text = text .. characters:sub(math.random(1, #characters), math.random(1, #characters))
    end
    return text
end

local function generateRandomNumber(minNum, maxNum)
    return math.random(minNum, maxNum)
end

local function generateRandomBoolean()
    return math.random(0, 1) == 1
end

local function generateRandomVector(minVal, maxVal)
    return Vector3.new(math.random(minVal, maxVal), math.random(minVal, maxVal), math.random(minVal, maxVal))
end

local function generateRandomAngle()
    return math.rad(math.random(0, 360))
end

local function generateRandomTextColor()
    return Color3.new(math.random(), math.random(), math.random())
end

local function generateRandomTextSize()
    return math.random(10, 30)
end

local function generateRandomTextFont()
    local fonts = Enum.Font.GetEnumItems()
    return fonts[math.random(#fonts)]
end

local function generateRandomTextWithLength(length)
    local text = ""
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, length do
        text = text .. characters:sub(math.random(1, #characters), math.random(1, #characters))
    end
    return text
end

local function generateRandomFloat(minNum, maxNum)
    return math.random() * (maxNum - minNum) + minNum
end

local function generateRandomBooleanWithProbability(probability)
    return math.random() < probability
end

local function generateRandomVectorWithBounds(minVal, maxVal)
    return Vector3.new(math.random(minVal, maxVal), math.random(minVal, maxVal), math.random(minVal, maxVal))
end

--Example:

--local cube = generateCube(Vector3.new(0, 5, 0), Vector3.new(2, 2, 2))
--cube.Color = generateRandomColor()
--cube.Material = generateRandomMaterial()

--local sphere = generateSphere(Vector3.new(5, 5, 0), 2)
--sphere.Color = generateRandomColor()
--sphere.Material = generateRandomMaterial()

--local cylinder = generateCylinder(Vector3.new(10, 5, 0), 2, 4)
--cylinder.Color = generateRandomColor()
--cylinder.Material = generateRandomMaterial()

--local plane = generatePlane(Vector3.new(15, 5, 0), Vector2.new(4, 4))
--plane.Color = generateRandomColor()
--plane.Material = generateRandomMaterial()


--█▀█ █░░ ▄▀█ █▄█ █▀▀ █▀█   █▀▄▀█ ▄▀█ █▄░█ ▄▀█ █▀▀ █▀▀ █▀█
--█▀▀ █▄▄ █▀█ ░█░ ██▄ █▀▄   █░▀░█ █▀█ █░▀█ █▀█ █▄█ ██▄ █▀▄

local PlayerManager = {}

function PlayerManager.OnPlayerJoin(player)
  print("Player " .. player.Name .. " joined (from PlayerManager)!")
end

return PlayerManager

-- CONNECT
local PlayerManager = require(game.ServerScriptService.PlayerManager)

game.Players.PlayerAdded:Connect(PlayerManager.OnPlayerJoin)

print("script loaded!")

function plrControl(player, maxSpeed)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
      local humanoid = player.Character.Humanoid
      humanoid.WalkSpeed = maxSpeed
      humanoid.JumpPower = 0
      logMessage("Player speed " .. player.Name .. " limited to: " .. maxSpeed)
  
      humanoid.CanCollide = true
      humanoid.UseJumpPower = false
  
      delay(10, function()
        humanoid.WalkSpeed = 16 
        humanoid.JumpPower = 50
        humanoid.UseJumpPower = true
        logMessage("Speed and jumps from player " .. player.Name .. " reseted to standart.")
      end)
  
    else
      logMessage("ERROR: Humanoid not found! player: " .. player.Name)
    end
  end
