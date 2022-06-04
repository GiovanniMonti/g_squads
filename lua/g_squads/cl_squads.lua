local squadInfo = squadInfo or {}

net.Receive( "gsquads::updateInfo", function()
    -- ClearClient uses same netstring but only clears the table.

    if net.ReadBool() == false then 
        squadInfo = {} 
        return 
    end

    --UpdateCient
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
local leftGap, topGap = w / 192, h / 216
local dot, crown = Material("dot.png"), Material("crown.png")

local function GsquadsHUD()

    surface.SetTextColor(255, 255, 255)
    surface.SetDrawColor( 255,0,0)
    surface.SetFont( 'Trebuchet18' )
    surface.SetTextPos(leftGap, topGap)
    surface.DrawText( squadInfo.Name .. ' Squad:')

    local textW = leftGap * 4
    local textH = topGap + (topGap*5)

    for k, name in ipairs(squadInfo.Members) do

        surface.SetTextPos(textW, textH)
        
        if k == squadInfo.Commander then --! commented for debugging
            surface.SetMaterial(crown)
            surface.DrawTexturedRect(leftGap,textH-topGap,topGap*5,topGap*5)
        else
            surface.SetMaterial(dot)
            surface.DrawTexturedRect(leftGap,textH-(topGap/2),topGap*5,topGap*5)
        end

        

        surface.DrawText(name)
        textH = textH + (topGap*5)
    end

    surface.DrawLine(leftGap, textH , leftGap*16, textH  )
end     

-- wish this could be above
net.Receive( "gsquads::openhud", function()
    if net.ReadBool() then 
        hook.Add( 'HUDPaint', "HUDPaint_Gsquads", GsquadsHUD )
    else
        hook.Remove( 'HUDPaint', "HUDPaint_Gsquads" )
    end
end)