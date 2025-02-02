local result = false
local waitResult = false

RegisterNUICallback('result',function(data)
  SetNuiFocus(false,false)
  waitResult = false
  result = data
end)

local function create(size,time)
  if waitResult then return end

  waitResult = true
  SetNuiFocus(true,false)
  SendNUIMessage({ action = 'taskbar', data = { size = size, time = time } })

  repeat
    Wait(1000)
  until not waitResult

  return result
end

exports('taskbar',function(count,size,time)
  local response = true
  for i = 1,count do
    if not create(size,time) then
      response = false
      break
    end
  end

  return response
end)

RegisterCommand('taskbar-testing',function()
  local response = exports['toddy-taskbar']:taskbar(3,10,3)
  print(response and 'okay' or 'not okay')
end,false)