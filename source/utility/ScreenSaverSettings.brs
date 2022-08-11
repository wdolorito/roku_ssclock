function RunScreenSaverSettings() as Void
  MVars()

  if isHD() <> True
    ' Screen is SD
    sssParams = {
      fontSize    : 25,
      fontPadding : 12,
      boxPadding  : 5
    }
  else
    ' Screen is HD
    sssParams = {
      fontSize    : 60,
      fontPadding : 30,
      boxPadding  : 3
    }
  end if

  sssParams.AddReplace("red", m["Red"])
  sssParams.AddReplace("green", m["Green"])
  sssParams.AddReplace("blue", m["Blue"])
  sssParams.AddReplace("cyan", m["Cyan"])
  sssParams.AddReplace("yellow", m["Yellow"])
  sssParams.AddReplace("magenta", m["Magenta"])
  sssParams.AddReplace("black", m["Black"])
  sssParams.AddReplace("white", m["White"])
  sssParams.AddReplace("highLight", m["highLight"])
  sssParams.AddReplace("xOffset", m.actionSafeDims.xOffset)
  sssParams.AddReplace("yOffset", m.actionSafeDims.yOffset)
  sssParams.AddReplace("wsWidth", m.actionSafeDims.wsWidth)
  sssParams.AddReplace("posX", 0)
  sssParams.AddReplace("posY", 0)
  sssParams.AddReplace("navMap", InitNavMap())


  fontParams = CalcFontOptions(sssParams)
  colorParams = CalcColorOptions(sssParams, fontParams)
  timeParams = CalcTimeOptions(sssParams, fontParams, colorParams)
  maskParams = CalcMasks(sssParams, fontParams, colorParams, timeParams)

  screen = m.screen
  port = screen.GetMessagePort()

  backDown = False
  upDown = False
  downDown = False
  leftDown = False
  rightDown = False
  selectDown = False

  while True ' main settings loop
    ' clear screen
    screen.Clear(sssParams.black)

    msg = port.GetMessage()

    if Type(msg) = "roUniversalControlEvent" then
        button = msg.GetInt()

        if button = 0 then                                ' Back
          backDown = True
        else if button = 100 and backDown = True then     ' Back <up>
          backDown = False
          return
        else if button = 2 then                           ' Up
          upDown = True
        else if button = 102 and upDown = True then       ' Up <up>
          upDown = False
          sssParams = MoveYPos(sssParams, False)
        else if button = 3 then                           ' Down
          downDown = True
        else if button = 103 and downDown = True then     ' Down <up>
          downDown = False
          sssParams = MoveYPos(sssParams)
        else if button = 4 then                           ' Left
          leftDown = True
        else if button = 104 and leftDown = True then     ' Left <up>
          leftDown = False
          sssParams = MoveXPos(sssParams, False)
        else if button = 5 then                           ' Right
          rightDown = True
        else if button = 105 and rightDown = True then    ' Right <up>
          rightDown = False
          sssParams = MoveXPos(sssParams)
        else if button = 6 then                           ' Select
          selectDown = True
        else if button = 106 and selectDown = True then   ' Select <up>
          selectDown = False
          StoreSettings(sssParams)
        end if
    end if

    DrawFontOptions(sssParams, fontParams)
    DrawColorOptions(sssParams, fontParams, colorParams)
    DrawTimeOption(sssParams, fontParams, timeParams)
    DrawMasks(sssParams, maskParams)

    ' display buffer
    screen.SwapBuffers()
  end while ' end main settings loop
end function

function InitNavMap() as Object
  Dim map[8, 2]

  map[0, 0] = "Thin"
  map[0, 1] = "Thin"
  map[1, 0] = "Regular"
  map[1, 1] = "Regular"
  map[2, 0] = "Script"
  map[2, 1] = "Script"
  map[3, 0] = "Red"
  map[3, 1] = "Yellow"
  map[4, 0] = "Green"
  map[4, 1] = "Magenta"
  map[5, 0] = "Blue"
  map[5, 1] = "White"
  map[6, 0] = "Cyan"
  map[6, 1] = "Cyan"
  map[7, 0] = "toggle"
  map[7, 1] = "toggle"

  return map
end function

