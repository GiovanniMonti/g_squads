gsquads.Squads = gsquads.Squads or {}
include('config/squads_config.lua')

gsquads.Squads.Count = 0
gsquads.Squads.list = {}

local squad_mt = {
    Members = {},
    Commander = 0,-- indx of commander in members table
    Kills = 0,
    Deaths = 0,
    Faction = 0
    id = 0
}
-- add new player to squad
-- gsquads.Squads.list[n] + ply

squad_mt.__add = function(squad, nply)
    if getmetatable(squad) ~= squad_mt then return end
    if not IsEntity(nply) or not nply:IsPlayer() then return end

    table.insert( squad.Members, nply )

    return squad.Members
end
-- remove player from squad
-- gsquads.Squads.list[n] - ply
squad_mt.__sub = function(squad, nply)
    if getmetatable(squad) ~= squad_mt then return end
    if not IsEntity(nply) or not nply:IsPlayer() then return end
    if nply == squad.Commander then return false end

    table.RemoveByValue( squad.Members, nply )
    if #squad.Members<1 then return squad:Delete() end
    return true
end

squad_mt:Delete = function()
    -- delete the squad
end

function gsquads.Squads:CreateNew(creator)
    if self.Config.squads_Maxnum <= self.Count or self: then return false end
    -- checks here

    local newsquad = {}
    setmetatable(newsquad,squad_mt)
    newsquad + creator -- adds creator into squad (commander by default)
    newsquad.Faction = gsquads.Factions.GetFaction(creator:Team())
    self.Count = self.Count + 1
end

function gsquads.Squads:GetCurSquad(ply)
    return ply:GetNWInt('gsquads::squad',0)
end
