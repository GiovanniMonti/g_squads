// this addon is for darkrp
if not DarkRP then return end
gsquads = gsquads or {}
if SERVER then
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