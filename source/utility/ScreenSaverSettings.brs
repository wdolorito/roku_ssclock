function RunScreenSaverSettings() as Void
  MVars()

  if isHD() <> True
    ' Screen is SD
    fontSize = 25
    fontPadding = 12
  else
    ' Screen is HD
    fontSize = 60
    fontPadding = 30
  end if

  red = m["Red"]
  green = m["Green"]
  blue = m["Blue"]
  cyan = m["Cyan"]
  yellow = m["Yellow"]
  magenta = m["Magenta"]
  black = m["Black"]
  white = m["White"]
  xOffset = m.actionSafeDims.xOffset
  yOffset = m.actionSafeDims.yOffset
  wsWidth = m.actionSafeDims.wsWidth
  wsHeight = m.actionSafeDims.wsHeight
  
  thinFont = m.fontRegistry.GetFont("Darker Grotesque", fontSize, False, False)
  regularFont = m.fontRegistry.GetFont("Muar", fontSize, False, False)
  scriptFont = m.fontRegistry.GetFont("Signatura Monoline Script", fontSize, False, False)

  font = thinFont
  ' strFont = m.font

  ' if strFont = "Thin"
  '   font = thinFont
  ' end if
  ' if strFont = "Regular"
  '   font = regularFont
  ' end if
  ' if strFont = "Script"
  '   font = scriptFont
  ' end if

  fontColor = m[m.color]

  ' font options position calculations
  fontPrompt = "Font"
  thinText = "Thin"
  regularText = "Regular"
  scriptText = "Script"

  fontPromptW = font.GetOneLineWidth(fontPrompt, m.screen.GetWidth())
  fontPromptH = font.GetOneLineHeight()

  thinTextW = font.GetOneLineWidth(thinText, m.screen.GetWidth())
  thinTextH = font.GetOneLineHeight()

  regularTextW = font.GetOneLineWidth(regularText, m.screen.GetWidth())
  regularTextH = font.GetOneLineHeight()

  scriptTextW = font.GetOneLineWidth(scriptText, m.screen.GetWidth())
  scriptTextH = font.GetOneLineHeight()

  fontOptPadding = xOffset + fontPromptW + fontPadding + fontPadding

  ' color options position calculations

  colorPrompt = "Color"
  redText = "Red"
  greenText = "Green"
  blueText = "Blue"
  cyanText = "Cyan"
  yellowText = "Yellow"
  magentaText = "Magenta"
  whiteText = "White"

  colorPromptW = font.GetOneLineWidth(fontPrompt, m.screen.GetWidth())
  colorPromptH = font.GetOneLineHeight()

  redTextW = font.GetOneLineWidth(redText, m.screen.GetWidth())
  redTextH = font.GetOneLineHeight()

  greenTextW = font.GetOneLineWidth(greenText, m.screen.GetWidth())
  greenTextH = font.GetOneLineHeight()

  blueTextW = font.GetOneLineWidth(blueText, m.screen.GetWidth())
  blueTextH = font.GetOneLineHeight()

  cyanTextW = font.GetOneLineWidth(cyanText, m.screen.GetWidth())
  cyanTextH = font.GetOneLineHeight()

  yellowTextW = font.GetOneLineWidth(yellowText, m.screen.GetWidth())
  yellowTextH = font.GetOneLineHeight()

  magentaTextW = font.GetOneLineWidth(magentaText, m.screen.GetWidth())
  magentaTextH = font.GetOneLineHeight()

  whiteTextW = font.GetOneLineWidth(whiteText, m.screen.GetWidth())
  whiteTextH = font.GetOneLineHeight()

  colorOptPadding = xOffset + colorPromptW + fontPadding + fontPadding
  colorOptPadding2 = colorOptPadding + greenTextW + fontPadding + fontPadding
  colorOptStartY = yOffset + fontPromptH + regularTextH + scriptTextH + fontPadding

  ' time options position calculations

  timePrompt = "24 hour format"

  timePromptW = font.GetOneLineWidth(timePrompt, m.screen.GetWidth())
  timePromptH = font.GetOneLineHeight()
  timeOptStartY = colorOptStartY + colorPromptH + greenTextH + blueTextH + cyanTextH + fontPadding

  while True ' main settings loop
    m.screen.Clear(black)

    ' font options draw to buffer
    offset = yOffset
    m.screen.DrawText(fontPrompt, xOffset, offset, fontColor, font)
    m.screen.DrawText(thinText, fontOptPadding, offset, fontColor, thinFont)
    offset = offset + fontPromptH
    m.screen.DrawText(regularText, fontOptPadding, offset, fontColor, regularFont)
    offset = offset + regularTextH
    m.screen.DrawText(scriptText, fontOptPadding, offset, fontColor, scriptFont)

    ' color options draw to buffer
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

    ' ampm option draw to buffer
    m.screen.DrawText(timePrompt, xOffset, timeOptStartY, white, font)

    ' display buffer
    m.screen.SwapBuffers()
  end while ' end main settings loop
end function
