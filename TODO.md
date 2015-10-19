# TODO

## Main Bot Functions

- [ ] Ensure no doubled output on lag (maybe output stream?)
- [ ] Add comment based help
- [ ] Track 'active' viewers (people who have typed in chat between time x and y)
- [ ] Implement raffle system.
- [ ] Polls/votes (maybe leverage new lc.tv facility)
- [ ] Limit some commands to followers only?
- [ ] Song requests?
- [ ] Current song playing.
- [ ] Creating countdown (progress bars) from chat command
- [ ] Command to mute/unmute the bot
- [ ] Ability to use mute commands via lctv chat (moderators only?)
- [ ] 'Status' updates? (change an OBS ticker?)
- [ ] Control OBS/Foobar2000 through bot?
- [ ] Stop-Stream: output to chat about following and about sending in requests, and then stop the stream via OBS (hotkeys?).
- [ ] Start-Stream: start five minute countdown and start the stream via OBS (hotkeys?)
- [ ] Reduce the timeout for !help to 1 minute
- [ ] Add timeout left to non-help command in !help output
- [ ] Regreet viewers that leave stream and return after x minutes. "Welcome back, $user"
- [ ] Mute users that issue more than 4 commands in a minute.
  - [ ] Initial mute for 1 minute
  - [ ] Aditional mutes double (2 minutes, 4 minutes, 8 minutes)
  - [ ] If still spamming after 8 minute ban, advise streamer to ban (command) spammer.
- [ ] Track regulars (people who have show up more than three times)
  - [ ] Greet regulars differently than new viewers
  - [ ] Give regulars access to privilaged commands (different commands than normal, but not admin commands. e.g. muting the bot)
- [ ] Track current task/todo list
  - [ ] !tasks command, or occasionally mention it in chat and ask viewers if they have worked on something similar.
- [ ] Random small talk, 'professional, student or other?' Country?
- [ ] Pull favourite ide, language and line of code from streamer profile, use in command responses.
- [ ] "Tools I'm using" - IDE, plugins,technologies etc.
- [ ] Feature for donors (song requests, VIP/custom greeting)
- [ ] Occasional reminder to follow (lctv and twitter)
- [ ] Only show most used commands in !help output, then link, to a webpage with full list.

### Random LCTV stuff for competition

- [ ] !favorite_language - tells us favorite language of the streamer, e.g. “Python”
- [ ] !favorite_framework! - tells us favorite framework of the streamer, e.g. “Django”
- [ ] !favorite_ide - tells us favorite ide of the streamer e.g. “Sublime”
- [ ] !favorite_viewer - tells us favorite viewer of the streamer, e.g. “faugusztin”
- [ ] !favorite_music - tells us favorite music of the streamer, e.g. “Wish you were here – Britney Spears”
- [ ] !streamingguide - Livecoding.tv streaming guide for Mac, Windows and Linux is here: https://www.livecoding.tv/streamingguide/
- [ ] !support - Livecoding.tv support page is here: http://support.livecoding.tv/hc/en-us/
- [ ] !newfeatures - Here is a list of new features Livecoding.tv released:
  Hire a Streamer & Pay
  Reddit stream announcement
  ……
- [ ] !song - Current song playing is “xxx”
- [ ] !tools - Eclipse, Vmware, Twilio API

## Dashboard

- [ ] 'Timeout' widgets for other commands. (e.g. !help)
- [ ] Greet stream viewers in the text box.
- [ ] Stream up time in number widget
- [ ] Consider third party widget (progress bar, github, weather, clock?)

## Archived
_These were moved from the main list to make that list more manageable._

- [x] Create function for installing phantomJS and Selenium (currently just lots of duplicated cmdlets.)
- [x] Reset greet delay if viewer leaves chat (i.e. if viewer leaves before 30 seconds, don't auto greet if they re-visit later unless they stay for delay)
- [x] Revisit dynamically adding commands, add to PBLoop.
- [x] Make added commands persistent.
- [x] Edit commands, remove commands.
- [X] New follower notifications (this and lc.tv poll facility will require bot to log in to site as myself rather than its own account.)
