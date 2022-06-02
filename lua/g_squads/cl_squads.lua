local isOpen = false
local squadInfo = squadInfo or {}

net.Receive( "gsquads::updateInfo", function()
    // ClearClient uses same netstring but only clears the table.
    if not net.ReadBool() then squadInfo = {}; return end
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

net.Receive( "gsquads::parUpdateInfo",function()

    squadInfo.Kills     =   net.ReadUInt( 16 )
    squadInfo.Deaths    =   net.ReadUInt( 16 )

end)