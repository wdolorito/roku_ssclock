function CreateScreen() as Object
  screen = CreateObject("roScreen", True)
  screen.SetAlphaEnable(True)
  port = CreateObject("roMessagePort")
  screen.SetMessagePort(port)
  return screen
end function

function ObjectInitialized(object as dynamic) as Boolean
  if Type(object) <> "Invalid" and Type(object) <> "<uninitialized>"
    return True
  else
    return False
  end if
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
