local Config = {

    ['ScrW'] = ScrW(),
    ['ScrH'] = ScrH(),
    ['frameColor'] = Color( 110,110,110,229)

}

local function openGui()
    
    local frame = vgui.Create('DFrame')
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame:MakePopup()
    frame:DockPadding( 0, 0, 0, 0 )
    frame.PerformLayout = function() end
    frame.btnMaxim:Remove()
    frame.btnMinim:Remove()
    frame.lblTitle:Remove()
    
    frame:SetSize(Config.ScrW*.25, Config.ScrH*.55)
    frame:SetPos( ( Config.ScrW-frame:GetWide() )*.5, ( Config.ScrH-frame:GetTall() )*.5)

    frame.Paint = function(self,w,h)
        draw.RoundedBox(4, 0, 0, w, h, Config.frameColor)
    end

    frame.Close = function(self)
        self:Hide()
        self:Remove()
    end


    frame.btnClose = vgui.Create('DImageButton',frame)
    frame.btnClose:SetKeepAspect(true)
    frame.btnClose:SetImage("cross_icon.png")
    frame.btnClose:SizeToContents()
    frame.btnClose:SetSize( frame:GetWide()*.04, frame:GetWide()*.04 )
    frame.btnClose:SetPos( frame:GetWide()*.95, frame:GetTall()*.03 )
    
    frame.btnClose.DoClick = function()
        frame:Close()
    end

end


net.Receive('gsquads::opengui', function ()

    openGui()
    
end)