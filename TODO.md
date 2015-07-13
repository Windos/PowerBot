# TODO

## Main Bot Functions

- [ ] Ensure no doubled output on lag (maybe output stream?)
- [x] Create function for installing phantomJS and Selenium (currently just lots of duplicated cmdlets.)
- [x] Reset greet delay if viewer leaves chat (i.e. if viewer leaves before 30 seconds, don't auto greet if they re-visit later unless they stay for delay)
- [x] Revisit dynamically adding commands, add to PBLoop.
- [x] Make added commands persistent.
- [x] Edit commands, remove commands.
- [ ] Add comment based help
- [ ] Track 'active' viewers (people who have typed in chat between time x and y)
- [ ] Implement raffle system.
- [ ] Polls/votes (maybe leverage new lc.tv facility)
- [ ] New follower notifications (this and lc.tv poll facility will require bot to log in to site as myself rather than its own account.)
- [ ] Limit some commands to followers only?
- [ ] Song requests?
- [ ] Creating countdown (progress bars) from chat command
- [x] Command to mute/unmute the bot
- [ ] Ability to use mute commands via lctv chat (moderators only?)
- [ ] 'Status' updates? (change an OBS ticker?)
- [ ] Control OBS/Foobar2000 through bot?
- [ ] Stop-Stream: output to chat about following and about sending in requests, and then stop the stream via OBS (hotkeys?).
- [ ] Start-Stream: start five minute countdown and start the stream via OBS (hotkeys?)
- [x] Reduce the timeout for !help to 1 minute
- [x] Add timeout left to non-help command in !help output
- [ ] Regreet viewers that leave stream and return after x minutes. "Welcome back, $user"
- [ ] Mute users that issue more than 4 commands in a minute.
  - [ ] Initial mute for 1 minute
  - [ ] Aditional mutes double (2 minutes, 4 minutes, 8 minutes)
  - [ ] If still spamming after 8 minute ban, advise streamer to ban (command) spammer.

## Dashboard

- [ ] 'Timeout' widgets for other commands. (e.g. !help)
- [ ] Greet stream viewers in the text box.
- [ ] Stream up time in number widget
- [ ] Consider third party widget (progress bar, github, weather, clock?)
