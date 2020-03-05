Quick start: install and run the NOX, set the resolution 1600x900 in NOX settings and Speed rendering mode. Install and run the game. Start the bot. To stop the bot press Ctrl + Alt+q  
  
1. 	Bot works only in NoxPlayer 1600x900. By default, the bot runs in the inactive window mode (you can switch to other programs, but you can not minimize or move the NOX itself), so you need to set the Speed rendering mode (Settings- > Advanced/Performance - >rendering Mode).  
2. 	Bot's settings in the file settings.ini  
2.1. 	mode=0 - bot works only in the active window  
	mode=1 - bot can works below any windows, set up Speed(DirectX) mode in NoxPlayer (Settings - > Advanced/Performance settings- > Graphics rendering mode)  
2.2. 	collectfood=1 bot tries to collect food, for correct work place the kitchen directly above Roger's bar  
2.3. 	participate=0 bot plays only for the food  
	participate=1 bot plays only for tickets  
	participate=2 bot plays first fully for food, then for tickets  
	participate=3 bot plays first fully for tickets, then for food  
2.4.	strategy=0 strategy 3+2
	strategy=1 strategy 1+4
2.5. 	ratio=1.1 option for 4th and 5th stages for finding stronger enemies  
2.6. 	timer=0 timer between fights in seconds, 0-for random delays of 2 to 5 minutes  
2.7.	screenshot=1 take screenshots of arena results in screenshots folder  
2.8.	alwaysontop=1 when an anti-bot window is detected, the NoxPlayer window becomes active until the anti-bot passes  
	alarm=1 when an anti-bot window is detected, a constant beep is activated until the anti-bot passes  

Hotkeys:  
Ctrl + Alt+p - pause  
Ctrl + Alt+q - exit  