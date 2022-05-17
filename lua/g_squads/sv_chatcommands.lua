local commandprefix = '/squad'
local ChatCommands = {}

ChatCommands.create = function(ply,text)
    local args = string.Explode( ' ', text)
    if #args < 1 then return false end
    if not gsquads.Squads.CanCreate(ply) then
        ply:ChatPrint('You cannot create a squad at this time.')
        return ''
    end

    gsquads.Squads:CreateNew(ply)
    return ''
end

--TODO do this
ChatCommands.join = function(ply,text)
    local args = string.Explode( ' ', text)

    -- local comander = findByName(args[1]) 
    -- local squadJoiing = getSquadbyLeader(comander)

    if #args < 1 then return false end
    if not gsquads.Squads.CanJoin(ply,) then
        ply:ChatPrint('You cannot join this squad at this time.')
        return ''
    end
    
    gsquads.Squads.list[ ply:GetNWInt(cursquad) ] - ply

    return ''
end

--? decide how to leave a squad, doesnt work atm
ChatCommands.leave = function(ply,text)
    --local args = string.Explode( ' ', text)

    local cursquad =  ply:GetNWInt('gsquads::squad')

    if not cursquad or cursquad == 0 then 
        ply:ChatPrint('You are not in squad.')
        return false
    end
    gsquads.Squads.list[ ply:GetNWInt(cursquad) ] - ply

    return ''
end

hook.Add('PlayerSay','gsquads::PlayerSay',function(ply,text_o,tmch)
    text = text_o
    if not string.StartWith( text, commandprefix ) then return end
    text = string.TrimLeft(text,commandprefix)
    
    for k,fnc in ipairs(ChatCommands) do
        if string.StartWith(text,k) then
            return (fnc( ply, string.TrimLeft(text,k) ) or text_o)
        end
    end
end)