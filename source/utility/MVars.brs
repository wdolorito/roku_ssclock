function MVars() as Void
  if ObjectInitialized(m.screen)
    return
  end if

  m.screen = CreateScreen()

  ' Asset dir
  if isHD() <> True
     ' Screen is SD
     m.varsDir = "pkg:/images/sd"
  else
     ' Screen is HD
     m.varsDir = "pkg:/images/hd"
  end if

  ' Safe Dims
  m.actionSafeDims = GetActionSafeDims()
  m.titleSafeDims = GetTitleSafeDims()

  ' Custom Screensaver Objects
  app = CreateObject("roAppManager")
  m.textureManager = InitTextureManager()
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
  m.ampm = False
  m.fontRegistry = CreateObject("roFontRegistry")
  ' Darker Grotesque
  m.fontRegistry.Register("pkg:/fonts/DarkerGrotesque-Regular.ttf")
end function