function MoveXPos(params, dir = True) as Object
  posX = params.posX

  if dir = True
    if posX = 0
      posX = 1
    end if
  else
    if posX = 1
      posX = 0
    end if
  end if

  params.AddReplace("posX", posX)

  return params
end function

function MoveYPos(params, dir = True) as Object
  posY = params.posY

  if dir = True
    if posY < 8
      posY = posY + 1
    end if
  else
    if posY > 0
      posY = posY - 1
    end if
  end if

  params.AddReplace("posY", posY)
  return params
end function

function CalcFontOptions(params) as Object
  xOffset = params.xOffset
  wsWidth = params.wsWidth
  fontSize = params.fontSize
  font = m.fontRegistry.GetFont("Darker Grotesque", fontSize, False, False)
  regularFont = m.fontRegistry.GetFont("Muar", fontSize, False, False)
  scriptFont = m.fontRegistry.GetFont("Signatura Monoline Script", fontSize, False, False)

  fontPrompt = "Font"
  thinText = "Thin"
  regularText = "Regular"
  scriptText = "Script"

  fontPromptW = font.GetOneLineWidth(fontPrompt, wsWidth)
  fontPadding = params.fontPadding

  options = {
    thinFont    : font,
    regularFont : regularFont,
    scriptFont  : scriptFont,

    font        : font,

    fontPrompt  : fontPrompt,
    thinText    : thinText,
    regularText : regularText,
    scriptText  : scriptText,

    fontPromptW : fontPromptW,
    fontPromptH : font.GetOneLineHeight(),

    thinTextW : font.GetOneLineWidth(thinText, wsWidth),
    thinTextH : font.GetOneLineHeight(),

    regularTextW : regularFont.GetOneLineWidth(regularText, wsWidth),
    regularTextH : regularFont.GetOneLineHeight(),

    scriptTextW : scriptFont.GetOneLineWidth(scriptText, wsWidth),
    scriptTextH : scriptFont.GetOneLineHeight(),

    fontOptPadding : xOffset + fontPromptW + fontPadding + fontPadding
  }

  return options
end function

function CalcColorOptions(params, fontParams) as Object
  xOffset = params.xOffset
  yOffset = params.yOffset
  wsWidth = params.wsWidth
  font = fontParams.font

  colorPrompt = "Color"
  redText = "Red"
  greenText = "Green"
  blueText = "Blue"
  cyanText = "Cyan"
  yellowText = "Yellow"
  magentaText = "Magenta"
  whiteText = "White"

  colorPromptW = font.GetOneLineWidth(colorPrompt, wsWidth)
  colorPromptH = font.GetOneLineHeight()
  greenTextW = font.GetOneLineWidth(greenText, wsWidth)
  fontPadding = params.fontPadding
  colorOptPadding = xOffset + colorPromptW + fontPadding + fontPadding

  fontPromptH = fontParams.fontPromptH
  regularTextH = fontParams.regularTextH
  scriptTextH = fontParams.scriptTextH

  options = {
    colorPrompt : colorPrompt,
    redText     : redText,
    greenText   : greenText,
    blueText    : blueText,
    cyanText    : cyanText,
    yellowText  : yellowText,
    magentaText : magentaText,
    whiteText   : whiteText,

    colorPromptW : colorPromptW,
    colorPromptH : colorPromptH,

    redTextW : font.GetOneLineWidth(redText, wsWidth),
    redTextH : font.GetOneLineHeight(),

    greenTextW : font.GetOneLineWidth(greenText, wsWidth),
    greenTextH : font.GetOneLineHeight(),

    blueTextW : font.GetOneLineWidth(blueText, wsWidth),
    blueTextH : font.GetOneLineHeight(),

    cyanTextW : font.GetOneLineWidth(cyanText, wsWidth),
    cyanTextH : font.GetOneLineHeight(),

    yellowTextW : font.GetOneLineWidth(yellowText, wsWidth),
    yellowTextH : font.GetOneLineHeight(),

    magentaTextW : font.GetOneLineWidth(magentaText, wsWidth),
    magentaTextH : font.GetOneLineHeight(),

    whiteTextW : font.GetOneLineWidth(whiteText, wsWidth),
    whiteTextH : font.GetOneLineHeight(),

    colorOptPadding  : colorOptPadding,
    colorOptPadding2 : colorOptPadding + greenTextW + fontPadding + fontPadding,
    colorOptStartY   : yOffset + fontPromptH + regularTextH + scriptTextH + fontPadding
  }

  return options
