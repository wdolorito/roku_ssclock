function MVars() as Void
  if ObjectInitialized(m.screen)
    return
  end if

  SetDefaults()

  m.screen = CreateScreen()

  ' Safe Dims
  m.actionSafeDims = GetActionSafeDims()
  m.titleSafeDims = GetTitleSafeDims()

  ' Custom Screensaver Objects
  app = CreateObject("roAppManager")
  m.di = CreateObject("roDeviceInfo")
  m.timer = CreateObject("roTimespan")
  m.deviceScreensaverTimeout = (app.GetScreenSaverTimeout() * 60) - 20
  m.screensaverTimeout = 1 * 60
  m.screensaverKeycode = "Lit_%E2%9C%8A"
  m.screensaverKeyIntDown = 9994
  m.screensaverKeyIntUp = 10094
  m.currDeviceScreensaverCounter = m.di.TimeSinceLastKeypress()
  m.currScreensaverCounter = 0
  m.addedTime = False
  m.rndDTWidth = 0
  m.ampm = strtobool(RegRead("ampm"))
  m.fontRegistry = CreateObject("roFontRegistry")
end function

function SetDefaults() as Void
  RegDelete("font")
  RegDelete("ampm")
  RegDelete("font")
  RegDelete("haveSettings")

  RegWrite("font", "Thin")
  RegWrite("ampm", "False")
  RegWrite("color", "White")
  RegWrite("haveSettings", "True")
end function
