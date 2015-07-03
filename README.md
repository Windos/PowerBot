# PowerBot

**PowerBot** is a chat bot for use on Livecoding.tv written in PowerShell.

It requires, and will download on first run, [Selenium](http://www.seleniumhq.org/) and [PhantomJS](http://phantomjs.org/).

#### Screenshots
![PowerBot in responding to commands](/Images/PowerBot-Commands.png)

## Download
* [Version 0.2](https://github.com/Windos/PowerBot/archive/master.zip)
* [Version 0.1](https://github.com/Windos/PowerBot/archive/84f1ff09d3472a5adaa4a22490679873c4e589c9.zip)
* Other Versions

## Instructions
1. [Download](https://github.com/Windos/PowerBot/archive/master.zip) PowerBot.
2. Extract archive to a PowerShell Module location.
  * Run `$env:PSModulePath` in a PowerShell console to get a list of valid paths.
3. Edit **Initialize-PowerBot.ps1**, change the default value for the `$Streamer` to your Livecoding.tv username.
4. Save and close **Initialize-PowerBot.ps1**
5. Open an elevated PowerShell prompt.
6. Run `Initialize-PowerBot`
7. Selenium and PhantomJS will be downloaded.
8. You will be prompted to enter a username and password:
	* Enter the username and password for the account you want to be automated in chat.
	* Either create a secondary account or your own if you authenticate with username and password.
9. Wait for the bot to join chat.
10. Test functionality by typing `Out-Stream 'Test'` in a PowerShell console
11. Run **BasicLoop.ps1**, this will lock the console.
12. Type `!help` in chat to ensure PowerBot is responding to commands.

## Contributors
* [Windos](https://github.com/Windos)

## License 
* see [LICENSE](LICENSE.md) file

## Contact

* Twitter: [@WindosNZ](https://twitter.com/windosnz)
* Livecoding.tv: [Windos](https://www.livecoding.tv/windos/)