end function

function CalcTimeOptions(params, fontParams, colorParams) as Object
  wsWidth = params.wsWidth
  font = fontParams.font
  colorOptStartY = colorParams.colorOptStartY
  colorPromptH = colorParams.colorPromptH
  greenTextH = colorParams.greenTextH
  blueTextH = colorParams.blueTextH
  cyanTextH = colorParams.cyanTextH
  fontPadding = params.fontPadding

  timePrompt = "24 hour format"

  options = {
    timePrompt : timePrompt,

    timePromptW : font.GetOneLineWidth(timePrompt, wsWidth),
    timePromptH : font.GetOneLineHeight(),

    timeOptStartY : colorOptStartY + colorPromptH + greenTextH + blueTextH + cyanTextH + fontPadding
  }

  return options
end function

function CalcMasks(params, fontParams, colorParams, timeParams) as Object
  boxPadding = params.boxPadding
  bp2 = boxPadding + boxPadding
  xOffset = params.XOffset
  yOffset = params.yOffset

  fontOptPadding = fontParams.fontOptPadding
  fontPromptH = fontParams.fontPromptH
  thinTextH = fontParams.thinTextH
  thinTextW = fontParams.thinTextW
  regularTextH = fontParams.regularTextH
  regularTextW = fontParams.regularTextW
  scriptTextH = fontParams.scriptTextH
  scriptTextW = fontParams.scriptTextW

  colorOptPadding = colorParams.colorOptPadding
  colorOptPadding2 = colorParams.colorOptPadding2
  colorOptStartY = colorParams.colorOptStartY
  redTextH = colorParams.redTextH
  redTextW = colorParams.redTextW
  greenTextH = colorParams.greenTextH
  greenTextW = colorParams.greenTextW
  blueTextH = colorParams.blueTextH
  blueTextW = colorParams.blueTextW
  cyanTextH = colorParams.cyanTextH
  cyanTextW = colorParams.cyanTextW
  yellowTextH = colorParams.yellowTextH
  yellowTextW = colorParams.yellowTextW
  magentaTextH = colorParams.magentaTextH
  magentaTextW = colorParams.magentaTextW
  whiteTextH = colorParams.whiteTextH
  whiteTextW = colorParams.whiteTextW

  timeOptStartY = timeParams.timeOptStartY
  timePromptH = timeParams.timePromptH
  timePromptW = timeParams.timePromptW

  options = {
    thinBoxX : fontOptPadding - boxPadding,
    thinBoxY : yOffset - boxPadding,
    thinBoxW : thinTextW + bp2,
    thinBoxH : thinTextH + bp2,

    regularBoxX : fontOptPadding - boxPadding,
    regularBoxY : yOffset - boxPadding + fontPromptH,
    regularBoxW : regularTextW + bp2,
    regularBoxH : regularTextH + bp2,

    scriptBoxX : fontOptPadding - boxPadding,
    scriptBoxY : yOffset - boxPadding + fontPromptH + regularTextH,
    scriptBoxW : scriptTextW + bp2,
    scriptBoxH : scriptTextH + bp2,

    redBoxX : colorOptPadding - boxPadding,
    redBoxY : colorOptStartY - boxPadding,
    redBoxW : redTextW + bp2,
    redBoxH : redTextH + bp2,

    greenBoxX : colorOptPadding - boxPadding,
    greenBoxY : colorOptStartY - boxPadding + redTextH,
    greenBoxW : greenTextW + bp2,
    greenBoxH : greenTextH + bp2,

    blueBoxX : colorOptPadding - boxPadding,
    blueBoxY : colorOptStartY - boxPadding + redTextH + greenTextH,
    blueBoxW : blueTextW + bp2,
    blueBoxH : blueTextH + bp2,

    cyanBoxX : colorOptPadding - boxPadding,
    cyanBoxY : colorOptStartY - boxPadding + redTextH + greenTextH + blueTextH,
    cyanBoxW : cyanTextW + bp2,
    cyanBoxH : cyanTextH + bp2,

    yellowBoxX : colorOptPadding2 - boxPadding,
    yellowBoxY : colorOptStartY - boxPadding,
    yellowBoxW : yellowTextW + bp2,
    yellowBoxH : yellowTextH + bp2,

    magentaBoxX : colorOptPadding2 - boxPadding,
    magentaBoxY : colorOptStartY - boxPadding + yellowTextH,
    magentaBoxW : magentaTextW + bp2,
    magentaBoxH : magentaTextH + bp2,

    whiteBoxX : colorOptPadding2 - boxPadding,
    whiteBoxY : colorOptStartY - boxPadding + yellowTextH + magentaTextH,
    whiteBoxW : whiteTextW + bp2,
    whiteBoxH : whiteTextH + bp2,

    timeBoxX : xOffset - boxPadding,
    timeBoxY : timeOptStartY - boxPadding,
    timeBoxW : timePromptW + bp2,
    timeBoxH : timePromptH + bp2
  }
  return options
