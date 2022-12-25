    

function connect(asset)
    for _,v in pairs(asset:GetDescendants()) do
        for i,a in pairs(workspace.CurrentRooms:GetChildren()) do
            if a:FindFirstChild("RainSky") then
                if v.Name == "Bush" then
                    v.BrickColor = BrickColor.new("Institutional White")
                end
                if v.Name == "Courtyard_Tree" then
                    v.Leaves.BrickColor = BrickColor.new("Institutional White")
                end
                if v.Name == "Floor" and v:IsA("BasePart") and v.Material == Enum.Material.Grass then
                    v.BrickColor = BrickColor.new("Institutional White")
                    v.Material=Enum.Material.Snow
                end
            end
        end
    end
end

connect(workspace.CurrentRooms)

workspace.CurrentRooms.ChildAdded:Connect(function(child)
    connect(child)
end)


    local RoomModels={11809071886}
    local FakeDoorName="FakeDoor_Hotel"
    local DoorReplicator=loadstring(game:HttpGet"https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Door%20Replication/Source.lua")()
    
    local Player = game.Players.LocalPlayer
    
    local PI_Folder = Instance.new("Folder", game.ReplicatedStorage)
    PI_Folder.Name = "Possibleitems"
    
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacteAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
     
    
    
    
    
    
    
    
    local Possibleitems = {
        "a Crucifix!",
        "Vitamins!",
        -- "Knobs!",
        -- "Boosts!",
        -- "Revives!",
        -- "Coal :("
    }
    
    function SetupDoor(fakedoor)
                -- local newdoor=DoorReplicator.CreateDoor({Sign=false, Light=false}).model; 
    
        -- DoorReplicator.ReplicateDoor({Config={GuidingLight=true, Model=newdoor}})
        local room=game:GetObjects("rbxassetid://"..tostring(RoomModels[math.random(1,#RoomModels)]))[1]:Clone()
        room.PrimaryPart=room.RoomStart
        room.Parent = workspace.CurrentRooms:FindFirstChild(tostring(Player:GetAttribute("CurrentRoom")))
    
        local cf=fakedoor.Collision.CFrame
        -- newdoor:PivotTo(cf)
        fakedoor:Destroy()
        -- DoorReplicator.ReplicateDoor({Config={GuidingLight=true, Model=newdoor}})
    
        room:PivotTo(cf)
        local TweenService = game:GetService("TweenService")
        
        if room.Name == "ExtraRoom_1" then
            local ImportantAssets = room:FindFirstChild("ImportantAssets")
    
            if ImportantAssets then
                local LootBag = ImportantAssets:FindFirstChild("Lootbag") 
                
                if LootBag then
                    local Spawner = LootBag:WaitForChild("ItemSpawner")
                    local BagTie = LootBag:WaitForChild("BagTie")
                    local SantasBag = BagTie:WaitForChild("SantasBag")
                    local PickupPrompt = SantasBag:FindFirstChildWhichIsA('ProximityPrompt', true)
    
    
                    if PickupPrompt then
                        PickupPrompt.Triggered:Connect(function()
                            local PickupModels = {
                                ["Vitamins!"] = 11801639840;
                                ["a Crucifix!"] = 11801550132;
                            }
    
                            local rng = tostring(Possibleitems[math.random(1,#Possibleitems)])
                            print(rng)
                            firesignal(game.ReplicatedStorage.Bricks.Caption.OnClientEvent, "You got "..tostring(rng))
                                if rng == "Vitamins!" then
                                    local Vitamins = game:GetObjects("rbxassetid://11685698403")[1]
                                    local idle = Vitamins.Animations:FindFirstChild("idle")
                                    local open = Vitamins.Animations:FindFirstChild("open")
                                    local tweenService = game:GetService("TweenService")
                                    local sound_open = Vitamins.Handle:FindFirstChild("sound_open")
                                    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacteAdded:Wait()
                                    local hum = char:WaitForChild("Humanoid")
                                    local idleTrack = hum.Animator:LoadAnimation(idle)
                                    local openTrack = hum.Animator:LoadAnimation(open)
                                    local Durability = 35
                                    local InTrans = false
                                    local Duration = math.random(5, 8)
                                    local xUsed = math.random(100,1000)
                                    local v1 = {};
                                    function AddDurability()
                                        InTrans = true
                                        hum:SetAttribute("SpeedBoost", 11)
                                        hum.WalkSpeed = Durability
                                        task.spawn(function()
                                            repeat
                                                task.wait(.1)
                                                hum:SetAttribute("SpeedBoost", hum:GetAttribute"SpeedBoost" - .1)
                                            until hum:GetAttribute("SpeedBoost") <= 0
                                        end)
                                        wait(Duration)
                                        InTrans = false
                                        hum.WalkSpeed = 16
                                    end
                                    function SetupVitamins()
                                        Vitamins.Parent = game.Players.LocalPlayer.Backpack
                                        Vitamins.Name = "FakeVitamins"
                                        for slotNum, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                            if tool.Name == "FakeVitamins" then
                                                local slot = game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI").MainFrame.Hotbar:FindFirstChild(slotNum)
                                                -- while task.wait() do
                                                --     slot.DurabilityNumber.Text = "x"..xUsed
                                                -- end
                                                -- slot.DurabilityNumber.Text = "x"..xUsed
                                                game:GetService("RunService").RenderStepped:Connect(function()
                                                    slot.DurabilityNumber.Visible = true
                                                    slot.DurabilityNumber.Text = "x" .. xUsed
                                                end)
                                                Vitamins.Activated:Connect(function()
                                                    if not InTrans then
                                                        xUsed -= 1
                                                        task.spawn(function()
                                                            slot.DurabilityNumber.Visible = true
                                                            slot.DurabilityNumber.Text = "x" .. xUsed
                                                            openTrack:Play()
                                                            sound_open:Play()
                                                            tweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.2), {
                                                                FieldOfView = 100
                                                            }):Play()
                                                            AddDurability()
                                                        end)
                                                        if xUsed == 0 then
                                                            delay(sound_open.TimeLength + .2, function()
                                                                Vitamins:Destroy()
                                                            end)
                                                        end
                                                    end
                                                end)
                                            end
                                        end
                                        Vitamins.Equipped:Connect(function()
                                            idleTrack:Play()
                                        end)
                                        Vitamins.Unequipped:Connect(function()
                                            idleTrack:Stop()
                                        end)
                                    end
                                    SetupVitamins()
                                    function AddLoop()
                                        while task.wait() do
                                            if InTrans then
                                                wait()
                                                hum.WalkSpeed = Durability
                                            else
                                                hum.WalkSpeed = 16
                                            end
                                        end
                                    end
    
    
                                    while task.wait() do
                                        AddLoop()
                                    end
                                                                end
                                                                local PickUpItem = game:GetObjects("rbxassetid://".. tostring(PickupModels[rng]))[1]
                                                                PickUpItem.Parent = workspace
                                                                PickUpItem:PivotTo(Spawner.CFrame)
                                                                TweenService:Create(PickUpItem.PrimaryPart, TweenInfo.new(0.3), {CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame}):Play()
                                                                for i,v in pairs(PickUpItem:GetDescendants()) do
                                                                    if v:IsA("BasePart") then
                                                                        TweenService:Create(v, TweenInfo.new(1), {Transparency = 1}):Play()
                                                                    end
                                                                end
    
                                                                wait(0.3)
                                                                PickUpItem:Remove()
    
    
                                                                ---Give
                                                                
                                                        end)    
                                                    end
                                                end
                                            end
                                        end
    end     
    
    
    for _, fakedoor in pairs(workspace.CurrentRooms:GetDescendants()) do
        if fakedoor.Name==FakeDoorName then
            SetupDoor(fakedoor)
        end
    end
    
    workspace.CurrentRooms.ChildAdded:Connect(function(room)
        for _, fakedoor in pairs(room:GetDescendants()) do
            if fakedoor.Name==FakeDoorName then
                SetupDoor(fakedoor)
            end
        end
    end)

    
    local Library = Instance.new("ScreenGui")
    Library.Parent = game.CoreGui

    local NotificationHandler = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    NotificationHandler.Name = "NotificationHandler"
    NotificationHandler.Parent = Library
    NotificationHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationHandler.BackgroundTransparency = 1.000
    NotificationHandler.Position = UDim2.new(0, 0, 0.8, 0)
    NotificationHandler.Size = UDim2.new(1, 0, 0.0925925896, 0)
    UIListLayout.Parent = NotificationHandler
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.Padding = UDim.new(0.100000001, 0)



    for i,v in pairs(Library:GetChildren()) do
        if v.Name == "Sound" then
            v:Remove()
        end
    end

    function CreateNotification(Text, Color)
        Text = Text or "Notification Description Here.."
        Color = Color or Color3.fromRGB(244, 181, 153)
        
        local Typewriter_effect = Instance.new("Sound")
        local Notification = Instance.new("TextLabel")
        --Properties:

        if Color == "nil" then
            Color = Color3.fromRGB(244, 181, 153)
        end

        Notification.Name = "Notification"
        Notification.Parent = NotificationHandler
        Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Notification.BackgroundTransparency = 1.000
        Notification.Size = UDim2.new(1, 0, 0.332086951, 0)
        Notification.Font = Enum.Font.Oswald
        Notification.Text = ""
        Notification.TextColor3 = Color
        Notification.TextScaled = true
        Notification.TextSize = 14.000
        Notification.TextStrokeTransparency = 1.000
        Notification.TextWrapped = true


        Typewriter_effect.Parent = Notification
        Typewriter_effect.SoundId = "rbxassetid://9120299506"
        Typewriter_effect.Volume = 0.05
        for i = 1, #Text do		

            Notification.Text = string.sub(Text, 1, i)
            Typewriter_effect:Play()
            wait(0.0001)
            if i == #Text then
                wait(1)
                game.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
                game.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextStrokeTransparency = 1}):Play()
                wait(2.1)
                Notification:Remove()
            end
        end

    end

    CreateNotification("Loading Script...")

 
 local FunctionsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()

        -- game.UserInputService.InputBegan:Connect(function(input)
        --     if input.KeyCode == Enum.KeyCode.J then
        --         local config={
        --             Image= "https://tse4.mm.bing.net/th?id=OIP.HUXv5LmpmHrDgtkAP7p3SQHaHa&pid=Api&P=0", -- Could also be "image.png"
        --             Sound="rbxassetid://4994284848", -- Could also be "file.mp3"
        --             EntityName="SanJClost" -- Make sure to change if you mod the image/sound to prevent overlapping
        --         }
        --         local ReSt = game:GetService("ReplicatedStorage")
                
        --         local ModuleScripts = {
        --             ModuleEvents = require(ReSt.ClientModules.Module_Events),
        --         }
                
        --         local function connectClosetJack(wardrobes, room, bool)
        --             for _, wardrobe in pairs(wardrobes) do
        --                 if not game:GetService("ReplicatedStorage"):FindFirstChild("closetAnim") then 
        --                     local anim = Instance.new("Animation")
        --                     anim.AnimationId = "rbxassetid://9460435404"
        --                     anim.Name="closetAnim"
        --                     anim.Parent=game:GetService("ReplicatedStorage")
        --                 end
        --                 if not game:GetService("ReplicatedStorage"):FindFirstChild("JackModel") then
        --                     if not isfile(config.EntityName..".txt") then writefile(config.EntityName..".txt", game:HttpGet("https://github.com/sponguss/storage/raw/real/newclosetjack.rbxm?raw=true")) end
        --                     local a=game:GetObjects((getcustomasset or getsynasset)(config.EntityName..".txt"))[1]
        --                     a.Name="JackModel"
        --                     a.Parent=game:GetService("ReplicatedStorage")
        --                 end
        --                 game:GetService("ReplicatedStorage").JackModel.Sound.SoundId=(isfile(config.Sound) and (getcustomasset or getsynasset)(config.Sound) or config.Sound)
        --                 game:GetService("ReplicatedStorage").JackModel.Gui.ImageLabel.Image=LoadCustomAsset(config.Image)
        --                 local prompt = wardrobe:WaitForChild("HidePrompt", 1)
        --                 if not prompt and wardrobe:FindFirstChild("fakePrompt") then return end
                    
        --                 if prompt then
        --                     -- Fake prompt
                    
        --                     local fakePrompt = prompt:Clone()
                            
        --                     if bool then prompt:Destroy() else prompt.Enabled=false end
        --                     fakePrompt.Parent = wardrobe
        --                     fakePrompt.Name="fakePrompt"
                            
        --                     local connection; connection = fakePrompt.Triggered:Connect(function()
        --                         if not bool then connection:Disconnect() end
        --                         local model=game:GetService("ReplicatedStorage").JackModel:Clone()
                    
        --                         if model and not wardrobe:FindFirstChild(model.Name) then
        --                             model:SetPrimaryPartCFrame(wardrobe.Main.CFrame)
        --                             model.Parent = workspace
                    
        --                             -- Animation setup
        --                             local anim = wardrobe.AnimationController:LoadAnimation(game:GetService("ReplicatedStorage").closetAnim)
                    
        --                             -- Scare
                                    
        --                             ModuleScripts.ModuleEvents.flickerLights(room, 1)
        --                             anim:Play()
    
                                    
        --                             model.Sound:Play()
                    
        --                             -- Destroy
                    
        --                             task.wait(1)
                                    
        --                             model:Destroy()
        --                             if not bool then prompt.Enabled = true end
        --                             if not bool then fakePrompt:Destroy() end
                    
        --                             if not bool then connection:Disconnect() end
        --                         end
        --                     end)
        --                 end
        --             end
        --         end
                
        --         local wardrobes = {}
        --         for _, wardrobe in pairs(workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")].Assets:GetChildren()) do
        --             if wardrobe.Name=="Wardrobe" then
        --                 table.insert(wardrobes, wardrobe)
        --             end
        --         end
                
        --         if wardrobes[1] then
        --             connectClosetJack(wardrobes, workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")], true) -- 'true' for jack to appear every time
        --         end
                
                
        --     end
        -- end)
    
    local config = {
        Decor_Figure = true;
        Decor_Seek = true;
        Decor_Screech = true;
        Decor_Rooms = true;
        CandyCaneDivider = 3;
        CandyCane_ActivateRadius = 10;
    }
    
    local PaperImage_Desk = "https://cdn.discordapp.com/attachments/1036326270130196521/1038674341082177576/Giga_Santa.png"


    local Timothy_C = game:GetObjects("rbxassetid://11790598244")[1]
    Timothy_C.Parent = game:GetService("ReplicatedStorage"):WaitForChild("Entities")
    game:GetService("Debris"):AddItem(game:GetService("ReplicatedStorage"):WaitForChild("Entities").Spider, 0)

    local Screech_C = game:GetObjects("rbxassetid://11790593224")[1]
    Screech_C.Parent = game:GetService("ReplicatedStorage"):WaitForChild("Entities")
    game:GetService("Debris"):AddItem(game:GetService("ReplicatedStorage"):WaitForChild("Entities").Screech, 0)

    function addHaltDecor(obj)
        wait(2)
        local Halt_C = game:GetObjects("rbxassetid://11790608967")[1]
        Halt_C.Parent = obj
        Halt_C.Anchored = true
        Halt_C.CanCollide = false


        while task.wait() do
            Halt_C.Orientation = obj.Orientation * Vector3.new(1,1,1)
            Halt_C.CFrame = obj.CFrame * CFrame.new(0,1.7,0)
        end
    end

    game.Workspace.Camera.ChildAdded:Connect(function(c)
        if c.Name == "Shade" then
            addHaltDecor(c)
        end
    end)

    function AddWindowDecor(obj)
        if obj.Name == "Skybox" then
            obj.Color = Color3.fromRGB(255,255,255)
            obj.Material = Enum.Material.SmoothPlastic
        end
        if obj.Name == "Window" or "Window_Tall" then
            if obj:FindFirstChild("Particles") then
                local Part_Particles = obj:FindFirstChild("Particles")
                local SnowFlakes = game:GetObjects("rbxassetid://11790612421")[1]
                SnowFlakes.Parent = Part_Particles
    
                if Part_Particles:FindFirstChild("RainParticle") then
                    Part_Particles.Orientation = Vector3.new(0, obj.Glass.Orientation.Y, 180)
                    game:GetService("Debris"):AddItem(Part_Particles:FindFirstChild("RainParticle"), 0.2)
                end
            end
        end
    end
    
    for index, Skybox in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
        AddWindowDecor(Skybox)
    end
    
    workspace.CurrentRooms.ChildAdded:Connect(function(child)
        wait(1)
        for i, v in pairs(child:GetDescendants()) do
            AddWindowDecor(v)
        end
    end)


    for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
        if room.Name == "0" then
            if room.Parts:FindFirstChild("FrontDesk") then
                for i,paper in pairs(room.Parts:FindFirstChild("FrontDesk"):GetChildren()) do
                    local Decal = Instance.new("Decal")
                    Decal.Parent = paper
                    Decal.Face = Enum.NormalId.Top
                    Decal.Texture = LoadCustomAsset(PaperImage_Desk)
                end
            end
        end
    end

    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    function AddCandyCanes(obj)        
        local CandyCane = game:GetObjects("rbxassetid://11790619548")[1]
        CandyCane.Parent = obj
        CandyCane.Handle.CFrame  =  obj.CFrame * CFrame.new(
            math.random(-obj.Size.X/config.CandyCaneDivider, obj.Size.X/config.CandyCaneDivider),math.random(-obj.Size.Y/config.CandyCaneDivider, obj.Size.Y/config.CandyCaneDivider),math.random(-obj.Size.Z/config.CandyCaneDivider, obj.Size.Z/config.CandyCaneDivider)
         )
        CandyCane.Handle.Orientation = Vector3.new(0, math.random(1,190), -90)
        -- game:GetService("RunService").RenderStepped:Connect(function()
        --     if (hrp.Position - CandyCane:WaitForChild("Handle").Position).Magnitude <= config.CandyCane_ActivateRadius then
        --                 local Highlight = Instance.new("Highlight")
        --                 Highlight.FillTransparency = 1
        --                 Highlight.OutlineColor = Color3.fromRGB(255, 222, 189)
        --                 Highlight.Enabled = true
        --                 Highlight.Parent = CandyCane
        --                 Highlight:Remove()
        --     end
        -- end)
    end
    
    for i, table in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
        if table.Name == "Table" then
            
            local Part = Instance.new("Part")
            Part.CFrame = table:WaitForChild("Main").CFrame * CFrame.new(0,1.7,0)
            Part.Transparency = 1
            Part.Size = Vector3.new(table:WaitForChild("Main").Size.X, 0.2, table:WaitForChild("Main").Size.Z)
            Part.Parent = table
            Part.Name = "Candy Zone"
            Part.Anchored = true
            wait(0.1)
            AddCandyCanes(Part)
        end
        if table.Name == "Candy Zone" then
            table:Remove()
        end
    end
    
    game.Workspace.CurrentRooms.ChildAdded:Connect(function(Child)
        wait(2)
        for i,v in pairs(Child:GetDescendants()) do
            if v.Name == "Table" then
                local Part = Instance.new("Part")
                Part.CFrame = v:WaitForChild("Main").CFrame * CFrame.new(0,1.7,0)
                Part.Transparency = 1
                Part.Size = Vector3.new(v:WaitForChild("Main").Size.X, 0.2, v:WaitForChild("Main").Size.Z)
                Part.Parent = v
                Part.Name = "Candy Zone"
                Part.Anchored = true
                wait(0.1)
                AddCandyCanes(Part)
            end
    
        end
    end)
    
    function AddRoomsDecor(obj)
        --Stocker
        local Christmas_Sock = game:GetObjects("rbxassetid://11790642477")[1]
    
        Christmas_Sock.Parent = obj
        Christmas_Sock.Sock.CFrame = obj:WaitForChild("Stand").CFrame * CFrame.new(0.1,-1.2,-0.5)
        Christmas_Sock.Sock.Orientation = Vector3.new(0,obj:WaitForChild("Stand").Orientation.Y,-180)
    
        --Table Candy Canes
        
        local var = math.random(0,1)
    
        --Create CandyCane Zones
    end
    

    
    for i, object in pairs(workspace:WaitForChild("CurrentRooms"):GetDescendants()) do
        if object.Name == "LightStand" then
            AddRoomsDecor(object)
        end
        -- if object.Name == "0" then
        --     local Christmas_Sock = game:GetObjects(getsynasset("ChristmasSock.rbxm"))[1]
    
        --     Christmas_Sock.Parent = obj
        --     Christmas_Sock.Sock.CFrame = CFrame.new(30.2429504, 1.28093481, 3238.35498, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07)
        --     Christmas_Sock.Sock.Orientation = Vector3.new(0,obj:WaitForChild("Stand").Orientation.Y,-180)
            
        -- end
    end
    
    workspace.CurrentRooms.ChildAdded:Connect(function(child)
        wait(2)
            for i,v in pairs(child:GetDescendants()) do
                if v.Name == "LightStand" then
                    AddRoomsDecor(v)
                end
            end
    end)
    
    
    function AddFigureDecor(e)
        if e.Name == "FigureRagdoll" then
            local Hat = game:GetObjects("rbxassetid://11793162205")[1]
            Hat.Parent = e
        
            while config.Decor_Figure and task.wait() do
                Hat.Handle.CFrame = e.Head.CFrame * CFrame.new(-0.07,1,0)
            end
        end
    end
    
    function AddSeekDecor(e)
        if e.Name == "SeekRig" then
            local Hat = game:GetObjects("rbxassetid://11793159447")[1]
            Hat.Parent = e
        
            e:FindFirstChild("LeftLowerArm").BrickColor = BrickColor.new("Sea green")
            e:FindFirstChild("LeftLowerLeg").BrickColor = BrickColor.new("Maroon")
            e:FindFirstChild("LeftUpperArm").BrickColor = BrickColor.new("Sea green")
            e:FindFirstChild("LeftUpperLeg").BrickColor = BrickColor.new("Sea green")
            e:FindFirstChild("LowerTorso").BrickColor = BrickColor.new("Maroon")
            e:FindFirstChild("RightLowerArm").BrickColor = BrickColor.new("Sea green")
            e:FindFirstChild("RightLowerLeg").BrickColor = BrickColor.new("Maroon")
            e:FindFirstChild("RightUpperArm").BrickColor = BrickColor.new("Sea green")
            e:FindFirstChild("RightUpperLeg").BrickColor = BrickColor.new("Sea green")
            e:FindFirstChild("UpperTorso").BrickColor = BrickColor.new("Maroon")

            while config.Decor_Seek and task.wait() do
                Hat.Handle.CFrame = e.Head.CFrame * CFrame.new(-0.07,0.6,0)
            end
        end
    end
    
    --FigureHat
    for i,entity in pairs(workspace.CurrentRooms:GetDescendants()) do
        if config.Decor_Figure then
            AddFigureDecor(entity)
        end
    end
    
    --SeekHat
    for i,entity in pairs(workspace:GetDescendants()) do
        if config.Decor_Seek then
            AddSeekDecor(entity)
        end
    end
    
    
    game.Workspace.ChildAdded:Connect(function(child)
        wait(0.2)
        if child.Name == "SeekMoving" then
            local seekrig = child:WaitForChild("SeekRig")
            if seekrig and config.Decor_Seek then
                AddSeekDecor(seekrig)
            end
        end
    end)
    
    -- game:GetService("Workspace").SeekMoving.SeekRig
    
    
    game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)
        wait(2)
        if child.Name == "50" or child.Name == "100" then
            local figure = child.FigureSetup:WaitForChild("FigureRagdoll")
            if figure and config.Decor_Figure then
                AddFigureDecor(figure)
            end
        end
    end)

    function AddWindowDecor(obj)
        if obj.Name == "Skybox" then
            obj.Color = Color3.fromRGB(255,255,255)
            obj.Material = Enum.Material.SmoothPlastic
        end
        if obj.Name == "Window" then
            if obj:FindFirstChild("Particles") then
                local Part_Particles = obj:FindFirstChild("Particles")
                local SnowFlakes = game:GetObjects("rbxassetid://11790612421")[1]
                SnowFlakes.Parent = Part_Particles
    
                if Part_Particles:FindFirstChild("RainParticle") then
                    Part_Particles.Orientation = Vector3.new(0, obj.Glass.Orientation.Y, 180)
                    game:GetService("Debris"):AddItem(Part_Particles:FindFirstChild("RainParticle"), 0.2)
                end
            end
        end
    end
    
    for index, Skybox in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
        AddWindowDecor(Skybox)
    end
    
    workspace.CurrentRooms.ChildAdded:Connect(function(child)
        wait(2)
        for i, v in pairs(child:GetDescendants()) do
            AddWindowDecor(v)
        end
    end)
    
    local function addtexturestoobject(obj)
        local Front = game:GetObjects(getsynasset("Front.rbxm"))[1]
        local Back = game:GetObjects(getsynasset("Back.rbxm"))[1]
        local Left = game:GetObjects(getsynasset("left.rbxm"))[1]
        local Right = game:GetObjects(getsynasset("Right.rbxm"))[1]
        local Top = game:GetObjects(getsynasset("Top.rbxm"))[1]
        local Bottom = game:GetObjects(getsynasset("Bottom.rbxm"))[1]
        Front.Parent = obj
        Back.Parent = obj
        Left.Parent = obj
        Right.Parent = obj
        Top.Parent = obj
        Bottom.Parent = obj
    end
    
    for i,v in pairs(game.Players.LocalPlayer.Backpack:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "SantasSack" then
            addtexturestoobject(v)
        end
    end
    
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("Tool") and v.Name ~= "SantasSack" then
            for i,a in pairs(v:GetDescendants()) do
                if a:IsA("BasePart") then
                    addtexturestoobject(v)
                end
            end
        end
    end

    game.Players.LocalPlayer.Character.ChildAdded:Connect(function(child)
        wait(0.3)
        if child:IsA("Tool") then
            for i,v in pairs(child:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "SantasSack" then
                    addtexturestoobject(v)
                end
            end
        end
    end)
    game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(c)
        for i,v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                addtexturestoobject(v)
                if v.Name == "SantasSack" then return end
            end
        end
    end)
    





    local Background_sound = Instance.new("Sound")
    Background_sound.SoundId = "rbxassetid://1838667039"
    Background_sound.Playing = true
    Background_sound.Looped = true
    Background_sound.Volume = 0.05
    Background_sound.Parent = Library




    






    local Player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")

    local ScenePrompt = Instance.new("ScreenGui")
    local TextY = Instance.new("TextLabel")
    local Typewriter_effect = Instance.new("Sound")
    local BorderTop = Instance.new("Frame")
    local BorderBottom = Instance.new("Frame")





    ScenePrompt.Name = "ScenePrompt"
    ScenePrompt.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScenePrompt.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScenePrompt.IgnoreGuiInset = true

    BorderTop.Name = "BorderTop"
    BorderTop.Parent = ScenePrompt
    BorderTop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BorderTop.BorderSizePixel = 0
    BorderTop.Position = UDim2.new(0, 0, -0.200000003, 0)
    BorderTop.Size = UDim2.new(1, 0, 0.167, 0)

    BorderBottom.Name = "BorderBottom"
    BorderBottom.Parent = ScenePrompt
    BorderBottom.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BorderBottom.BorderSizePixel = 0
    BorderBottom.Position = UDim2.new(0, 0, 1, 0)
    BorderBottom.Size = UDim2.new(1, 0, 0.167, 0)

    TextY.Name = "Text"
    TextY.Parent = ScenePrompt
    TextY.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextY.BackgroundTransparency = 1.000
    TextY.Position = UDim2.new(0, 0, 0.909782588, 0)
    TextY.Size = UDim2.new(1, 0,0.038, 0)
    TextY.Font = Enum.Font.Oswald
    TextY.Text = ""
    TextY.TextColor3 = Color3.fromRGB(244, 181, 153)
    TextY.TextScaled = true
    TextY.TextSize = 14.000
    TextY.ZIndex = 213
    TextY.TextStrokeTransparency = 0.410
    TextY.TextWrapped = true

    Typewriter_effect.Parent = ScenePrompt
    Typewriter_effect.SoundId = "rbxassetid://9120299506"
    Typewriter_effect.Volume = 0.05

    function addSceneText(text)
        TextY.TextStrokeTransparency = 0
        TextY.TextTransparency = 0
        for i = 1, #text do		
            TextY.Text = string.sub(text, 1, i)
            Typewriter_effect:Play()
            wait(0.0001)
                if i == #text then
                    wait(1)
                end
            end
        end


        local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
    local CustomShop = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"))()


    -- Create your tool here
    -- local SantasSack =game:GetObjects(getsynasset("SantasSack.rbxm"))[1]
    -- local char=game.Players.LocalPlayer.Character
    -- local animation=Instance.new("Animation")
    -- animation.Name="thing"
    -- animation.AnimationId="rbxassetid://9982615727"
    -- local track=char.Humanoid.Animator:LoadAnimation(animation)
        
    -- SantasSack.Equipped:Connect(function()
    --     track:Play()
    -- end)
    -- SantasSack.Unequipped:Connect(function()
    --     track:Stop()
    -- end)
    
    -- SantasSack.Activated:Connect(function()
    --     print('clicked')
    
    --     if char:FindFirstChild("SantasSack") then
    --         SantasSack:FindFirstChild("Handle").CanCollide = true
    --         SantasSack:FindFirstChild("Handle").Parent = workspace
            
    --         wait(1)
    --         workspace:FindFirstChild("Handle").Tick:Play()
    --         wait(1)
    --         while task.wait(0.2) do
    --             workspace:FindFirstChild("Handle").Tick.PlaybackSpeed = workspace:FindFirstChild("Handle").Tick.PlaybackSpeed + 0.06
    --             workspace:FindFirstChild("Handle").Tick.Volume = workspace:FindFirstChild("Handle").Tick.Volume +  0.06
    --         end
            
    --         workspace:FindFirstChild("Handle").Tick.Ended:Connect(function()
    --             wait(1)
    --             local Explosion = Instance.new("Explosion")
    --             Explosion.Parent = workspace
    --             Explosion.Position = workspace:FindFirstChild("Handle").Position
                
    --             workspace:FindFirstChild("Handle").explosion:Play()
    --             workspace:FindFirstChild("Handle").explosion.Volume = 8
    --             local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
    --             local camara = game.Workspace.CurrentCamera
    --             local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
    --             camara.CFrame = camara.CFrame * shakeCf
    --             end)
    --             camShake:Start()

    --             camShake:ShakeOnce(15,50,1,0.2)
    --         end)
    --         -- workspace:FindFirstChild("Handle").Position = char:WaitForChild("RightHand").Position
    --     end
    -- end)
    -- Create custom shop item
    -- CustomShop.CreateItem(SantasSack, {
    --     Title = "Santas Ball Sack!??",
    --     Desc = "Stay away from it kids..",
    --     Image = "https://i.pinimg.com/originals/05/5b/a9/055ba99aaffbabe3b1387376a77aff76.png",
    --     Price = "1 Quadrillion",
    --     Stack = 1,
    -- })


    local inPrompt = false
    local MiniSanta = game:GetObjects("rbxassetid://11790626263")[1]
    local Prompt = game:GetObjects("rbxassetid://11790629155")[1]
    
    MiniSanta.Parent = game:GetService("Workspace").CurrentRooms["0"].Assets
    MiniSanta:FindFirstChild("RootPart").CFrame = game:GetService("Workspace").CurrentRooms["0"].Assets["Desk_Bell"].Base.CFrame * CFrame.new(1.6,0,0)
    Prompt.Parent = MiniSanta
    

    Prompt.Triggered:Connect(function()
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

        local BodyPosition = Instance.new("BodyPosition", MiniSanta:FindFirstChild("RootPart"))

        game:GetService("Debris"):AddItem(Prompt, 0)
        inPrompt = true
        game:GetService("TweenService"):Create(BorderTop, TweenInfo.new(0.24, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(0,0,0,0)}):Play()
        game:GetService("TweenService"):Create(BorderBottom, TweenInfo.new(0.24, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0,0.833, 0)}):Play()
        wait(1.6)
        addSceneText("Why Hello, Large Human!")
        addSceneText("I See you've been good for Christmas!")
        addSceneText("Heres x100 Vitamins!")
        local Vitamins = game:GetObjects("rbxassetid://11790631352")[1]
        local idle = Vitamins.Animations:FindFirstChild("idle")
        local open = Vitamins.Animations:FindFirstChild("open")
    
        local tweenService = game:GetService("TweenService")
    
        local sound_open = Vitamins.Handle:FindFirstChild("sound_open")
    
        local hum = char:WaitForChild("Humanoid")
    
        local idleTrack = hum.Animator:LoadAnimation(idle)
        local openTrack = hum.Animator:LoadAnimation(open)
    
        local Durability = 35
        local InTrans = false
        local Duration = 10
    
        local xUsed = 100
    
    
    
    
    
    
    
    
        wait(1)
        addSceneText("Enjoy!!")
        game.TweenService:Create(TextY, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
        game.TweenService:Create(TextY, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextStrokeTransparency = 1}):Play()
        game:GetService("TweenService"):Create(BorderTop, TweenInfo.new(0.24, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(0,0,1,0)}):Play()
        game:GetService("TweenService"):Create(BorderBottom, TweenInfo.new(0.24, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0,-0.184, 0)}):Play()
        inPrompt = false
        function AddDurability()
            

            InTrans = true
            wait(Duration)
            InTrans = false

    
        end

    
        function SetupVitamins()
            Vitamins.Parent = game.Players.LocalPlayer.Backpack
            Vitamins.Name = "FakeVitamins"
    
            for slotNum, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool.Name == "FakeVitamins" then
                    local slot =game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI").MainFrame:FindFirstChild("Hotbar")[slotNum]
                    -- while task.wait() do
                    --     slot.DurabilityNumber.Text = "x"..xUsed
                    -- end
                    -- slot.DurabilityNumber.Text = "x"..xUsed
                        game:GetService("RunService").RenderStepped:Connect(function()
                            slot.DurabilityNumber.Visible = true
                            slot.DurabilityNumber.Text = "x"..xUsed
                        end)
    
                    Vitamins.Unequipped:Connect(function()
                        slot.DurabilityNumber.Visible = true
                        slot.DurabilityNumber.Text = "x"..xUsed
                    end)
    
                    Vitamins.Equipped:Connect(function()
                        slot.DurabilityNumber.Visible = true
                    end)
    
                    Vitamins.Activated:Connect(function()
                        if not InTrans and xUsed > 0 then
                            humanoid:SetAttribute("SpeedBoost", 25)
                            xUsed = xUsed - 1
                            slot.DurabilityNumber.Visible = true
                            slot.DurabilityNumber.Text = "x"..xUsed
                            openTrack:Play()
                            sound_open:Play()
                    
                            AddDurability()

                            if xUsed == 0 then
                                Vitamins:Remove()
                            end
                        end
                    end)
                end
            end
    
    
    
    
            Vitamins.Equipped:Connect(function()
                idleTrack:Play()
            end)
    
    
            Vitamins.Unequipped:Connect(function()
                idleTrack:Stop()
    
            end)
        end
    
        SetupVitamins()
    
        function AddLoop()
            while task.wait() do
                if InTrans then
                    wait()
                    print'in trans'
                    hum.WalkSpeed = Durability
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    
        while task.wait() do
            AddLoop()
        end
    
        while task.wait() do
            if inPrompt then
                humanoid.WalkSpeed = 0
            end
        end

    end)

        CreateNotification("Script Loaded! Script made by Zepsyy#1111")
