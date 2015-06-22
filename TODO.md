# TODO

## Main Bot Functions

* Create function for installing phantomJS and Selenium (currently just lots of duplicated cmdlets.)
* Reset greet delay if viewer leaves chat (i.e. if viewer leaves before 30 seconds, don't auto greet if they re-visit later unless they stay for delay)
  * (this may be fixed, needs testing off stream)
* Revisit dynamically adding commands, add to PBLoop.
* Make added commands persistent.
* Edit commands, remove commands.
* Add comment based help
* Track 'active' viewers (people who have typed in chat between time x and y)
* Implement raffle system.
* Polls/votes (maybe leverage new lc.tv facility)
* New follower notifications (this and lc.tv poll facility will require bot to log in to site as myself rather than its own account.)
* Limit some commands to followers only?
* Song requests?
* Creating countdown (progress bars) from chat command
* Command to mute/unmute the bot
* 'Status' updates? (change an OBS ticker?)
* Control OBS/Foobar2000 through bot?
* Stop-Stream: output to chat about following and about sending in requests, and then stop the stream via OBS (hotkeys?).
* Star-Stream: start five minute countdown and start the stream via OBS (hotkeys?)

## Dashboard

* 'Timeout' widgets for other commands. (e.g. !help)
* Greet stream viewers in the text box.
* Stream up time in number widget
* Consider third party widget (progress bar, github, weather, clock?)
