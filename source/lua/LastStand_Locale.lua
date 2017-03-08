local StringFormat = string.format

local LastStandLocale = {}

LastStandLocale.Strings = {}
LastStandLocale.Sources = {}

Locale.DefaultLanguage = "enUS"

-- Get all available locale files now, so we don't keep trying to open them later.
local LangFiles = {}
Shared.GetMatchingFileNames( "locale/LastStand/*.json", false, LangFiles )

local LangLookup = {}
for i = 1, #LangFiles do
	LangLookup[ LangFiles[ i ] ] = true
end

local function ReadFile( Path )
	if not GetFileExists(Path) then
		Shared.Message(string.format("Error: Json file %s could not be found!", Path))
		return
	end

	local file = io.open( Path, "r" )
	local contents = file:read( "*all" )
	file:close()

	return contents
end

local function LoadJSONFile( Path )
	local Data, Err = ReadFile( Path )
	if not Data then
		return false, Err
	end

	return json.decode( Data )
end

function LastStandLocale:ResolveFilePath( Lang )
	return StringFormat( "locale/LastStand/%s.json", Lang )
end

function LastStandLocale:LoadStrings( Lang )
	local Path = self:ResolveFilePath( Lang )
	if not LangLookup[ Path ] then
		return nil
	end

	local LanguageStrings = LoadJSONFile( Path )
	if LanguageStrings then
		self.Strings[ Lang ] = LanguageStrings
	end

	return LanguageStrings
end

function LastStandLocale:GetLanguageStrings( Lang )
	local LoadedStrings = self.Strings[ Lang ]

	if not LoadedStrings then
		LoadedStrings = self:LoadStrings( Lang )
	end

	return LoadedStrings
end

function LastStandLocale:GetLocalisedString( Lang, Key )
	local LanguageStrings = self:GetLanguageStrings( Lang )
	if not LanguageStrings or not LanguageStrings[ Key ] then
		LanguageStrings = self:GetLanguageStrings( self.DefaultLanguage )
	end

	return LanguageStrings and LanguageStrings[ Key ]
end

function LastStandLocale:GetPhrase( Key )
	return self:GetLocalisedString( tostring(Locale.GetLocale()), Key )
end

local oldResolveString = Locale.ResolveString
function Locale.ResolveString( Key )
	return LastStandLocale:GetPhrase( Key ) or oldResolveString( Key )
end

