function MVars() as Void
  if ObjectInitialized(m.screen)
    return
  end if

  m.screen = CreateScreen()

  ' Asset dir
  if isHD() <> True
     Screen is SD
     m.varsDir = "pkg:/assets/sd"
  else
     Screen is HD
     m.varsDir = "pkg:/assets/hd"
  end if

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
  m.timeMoved = True
  m.dtX = m.titleSafeDims.xOffset + Rnd(250)
  m.dtY = m.titleSafeDims.yOffset + Rnd(150)
  m.rndDTWidth = 0
  m.ampm = False
end function
