include('config/squads_config.lua')

gsquads.Squads.Count = 0
gsquads.Squads.list = {}

local squad_prototype = {}
squad_prototype.__index = squad_prototype

-- add new player to squad
function squad_prototype:Join(ply)
    if not ply:IsPlayer() then return end
        
    if table.HasValue( self.Members, ply ) then
        ply:ChatPrint('You are already in this squad!')
        return false
    end

    if not gsquads.Squads.CanJoin(ply,self) then
        ply:ChatPrint('You cannot join this squad at this time.')
        return false
    end

    if not table.insert( self.Members, ply ) then return false end

    ply:SetNWInt('gsquads::squad',self.id)

    return self.Members
end

-- remove player from squad
function squad_prototype:Leave(ply)
    if ply == self.Commander then return false end
    table.RemoveByValue( self.Members, ply )
    ply:SetNWInt('gsquads::squad',0)
    if #self.Members == 1 then
        self.Commander = 1
    end
    return true
end

 -- delete the squad
function squad_prototype:Delete()
    if #self.Members > 0 then
        for _,v in self.Members do
            v:SetNWInt('gsquads::squad',0)
        end
    end
    -- for other stuff later in the script
    hook.Run('Gsquads_PreSquadDelete',self)
end

function gsquads.Squads.CreateNew(creator)
    if gsquads.Squads.Config.squad_Maxnum <= gsquads.Squads.Count or not gsquads.Squads.CanCreate(creator) then return false end

    local newsquad = {
        Members = {},
        Commander = 1, -- indx of commander in members table
        Kills = 0,
        Deaths = 0,
        Faction = 0,
        id = 0,
    }
    setmetatable( newsquad, squad_prototype )
    newsquad.Faction = gsquads.Factions.GetFaction(creator:Team())
    newsquad.id = table.insert( gsquads.Squads.list, newsquad )

    if not newsquad.id then
        print('GSQUADS : CRITICAL ERROR IN SQUAD CREATION')
    end
    newsquad:Join( creator ) -- adds creator into squad (commander by default)

    gsquads.Squads.Count = gsquads.Squads.Count + 1

    --creator:SetNWInt('gsquads::squad',newsquad.id)
    return newsquad
end

-- action permission checks here
function gsquads.Squads.CanCreate(ply)
    if ply:GetNWInt('gsquads::squad',0) ~= 0 then return false end
    if not gsquads.Squads.Config.CustomCanCreate(ply) then return false end
    return true
end

function gsquads.Squads.CanJoin(ply,squad)
    if gsquads.Factions.Config.Toggle and gsquads.Factions.jobsToFaction[ply:Team()] ~= squad.Faction then return false end
    if not gsquads.Squads.Config.CustomCanJoin( squad, ply ) then return false end
    return true
end

function gsquads.Squads:GetSquadbyCmnd(cmnd)
    if not cmnd then return false end
    local cmnd_squad = cmnd:GetNWInt("gsquads::squad",false)
    if not cmnd_squad then return false end
    return self.list[cmnd_squad]
end

function gsquads.Squads.GetCurSquad(ply)
    local indx = ply:GetNWInt("gsquads::squad",false)
    if not indx then return false end
    return gsquads.Squads.list[ indx ]
end

hook.Add("PlayerDeath", "Gsquads::plydeath", function( victim, _, attacker )
    local vicsquad = gsquads.Squads.GetCurSquad(victim)
    local attsquad = gsquads.Squads.GetCurSquad(attacker)
    if vicsquad then
        vicsquad.Deaths = vicsquad.Deaths + 1
    end
    if attsquad and ( gsquads.Squads.Config.count_teamkill or attsquad ~= vicsquad) then
        attsquad.Kills = attsquad.Kills + 1
    end
end)