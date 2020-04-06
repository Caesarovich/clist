// cList Menu Derma
// In this file we have the menu derma

local Settings = {}
local PropList = {}

surface.CreateFont( "cList:Title", 
{
	font = "Arial",
	size = 18,
	weight = 700,
})

surface.CreateFont( "cList:Title2", 
{
	font = "Arial",
	size = 50,
	weight = 700,
})

function cList.OpenMenu()
  local Scrw, Scrh = ScrW(), ScrH()

  local Rows = {}

  // Frame
  local menuFrame = vgui.Create( "DFrame" )
	menuFrame:SetSize(Scrw * 0.25, Scrh * 0.6)
	menuFrame:Center()
	menuFrame:SetTitle('')
	menuFrame:SetDraggable(true)
	menuFrame:MakePopup()
  menuFrame:ShowCloseButton(false)

  menuFrame.Paint = function(self, w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(25, 25, 25))
	end

  // Top Bar
  local Pw, Ph = menuFrame:GetSize()
	
	local topBar = vgui.Create( "DPanel",  menuFrame)
	topBar:SetSize(Pw, Ph * 0.04)
	topBar:SetPos(0, 0)
	topBar.Paint = function(self, w, h)
		draw.RoundedBoxEx(5, 0, 0, w, h, Color( 170, 20, 165 ), true, true, false, false)
		draw.SimpleText('cList - Props Blacklist / Whitelist', "cList:Title", 10, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

  // Top Bar: Close Button
  local Pw, Ph = topBar:GetSize()
	
	local closeBtn = vgui.Create( "DButton", topBar)
	closeBtn:SetSize(Ph, Ph)
	closeBtn:SetPos(Pw - Ph, 0)
  closeBtn:SetText('')
  closeBtn.color = Color( 140, 20, 120 )
	closeBtn.Paint = function(self, w, h)
    if self:IsHovered() then
      self.color = cList.Util.LerpColor(0.04, self.color, Color(230, 0, 0))  
    else 
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 140, 20, 120 )) 
    end
		draw.RoundedBoxEx(5, 0, 0, w, h, self.color, false, true, false, false)
		draw.SimpleText('X', "cList:Title", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

  closeBtn.DoClick = function(self)
    surface.PlaySound("UI/buttonrollover.wav")
    menuFrame:Close()
  end


  // ScrollPanel
  local Pw, Ph = menuFrame:GetSize()

  local scrollPanel = vgui.Create( "DScrollPanel", menuFrame )
  scrollPanel:SetSize(Pw * 0.95, Ph * 0.86)
  scrollPanel:SetPos(Pw * 0.05, Ph * 0.04)


  local scrollBar = scrollPanel:GetVBar()

  function scrollBar.btnGrip:Paint(w, h)
		draw.RoundedBox(6,  w * 0.1, 0, w * 0.6, h, Color(60, 60, 60, 225))
	end
	function scrollBar:Paint(w, h)
		return
	end
	function scrollBar.btnUp:Paint(w, h)
		return
	end
	function scrollBar.btnDown:Paint(w, h)
		return
	end


  // ScrollPanel: ListLayout
  local scrollList = vgui.Create("DListLayout", scrollPanel)
	scrollList:SetSize(Pw * 0.9, Ph * 0.84)
  scrollList:SetPos(0, 0)

  local Pw, Ph = scrollList:GetSize()

  cList.Util.AddSpacer(scrollList, 5)

  for k, v in pairs(table.Reverse(PropList)) do
    // List row
    local row = vgui.Create("DPanel")
    row:SetSize(Pw, Ph * 0.06)
    row.color = Color(60, 60, 60)
    row.model = v
    row.selected = false
    row.Paint = function(self, w, h)
      if self.selected then
        self.color = Color(150, 150, 150)
      end
      draw.RoundedBox(4, 0, 0, w, h, self.color)
      draw.RoundedBox(4, h * 0.05, h * 0.05, h * 0.9, h * 0.9, Color(40, 40, 40))
      draw.SimpleText(v, "cList:Title", h + 5, h / 2, Color( 250, 250, 250), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    // Row: Icon
    local Pw, Ph = row:GetSize()

    local icon = vgui.Create( "SpawnIcon" , row ) 
    icon:SetSize(Ph * 0.8, Ph * 0.8)
    icon:SetPos( Ph * 0.1, Ph * 0.1 )
    icon:SetModel( v ) 

    local btn = vgui.Create("DButton", row)
    btn:SetSize(Pw, Ph)
    btn:SetPos(0, 0)
    btn:SetText('')

    btn.DoClick = function(self)
      row.selected = !row.selected
    end

    btn.Paint = NoDraw
    btn.Think = function(self)
      if self:IsHovered() then
        row.color = cList.Util.LerpColor(0.04, row.color, Color(100, 100, 100))  
      else 
        row.color = cList.Util.LerpColor(0.04, row.color, Color(60, 60, 60)) 
      end
    end


    Rows[#PropList - k + 1] = row
    scrollList:Add(row)  -- Add to List
    cList.Util.AddSpacer(scrollList, 10)
  end

  // Bottom Bar

  local Pw, Ph = menuFrame:GetSize()
	
	local bottomBar = vgui.Create( "DPanel",  menuFrame)
	bottomBar:SetSize(Pw, Ph * 0.1)
	bottomBar:SetPos(0, Ph * 0.9 + 1)
	bottomBar.Paint = function(self, w, h)
		draw.RoundedBoxEx(5, 0, 0, w, h, Color( 170, 20, 165 ), false, false, true, true)
	end

  // Bottom Bar: Add Button

  local Pw, Ph = bottomBar:GetSize()

  local addButton = vgui.Create("DButton", bottomBar)
  addButton:SetSize(Ph * 0.8, Ph * 0.8)
  addButton:SetPos(Ph * 0.1, Ph * 0.1)
  addButton:SetText('')
  addButton.color = Color( 200, 30, 180 )
  addButton.Paint = function(self, w, h)
    if self:IsHovered() then
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 230, 40, 210 ))  
    else 
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 200, 30, 180 )) 
    end
    draw.RoundedBox(4, 0, 0, w, h, self.color)
    draw.SimpleText('+', "cList:Title2", w / 2, h / 2, Color( 250, 250, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end

  addButton.DoClick = function(self)
    surface.PlaySound("UI/buttonrollover.wav")
    cList.MakePopupEntry(menuFrame)
  end

  // Bottom Bar: Delete Button

  local deleteButton = vgui.Create("DButton", bottomBar)
  deleteButton:SetSize(Ph * 0.8, Ph * 0.8)
  deleteButton:SetPos(Ph * 1.1, Ph * 0.1)
  deleteButton:SetText('')
  deleteButton.color = Color( 200, 30, 180 )
  deleteButton.Paint = function(self, w, h)
    if self:IsHovered() then
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 230, 40, 210 ))  
    else 
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 200, 30, 180 )) 
    end
    draw.RoundedBox(4, 0, 0, w, h, self.color)
    draw.SimpleText('-', "cList:Title2", w / 2, h / 2, Color( 250, 250, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end

  deleteButton.DoClick = function(self)
    surface.PlaySound("UI/buttonclick.wav")
    for k, v in pairs(Rows) do
      if v.selected then
        net.Start("cList:RemoveElement")
          net.WriteString(v.model)
        net.SendToServer()
      end
    end

    menuFrame:Close()
  end


  // Mode Button

  local modeButton = vgui.Create("DButton", bottomBar)
  modeButton:SetSize(Ph * 5.2, Ph * 0.8)
  modeButton:SetPos(Ph * 2.1, Ph * 0.1)
  modeButton:SetText('')
  modeButton.color = Color( 200, 30, 180 )
  modeButton.Paint = function(self, w, h)
    if self:IsHovered() then
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 230, 40, 210 ))  
    else 
      self.color = cList.Util.LerpColor(0.04, self.color, Color( 200, 30, 180 )) 
    end
    draw.RoundedBox(4, 0, 0, w, h, self.color)
    draw.SimpleText('Mode: '..Settings.Mode, "cList:Title2", w / 2, h / 2, Color( 250, 250, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end

  modeButton.DoClick = function(self)
    surface.PlaySound("UI/buttonclick.wav")
    if Settings.Mode == "Disabled" then
      Settings.Mode = "Blacklist"
    elseif Settings.Mode == "Blacklist" then
      Settings.Mode = "Whitelist"
    elseif Settings.Mode == "Whitelist" then
      Settings.Mode = "Disabled"
    end
    net.Start("cList:ChangeSettings")
      net.WriteTable(Settings)
    net.SendToServer()
  end
end




function cList.MakePopupEntry(menuF)
  local Scrw, Scrh = ScrW(), ScrH()

  // Frame
  local popupFrame = vgui.Create( "DFrame" )
	popupFrame:SetSize(Scrw * 0.15, Scrh * 0.12)
	popupFrame:Center()
	popupFrame:SetTitle('')
	popupFrame:SetDraggable(true)
	popupFrame:MakePopup()
  popupFrame:ShowCloseButton(true)

  popupFrame.Paint = function(self, w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(35, 35, 35))
	end


  // Top Bar
  local Pw, Ph = popupFrame:GetSize()

  local topBar = vgui.Create("DPanel", popupFrame)
  topBar:SetSize(Pw, Ph * 0.2)
  topBar:SetPos(0, 0)
  topBar.Paint = function(self, w, h)
    draw.RoundedBoxEx(5, 0, 0, w, h, Color( 170, 20, 165 ), true, true, false, false)
    draw.SimpleText('Add an element', "cList:Title", w / 2, h / 2, Color( 250, 250, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end



  // Text Entry
  local textEntry = vgui.Create( "DTextEntry", popupFrame ) -- create the form as a child of frame
  textEntry:SetSize( Pw * 0.8, Ph * 0.2 )
  textEntry:SetPos( Pw * 0.1, Ph * 0.3 ) 
  textEntry:SetPlaceholderText( "Model" )
  
  

  // Cancel Button
  local cancelButton = vgui.Create("DButton", popupFrame)
  cancelButton:SetSize(Pw * 0.3, Ph * 0.2)
  cancelButton:SetPos(Pw * 0.1, Ph * 0.6)
  cancelButton:SetText('')
  cancelButton.color = Color(50, 50, 50)
  cancelButton.Paint = function(self, w, h)
    if self:IsHovered() then
      self.color = cList.Util.LerpColor(0.04, self.color, Color(100, 100, 100))  
    else 
      self.color = cList.Util.LerpColor(0.04, self.color, Color(50, 50, 50)) 
    end
    draw.RoundedBox(4, 0, 0, w, h, self.color)
    draw.SimpleText("Cancel", "DermaDefault", w / 2,  h / 2, Color( 250, 250, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end


  cancelButton.DoClick = function(self)
    surface.PlaySound("UI/buttonrollover.wav")
    popupFrame:Close()
  end

  // Accept Button

  local acceptButton = vgui.Create("DButton", popupFrame)
  acceptButton:SetSize(Pw * 0.3, Ph * 0.2)
  acceptButton:SetPos(Pw * 0.6, Ph * 0.6)
  acceptButton:SetText('')
  acceptButton.color = Color(50, 50, 50)
  acceptButton.Paint = function(self, w, h)
    if self:IsHovered() then
      self.color = cList.Util.LerpColor(0.04, self.color, Color(100, 100, 100))  
    else 
      self.color = cList.Util.LerpColor(0.04, self.color, Color(50, 50, 50)) 
    end
    draw.RoundedBox(4, 0, 0, w, h, self.color)
    draw.SimpleText("Add", "DermaDefault", w / 2,  h / 2, Color( 250, 250, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end


  acceptButton.DoClick = function(self)
    if textEntry:GetValue() == "" then return end
    surface.PlaySound("UI/buttonclick.wav")
    table.insert(PropList, textEntry:GetValue())
    net.Start("cList:AddElement")
      net.WriteString(textEntry:GetValue())
    net.SendToServer()
    popupFrame:Close()
    menuF:Close()
    cList.OpenMenu() 
  end

end


net.Receive("cList:OpenMenu", function(len)
  Settings = net.ReadTable()
  PropList = net.ReadTable()
  print("[cList] Received "..#PropList.." elements.")
  cList.OpenMenu()
end)