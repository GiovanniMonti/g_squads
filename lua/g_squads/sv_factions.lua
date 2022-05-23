gsquads.Factions.list = gsquads.Factions.list or { [ 1 ] = {
    Name = 'No Faction',
    TeamsTable = nil, 
    FactionCol = Color(0,0,0)
} }

gsquads.Factions.jobsToFaction = gsquads.Factions.jobsToFaction or { TEAM_CONNECTING = 1, TEAM_UNASSIGNED = 1 }

function gsquads.Factions:CreateNew( name, WhitelistTeams, Tcolor )
    if not name then return false end
    Tcolor = Tcolor or Color(255,255,255)
    local idx = table.insert( self.list, {
        Name = name,
        TeamsTable = WhitelistTeams,
        FactionCol = Tcolor
    } )
    if not idx then print('GSQUADS : ERROR IN FACTIONS GENERATION : ' .. name .. ' IS FUCKED') return false end
    for _, v in pairs(WhitelistTeams) do table.insert( self.jobsToFaction, v, idx) end
    return idx
end

function gsquads.Factions.GetTable(idx)
    if not isnumber(idx) then return false end
    return gsquads.Factions.list[idx]
end

function gsquads.Factions.GetFaction(job)
    if not isnumber(job) or not RPExtraTeams[job] then return false end
    return gsquads.Factions.jobsToFaction[job] or 0
end

hook.Add('loadCustomDarkRPItems','gsquads_factions::postCustomDrp',function()
    include('config/factions_config.lua')
end)

hook.Add('PlayerChangedTeam','gsquads::PlayerChangedTeam',function(ply,oteam,nteam)
    local ofac = gsquads.Factions.GetFaction(oteam) or 0
    local nfac = gsquads.Factions.GetFaction(nteam)
    if not nfac or ofac == nfac then return end
    -- hook into here for custom prints and such
    hook.Run('GsquadsPlayerChangedFaction', ply, ofac, nfac) 
end)