// cList Props Check
// In this file we check if a prop should be spawned or not


local function checkProp(ply, model) 
  if cList.Settings.Mode == "Disabled" then return end 
  if ply:IsAdmin() then return end  // Do not return true, we don't want to interfer with other addons

  if (cList.Settings.Mode == "Blacklist") && (cList.Util.ArrayContains(cList.PropList, model)) then
    net.Start("cList:Message")
      net.WriteString("Your are not allowed to spawn this prop, it's in the Blacklist.")
    net.Send(ply)
    return false
  elseif (cList.Settings.Mode == "Whitelist") && !(cList.Util.ArrayContains(cList.PropList, model)) then
    net.Start("cList:Message")
      net.WriteString("Your are not allowed to spawn this prop, it's not in the Whitelist.")
    net.Send(ply)
    return false
  end
end



hook.Add("PlayerSpawnProp", "cList:CheckProp", checkProp)
