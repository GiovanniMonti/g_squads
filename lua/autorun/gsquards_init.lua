// this addon is for darkrp
hook.Add('loadCustomDarkRPItems','gsquads_factions::postCustomDrp', function()

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
        gsquads.Factions = gsquads.Factions or {}
        include("g_squads/sv_factions.lua")

        gsquads.Squads = gsquads.Squads or {}
        include("g_squads/sv_squads.lua")
        
        include("g_squads/sv_chatcommands.lua")

        AddCSLuaFile("g_squads/cl_squads.lua")
        print([[
        ---------------------------------
        ---------------------------------
                    GSquads 1.0          
        ------------ Loaded sv ----------
        ---------------------------------
        ]])
    end

    if CLIENT then
        include("g_squads/cl_squads.lua")
        print([[
        ---------------------------------
        ---------------------------------
                    GSquads 1.0          
        ------------ Loaded cl ----------
        ---------------------------------
        ]])
    end

end)