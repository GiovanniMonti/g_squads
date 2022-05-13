gsquads.Squads = gsquads.Squads or {}
include('config/squads_config.lua')

gsquads.Squads.Count = 0
gsquads.Squads.list = {}

function gsquads.Squads:GetCurSquad(ply)

end

function gsquads.Squads:JoinSquad(ply,squad)

end

function gsquads.Squads:LeaveSquad(ply)

end

function gsquads.Squads:CreateNew(creator)
    if self.Config.squads_Maxnum <= self.Count or self: then return false end
    -- code
    self.Count = self.Count + 1
end