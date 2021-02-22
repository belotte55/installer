tell application "System Events"
	tell process "iTerm2"
		set frontmost to true
		click menu item "Preferences..." of menu "iTerm2" of menu bar 1
		delay 0.5
		repeat 10 times
			key code 48
		end repeat
		delay 0.5
		repeat 6 times
			key code 124
		end repeat
		delay 0.5
		repeat 2 times
			key code 48
		end repeat
		delay 0.5
		keystroke "~/.config"
		delay 0.5
		keystroke "w" using command down
	end tell
end tell