end function

function DrawFontOptions(params, fontParams) as Void
  fontColor = m["White"]
  font = fontParams.font
  fontPrompt = fontParams.fontPrompt
  xOffset = params.xOffset
  yOffset = params.yOffset
  fontPromptH = fontParams.fontPromptH
  regularTextH = fontParams.regularTextH
  thinText = fontParams.thinText
  regularText = fontParams.regularText
  scriptText = fontParams.scriptText
  thinFont = fontParams.thinFont
  regularFont = fontParams.regularFont
  scriptFont = fontParams.scriptFont
  fontOptPadding = fontParams.fontOptPadding

  offset = yOffset
  m.screen.DrawText(fontPrompt, xOffset, offset, fontColor, font)
  m.screen.DrawText(thinText, fontOptPadding, offset, fontColor, thinFont)
  offset = offset + fontPromptH
  m.screen.DrawText(regularText, fontOptPadding, offset, fontColor, regularFont)
  offset = offset + regularTextH
  m.screen.DrawText(scriptText, fontOptPadding, offset, fontColor, scriptFont)
end function

function DrawColorOptions(params, fontParams, colorParams) as Void
  red = params.red
  green = params.green
  blue = params.blue
  cyan = params.cyan
  yellow = params.yellow
  magenta = params.magenta
  white = params.white
  font = fontParams.font
  colorPrompt = colorParams.colorPrompt
  redText = colorParams.redText
  greenText = colorParams.greenText
  blueText = colorParams.blueText
  cyanText = colorParams.cyanText
  yellowText = colorParams.yellowText
  magentaText = colorParams.magentaText
  whiteText = colorParams.whiteText
  redTextH = colorParams.redTextH
  greenTextH = colorParams.greenTextH
  blueTextH = colorParams.blueTextH
  yellowTextH = colorParams.yellowTextH
  magentaTextH = colorParams.magentaTextH
  xOffset = params.xOffset
  colorOptStartY = colorParams.colorOptStartY
  colorOptPadding = colorParams.colorOptPadding
  colorOptPadding2 = colorParams.colorOptPadding2

  offset = colorOptStartY
  m.screen.DrawText(colorPrompt, xOffset, offset, white, font)
  m.screen.DrawText(redText, colorOptPadding, offset, red, font)
  offset = offset + redTextH
  m.screen.DrawText(greenText, colorOptPadding, offset, green, font)
  offset = offset + greenTextH
  m.screen.DrawText(blueText, colorOptPadding, offset, blue, font)
  offset = offset + blueTextH
  m.screen.DrawText(cyanText, colorOptPadding, offset, cyan, font)
  offset = colorOptStartY
  m.screen.DrawText(yellowText, colorOptPadding2, offset, yellow, font)
  offset = offset + yellowTextH
  m.screen.DrawText(magentaText, colorOptPadding2, offset, magenta, font)
  offset = offset + magentaTextH
  m.screen.DrawText(whiteText, colorOptPadding2, offset, white, font)
end function

function DrawTimeOption(params, fontParams, timeParams) as Void
  timePrompt = timeParams.timePrompt
  xOffset = params.xOffset
  white = params.white
  timeOptStartY = timeParams.timeOptStartY
  font = fontParams.font

  m.screen.DrawText(timePrompt, xOffset, timeOptStartY, white, font)
end function

