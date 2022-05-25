local commandprefix = '/squad'
local ChatCommands = ChatCommands or {}
local ComandDescs = ComandDescs or {}

-- creates new squad
ComandDescs.create = 'create : Creates a new squad. [no args]'
ChatCommands.create = function(ply,text)
    --print('check0')
    if gsquads.Squads.GetCurSquad(ply) then
        ply:ChatPrint('You are already in a squad.')
        return ''
    end

    if not gsquads.Squads.CanCreate(ply) then
        ply:ChatPrint('You cannot create a squad at this time.')
        return ''
    end
    local squad = gsquads.Squads.CreateNew(ply)
    ply:ChatPrint('Created squad.')
    return ''
end
-- join squad. in : commander name
ComandDescs.join = 'join : Joins the selected squad. [name/steamid of squad commander]'
ChatCommands.join = function(ply,text)

    local args = string.Explode( ' ', text)
    if #args < 2 then 
        ply:ChatPrint('Error. command usage : /squad join <commander_name>')
        return '' 
    end

    local comander = gsquads.IsPlyNick( args[1] )
    local squadJoining = gsquads.Squads:GetSquadbyCmnd(comander)

    if not squadJoining then
        ply:ChatPrint('This user is not in a squad or was not found!')
        return ''
    end

    if table.HasValue( squadJoining.list, ply ) then
        ply:ChatPrint('You are already in this squad!')
        return ''
    end

    if not gsquads.Squads.CanJoin(ply,squadJoining) then
        ply:ChatPrint('You cannot join this squad at this time.')
        return ''
    end
    
    squadJoining:Join(ply)

    return ''
end

--leave current squad
ComandDescs.leave = 'leave : Leaves the current squad. [no args]'
ChatCommands.leave = function(ply,text)
    --local args = string.Explode( ' ', text)

    local cursquad = gsquads.Squads.GetCurSquad(ply)
    print(cursquad)
    if not cursquad then 
        ply:ChatPrint('You are not in a squad.')
        return ''
    end

    cursquad:Leave(ply)

    return ''
end
ComandDescs.help = 'help : prints information about all chatcommands in this script. [no args]'
ChatCommands.help = function(ply,_)
    ply:ChatPrint('gSquads chatcommands help : all commands below.')
    for _,v in pairs(ComandDescs) do
        ply:ChatPrint( '\t' .. v )
    end
    return ''
end

local plyCooldowns = plyCooldowns or {}
local cooldown = .200 --ms 
hook.Add('PlayerSay','gsquads::PlayerSay',function(ply,text_o,tmch)
    text = text_o
    if not string.StartWith( text, commandprefix ) then return end
    if plyCooldowns[ply] and CurTime() - plyCooldowns[ply] < cooldown then ply:ChatPrint('Please wait 200ms between comands') return end
    plyCooldowns[ply] = CurTime()

    if text == commandprefix  then
        return ChatCommands.help(ply,'')
    end

    text = string.TrimLeft(text,commandprefix)
    text = string.TrimLeft(text,' ')
    
    for k,fnc in pairs(ChatCommands) do
        if string.StartWith(text,k) then
            return (fnc( ply, string.TrimLeft(text,k) ) or text_o)
        end
    end
end)

