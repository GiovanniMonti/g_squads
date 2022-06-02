local squadInfo = squadInfo or {}

net.Receive( "gsquads::updateInfo", function()
    // ClearClient uses same netstring but only clears the table.
    print('fuck you')

    if net.ReadBool() == false then 
        squadInfo = {} 
        return 
    end

    print('fuck youx2')

    //UpdateCient
    squadInfo.Name      =   net.ReadString()
    squadInfo.Kills     =   net.ReadUInt( 16 )
    squadInfo.Deaths    =   net.ReadUInt( 16 )
    squadInfo.Faction   =   net.ReadUInt( 8 )
    squadInfo.Commander =   net.ReadUInt( 8 )
    local MemberCount   =   net.ReadUInt( 8 )

    for i = 0, MemberCount do
        squadInfo.Members[i] = net.ReadString()
    end
end)

net.Receive( "gsquads::parUpdateInfo", function()
    squadInfo.Kills     =   net.ReadUInt( 16 )
    squadInfo.Deaths    =   net.ReadUInt( 16 )
end)

net.Receive( "gsquads::openhud", function()
    print('Message recieved')
    if net.ReadBool() then 
        hook.Add( 'HUDPaint', "HUDPaint_Gsquads", GsquadsHUD )
        print(1)
    else
        hook.Remove( 'HUDPaint', "HUDPaint_Gsquads" )
    end
end)

-- end of networking.

local w,h = ScrW(), ScrH()
local leftGap, topGap = w / 384, h / 216

local function GsquadsHUD()
    surface.SetTextColor(209, 209, 209)
    surface.SetDrawColor( 255,255,255)
    surface.SetFont( 'Trebuchet18' )
    surface.SetTextPos(leftGap, topGap)
    surface.DrawText( squadInfo.Name .. ' Squad:')

    local textW = topGap
    for k, name in squadInfo.Members do

        surface.SetTextPos(leftGap, textW)
        --todo draw a dot before ply name (texture)
        if k == squadInfo.Commander then
            --todo draw a different icon or smth idk
        end

        surface.DrawText(name)
        textW = textW + topGap
    end
    surface.DrawLine(leftGap, textW , leftGap*16, textW  )
end     
