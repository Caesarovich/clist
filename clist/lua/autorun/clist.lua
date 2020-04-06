// cList Autorun

cList = {}
cList.Settings = {
  Mode = "Disabled"
}

cList.PropList = {}

print("[cList] Loading...")


// Nets
if SERVER then
  util.AddNetworkString("cList:OpenMenu")
  util.AddNetworkString("cList:AddElement")
  util.AddNetworkString("cList:RemoveElement")
  util.AddNetworkString("cList:ChangeSettings")
  util.AddNetworkString("cList:Message")
end

// Includes
if SERVER then
  include("clist/sh_util.lua")
  include("clist/sv_check.lua")
  include("clist/sv_init.lua")
  AddCSLuaFile("clist/sh_util.lua")
  AddCSLuaFile("clist/cl_message.lua")
  AddCSLuaFile("clist/cl_menu.lua")
else
  include("clist/sh_util.lua")
  include("clist/cl_message.lua")
  include("clist/cl_menu.lua")
end