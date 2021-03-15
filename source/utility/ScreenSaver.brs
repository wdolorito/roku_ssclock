function RunScreensaver(fromSystem = True) as Void
  MVars()
  screen = m.screen
  port = screen.GetMessagePort()
  logo = GetTextureRegion(m.varsDir + "/cov_logo.png", m.textureManager)
  screenColor = &hFFFFFFFF
  width = m.titleSafeDims.screenWidth
  height = m.titleSafeDims.screenHeight
  xOffset = m.titleSafeDims.xOffset
  yOffset = m.titleSafeDims.yOffset

  minX = 0 - logo.GetWidth()
  minY = 0 - logo.GetHeight()

  fontRegistry = CreateObject("roFontRegistry")
  fontRegistry.Register("pkg:/assets/fonts/Lato/Lato-Regular.ttf")

  if isHD() <> True
    ' Screen is SD
    fontSize = 25
  else
    ' Screen is HD
    fontSize = 40
  end if

  textFont = fontRegistry.GetFont("Lato", fontSize, False, False)
  textColor = &h333333FF

  x = Rnd(width)
  y = Rnd(height)

  xUp = True
  yUp = True

  dx = Rnd(10)
  dy = Rnd(10)

  while True
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

    localTime = GetLocalTime(m.ampm)
    date = localTime.date
    time = localTime.time

    wsWidth = m.titleSafeDims.wsWidth

    dateWidth = textFont.GetOneLineWidth(date, wsWidth)
    timeWidth = textFont.GetOneLineWidth(time, wsWidth)

    m.rndDTWidth = wsWidth - dateWidth
    timeLeftStart = CenterHText(time, textFont, dateWidth)
    timeTopStart = textFont.GetOneLineHeight()

    if m.currScreensaverCounter mod 30 = 0 and m.timeMoved = False
      print "time moved "; m.currScreensaverCounter
      m.dtX = xOffset + Rnd(m.rndDTWidth)
      m.dtY = yOffset + Rnd(m.rndDTWidth)
      m.timeMoved = True
    end if

    if m.currScreensaverCounter mod 30 = 1
      m.timeMoved = False
    end if

    dtX = m.dtX
    dtY = m.dtY

    screen.Clear(screenColor)

    screen.DrawText(date, dtX, dtY, textColor, textFont)
    screen.DrawText(time, dtX + timeLeftStart, dtY + timeTopStart, textColor, textFont)

    screen.DrawScaledObject(x, y, 1, 1, logo)

    backNotChecked = True
    while backNotChecked
      msg = port.GetMessage()
      if msg = Invalid
        backNotChecked = False
      else
        if Type(msg) = "roUniversalControlEvent"
          button = msg.GetInt()
          down = button <> m.screensaverKeyIntDown
          up = button <> m.screensaverKeyIntUp
          print "button pressed"; button
          print "down "; down
          print "up "; up
          print "down and up "; down and up
          if down and up
            return
          end if
        end if
      end if
    end while

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
    print "mark"; m.currScreenSaverCounter ; " cdsc" ; m.currDeviceScreensaverCounter
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
    print "screensaver on"
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
