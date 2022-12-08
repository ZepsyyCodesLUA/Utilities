local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local ReSt = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local TS = game:GetService("TweenService")


local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

local ModuleScripts = {
    MainGame = require(Plr.PlayerGui.MainUI.Initiator.Main_Game),
    SeekIntro = require(Plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes.SeekIntro),
}
local Connections = {}


local function playSound(soundId, source, properties)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://".. soundId
    sound.PlayOnRemove = true
    
    for i, v in next, properties do
        if i ~= "SoundId" and i ~= "Parent" and i ~= "PlayOnRemove" then
            sound[i] = v
        end
    end

    sound.Parent = source
    sound:Destroy()
end

local function drag(model, dest, speed)
    local reached = false

    Connections.Drag = RS.Stepped:Connect(function(_, step)
        if model.Parent then
            local seekPos = model.PrimaryPart.Position
            local newDest = Vector3.new(dest.X, seekPos.Y, dest.Z)
            local diff = newDest - seekPos
    
            if diff.Magnitude > 0.1 then
                model:SetPrimaryPartCFrame(CFrame.lookAt(seekPos + diff.Unit * math.min(step * speed, diff.Magnitude - 0.05), newDest))
            else
                Connections.Drag:Disconnect()
                reached = true
            end
        else
            Connections.Drag:Disconnect()
        end
    end)

    repeat task.wait() until reached
end

local function jumpscareSeek()
    Hum.Health = 0
    workspace.Ambience_Seek:Stop()

    local func = getconnections(ReSt.Bricks.Jumpscare.OnClientEvent)[1].Function
    debug.setupvalue(func, 1, false)
    func("Seek")
end

