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

  settings = GetSettings()
  m.font = settings.font
  m.ampm = settings.ampm
  m.color = settings.color

  ' Register bundled custom fonts
  m.fontRegistry = CreateObject("roFontRegistry")

  ' Darker Grotesque - Thin
  m.fontRegistry.Register("pkg:/fonts/DarkerGrotesque-Regular.ttf")
  ' Muar Regular - Regular
  m.fontRegistry.Register("pkg:/fonts/Muar-Regular.ttf")
  ' Signatura Monoline Script - Script
  m.fontRegistry.Register("pkg:/fonts/Signatura Monoline.ttf")

  ' Colors
  m.Red = &hFF0000FF
  m.Green = &h00FF00FF
  m.Blue = &h0000FFFF
  m.Cyan = &h00FFFFFF
  m.Yellow = &hFFFF00FF
  m.Magenta = &hFF00FFFF
  m.Black = &h000000FF
  m.White = &hFFFFFFFF
  m.highLight = &h9999997F
end function

function SetDefaults() as Void
  font = ObjectInitialized(RegRead("font"))
  ampm = ObjectInitialized(RegRead("ampm"))
  color = ObjectInitialized(RegRead("color"))

  if font and ampm and color
    return
  end if

  RegDelete("font")
  RegDelete("ampm")
  RegDelete("color")

  RegWrite("font", "Regular")
  RegWrite("ampm", "False")
  RegWrite("color", "White")
end function

function GetSettings() as Object
  settings = {}
  settings.font = RegRead("font")
  settings.ampm = strtobool(RegRead("ampm"))
  settings.color = RegRead("color")

  return settings
end function
