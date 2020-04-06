// cList Util

cList.Util = {}

// Array contains, check for a table containing an element

local function ArrayContains(table, element)  
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

cList.Util.ArrayContains = ArrayContains



// Linear color interpolation
local function LerpColor(T, Color1, Color2)
	local r = Lerp(T, Color1.r, Color2.r)
	local g = Lerp(T, Color1.g, Color2.g)
	local b = Lerp(T, Color1.b, Color2.b)
	local a = Lerp(T, Color1.a, Color2.a)
	return Color(r,g,b,a)
end

cList.Util.LerpColor = LerpColor


// Derma ListView: Add Spacer
local function AddSpacer(list, height)  -- Thanks Marum
  local spacer = list:Add(vgui.Create( "DPanel"))
  spacer:SetSize(0, height)
  spacer.Paint = NoDraw
end

cList.Util.AddSpacer = AddSpacer