local function connectSeek(room)
    local seekMoving = workspace.SeekMoving
    local seekRig = seekMoving.SeekRig

    -- Intro
    
    seekMoving:SetPrimaryPartCFrame(room.RoomStart.CFrame * CFrame.new(0, 0, -15))
    seekRig.AnimationController:LoadAnimation(seekRig.AnimRaise):Play()

    task.spawn(function()
        task.wait(7)
        workspace.Footsteps_Seek:Play()
    end)

    workspace.Ambience_Seek:Play()
    ModuleScripts.SeekIntro(ModuleScripts.MainGame)
    seekRig.AnimationController:LoadAnimation(seekRig.AnimRun):Play()
    Char:SetPrimaryPartCFrame(room.RoomEnd.CFrame * CFrame.new(0, 0, 20))
    ModuleScripts.MainGame.chase = true
    Hum.WalkSpeed = 22
    
    -- Movement

    task.spawn(function()
        local nodes = {}

        for _, v in next, workspace.CurrentRooms:GetChildren() do
            for i2, v2 in next, v:GetAttributes() do
                if string.find(i2, "Seek") and v2 then
                    nodes[#nodes + 1] = v.RoomEnd
                end
            end
        end

        for _, v in next, nodes do
            if seekMoving.Parent and not seekMoving:GetAttribute("IsDead") then
                drag(seekMoving, v.Position, 15)
            end
        end
    end)

    -- Killing

    task.spawn(function()
        while seekMoving.Parent do
            if (Root.Position - seekMoving.PrimaryPart.Position).Magnitude <= 30 and Hum.Health > 0 and not seekMoving.GetAttribute(seekMoving, "IsDead") then
                Connections.Drag:Disconnect()
                workspace.Footsteps_Seek:Stop()
                ModuleScripts.MainGame.chase = false
                Hum.WalkSpeed = 15
                
                -- Crucifix / death

                if not Char.FindFirstChild(Char, "Crucifix") then
                    jumpscareSeek()
                else
                    seekMoving.Figure.Repent:Play()
                    seekMoving:SetAttribute("IsDead", true)
                    workspace.Ambience_Seek.TimePosition = 92.6

                    task.spawn(function()
                        ModuleScripts.MainGame.camShaker:ShakeOnce(35, 25, 0.15, 0.15)
                        task.wait(0.5)
                        ModuleScripts.MainGame.camShaker:ShakeOnce(5, 25, 4, 4)
                    end)

                    -- Crucifix float

                    local model = Instance.new("Model")
                    model.Name = "Crucifix"
                    local hl = Instance.new("Highlight")
                    local crucifix = Char.Crucifix
                    local fakeCross = crucifix.Handle:Clone()
        
                    fakeCross:FindFirstChild("EffectLight").Enabled = true
        
                    ModuleScripts.MainGame.camShaker:ShakeOnce(35, 25, 0.15, 0.15)
        
                    model.Parent = workspace
                    -- hl.Parent = model
                    -- hl.FillTransparency = 1
                    -- hl.OutlineColor = Color3.fromRGB(75, 177, 255)
                    fakeCross.Anchored = true
                    fakeCross.Parent = model
        
                    crucifix:Destroy()
        
                    for i, v in pairs(fakeCross:GetChildren()) do
                        if v.Name == "E" and v:IsA("BasePart") then
                            v.Transparency = 0
                            v.CanCollide = false
                        end
                        if v:IsA("Motor6D") then
                            v.Name = "Motor6D"
                        end
                    end
        


                    -- Seek death

                    task.wait(4)
                    seekMoving.Figure.Scream:Play()
                    playSound(11464351694, workspace, { Volume = 3 })
                    game.TweenService:Create(seekMoving.PrimaryPart, TweenInfo.new(4), {CFrame = seekMoving.PrimaryPart.CFrame - Vector3.new(0, 10, 0)}):Play()
                    task.wait(4)

                    seekMoving:Destroy()
                    fakeCross.Anchored = false
                    fakeCross.CanCollide = true
                    task.wait(0.5)
                    model:Remove()
                end

                break
            end

            task.wait()
        end
    end)
end

-- Setup

local newIdx; newIdx = hookmetamethod(game, "__newindex", newcclosure(function(t, k, v)
    if k == "WalkSpeed" and not checkcaller() then
        if ModuleScripts.MainGame.chase then
            v = ModuleScripts.MainGame.crouching and 17 or 22
        else
            v = ModuleScripts.MainGame.crouching and 10 or 15
        end
    end
    
    return newIdx(t, k, v)
end))

local function IsVisible(part)
    local vec, found=workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    local onscreen = found and vec.Z > 0
    local cfg = RaycastParams.new()
    cfg.FilterType = Enum.RaycastFilterType.Blacklist
    cfg.FilterDescendantsInstances = {part}

    local cast = workspace:Raycast(part.Position, (game.Players.LocalPlayer.Character.UpperTorso.Position - part.Position), cfg)
    if onscreen then
        if cast and (cast and cast.Instance).Parent==game.Players.LocalPlayer.Character then
            return true
        end
    end
end

local Equipped = false

-- Edit this --
getgenv().spawnKey = Enum.KeyCode.F4
---------------

-- Services

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

-- Variables

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")
local RightArm = Char:WaitForChild("RightUpperArm")
local LeftArm = Char:WaitForChild("LeftUpperArm")

local RightC1 = RightArm.RightShoulder.C1
local LeftC1 = LeftArm.LeftShoulder.C1

local SelfModules = {
    Functions = loadstring(
        game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua")
    )(),
    CustomShop = loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"
        )
    )(),
}

local ModuleScripts = {
    MainGame = require(Plr.PlayerGui.MainUI.Initiator.Main_Game),
    SeekIntro = require(Plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes.SeekIntro),
}

-- Functions

local function setupCrucifix(tool)
    tool.Equipped:Connect(function()
        Equipped = true
        Char:SetAttribute("Hiding", true)
        for _, v in next, Hum:GetPlayingAnimationTracks() do
            v:Stop()
        end

        RightArm.Name = "R_Arm"
        LeftArm.Name = "L_Arm"

        RightArm.RightShoulder.C1 = RightC1 * CFrame.Angles(math.rad(-90), math.rad(-15), 0)
        LeftArm.LeftShoulder.C1 = LeftC1
            * CFrame.new(-0.2, -0.3, -0.5)
            * CFrame.Angles(math.rad(-125), math.rad(25), math.rad(25))
    end)

    tool.Unequipped:Connect(function()
        Equipped = false
        Char:SetAttribute("Hiding", nil)
        RightArm.Name = "RightUpperArm"
        LeftArm.Name = "LeftUpperArm"

        RightArm.RightShoulder.C1 = RightC1
        LeftArm.LeftShoulder.C1 = LeftC1
    end)
end

-- Scripts

local CrucifixTool = game:GetObjects("rbxassetid://11590476113")[1]
CrucifixTool.Name = "Crucifix"
CrucifixTool.Parent = game.Players.LocalPlayer.Backpack

