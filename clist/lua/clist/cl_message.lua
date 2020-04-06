// cList Message
// In this file we print a message to the player's chat whenever server tells to


local function printMessage(message)
  chat.AddText(Color( 170, 20, 165 ), "[cList] ", Color( 230, 230, 230 ), message )
end

net.Receive("cList:Message", function(len)
  printMessage(net.ReadString())
end)