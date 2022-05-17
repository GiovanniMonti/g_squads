// this addon is for darkrp
if not DarkRP then return end
gsquads = gsquads or {}


local function loadExtraFunctions()
    function gsquads.IsPlyNick( nick )
        for _, v in pairs( player.GetAll() ) do
            
            if string.find( string.lower( v:Nick() ), string.lower( nick ), 1, true ) then return v end
            if (v:SteamID64() == nick) or (v:SteamID() == nick) then return v end
            
        end
        return false
    end
end

if SERVER then

    loadExtraFunctions()

    include("g_squads/sv_factions.lua")
    include("g_squads/sv_squads.lua")
    include("g_squads/sv_chatcommands.lua")
    print([[
    ---------------------------------\n
    ---------------------------------\n
                GSquads 1.0          \n
    ------------ Loaded sv ----------\n
    ---------------------------------\n
    ]])
end

if CLIENT then
    include("g_squads/cl_squads.lua")
    print([[
    ---------------------------------\n
    ---------------------------------\n
                GSquads 1.0          \n
    ------------ Loaded cl ----------\n
    ---------------------------------\n
    ]])
end