# Simple pure BrightScript screensaver

This is a breakout of a custom screensaver that existed in a channel of mine.  If you're interested in creating a private screensaver that runs only when an existing project is currently open and running on a Roku, there's only a couple requirements:
```
- Add a RunScreenSaver() function
- add screensaver_private=1 option to the manifest file
```
For a public screensaver, one that you can change from the main Roku theme settings page, you need the following:
```
- Add a RunScreenSaver() function
- Add a RunScreenSaverSettings() function, if you have user changeable options
- add screensaver_private=0 option to manifest file
- Do not add a Main() function so that the channel doesn't appear on the Roku channel menus (or not if you have a nice icon you want to show off)
```
The relevant functions live in `ScreenSaver.brs` and `ScreenSaverSettings.brs`.  Create an archive with the build script, `build.sh` and the resulting zip file will be ready to upload to the development Roku device.
The settings screen code was somewhat hastily put together over a few days (lazy does that to you), so the UI hasn't been tested in SD mode, but there is a check to adjust values in the case the screensaver is targeted to run on one of those older devices.