function DrawMasks(params, maskParams) as Void
  settings = GetSettings()
  font = settings.font
  color = settings.color
  ampm = settings.ampm
  highLight = params.highLight

  thinBoxX = maskParams.thinBoxX
  thinBoxY = maskParams.thinBoxY
  thinBoxW = maskParams.thinBoxW
  thinBoxH = maskParams.thinBoxH
  regularBoxX = maskParams.regularBoxX
  regularBoxY = maskParams.regularBoxY
  regularBoxW = maskParams.regularBoxW
  regularBoxH = maskParams.regularBoxH
  scriptBoxX = maskParams.scriptBoxX
  scriptBoxY = maskParams.scriptBoxY
  scriptBoxW = maskParams.scriptBoxW
  scriptBoxH = maskParams.scriptBoxH

  redBoxX = maskParams.redBoxX
  redBoxY = maskParams.redBoxY
  redBoxW = maskParams.redBoxW
  redBoxH = maskParams.redBoxH
  greenBoxX = maskParams.greenBoxX
  greenBoxY = maskParams.greenBoxY
  greenBoxW = maskParams.greenBoxW
  greenBoxH = maskParams.greenBoxH
  blueBoxX = maskParams.blueBoxX
  blueBoxY = maskParams.blueBoxY
  blueBoxW = maskParams.blueBoxW
  blueBoxH = maskParams.blueBoxH
  cyanBoxX = maskParams.cyanBoxX
  cyanBoxY = maskParams.cyanBoxY
  cyanBoxW = maskParams.cyanBoxW
  cyanBoxH = maskParams.cyanBoxH
  yellowBoxX = maskParams.yellowBoxX
  yellowBoxY = maskParams.yellowBoxY
  yellowBoxW = maskParams.yellowBoxW
  yellowBoxH = maskParams.yellowBoxH
  magentaBoxX = maskParams.magentaBoxX
  magentaBoxY = maskParams.magentaBoxY
  magentaBoxW = maskParams.magentaBoxW
  magentaBoxH = maskParams.magentaBoxH
  whiteBoxX = maskParams.whiteBoxX
  whiteBoxY = maskParams.whiteBoxY
  whiteBoxW = maskParams.whiteBoxW
  whiteBoxH = maskParams.whiteBoxH

  timeBoxX = maskParams.timeBoxX
  timeBoxY = maskParams.timeBoxY
  timeBoxW = maskParams.timeBoxW
  timeBoxH = maskParams.timeBoxH

  navMap = params.navMap
  posY = params.posY
  posX = params.posX
  selection = navMap[posY, posX]

  ' font option masks
  if font = "Thin" or selection = "Thin"
    m.screen.DrawRect(thinBoxX, thinBoxY, thinBoxW, thinBoxH, highLight)
  end if
  if font = "Regular" or selection = "Regular"
    m.screen.DrawRect(regularBoxX, regularBoxY, regularBoxW, regularBoxH, highLight)
  end if
    if font = "Script" or selection = "Script"
  m.screen.DrawRect(scriptBoxX, scriptBoxY, scriptBoxW, scriptBoxH, highLight)
  end if

  ' color option masks
  if color = "Red" or selection = "Red"
    m.screen.DrawRect(redBoxX, redBoxY, redBoxW, redBoxH, highLight)
  end if
  if color = "Green" or selection = "Green"
    m.screen.DrawRect(greenBoxX, greenBoxY, greenBoxW, greenBoxH, highLight)
  end if
  if color = "Blue" or selection = "Blue"
    m.screen.DrawRect(blueBoxX, blueBoxY, blueBoxW, blueBoxH, highLight)
  end if
  if color = "Cyan" or selection = "Cyan"
    m.screen.DrawRect(cyanBoxX, cyanBoxY, cyanBoxW, cyanBoxH, highLight)
  end if
  if color = "Yellow" or selection = "Yellow"
    m.screen.DrawRect(yellowBoxX, yellowBoxY, yellowBoxW, yellowBoxH, highLight)
  end if
  if color = "Magenta" or selection = "Magenta"
    m.screen.DrawRect(magentaBoxX, magentaBoxY, magentaBoxW, magentaBoxH, highLight)
  end if
  if color = "White" or selection = "White"
    m.screen.DrawRect(whiteBoxX, whiteBoxY, whiteBoxW, whiteBoxH, highLight)
  end if

  ' time option mask
  if ampm = False or selection = "toggle"
    m.screen.DrawRect(timeBoxX, timeBoxY, timeBoxW, timeBoxH, highLight)
  end if
end function
