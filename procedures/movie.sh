# Movie Mode
# Opens TBCPL in Firefox; handled by assistant hyprchan

cd ~/Mid_Hunter/scripts/assistants/ || exit
python -m hyprchan.run_firefox "Experiment" "https://tbcpl.lol/" > /dev/null 2>&1
