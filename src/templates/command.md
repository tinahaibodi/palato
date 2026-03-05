Read the file `palato/palato.md` and follow its instructions. The user's request is: $ARGUMENTS

Determine which mode to activate based on the request:

- If the request is a name (e.g. "keeks"), check if `palato/$ARGUMENTS-palato.md` exists. If not, begin the Init interview. If it does, load it as the active profile.
- If the request starts with "use" (e.g. "use brutalist"), activate Switch mode.
- If the request is "list", activate List mode.
- If no arguments are provided, check the active pointer in `palato/palato.md`. If a profile is active, confirm which one. If none, offer to create one.