-- game.UserInputService.InputBegan:Connect(function(input, proc)
--     if proc then return end

--     if input.KeyCode == input.KeyCode[getgenv().spawnKey] then
--         local CrucifixTool = game:GetObjects("rbxassetid://11590476113")[1]
--         CrucifixTool.Name = "Crucifix"
--         CrucifixTool.Parent = game.Players.LocalPlayer.Backpack
--     end
-- end)
-- Input handler

setupCrucifix(CrucifixTool)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

-- Variables

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

local dupeCrucifix = Instance.new("BindableEvent")
local function func(ins)
    wait(.01) -- Wait for the attribute
    if ins:GetAttribute("IsCustomEntity")==true and ins:GetAttribute("ClonedByCrucifix")~=true then
        local Chains = game:GetObjects("rbxassetid://11584227521")[1]
        Chains.Parent = workspace
        local chained = true
        local posTime = false
        local rotTime = false
        local tweenTime = false
        local intFound = true

        game:GetService("RunService").RenderStepped:Connect(function()
            if Equipped then
                if ins.Parent~=nil and ins.PrimaryPart and IsVisible(ins.PrimaryPart) and (Root.Position-ins.PrimaryPart.Position).magnitude <= 25 then
                    local c=ins:Clone()
                    c:SetAttribute("ClonedByCrucifix", true)
                    c.RushNew.Anchored=true
                    c.Parent=ins.Parent
                    ins:Destroy()
                    dupeCrucifix:Fire(6,c.RushNew)


                    
                    -- Chains.PrimaryPart.Orientation = Chains.PrimaryPart.Orientation + Vector3.new(0, 3, 0)

                    local EntityRoot = c:FindFirstChild("RushNew")

                    if EntityRoot then



                        local Fake_FaceAttach = Instance.new("Attachment")
                        Fake_FaceAttach.Parent = EntityRoot
                        

                        for i, beam in pairs(Chains:GetDescendants()) do
                            if beam:IsA("BasePart") then
                                beam.CanCollide = false
                            end
                            if beam.Name == "Beam" then
                                beam.Attachment1 = Fake_FaceAttach
                            end
                        end
                        
                        if not posTime then
                            Chains:SetPrimaryPartCFrame(
                                EntityRoot.CFrame * CFrame.new(0, -3.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
                            )
                            posTime = true
                        end

                        task.wait(1.35)
                        if not tweenTime then

                            task.spawn(function()
                                while task.wait() do
                                    if Chains:FindFirstChild('Base') then
                                        Chains.Base.CFrame = Chains.Base.CFrame * CFrame.Angles(0,0 , math.rad(0.5))
                                    end
                                end
                            end)

                            task.spawn(function()
                                while task.wait() do
                                    for i, beam in pairs(Chains:GetDescendants()) do
                                        if beam.Name == "Beam" then
                                            beam.TextureLength = beam.TextureLength+0.035
                                        end
                                    end
                                end
                            end)


                            game.TweenService
                                :Create(
                                    EntityRoot,
                                    TweenInfo.new(6),
                                    { CFrame = EntityRoot.CFrame * CFrame.new(0, 50, 0) }
                                )
                                :Play()
                            

                            tweenTime = true
                            task.wait(1.5)
                            intFound = false
                            game:GetService("Debris"):AddItem(c, 0)
                            game:GetService("Debris"):AddItem(Chains, 0)
                        end
                    end
                end
            end
        end)
    elseif ins.Name=="Lookman" then
        local c=ins
        task.spawn(function()
            repeat task.wait() until IsVisible(c.Core) and Equipped and c.Core.Attachment.Eyes.Enabled==true
            local pos=c.Core.Position
            dupeCrucifix:Fire(18.364, c.Core)
            task.spawn(function()
                c:SetAttribute("Killing", true)
                ModuleScripts.MainGame.camShaker:ShakeOnce(10, 10, 5, 0.15)
                wait(5)
                c.Core.Initiate:Stop()
                for i=1,3 do
                    c.Core.Repent:Play()  
                    c.Core.Attachment.Angry.Enabled=true
                    ModuleScripts.MainGame.camShaker:ShakeOnce(8, 8, 1.3, 0.15)
                    delay(c.Core.Repent.TimeLength, function() c.Core.Attachment.Angry.Enabled=false end)
                    wait(4)
                end
                c.Core.Scream:Play();
                ModuleScripts.MainGame.camShaker:ShakeOnce(8, 8, c.Core.Scream.TimeLength, 0.15);
                (c.Core:FindFirstChild"whisper" or c.Core:FindFirstChild"Ambience"):Stop()
                for _, l in pairs(c:GetDescendants()) do
                    if l:IsA("PointLight") then
                        l.Enabled=false
                    end
                end
                game:GetService("TweenService"):Create(c.Core, TweenInfo.new(c.Core.Scream.TimeLength, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    CFrame=CFrame.new(c.Core.CFrame.X, c.Core.CFrame.Y-12, c.Core.CFrame.Z)
                }):Play()
            end)
            local col=game.Players.LocalPlayer.Character.Collision

            local function CFrameToOrientation(cf)
                local x, y, z = cf:ToOrientation()
                return Vector3.new(math.deg(x), math.deg(y), math.deg(z))
            end
            
            while c.Parent~=nil and c.Core.Attachment.Eyes.Enabled==true do
                -- who's the boss now huh?
                col.Orientation = CFrameToOrientation(CFrame.lookAt(col.Position, pos)*CFrame.Angles(0, math.pi, 0))
                task.wait()
            end
        end)
    elseif ins.Name=="Shade" and ins.Parent==workspace.CurrentCamera and ins:GetAttribute("ClonedByCrucifix")==nil then
        task.spawn(function()
            repeat task.wait() until IsVisible(ins) and (Root.Position-ins.Position).Magnitude <= 12.5 and Equipped

            local clone = ins:Clone()

            clone.CFrame = ins.CFrame
            clone.Parent = ins.Parent
            clone.Anchored = true

            ins:Remove()

            dupeCrucifix:Fire(13, ins)
            ModuleScripts.MainGame.camShaker:ShakeOnce(40, 10, 5, 0.15)



            for _, thing in pairs(clone:GetDescendants()) do
                if thing:IsA("SpotLight") then
                    game:GetService("TweenService"):Create(thing, TweenInfo.new(5), {
                        Brightness=thing.Brightness*5
                    }):Play()
                elseif thing:IsA("Sound") and thing.Name~="Burst" then
                    game:GetService("TweenService"):Create(thing, TweenInfo.new(5), {
                        Volume=0
                    }):Play()
                elseif thing:IsA("TouchTransmitter") then thing:Destroy() end
            end

            for _, pc in pairs(clone:GetDescendants()) do
                if pc:IsA("ParticleEmitter") then
                        pc.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(182, 0, 3)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
                end
            end

            local Original_color = {}

            local light
            light = game.Lighting["Ambience_Shade"]
            game:GetService("TweenService"):Create(light, TweenInfo.new(1), {


            }):Play()

            wait(5)

            clone.Burst.PlaybackSpeed=0.5
            clone.Burst:Stop()
            clone.Burst:Play()
            light.TintColor = Color3.fromRGB(215,253,255)
            game:GetService("TweenService"):Create(clone, TweenInfo.new(6), {
                CFrame=CFrame.new(clone.CFrame.X, clone.CFrame.Y-12, clone.CFrame.Z)
            }):Play()
            wait(8.2)

            game:GetService("Debris"):AddItem(clone, 0)
            game.ReplicatedStorage.Bricks.ShadeResult:FireServer()
        end)
    end
end

workspace.ChildAdded:Connect(func)
workspace.CurrentCamera.ChildAdded:Connect(func)
for _, thing in pairs(workspace:GetChildren()) do
    func(thing)
end
dupeCrucifix.Event:Connect(function(time, entityRoot)
    local Cross = game:GetObjects("rbxassetid://11656343590")[1]
    Cross.Parent = workspace

    local fakeCross = Cross.Handle

    -- fakeCross:FindFirstChild("EffectLight").Enabled = true

    ModuleScripts.MainGame.camShaker:ShakeOnce(35, 25, 0.15, 0.15)
    -- you tell me i didnt make?
    fakeCross.CFrame = CFrame.lookAt(CrucifixTool.Handle.Position, entityRoot.Position)
    
    -- hl.Parent = model
    -- hl.FillTransparency = 1
    -- hl.OutlineColor = Color3.fromRGB(75, 177, 255)
    fakeCross.Anchored = true

    CrucifixTool:Destroy()

    -- for i, v in pairs(fakeCross:GetChildren()) do
    --     if v.Name == "E" and v:IsA("BasePart") then
    --         v.Transparency = 0
    --         v.CanCollide = false
    --     end
    --     if v:IsA("Motor6D") then
    --         v.Name = "Motor6D"
    --     end
    -- end

    task.wait(time)
    fakeCross.Anchored = false
    fakeCross.CanCollide = true
    task.wait(0.5)
    Cross:Remove()
end)
