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
    
    hook.Run('Gsquads_SquadJoin', self , ply )

    return self.Members
end

-- remove player from squad
function squad_prototype:Leave(ply)
    if not IsEntity(ply) or not ply:IsPlayer() then return end
    if ply == self.Commander then return false end
    table.RemoveByValue( self.Members, ply )
    if #self.Members == 2 then self.Comander = 1 end
    return true
end

 -- delete the squad
function squad_prototype:Delete()
    for _,v in self.Members do
        v:SetNWInt('gsquads::squad',0)
    end
    -- for other stuff later in the script
    hook.Run('Gsquads_PreSquadDelete',self)
end

function gsquads.Squads.CreateNew(creator)
    if gsquads.Squads.Config.squad_Maxnum <= gsquads.Squads.Count or not gsquads.Squads.CanCreate(creator) then return false end

    local newsquad = {
        Name = ''
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
    -- todo set squad name
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

function gsquads.Squads.UpdateClient(ply)
    local sqd = gsquads.Squads.GetCurSquad(ply)
    net.Start("gsquads::openhud")
    net.WriteString()
    net.Send(ply)

util.AddNetworkString("gsquads::openhud")
hool.Add("Gsquads_SquadJoin",function(sqd,ply)

    if not gsquads.Squads.Config.EnableHUD then
        return
    end

    
    
end)