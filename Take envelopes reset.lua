-- Reset ALL take envelopes of active take on first selected item
-- Volume = 0 dB, Pan = center, Pitch = 0, Mute = 0, autres = 0.0

local function get_default_value_from_name(name)
  name = name or ""

  name = name:lower()

  if name:find("volume") then
    return 1.0           -- 0 dB
  elseif name:find("pan") then
    return 0.0           -- center
  elseif name:find("pitch") then
    return 0.0           -- pitch zero
  elseif name:find("mute") then
    return 0.0           -- unmuted
  else
    return 0.0           -- set to default other visible parameters
  end
end

local function reset_take_env(env, default_value, item)
  if not env or not item then return end

  -- Effacer tous les points
  reaper.DeleteEnvelopePointRange(env, -math.huge, math.huge)

  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  local start_t  = item_pos
  local end_t    = item_pos + item_len

  -- Deux points pour garder une valeur constante
  reaper.InsertEnvelopePoint(env, start_t, default_value, 0, 0, true, true)
  reaper.InsertEnvelopePoint(env, end_t,   default_value, 0, 0, true, true)
  reaper.Envelope_SortPoints(env)
end

reaper.Undo_BeginBlock()

local item = reaper.GetSelectedMediaItem(0, 0)
if not item then
  reaper.ShowMessageBox("Select at least one item.", "Reset take envelopes", 0)
  return
end

local take = reaper.GetActiveTake(item)
if not take then
  reaper.ShowMessageBox("Item doesn't have active take.", "Reset take envelopes", 0)
  return
end

local env_count = reaper.CountTakeEnvelopes(take)
if env_count == 0 then
  reaper.ShowMessageBox("Take doesn't have active envelope.", "Reset take envelopes", 0)
else
  for i = 0, env_count - 1 do
    local env = reaper.GetTakeEnvelope(take, i)
    local retval, env_name = reaper.GetEnvelopeName(env, "")
    local default_val = get_default_value_from_name(env_name)
    reset_take_env(env, default_val, item)
  end
end

reaper.Undo_EndBlock("Reset ALL take envelopes of active take", -1)
reaper.UpdateArrange()

