local function ForEachUpValue( Func, Filter, Recursive, Done )
	local i = 1
	Done = Done or {}
	if Done[ Func ] then return nil end

	Done[ Func ] = true

	while true do
		local N, Val = debug.getupvalue( Func, i )
		if not N then break end

		if Filter( Func, N, Val, i ) then
			return Val, i, Func
		end

		if Recursive and not Done[ Val ] and type( Val ) == "function" then
			local LowerVal, j, Function = ForEachUpValue( Val, Filter, true, Done )
			if LowerVal ~= nil then
				return LowerVal, j, Function
			end
		end

		i = i + 1
	end
end

function GetUpValue( Func, Name, Recursive )
	return ForEachUpValue( Func, function( Function, N, Val, i )
		return N == Name
	end, Recursive )
end

function SetUpValue( Func, Name, Value, Recursive )
	local OldValue, Index, Function = GetUpValue( Func, Name, Recursive )

	if not Index then return nil end

	debug.setupvalue( Function, Index, Value )

	return OldValue
end
