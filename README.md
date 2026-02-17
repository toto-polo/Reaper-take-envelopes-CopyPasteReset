# Take Envelopes scripts for Reaper

A small collection of Lua scripts that let you manage take‑level envelopes (Volume, Pan, Pitch, FX) in Reaper without any manual editing.

> Scripts
> 
> - Take envelopes copy.lua – Copies all envelope values from the selected take.
> - Take envelopes paste.lua – Pastes the previously‑copied envelope values onto the selected take.
> - Take envelopes reset.lua – Resets all envelope values of the selected take to zero.

* * *

## 📦 Installation

1.  Download the three `.lua` files from this repository.
2.  Open the Action List (shortcut `?`) → New action → Load Reascript... → and select downloaded scripts
3.  You can now use those scripts via the Action List


* * *

## ⚙️ Usage

| Action | How to run | What happens |
| :--- | :--- | :--- |
| Copy envelopes | Select a media item (the take whose envelopes you want to copy) → use "Script: Take envelopes copy.lua" | Copies all envelope points (volume, pan, pitch, FX) of that take to an internal buffer. |
| Paste envelopes | Select a different media item → use "Script: Take envelopes paste.lua" | Pastes the previously copied envelope values onto the selected take. If no envelope existed before, it will be created. |
| Reset envelopes | Select a media item → use "Script: Take envelopes reset.lua" | Sets every envelope point of the take back to zero. Useful for cleaning up or starting a new automation curve. |

> Important:
> 
> - These scripts operate at the take level only, not on track‑level envelopes.
> - The copy buffer is local to Reaper; closing Reaper will clear it.

* * *

## 🤝 Contributing

Feel free to open issues or submit pull requests if you find bugs or want to add more envelope types (e.g., MIDI CC, pan2, custom FX params).  
Please keep the scripts in the same folder structure and maintain the simple Lua format.

* * *

## 📄 License

These scripts are released under the Creative Commons Attribution‑NonCommercial‑ShareAlike 4.0 International (CC BY‑NC‑SA 4.0) license.
https://creativecommons.org/licenses/by-nc-sa/4.0/
