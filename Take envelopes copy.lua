--[[ Copy ALL Take Envelopes (Volume/Pan/Pitch + ALL Take FX) ]]
function get_take_env(take, env_name)
  local env = reaper.GetTakeEnvelopeByName(take, env_name)
  if not env then
    local item = reaper.GetMediaItemTake_Item(take)
    local was_selected = reaper.IsMediaItemSelected(item)
    if not was_selected then reaper.SetMediaItemSelected(item, true) end
    
    local cmd_id = ({
      ["Volume"] = "_S&M_TAKEENV1", ["Pan"] = "_S&M_TAKEENV2", 
      ["Pitch"] = "_S&M_TAKEENV10"
    })[env_name]
    if cmd_id then reaper.Main_OnCommand(reaper.NamedCommandLookup(cmd_id), 0) end
    
    if was_selected then reaper.SetMediaItemSelected(item, true) end
    env = reaper.GetTakeEnvelopeByName(take, env_name)
  end
  return env
end

function scan_all_envelopes(take)
  local env_list = {}
  local count = reaper.CountTakeEnvelopes(take)
  
  -- Standard envelopes
  local std_envs = {"Volume", "Pan", "Pitch"}
  for _, name in ipairs(std_envs) do
    local env = get_take_env(take, name)
    if env then table.insert(env_list, {name=name, env=env}) end
  end
  
  -- Scan ALL Take FX envelopes
  for i = 0, count - 1 do
    local env = reaper.GetTakeEnvelope(take, i)
    if env then
      local _, env_name = reaper.GetEnvelopeName(env)
      -- Évite doublons
      local exists = false
      for _, e in ipairs(env_list) do
        if e.name == env_name then exists = true; break end
      end
      if not exists then table.insert(env_list, {name=env_name, env=env}) end
    end
  end
  
  return env_list
end

local item = reaper.GetSelectedMediaItem(0, 0)
if not item then 
  reaper.ShowMessageBox("Select a source item", "Error", 0)
  return
end

local take = reaper.GetActiveTake(item)
if not take then return end

local env_list = scan_all_envelopes(take)
local copied = 0

for _, env_info in ipairs(env_list) do
  local ret, chunk = reaper.GetEnvelopeStateChunk(env_info.env, "", false)
  reaper.SetExtState("TakeEnvsCopy", env_info.name.."_chunk", chunk, false)
  copied = copied + 1
end

local msg = "✅ " .. copied .. " envelopes copied :\n\n"
for i, env_info in ipairs(env_list) do
  msg = msg .. "• " .. env_info.name .. "\n"
end

reaper.ShowMessageBox(msg, "Copy !", 0)

