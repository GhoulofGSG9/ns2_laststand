--[[
	Author: Sebastian Schuck( ghoulofgsg9@gmail.com )
	
	We need to expand the GameInfo a bit to network the for Last Stand important gamerules values
]]

function GameInfo:GetNumMarinesLeft()
	return self.lsNumMarinesLeft
end

function GameInfo:GetWave()
	return self.lsWave + 1
end

function GameInfo:GetGameTimeLeft()
	return self.timeLeft
end

if Server then

	function GameInfo:SetNumMarinesLeft( marinesLeft )
		self.lsNumMarinesLeft = marinesLeft
	end

    function GameInfo:SetWave( wave )
		self.lsWave = wave
	end

    function GameInfo:SetGameTimeLeft( time )
        self.timeLeft = time
    end

end

local networkVars = 
{
    lsNumMarinesLeft = "integer (0 to 255)",
    lsWave = "integer (0 to 255)",
    timeLeft = "time"
}
Class_Reload( "GameInfo", networkVars )