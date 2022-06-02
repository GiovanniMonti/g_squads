local squadInfo = squadInfo or {}

net.Receive( "gsquads::updateInfo", function()
    // ClearClient uses same netstring but only clears the table.

    if net.ReadBool() == false then 
        squadInfo = {} 
        return 
    end

    //UpdateCient
    squadInfo.Name      =   net.ReadString()
    squadInfo.Kills     =   net.ReadUInt( 16 )
    squadInfo.Deaths    =   net.ReadUInt( 16 )
    squadInfo.Faction   =   net.ReadUInt( 8 )
    squadInfo.Commander =   net.ReadUInt( 8 )
    local MemberCount   =   net.ReadUInt( 8 )
    squadInfo.Members = {}

    for i = 1, MemberCount do
        table.insert( squadInfo.Members, i, net.ReadString() )
    end
    PrintTable(squadInfo)

end)

net.Receive( "gsquads::parUpdateInfo", function()
    squadInfo.Kills     =   net.ReadUInt( 16 )
    squadInfo.Deaths    =   net.ReadUInt( 16 )
end)

local w,h = ScrW(), ScrH()
local leftGap, topGap = w / 384, h / 216

local function GsquadsHUD()
    surface.SetTextColor(209, 209, 209)
    surface.SetDrawColor( 255,255,255)
    surface.SetFont( 'Trebuchet18' )
    surface.SetTextPos(leftGap, topGap)
    surface.DrawText( squadInfo.Name .. ' Squad:')

    local textW = topGap
    for k, name in ipairs(squadInfo.Members) do

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

-- wish this could be above
net.Receive( "gsquads::openhud", function()
    if net.ReadBool() then 
        hook.Add( 'HUDPaint', "HUDPaint_Gsquads", GsquadsHUD )
    else
        hook.Remove( 'HUDPaint', "HUDPaint_Gsquads" )
    end
end)