--[[ Paste ALL Take Envelopes (Volume/Pan/Pitch + ALL Take FX) ]]
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

function scan_and_paste_all(take)
  local pasted = {}
  local count = reaper.CountTakeEnvelopes(take)
  
  -- Colle standard envelopes
  local std_envs = {"Volume", "Pan", "Pitch"}
  for _, name in ipairs(std_envs) do
    local chunk = reaper.GetExtState("TakeEnvsCopy", name.."_chunk")
    if chunk ~= "" then
      local env = get_take_env(take, name)
      if env then
        reaper.SetEnvelopeStateChunk(env, chunk, false)
        table.insert(pasted, name)
      end
    end
  end
  
  -- Colle TOUTES les autres Take FX envelopes
  for i = 0, count - 1 do
    local env = reaper.GetTakeEnvelope(take, i)
    if env then
      local _, env_name = reaper.GetEnvelopeName(env)
      local chunk = reaper.GetExtState("TakeEnvsCopy", env_name.."_chunk")
      if chunk ~= "" then
        reaper.SetEnvelopeStateChunk(env, chunk, false)
        table.insert(pasted, env_name)
      end
    end
  end
  
  return pasted
end

local item = reaper.GetSelectedMediaItem(0, 0)
if not item then 
  reaper.ShowMessageBox("Sélectionne un item cible", "Erreur", 0)
  return
end

local take = reaper.GetActiveTake(item)
if not take then return end

local pasted = scan_and_paste_all(take)
reaper.UpdateItemInProject(item)
reaper.UpdateArrange()

local msg = "✅ " .. #pasted .. " envelopes pasted :\n\n"
for _, name in ipairs(pasted) do
  msg = msg .. "• " .. name .. "\n"
end
reaper.ShowMessageBox(msg, "Paste !", 0)

