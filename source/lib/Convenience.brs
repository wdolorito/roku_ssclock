function CreateScreen() as Object
  screen = CreateObject("roScreen", True)
  screen.SetAlphaEnable(True)
  port = CreateObject("roMessagePort")
  screen.SetMessagePort(port)
  return screen
end function

function InitTextureManager() as Object
  textureManager = CreateObject("roTextureManager")
  port = CreateObject("roMessagePort")
  textureManager.SetMessagePort(port)

  return textureManager
end function

function ObjectInitialized(object as dynamic) as Boolean
  if Type(object) <> "Invalid" and Type(object) <> "<uninitialized>"
    return True
  else
    return False
  end if
end function

function GetTextureRegion(localpath, textureManager) as Dynamic
  port = textureManager.GetMessagePort()

  texture = invalid
  scale = 1

  request = CreateObject("roTextureRequest", localpath)
  textureManager.RequestTexture(request)

  while True
    msg = wait(5, port)

    if type(msg) = "roTextureRequestEvent" then
      if msg.GetState() = 3 then
        bitmap = msg.GetBitmap()

        if bitmap <> invalid
          texture = CreateObject("roRegion", bitmap, 0, 0, bitmap.GetWidth(), bitmap.GetHeight())
          texture.SetScaleMode(scale)
        end if

        exit while
      end if
    end if
  end while

  return texture
end function

function CenterHText(text, font, maxWidth = 0) as Object
  leftStart = 0

  if maxWidth = 0
    maxWidth = m.titleSafeDims.screenWidth
  end if

  textWidth = font.GetOneLineWidth(text, maxWidth)
  leftStart = (maxWidth - textWidth) * 0.5

  return leftStart
end function

function CenterVText(text, font, maxHeight = 0) as Object
  topStart = 0

  if maxHeight = 0
    maxHeight = m.titleSafeDims.screenHeight
  end if

  textHeight = font.GetOneLineHeight()
  topStart = (maxHeight - textHeight) * 0.5

  return topStart
end function

function GetBlankBM(w, h, clear) as Object
  bmParams = { width : w, height : h, AlphaEnable: False }

  blank = CreateObject("roBitmap", bmParams)
  blank.Clear(clear)

  return blank
end function

function GetMLArr(text, font, width) as Object
  maxWidth = m.titleSafeDims.screenWidth

  mlTokens = text.Tokenize(" ")
  mlArr = []

  mlArr.Push(font)

  maxCount = mlTokens.Count()
  counter = 0
  newLine = False

  while counter < maxCount
    aLine = ""
    prevStart = counter

    currLen = font.GetOneLineWidth(aLine, width)

    while currLen < width
      aLine = aLine + " " + mlTokens[counter]
      aLine.Trim()
      currLen = font.GetOneLineWidth(aLine, maxWidth)

      if mlTokens[counter] = "\n"
        newLine = True
        counter = counter + 1

        exit while
      end if

      counter = counter + 1

      if counter = maxCount
        exit while
      end if
    end while

    if newLine = True
      newLine = False

      aLine = ""

      for count = prevStart to counter - 2 step 1
        aLine = aLine + " " + mlTokens[count]
      end for

      aLine.Trim()
    end if

    if font.GetOneLineWidth(aLine, maxWidth) > width
      aLine = ""

      for count = prevStart to counter - 2 step 1
        aLine = aLine + " " + mlTokens[count]
      end for

      aLine.Trim()
      prevStart = counter - 1
      counter = prevStart
    end if

    mlArr.Push(aLine)
  end while

  return mlArr
end function

function FixMLArr(arr, lines) as Object
  arrLines = arr.Count() - 1
  newLines = lines + 1
  maxCount = arrLines

  if newLines < arrLines
    maxCount = newLines
  end if

  newArr = []

  for count = 0 to maxCount step 1
    newArr.Push(arr[count])
  end for

  lastLine = newArr[newArr.Count() - 1]
  tokenLL = lastLine.Tokenize(" ")

  if lastLine.Len() > 20
    ellipsisLen = 10
    endLen = 0
    endCounter = tokenLL.Count() - 1

    while endLen < ellipsisLen
      endLen = endLen + tokenLL[endCounter].Len()
      endCounter = endCounter - 1
    end while

    lastLine = ""

    for count = 0 to endCounter step 1
      lastLine = lastLine + tokenLL[count] + " "
    end for

    lastLine = lastLine + "..."

    newArr.Pop()
    newArr.Push(lastLine)
  end if

  return newArr
end function

function ReturnDivider(textWidth, margin, dividerColor, clear) as Object
  dividerWidth = textWidth - margin - margin

  dividerBM = GetBlankBM(textWidth, 10, clear)
  dividerBM.DrawRect(margin, 4, dividerWidth, 2, dividerColor)

  return dividerBM
end function

function GetDummyText(font, titleText = "") as Object
  dummyText = []

  dummyText.Push(font)
  if titleText <> ""
    dummyText.Push(titleText)
  end if

  return dummyText
end function

function GetDispAA(field, xOffset, textColor) as Object
  dispAA = {
            name    : field,
            offset  : xOffset,
            color   : textColor
  }

  return dispAA
end function

function GetTitleSafeDims() as Object
  titleSafeDims = {}

  if isHD() <> True
      ' Screen is SD
      titleSafeDims.screenWidth   = 720
      titleSafeDims.screenHeight  = 480
      titleSafeDims.wsWidth       = 576
      titleSafeDims.wsHeight      = 384
      titleSafeDims.xOffset       = 72
      titleSafeDims.yOffset       = 48
  else
  	' Screen is HD
  	titleSafeDims.screenWidth   = 1280
  	titleSafeDims.screenHeight  = 720
  	titleSafeDims.wsWidth       = 1022
  	titleSafeDims.wsHeight      = 578
  	titleSafeDims.xOffset       = 128
  	titleSafeDims.yOffset       = 70
  end if

  return titleSafeDims
end function

function GetActionSafeDims() as Object
  actionSafeDims = {}

  if isHD() <> True
    ' Screen is SD
    actionSafeDims.screenWidth   = 720
    actionSafeDims.screenHeight  = 480
    actionSafeDims.wsWidth       = 648
    actionSafeDims.wsHeight      = 432
    actionSafeDims.xOffset       = 36
    actionSafeDims.yOffset       = 24
  else
  	' Screen is HD
  	actionSafeDims.screenWidth   = 1280
  	actionSafeDims.screenHeight  = 720
  	actionSafeDims.wsWidth       = 1150
  	actionSafeDims.wsHeight      = 646
  	actionSafeDims.xOffset       = 64
  	actionSafeDims.yOffset       = 35
  end if

  return actionSafeDims
end function

function SendECP(keycode) as Void
  xfer = CreateObject("roURLTransfer")
  port = CreateObject("roMessagePort")
  xfer.SetMessagePort(port)

  url = "http://localhost:8060/keypress/" + keycode
  xfer.SetUrl(url)
  xfer.AsyncPostFromString("")

  while True
    msg = port.GetMessage()

    if Type(msg) = "roUrlEvent"
      exit while
    end if
  end while
end function
