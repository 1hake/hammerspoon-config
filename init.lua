

-- assign hyper key 
local hyper = { "cmd", "alt", "ctrl", "shift" }
hs.hotkey.bind(hyper, "0", function()
  hs.reload()
end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()        


-- FUNCTIONS

-- chrome switch
function chrome_switch_to(ppl)
  return function()
      hs.application.launchOrFocus("Google Chrome")
      local chrome = hs.appfinder.appFromName("Google Chrome")
      local str_menu_item
      if ppl == "Incognito" then
          str_menu_item = {"File", "New Incognito Window"}
      else
          str_menu_item = {"Profiles", ppl}
      end
      local menu_item = chrome:findMenuItem(str_menu_item)
      if (menu_item) then
          chrome:selectMenuItem(str_menu_item)
      end
  end
end

function chrome_switch_to_bookmark(bookmark)
  return function()
      hs.application.launchOrFocus("Google Chrome")
      local chrome = hs.appfinder.appFromName("Google Chrome")
      local str_menu_item
      str_menu_item = {"Bookmarks", bookmark}
      local menu_item = chrome:findMenuItem(str_menu_item)
      newWindow()
      if (menu_item) then
          chrome:selectMenuItem(str_menu_item)
      end
  end
end

-- shut down everything
function shutDownEverything()
  local dockedApplications =
    hs.fnutils.filter(hs.application.runningApplications(), function(app)
      return app:kind() == 1
    end)
    for _, app in ipairs(dockedApplications) do
      app:kill()
    end
end

-- get network status
function pingResult(object, message, seqnum, error)
  if message == "didFinish" then
      avg = tonumber(string.match(object:summary(), '/(%d+.%d+)/'))
      if avg == 0.0 then
          hs.alert.show("No network")
      elseif avg < 200.0 then
          hs.alert.show("Network good (" .. avg .. "ms)")
      elseif avg < 500.0 then
          hs.alert.show("Network poor(" .. avg .. "ms)")
      else
          hs.alert.show("Network bad(" .. avg .. "ms)")
      end
  end
end

-- new tab on chrome
function newWindow() 
  local app = hs.application.find("Chrome")
  app:selectMenuItem({"File", "New Tab"})
end

function openDesktop()
  hs.application.launchOrFocus('Finder')
  local app = hs.application.find("Finder")
  app:selectMenuItem({"Go", "Desktop"})
end

function openDownloads()
  hs.application.launchOrFocus('Finder')
  local app = hs.application.find("Finder")
  app:selectMenuItem({"Go", "Downloads"})
end

function listAudio(device)
  return function()
    local list = 	hs.audiodevice.allOutputDevices()
    for i, v in ipairs(list) do
      print(i, v:name())
    end
    for i,v in ipairs(list) do
      if v:name() == device then
        if v:setDefaultOutputDevice() then 
          hs.alert.show(v:name(), 0.3)
        else
          hs.alert.show("Erreur de connexion", 0.3)
        end
      end
    end
  end
end



-- LAYOUT CONFIGURATION 
hs.window.animationDuration = 0

-- left half 
hs.hotkey.bind(hyper, "o", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToUnit(hs.layout.left50)
end)

-- right half
hs.hotkey.bind(hyper, "p", function()
    local win = hs.window.focusedWindow();
    if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

-- maximize
hs.hotkey.bind(hyper, "m", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToUnit(hs.layout.maximized)
end)

-- next window
hs.hotkey.bind(hyper, "l", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToScreen(win:screen():next())
end)


-- OTHER UTILS

-- new tab in chrome
hs.hotkey.bind(hyper, "3", newWindow)

-- shutodown
hs.hotkey.bind(hyper, "-", shutDownEverything)

-- finder
hs.hotkey.bind(hyper, "d", openDesktop)
hs.hotkey.bind(hyper, "f", openDownloads)


-- chrome profiles
hs.hotkey.bind(hyper, "1", chrome_switch_to('Cln (Perso)'))
hs.hotkey.bind(hyper, "2", chrome_switch_to('Colin (Izi)'))

-- Audio devices
hs.hotkey.bind(hyper, "5", listAudio('MacBook Pro Speakers'))
hs.hotkey.bind(hyper, "6", listAudio('AirPods de Colin'))
hs.hotkey.bind(hyper, "7", listAudio('Home Colin'))



 -- IZI biding
hs.hotkey.bind(hyper, "t", chrome_switch_to_bookmark('Daily'))
hs.hotkey.bind(hyper, "y", chrome_switch_to_bookmark('Calendar'))


-- ping result
hs.hotkey.bind(hyper, "c", function()
  hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult)
end)

-- APP LAUNCHER

local applicationHotkeys = {
    q = 'Google Chrome',
    w = 'Visual Studio Code',
    a = 'Slack',
    s = 'Spotify',
    e = 'Spotify', 
    z = 'System Preferences',
    x = 'Notes', 
  }

  for key, app in pairs(applicationHotkeys) do
    hs.hotkey.bind(hyper, key, function()
      hs.alert.show(app, 0.3)
      hs.application.launchOrFocus(app)
    end)
  end
  

