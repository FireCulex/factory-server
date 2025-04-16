#!/bin/bash

# Path to the appmanifest file
manifest_file="/satisfactory/steamapps/appmanifest_1690800.acf"

# Extract the current build ID from the appmanifest file
current_build=$(grep '"buildid"' "$manifest_file" | awk '{print $2}' | tr -d '"')

# Check for port 8888 in ESTABLISHED state
if netstat -an 2>/dev/null | grep -q ':8888.*ESTABLISHED'; then
  echo Players Connected, not updating.
else
   # Fetch the latest build ID from SteamCMD for the experimental branch
   latest_build=$(/usr/games/steamcmd +login anonymous +app_info_print 1690800 +quit | grep -A 2 '"experimental"' | grep '"buildid"' | awk '{print $2}' | tr -d '"')

   # Compare the build IDs and output the result
   if [ -n "$latest_build" ] && [ "$current_build" == "$latest_build" ]; then
       echo "Satisfactory is up-to-date (Build ID: $current_build)."
   elif [ -n "$latest_build" ]; then
       echo "An update is available! Installed Build: $current_build | Latest Build: $latest_build."
       killall FactoryServer.sh
       /usr/games/steamcmd +force_install_dir /satisfactory +login anonymous +app_update 1690800 -beta experimental validate +quit
   else
       echo "Failed to retrieve the latest build ID. Please check SteamCMD output or network connectivity."
   fi
fi

