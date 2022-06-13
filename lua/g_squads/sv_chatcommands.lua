local commandprefix = '/squad'
local ChatCommands = ChatCommands or {}
local ComandDescs = ComandDescs or {}

-- creates new squad
ComandDescs.create = 'create : Creates a new squad. [no args]'
ChatCommands.create = function(ply,text)
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

    if squadJoining:Join(ply) then
        ply:ChatPrint('You have joined the squad.')
    end

    return ''
end

--leave current squad
ComandDescs.leave = 'leave : Leaves the current squad. [no args]'
ChatCommands.leave = function(ply,text)
    local cursquad = gsquads.Squads.GetCurSquad(ply)

    if not cursquad then 
        ply:ChatPrint('You are not in a squad.')
        return ''
    end

    if cursquad.Members[cursquad.Commander] == ply then
        for k,pl in pairs(cursquad.Members) do
            if pl ~= ply then
                cursquad.Commander = k
                pl:ChatPrint('You are now the squad leader.')
                break
            end
        end
    end

    cursquad:Leave(ply)
    ply:ChatPrint('You have left the squad.')

    if #cursquad.Members == 0 then
        cursquad:Delete()
    end
    return ''
end

--delete current squad
ComandDescs.delete = 'delete : Deletes the current squad. [no args]'
ChatCommands.delete = function(ply,text)
    local cursquad = gsquads.Squads.GetCurSquad(ply)

    if not cursquad then 
        ply:ChatPrint('You are not in a squad.')
        return ''
    end

    if cursquad.Members[cursquad.Commander] ~= ply then
        ply:ChatPrint('You are not the squad commander.')
        return ''
    end

    for _,pl in pairs(cursquad.Members) do
        ply:ChatPrint('Your squad is being deleted.')
    end
    
    cursquad:Delete()
    
    return ''
end

-- get info about addon's commands
ComandDescs.help = 'help : prints information about all chatcommands in this script. [no args]'
ChatCommands.help = function(ply,_)
    ply:ChatPrint('gSquads chatcommands help : all commands below.')
    for _,v in pairs(ComandDescs) do
        ply:ChatPrint( '\t' .. v )
    end
    return ''
end
-- get info on cursquad
ComandDescs.info = 'info : prints information about the current squad. [no args]'
ChatCommands.info = function(ply,_)
    local squad = gsquads.Squads.GetCurSquad(ply)
    if not squad then ply:ChatPrint('You are not in a squad.') return '' end
    local chpr = ply.ChatPrint
    chpr(ply,'Current squad information :')
    chpr(ply,'\tMembers:')
    for _, pl in pairs(squad.Members) do
        chpr(ply, '\t\t' .. pl:Nick() )
    end
    chpr(ply,'\tCommander: ' .. squad.Members[squad.Commander]:Nick())
    chpr(ply,'\tKills: ' .. squad.Kills)
    chpr(ply,'\tDeaths: ' .. squad.Deaths)
    chpr(ply,'\tFaction [debugging] : '.. squad.Faction)
    chpr(ply,'\tid [debugging] : ' .. squad.id)
    return ''
end

ComandDescs.gui = 'opens the gsquads GUI [no args]'
ChatCommands.gui = function(ply,_)

    net.Start('gsquads::opengui')
    net.Send(ply)

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

