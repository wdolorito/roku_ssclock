function RunScreensaver(fromSystem = True) as Void
  MVars()
  screen = m.screen
  port = screen.GetMessagePort()
  screenColor = &h000000FF
  width = m.titleSafeDims.screenWidth
  height = m.titleSafeDims.screenHeight
  xOffset = m.titleSafeDims.xOffset
  yOffset = m.titleSafeDims.yOffset

  if isHD() <> True
    ' Screen is SD
    fontSize = 45
  else
    ' Screen is HD
    fontSize = 100
  end if

  font = RegRead("font")
  if font = "Thin"
    ' Darker Grotesque
    m.fontRegistry.Register("pkg:/fonts/DarkerGrotesque-Regular.ttf")
    textFont = m.fontRegistry.GetFont("Darker Grotesque", fontSize, False, False)
  end if

  if font = "Regular"
    ' Muar Regular
    m.fontRegistry.Register("pkg:/fonts/Muar-Regular.ttf")
    textFont = m.fontRegistry.GetFont("Muar", fontSize, False, False)
  end if

  if font = "Stencil"
    ' Muar Stencil
    m.fontRegistry.Register("pkg:/fonts/Muar-Stencil.ttf")
    textFont = m.fontRegistry.GetFont("Muar", fontSize, False, False)
  end if

  if font = "Script"
    ' Signatura Monoline Script
    m.fontRegistry.Register("pkg:/fonts/Signatura Monoline.ttf")
    textFont = m.fontRegistry.GetFont("Signatura Monoline Script", fontSize, False, False)
  end if

  oneLineHeight = textFont.GetOneLineHeight()

  color = RegRead("color")
  if color = "Red"
    textColor = &hFF0000FF
  end if

  if color = "Green"
    textColor = &h00FF00FF
  end if

  if color = "Blue"
    textColor = &h0000FFFF
  end if

  if color = "Cyan"
    textColor = &h00FFFFFF
  end if

  if color = "Yellow"
    textColor = &hFFFF00FF
  end if

  if color = "Magenta"
    textColor = &hFF00FFFF
  end if

  if color = "White"
    textColor = &hFFFFFFFF
  end if

  x = Rnd(width)
  y = Rnd(height)

  dx = Rnd(3)
  dy = Rnd(3)

  xUp = True
  yUp = True

  while True
    localTime = GetLocalTime(m.ampm)
    date = localTime.date
    time = localTime.time

    wsWidth = m.titleSafeDims.wsWidth

    dateWidth = textFont.GetOneLineWidth(date, wsWidth)
    timeWidth = textFont.GetOneLineWidth(time, wsWidth)

    minX = 0 - dateWidth
    minY = 0 - oneLineHeight - oneLineHeight

    if xUp
      x = x + dx
    else
      x = x - dx
    end if

    if x > width
      xUp = False
      dx = Rnd(10)
    end if

    if x < minX
      xUp = True
      dx = Rnd(10)
    end if

    if yUp
      y = y + dy
    else
      y = y - dy
    end if

    if y > height
      yUp = False
      dy = Rnd(10)
    end if

    if y < minY
      yUp = True
      dy = Rnd(10)
    end if

    m.rndDTWidth = wsWidth - dateWidth
    timeLeftStart = CenterHText(time, textFont, dateWidth)
    timeTopStart = oneLineHeight

    if m.currScreensaverCounter mod 30 = 1
      m.timeMoved = False
    end if

    screen.Clear(screenColor)

    screen.DrawText(date, x, y, textColor, textFont)
    screen.DrawText(time, x + timeLeftStart, y + timeTopStart, textColor, textFont)

    if Type(fromSystem) <> "roAssociativeArray"
      UpdateScreensaver(True)
    else
      UpdateScreensaver(True, True)
    end if
  end while
end function

function UpdateScreensaver(inSS, fromSystem = False) as Void
  m.currScreensaverCounter = m.timer.TotalSeconds() + 1

  if m.currScreensaverCounter < m.screensaverTimeout
    newCount = m.timer.TotalSeconds()

    if newCount <> m.currScreensaverCounter
      m.currScreensaveerCounter = newCount
    end if
  end if

  if m.currScreensaverCounter mod 10 = 0 and m.addedTime = False
    m.currDeviceScreensaverCounter = m.currDeviceScreensaverCounter + 10
    m.addedTime = True
  end if

  if m.currScreensaverCounter mod 10 = 1
    m.addedTime = False
  end if

  if fromSystem = False
    if m.currDeviceScreensaverCounter >= m.deviceScreensaverTimeout
      SendECP(m.screensaverKeycode)
      m.currDeviceScreensaverCounter = 0
    end if
  end if

  if m.currScreensaverCounter >= m.screensaverTimeout
    m.currScreensaverCounter = 0
    m.timer.Mark()

    if inSS = False
      RunScreensaver(fromSystem)
    end if
  end if

  m.screen.SwapBuffers()
end function

function ResetScreensaver(button) as Void
  down = button <> m.screensaverKeyIntDown
  up = button <> m.screensaverKeyIntUp

  if down and up
    m.currDeviceScreensaverCounter = 0
    m.currScreensaverCounter = 0
    m.timer.Mark()
  end if
end function

function GetLocalTime(meridian = False) as Object
  dt = CreateObject("roDateTime")
  dt.ToLocalTime()
  currDate = dt.AsDateStringNoParam()
  currHours = itostr(dt.GetHours())
  currMins = itostr(dt.GetMinutes())
  currSecs = itostr(dt.GetSeconds())

  if currHours.Len() < 2
    currHours = "0" + currHours
  end if

  if currMins.Len() < 2
    currMins = "0" + currMins
  end if

  if currSecs.Len() < 2
    currSecs = "0" + currSecs
  end if

  currTime = currHours + ":" + currMins + ":" + currSecs

  if meridian
    ampm = " "

    if currHours = "00"
      currHours = "12"
    end if

    if currHours.ToInt() >= 13
      currHours = itostr(currHours.ToInt() - 12)

      if currHours.Len() < 2
        currHours = "0" + currHours
      end if

      ampm = ampm + "PM"
    else
      ampm = ampm + "AM"
    end if

    currTime = currHours + ":" + currMins + ":" + currSecs + ampm
  end if

  localTime = {}
  localTime.date = currDate
  localTime.time = currTime

  return localTime
end function
