// cList Init
// This files handles command for menu opening,
// Adding/Removing list elements
// Changing settings


local function checkCommand(ply, message)
  if string.lower(message) == "!clist" then
    if ply:IsSuperAdmin() then
      net.Start("cList:OpenMenu")
        net.WriteTable(cList.Settings)
        net.WriteTable(cList.PropList)
      net.Send(ply)
    else
      net.Start("cList:Message")
        net.WriteString("You are not allowed to use this command.")
      net.Send(ply)
    end
    return "" // Don't print message in chat
  end
end

hook.Add("PlayerSay", "cList:CommandCheck", checkCommand)



// Add
local function AddElement(element)
  if not cList.Util.ArrayContains(cList.PropList, element) then
    table.insert(cList.PropList, element)
    local query = sql.Query("INSERT INTO cList_models(Model) VALUES('"..element.."')")
    if query == false then
      print("[cList SQL ERROR] Failed to insert element: "..element)
    end
  end
end


net.Receive("cList:AddElement", function(len, ply)
  if !ply:IsSuperAdmin() then return end
  local element = net.ReadString()
  AddElement(element)
  net.Start("cList:Message")
    net.WriteString("You added \""..element.."\" to the PropList.")
  net.Send(ply)
end)


// Remove
local function RemoveElement(element)
  for k, v in pairs(cList.PropList) do
    if v == element then
      table.remove(cList.PropList, k)
      local query = sql.Query("DELETE FROM cList_models WHERE Model = '"..element.."'")
      if query == false then
        print("[cList SQL ERROR] Failed to remove element: "..element)
      end
    end
  end
end

net.Receive("cList:RemoveElement", function(len, ply)
  if !ply:IsSuperAdmin() then return end
  local element = net.ReadString()
  RemoveElement(element)
  net.Start("cList:Message")
    net.WriteString("You removed \""..element.."\" from the PropList.")
  net.Send(ply)
end)

// Settings

net.Receive("cList:ChangeSettings", function(len, ply)
  if !ply:IsSuperAdmin() then return end
  cList.Settings = net.ReadTable()
  file.Write( "clist_settings.json", util.TableToJSON(cList.Settings))
  net.Start("cList:Message")
    net.WriteString("You changed the settings.")
  net.Send(ply)
end)




// Database
function cList.MakeTable()
   local MakeTable = sql.Query([=[
      CREATE TABLE IF NOT EXISTS cList_models(
         Model     TEXT     ,

         PRIMARY KEY (Model)
      ) WITHOUT ROWID;]=]
   )
   if MakeTables == false then
      print("[cList SQL ERROR] Failed to create table")
      return
   end
end

cList.MakeTable()


function cList.LoadDatabase()
  local query = sql.Query("SELECT * FROM cList_models") or {}
  if query == false then
    print("[cList SQL ERROR] Failed to load DB")
    return
  end
  cList.PropList = {}
  for k, v in pairs(query) do
    table.insert(cList.PropList, v.Model)
  end
  print("[cList] Loaded "..#cList.PropList.." elements from DB")
end
cList.LoadDatabase()




// Settings
function cList.LoadSettings()
  if !file.Exists( "clist_settings.json", "DATA" )then
    file.Write( "clist_settings.json", util.TableToJSON(cList.Settings))
    print("[cList] Creating settings file...")
    return
  end

  cList.Settings = util.JSONToTable(file.Read( "clist_settings.json", "DATA" ))

  print("[cList] Loaded settings")
end

cList.LoadSettings()
