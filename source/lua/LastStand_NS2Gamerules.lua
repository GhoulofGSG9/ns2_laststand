local kRoundSecs = kRoundTime
local kNumSecondsPerWave = kWaveTime
local kPreGameLength = kPrepareTime
local oldWave = 0

if Server then
    --noinspection GlobalCreationOutsideO
    gGameEventListeners = {}

    local OldSetGameState =  NS2Gamerules.SetGameState
    function NS2Gamerules:SetGameState(state)
        if state ~= self.gameState then
        
            self.gameState = state
            self.gameInfo:SetState(state)
            self.timeGameStateChanged = Shared.GetTime()
            self.timeSinceGameStateChanged = 0

            if self.gameState == kGameState.Started then

                DestroyLiveMapEntities()

                PostGameViz("Game started")
                self.gameStartTime = Shared.GetTime()
                
                self.gameInfo:SetStartTime(self.gameStartTime)
                
                -- signal all the equipment piles
                -- we should really have an event system here..
                for _, listener in ipairs(gGameEventListeners) do
                    if listener.OnGameStart then
                        listener:OnGameStart()
                    end
                end

            elseif state == kGameState.PreGame then
                
                for _, listener in ipairs(gGameEventListeners) do
                    if listener.OnPreGameStart then
                        listener:OnPreGameStart()
                    end
                end

                --Reset all aliens
                local aliens = self.team2:GetPlayers()
                for i = 1, #aliens do
                    self.team2:ReplaceRespawnPlayer(aliens[i], nil, nil)
                end

                for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                    player:SetResources(kStartingRes)
                end
                
            else
                OldSetGameState( self, state )
            end
            self:SendTimeLeft()
        end
    end

    function NS2Gamerules:ResetGame()

        StatsUI_ResetStats()

        TournamentModeOnReset()
        
        -- Destroy any map entities that are still around
        DestroyLiveMapEntities()
        
        -- Track which clients have joined teams so we don't
        -- give them starting resources again if they switch teams
        self.userIdsInGame = {}
        
        self:SetGameState(kGameState.NotStarted)
        
        self.lsPreGameSecsLeft = self:GetPregameLength()
        
        -- Reset all players, delete other not map entities that were created during
        -- the game (hives, command structures, initial resource towers, etc)
        -- We need to convert the EntityList to a table since we are destroying entities
        -- within the EntityList here.
        for _, entity in ientitylist(Shared.GetEntitiesWithClassname("Entity")) do
        
            -- Don't reset/delete NS2Gamerules or TeamInfo.
            -- NOTE!!!
            -- MapBlips are destroyed by their owner which has the MapBlipMixin.
            -- There is a problem with how this reset code works currently. A map entity such as a Hive creates
            -- it's MapBlip when it is first created. Before the entity:isa("MapBlip") condition was added, all MapBlips
            -- would be destroyed on map reset including those owned by map entities. The map entity Hive would still reference
            -- it's original MapBlip and this would cause problems as that MapBlip was long destroyed. The right solution
            -- is to destroy ALL entities when a game ends and then recreate the map entities fresh from the map data
            -- at the start of the next game, including the NS2Gamerules. This is how a map transition would have to work anyway.
            -- Do not destroy any entity that has a parent. The entity will be destroyed when the parent is destroyed or
            -- when the owner manually destroyes the entity.
            local shieldTypes = { "GameInfo", "MapBlip", "NS2Gamerules", "PlayerInfoEntity" }
            local allowDestruction = true
            for i = 1, #shieldTypes do
                allowDestruction = allowDestruction and not entity:isa(shieldTypes[i])
            end
            
            if allowDestruction and entity:GetParent() == nil then
                
                -- Reset all map entities and all player's that have a valid Client (not ragdolled players for example).
                local resetEntity = entity:isa("TeamInfo") or entity:GetIsMapEntity() or (entity:isa("Player") and entity:GetClient() ~= nil)
                if resetEntity then
                
                    if entity.Reset then
                        entity:Reset()
                    end
                    
                else
                    DestroyEntity(entity)
                end
                
            end
            
        end
        
        -- Clear out obstacles from the navmesh before we start repopualating the scene
        RemoveAllObstacles()
        
        self.worldTeam:ResetPreservePlayers()
        self.spectatorTeam:ResetPreservePlayers()
        
        self.team1:ResetPreservePlayers()
        self.team2:ResetPreservePlayers()
        
        -- Replace players with their starting classes with default loadouts at spawn locations
        self.team1:ReplaceRespawnAllPlayers()
        self.team2:ReplaceRespawnAllPlayers()
        
        self.team1:ResetTeam()
        self.team2:ResetTeam()
        
        -- Create living map entities fresh
        CreateLiveMapEntities()
        
        self.forceGameStart = false
        self.losingTeam = nil
        self.preventGameEnd = nil
        
        -- Send scoreboard and tech node update, ignoring other scoreboard updates (clearscores resets everything)
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            Server.SendCommand(player, "onresetgame")
            player.sendTechTreeBase = true
            player:SetResources(kStartingRes)
        end
        
        self.team1:OnResetComplete()
        self.team2:OnResetComplete()

        StatsUI_InitializeTeamStatsAndTechPoints(self)
    end

    function NS2Gamerules:OnUpdate(timePassed)
    
        PROFILE("NS2Gamerules:OnUpdate")

        if Server then

            if self.justCreated then
            
                if not self.gameStarted then
                    self:ResetGame()
                end
                
                self.justCreated = false
                
            end
            
            if self:GetMapLoaded() then
                self:CheckGameStart(timePassed)
                self:CheckGameEnd()
                
                self:UpdateToReadyRoom()
                self:UpdateMapCycle()
                self:ServerAgeCheck()
                
                self.timeSinceGameStateChanged = self.timeSinceGameStateChanged + timePassed
                
                self.worldTeam:Update(timePassed)
                self.team1:Update(timePassed)
                self.team2:Update(timePassed)
                self.spectatorTeam:Update(timePassed)
                
                -- Send scores every so often
                self:UpdatePings()
                self:UpdateHealth()
 
                self:UpdatePlayerSkill()
                self:UpdateNumPlayersForScoreboard()
                self:SendTimeLeft()
                
            end

            self:UpdateWave()
            self:UpdateSounds(timePassed)
            
        end
        
    end

    function NS2Gamerules:CheckGameStart(dt)
        if self:GetGameState() == kGameState.NotStarted then
            if self.team1:GetNumPlayers() > 0 and self.team2:GetNumPlayers() > 0 or Shared.GetCheatsEnabled() then
                self:SetGameState(kGameState.PreGame)
            elseif self.team1:GetNumPlayers() > 0 then
                if not self.nextGameStartMessageTime or Shared.GetTime() > self.nextGameStartMessageTime then
                    SendTeamMessage(self.team1, kTeamMessageTypes.NoCommander) --waiting for aliens
                    self.nextGameStartMessageTime = Shared.GetTime() + 10
                end
            end
        elseif self:GetGameState() == kGameState.PreGame then
            self.lsPreGameSecsLeft = math.max(self.lsPreGameSecsLeft - dt, 0)
            if math.ceil(self.lsPreGameSecsLeft) == 3 then
                self.worldTeam:PlayPrivateTeamSound(NS2Gamerules.kCountdownSound)
                self.team1:PlayPrivateTeamSound(NS2Gamerules.kCountdownSound)
                self.team2:PlayPrivateTeamSound(NS2Gamerules.kCountdownSound)
                self.spectatorTeam:PlayPrivateTeamSound(NS2Gamerules.kCountdownSound)
            end

            if self.lsPreGameSecsLeft <= 0 then
                self:SetGameState(kGameState.Started)
                self:SpawnAllDeadAlien()
                self.playerRanking:StartGame()
                self.preventGameEnd = true
            end

        end
        
    end

    function NS2Gamerules:CheckGameEnd()

        PROFILE("NS2Gamerules:CheckGameEnd")

        if self:GetGameStarted() then
            local marinesLeft = self.team1:GetNumAlivePlayers()
            if self.marinesLeft ~= marinesLeft then
                self.gameInfo:SetNumMarinesLeft( marinesLeft )
                self.marinesLeft = marinesLeft
            end

            --don't end the game with cheats enabled
            if not Shared.GetCheatsEnabled() then
                if self.marinesLeft == 0 then

                    -- all marines gone, lose
                    self:EndGame(self.team2)

                elseif self.gameStartTime + kRoundSecs <= Shared.GetTime() then

                    -- marines survived the time - win!
                    self:EndGame(self.team1)

                end
            end
        end

    end

    function NS2Gamerules:SetRoundLength(time)
        kRoundSecs = time
    end
    
    function NS2Gamerules:GetRoundLength()
        return kRoundSecs
    end
    
    function NS2Gamerules:SendTimeLeft()
        self.gameInfo:SetGameTimeLeft(self:GetTimeLeft())
    end

    function NS2Gamerules:GetTimeLeft()
        if self.gameState == kGameState.Started then
            return self.gameStartTime + kRoundSecs - Shared.GetTime()
        elseif self.gameState == kGameState.PreGame then
            return self.timeGameStateChanged + kPreGameLength - Shared.GetTime()
        else
            return 0
        end
    end

    function NS2Gamerules:GetCanJoinTeamNumber(player, teamNumber)
        local forceEvenTeams = Server.GetConfigSetting("force_even_teams_on_join", true)

        if forceEvenTeams then

            local team1Players = self.team1:GetNumPlayers()
            local team2Players = self.team2:GetNumPlayers()

            if (team1Players > team2Players) and (teamNumber == self.team1:GetTeamNumber()) then
                return false
            elseif (team2Players > team1Players) and (teamNumber == self.team2:GetTeamNumber()) then
                return false
            end

        end

        return true
    end

    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)

        local client = Server.GetOwner(player)
        if not client then return end

        if newTeamNumber ~= kSpectatorIndex and not self:GetCanJoinPlayingTeam(player) then
            return false
        end

        if not force and not self:GetCanJoinTeamNumber(player, newTeamNumber) then
            return false
        end

        local success = false
        local newPlayer

        local oldPlayerWasSpectating = client and client:GetSpectatingPlayer()
        local oldTeamNumber = player:GetTeamNumber()

        -- Join new team
        if oldTeamNumber ~= newTeamNumber or force then

            if not Shared.GetCheatsEnabled() and self:GetGameStarted() and newTeamNumber ~= kTeamReadyRoom then
                player.spawnBlockTime = Shared.GetTime() + kSuicideDelay
            end

            local team = self:GetTeam(newTeamNumber)
            local oldTeam = self:GetTeam(oldTeamNumber)

            -- Remove the player from the old queue if they happen to be in one
            if oldTeam then
                oldTeam:RemovePlayerFromRespawnQueue(player)
            end

            -- Spawn immediately if going to ready room, game hasn't started, cheats on, or game started recently
            if newTeamNumber == kTeamReadyRoom then

                newPlayer = player:Replace(LastStand_ReadyRoomPlayer.kMapName, newTeamNumber)
                success = true

            elseif self:GetCanSpawnImmediately() or force then

                success,newPlayer = team:ReplaceRespawnPlayer(player, nil, nil)

            else

                -- Destroy the existing player and create a spectator in their place.
                newPlayer = player:Replace(team:GetSpectatorMapName(), newTeamNumber)

                -- Queue up the spectator for respawn.
                team:PutPlayerInRespawnQueue(newPlayer)

                success = true

            end

            local clientUserId = client:GetUserId()
            --Save old pres
            if oldTeam == self.team1 or oldTeam == self.team2 then
                if not self.clientpres[clientUserId] then self.clientpres[clientUserId] = {} end
                self.clientpres[clientUserId][oldTeamNumber] = player:GetResources()
            end

            -- Update frozen state of player based on the game state and player team.
            if team == self.team1 or team == self.team2 then

                local devMode = Shared.GetDevMode()
                local inCountdown = self:GetGameState() == kGameState.Countdown
                if not devMode and inCountdown then
                    newPlayer.frozen = true
                end

                local pres = self.clientpres[clientUserId] and self.clientpres[clientUserId][newTeamNumber]
                newPlayer:SetResources( pres or ConditionalValue(team == self.team1, kMarineInitialIndivRes, kAlienInitialIndivRes) )

            else

                -- Ready room or spectator players should never be frozen
                newPlayer.frozen = false

            end


            newPlayer:TriggerEffects("join_team")

            if success then

                local newPlayerClient = Server.GetOwner(newPlayer)
                if oldPlayerWasSpectating then
                    newPlayerClient:SetSpectatingPlayer(nil)
                end

                if newPlayer.OnJoinTeam then
                    newPlayer:OnJoinTeam()
                end

                if newTeamNumber == kTeam1Index or newTeamNumber == kTeam2Index then
                    self.playerRanking:SetEntranceTime( newPlayer, newTeamNumber )  --Hive2 added team param
                elseif oldTeamNumber == kTeam1Index or oldTeamNumber == kTeam2Index then
                    self.playerRanking:SetExitTime( newPlayer, oldTeamNumber ) --Hive2 added team param
                end

                if newTeamNumber == kSpectatorIndex then
                    newPlayer:SetSpectatorMode(kSpectatorMode.Overhead)

                    -- add player to list of spectators if there are spectator lots available
                    local numSpecs = Server.GetNumSpectators()
                    if numSpecs < Server.GetMaxSpectators() and newPlayer:GetIsSpectator() == false then
                        newPlayer:SetIsSpectator(true)
                    end
                else
                    --remove player from spectator list
                    if newPlayer:GetIsSpectator() then
                        newPlayer:SetIsSpectator(false)
                    end
                end

                Server.SendNetworkMessage(newPlayerClient, "SetClientTeamNumber", { teamNumber = newPlayer:GetTeamNumber() }, true)

                self.botTeamController:UpdateBots()
            end

            return success, newPlayer

        end

        -- Return old player
        return success, player

    end

    function NS2Gamerules:GetNumMarinePlayers()
        return self.team1:GetNumPlayers()
    end

    function NS2Gamerules:GetMarineBase()
    end

    function NS2Gamerules:SetPreGameLength(length)
        kPreGameLength = length
    end
    
    function NS2Gamerules:GetPregameLength()
        return Shared.GetCheatsEnabled() and 0 or kPreGameLength
    end

    function NS2Gamerules:SetNumSecondsPerWave(length)
        kNumSecondsPerWave = length
    end
    
    function NS2Gamerules:GetRoundFraction()
        return ConditionalValue(self:GetGameStarted(), (Shared.GetTime() - self:GetGameStartTime()) / kRoundSecs , 0)
    end

    function NS2Gamerules_GetUpgradedDamageScalar( attacker )

        if attacker:GetTeamNumber() == kMarineTeamType then
            return kWeapons3DamageScalar
        end

        return 1.0

    end
    
    function NS2Gamerules:UpdateSounds( dt )
        if self.gameState == kGameState.Started then
            if self:GetTimeLeft() < 30 and not self.roundEndMusicPlayed then
                self.worldTeam:PlayPrivateTeamSound(kCommonSounds.RoundEndMusic)
                self.team1:PlayPrivateTeamSound(kCommonSounds.RoundEndMusic)
                self.team2:PlayPrivateTeamSound(kCommonSounds.RoundEndMusic)
                self.spectatorTeam:PlayPrivateTeamSound(kCommonSounds.RoundEndMusic)

                self.roundEndMusicPlayed = true
                self.stopMusicTimer = 2
            end        
        else
            if self.roundEndMusicPlayed then
                self.stopMusicTimer = self.stopMusicTimer - dt
                if self.stopMusicTimer <= 0 then                    
                    Shared.StopSound(nil, kCommonSounds.RoundEndMusic)
                    self.roundEndMusicPlayed = false
                end    
            end
        end
    end

    function NS2Gamerules:SpawnAllDeadAlien()
        for _, player in ientitylist(Shared.GetEntitiesWithClassname("AlienSpectator")) do
            player:SpawnPlayer()
        end
    end

    function NS2Gamerules:UpdateWave()
        if self.gameState == kGameState.Started then
            local numWaves = math.ceil(self:GetRoundLength() / kNumSecondsPerWave)
            local waveFraction = self:GetRoundLength() / numWaves
            local wave = numWaves - math.ceil(self:GetTimeLeft() / waveFraction)
            self.gameInfo:SetWave(wave)
            if oldWave ~= wave then
                for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
                    player:AddResources(kResPerWave)
                end

                self:SpawnAllDeadAlien()

                if wave % 3 == 0 then
                    for _, pile in ientitylist(Shared.GetEntitiesWithClassname("EquipPile")) do
                        pile:SpewCat()
                    end
                end

                oldWave = wave
            end
        end
    end

    --Bots are not working with Last Stand
    function NS2Gamerules:SetMaxBots(newMax,com)
    end
end