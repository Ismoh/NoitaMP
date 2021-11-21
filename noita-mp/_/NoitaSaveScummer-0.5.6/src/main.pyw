import os
import io
import time
import subprocess
import sys
from threading import Thread
import datetime
import tarfile
import ctypes
import shutil
import webbrowser
from enum import Enum

from system_hotkey import SystemHotkey
import yaml
import win32api
import win32gui
import win32process
import win32con
import keyboard
import psutil
import wx
from wx.lib.newevent import NewEvent
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler
import locale

from mem_resources.resources import *

config = {
   'saveFolderPath' : os.path.expanduser('~') + '\\AppData\\LocalLow\\Nolla_Games_Noita',
   'hotkey_save': ('control', 'alt', 'f5'),
   'hotkey_saveQuick': ('control', 'shift', 'f5'),
   'hotkey_load': ('control', 'alt', 'f9'),
   'hotkey_loadQuick': ('control', 'shift', 'f9'),
   'autoclose': True,
   'launch_on_load': False,
   'executable_path': '',
   '7z_path': '',
   'steam_launch': '',
   'use_steam_launch': True,
   'launch_arguments': ['-no_logo_splashes', '-gamemode 4294967295', '-save_slot 0'],
   'display_save_status' : True
}

colors = {
   'border':           wx.Colour(240, 207, 116),
   'border-light':     wx.Colour(107, 101,  96),
   'background':       wx.Colour( 37,  33,  30),
   'content':          wx.Colour( 24,  23,  21),
   'save-item':        wx.Colour( 18,  17,  14),
   'hover-red':        wx.Colour(165,  45,  52),
   'hover-light':      wx.Colour( 63,  53,  39),
   'main-text':        wx.Colour(255, 252, 241),
   'secondary-text':   wx.Colour(156, 155, 145),
   'text-input':       wx.Colour( 11,  10,   6),
   'button':           wx.Colour(214, 214, 207),
   'button-hover':     wx.Colour(218, 217, 152),
   'button-red':       wx.Colour( 83,  27,  27),
   'progress-pending': wx.Colour( 51,  45,  18),
   'progress':         wx.Colour(205, 196,  72)
}

scanCodes = {
   0x02: '1',
   0x03: '2',
   0x04: '3',
   0x05: '4',
   0x06: '5',
   0x07: '6',
   0x08: '7',
   0x09: '8',
   0x0a: '9',
   0x0b: '0',

   0x10: 'q',
   0x11: 'w',
   0x12: 'e',
   0x13: 'r',
   0x14: 't',
   0x15: 'y',
   0x16: 'u',
   0x17: 'i',
   0x18: 'o',
   0x19: 'p',

   0x1e: 'a',
   0x1f: 's',
   0x20: 'd',
   0x21: 'f',
   0x22: 'g',
   0x23: 'h',
   0x24: 'j',
   0x25: 'k',
   0x26: 'l',

   0x2c: 'z',
   0x2d: 'x',
   0x2e: 'c',
   0x2f: 'v',
   0x30: 'b',
   0x31: 'n',
   0x32: 'm',

   0x3b: 'f1',
   0x3c: 'f2',
   0x3d: 'f3',
   0x3e: 'f4',
   0x3f: 'f5',
   0x40: 'f6',
   0x41: 'f7',
   0x42: 'f8',
   0x43: 'f9',
   0x44: 'f10',
   0x57: 'f11',
   0x58: 'f12',

   0x1d: 'control',
   0x2a: 'shift', 0x36: 'shift',
   0x38: 'alt', 0xe038: 'alt',
   0x5b: 'super', 0x5c: 'super',
}

class Action(Enum):
   delete = 0
   load = 1
   save = 2

saveFiles = {}

saveStatus = {
   'player_pos': None
}

def toAscii(code):
   try:
      return scanCodes[code]
   except:
      return None

def readConfig():
   os.chdir(working_dir)
   if os.path.exists('./config.yaml'):
      global config
      with open('./config.yaml', 'r') as file:
         config_file = yaml.load(file, Loader=yaml.FullLoader)
         if config_file:
            for item in config:
               if item in config_file:
                  value = config_file[item]
                  if value != '':
                     config[item] = value

def writeConfig():
   os.chdir(working_dir)
   with open("./config.yaml" , "w") as file:
      yaml.dump(config , file)

def focusWindow():
   if window.IsIconized():
      window.Restore()
   win32gui.SetForegroundWindow(window.GetHandle())

def hitTest(rect, point):
   deltaX = point[0] - rect[0]
   deltaY = point[1] - rect[1]

   return deltaX > 0 and deltaX < rect[2] and deltaY > 0 and deltaY < rect[3]

def get_hwnds_for_pid(pid):
   def callback(hwnd, hwnds):
      if win32gui.IsWindowVisible (hwnd) and win32gui.IsWindowEnabled(hwnd):
         _, found_pid = win32process.GetWindowThreadProcessId(hwnd)
         if found_pid == pid:
            hwnds.append(hwnd)
      return True

   hwnds = []
   win32gui.EnumWindows(callback, hwnds)
   return hwnds

def findProcess(procName):
   for proc in psutil.process_iter():
      if procName == proc.name().lower():
         return proc
   return None

def waitForNoitaTermination(action):
   proc = findProcess('noita.exe')
   if proc:
      config['executable_path'] = proc.exe()

      if config['autoclose']:
         hwnd = get_hwnds_for_pid(proc.pid)
         if len(hwnd) > 0:
            hwnd = hwnd[0]
            try:
               win32gui.PostMessage(hwnd, win32con.WM_CLOSE, 0, 0)
            except:
               pass

      while psutil.pid_exists(proc.pid):
         try:
            if psutil.Process(proc.pid).name().lower() != 'noita.exe':
               break
         except:
            pass
         time.sleep(0.1)

      return config['autoclose'], True
   return config['launch_on_load'] if action == Action.load else False, True

def findExecutable(binary_loc, prefix_prog_files, prefix_independent):
   candidates = []

   candidates.append(os.path.expandvars('%programfiles(x86)%') + prefix_prog_files + binary_loc)
   candidates.append(os.path.expandvars('%programfiles%') + prefix_prog_files + binary_loc)

   drives = win32api.GetLogicalDriveStrings()
   drives = drives.split('\0')[:-1]
   for drive in drives:
      candidates.append(drive + prefix_independent + binary_loc)

   for candidate in candidates:
      if os.path.exists(candidate):
         return candidate

   return ''

def findNoita():
   global config
   if os.path.exists(config.get('executable_path')):
      return

   proc = findProcess('noita.exe')
   if proc:
      config['executable_path'] = proc.exe()
      return

   path = findExecutable('\\steamapps\\common\\Noita\\Noita.exe', '\\Steam', '\\SteamLibrary')
   if path != '':
      config['executable_path'] = path

def findSteam():
   global config
   if os.path.exists(config.get('steam_launch')):
      return

   proc = findProcess('steam.exe')
   if proc:
      config['steam_launch'] = proc.exe()
      return

   path = findExecutable('\\Steam\\steam.exe', '', '')
   if path != '':
      config['steam_launch'] = path

def find7Zip():
   envPath = shutil.which('7z.exe')
   if envPath:
      return envPath

   return findExecutable('\\7-Zip\\7z.exe', '', '')

def stylizeBorder(element):
   if hasattr(element, 'styleBorder') and element.styleBorder:
      for border in element.styleBorder:
         border.Destroy()

   element.styleBorder = []
   element.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
   size = element.GetSize()
   positions = [
      (2, 0),
      (2, size.GetHeight() - 2),
      (0, 2),
      (size.GetWidth() - 2, 2)
   ]
   sizes = [
      (size.GetWidth() - 4, 2),
      (size.GetWidth() - 4, 2),
      (2, size.GetHeight() - 4),
      (2, size.GetHeight() - 4)
   ]

   for i in range(0, len(positions)):
      element.styleBorder.append(wx.Panel(element, pos = positions[i], size = sizes[i]))
      element.styleBorder[-1].SetBackgroundColour(element.GetBackgroundColour())

def selectArchiveTool():
   extension = '.tar'

   if not os.path.exists(config.get('7z_path')):
      config['7z_path'] = find7Zip()
   if config['7z_path'] != '':
      extension = '.7z'

   return extension

def getTextInQuotes(source, start):
   if source[start] != '"':
      return None

   result = ''
   pos = start + 1
   while source[pos] != '"':
      result += source[pos]
      pos += 1

   return result if len(result) else None

def updatePlayerSaveStatus():
   time.sleep(2)
   with open(config['saveFolderPath'] + '\\save00\\player.xml', 'r') as file:
      content = file.read()
      posXStr = 'position.x='
      posYStr = 'position.y='

      try:
         xValue = getTextInQuotes(content, content.index(posXStr) + len(posXStr))
         yValue = getTextInQuotes(content, content.index(posYStr) + len(posYStr))
      except:
         return

      if xValue and yValue:
         try:
            saveStatus['player_pos'] = (int(float(xValue)), int(float(yValue)))
            window.saveStatusChanged()
         except:
            pass

def saveDirChangeHandler(event):
   if event.src_path.endswith('\\player.xml'):
      thread = Thread(target = updatePlayerSaveStatus)
      thread.start()

def watchSaveDirectory():
   thread = Thread(target = updatePlayerSaveStatus)
   thread.start()

   eventHandler = PatternMatchingEventHandler(['*'], None, False, True)
   eventHandler.on_created = saveDirChangeHandler
   eventHandler.on_modified = saveDirChangeHandler

   saveDirObserver = Observer()
   saveDirObserver.schedule(eventHandler, config['saveFolderPath'], recursive = True)
   saveDirObserver.start()

   return saveDirObserver

class ScaledBitmap (wx.Bitmap):
   def __init__(self, data, width, height, quality = wx.IMAGE_QUALITY_HIGH):
      image = wx.Image(io.BytesIO(data), type = wx.BITMAP_TYPE_ANY, index = -1)
      #ImageFromStream

      ratio = min(
         float(width) / float(image.GetWidth()),
         float(height) / float(image.GetHeight())
      )

      image = image.Scale(
         round(float(image.GetWidth()) * ratio),
         round(float(image.GetHeight()) * ratio),
         quality
      )

      wx.Bitmap.__init__(self, image.ConvertToBitmap())

class ActionButton (wx.Button):
   def __init__(self, parent, **kwargs):
      wx.Button.__init__(self, parent, **kwargs)

      self.Initialize()

   def Initialize(self):
      if self.passiveColor != None:
         self.SetBackgroundColour(self.passiveColor)

      self.Bind(wx.EVT_ENTER_WINDOW, self.onMouseEnter)
      self.Bind(wx.EVT_LEAVE_WINDOW, self.onMouseLeave)
      self.Bind(wx.EVT_BUTTON, self.onClick)

   def onMouseEnter(self, event):
      if self.hoverColor != None:
         self.SetBackgroundColour(self.hoverColor)

   def onMouseLeave(self, event):
      if self.passiveColor != None:
         self.SetBackgroundColour(self.passiveColor)

   def onClick(self, event):
      self.PerformAction()

   def PerformAction(self):
      raise NotImplementedError('Method \'PerformAction\' is not implemented')

class ActionBitmapButton (wx.BitmapButton, ActionButton):
   def __init__(self, parent, **kwargs):
      wx.BitmapButton.__init__(self, parent, **kwargs)

      self.Initialize()

class TitleImage (wx.StaticBitmap):
   def __init__(self, parent):
      logo  = ScaledBitmap(resources_logo_png, 587, 24)

      wx.StaticBitmap.__init__(
         self,
         parent,
         size = wx.Size(logo.GetWidth(), logo.GetHeight()),
         bitmap = logo,
         pos = (2, 0)
      )

      self.Bind(wx.EVT_LEFT_UP, parent.OnLeftUp)
      self.Bind(wx.EVT_MOTION, parent.OnMouseMove)
      self.Bind(wx.EVT_LEFT_DOWN, parent.OnLeftDown)

class CloseButton (ActionBitmapButton):
   def __init__(self, parent):
      self.passiveColor = colors['background']
      self.hoverColor = colors['hover-red']

      ActionBitmapButton.__init__(
         self,
         parent,
         bitmap = ScaledBitmap(resources_close_png, 42, 24, wx.IMAGE_QUALITY_NEAREST),
         size = wx.Size(42, 24),
         style = wx.BORDER_NONE,
         pos = (654, 0)
      )

   def PerformAction(self):
      if (window.ReadyToClose):
         window.Close()
      else:
         answer = wx.MessageBox(
            "Are you sure you want to stop the installation?",
            "Exit Installation",
            wx.YES_NO | wx.ICON_EXCLAMATION,
            window
         )
         if answer == wx.YES:
            window.Close()

class MinimizeButton (ActionBitmapButton):
   def __init__(self, parent):
      self.passiveColor = colors['background']
      self.hoverColor = colors['hover-light']

      ActionBitmapButton.__init__(
         self,
         parent,
         bitmap = ScaledBitmap(resources_minimize_png, 42, 24, wx.IMAGE_QUALITY_NEAREST),
         size = wx.Size(42, 24),
         style = wx.BORDER_NONE,
         pos = (612, 0)
      )

   def PerformAction(self):
      window.Iconize()

class TitlePanel (wx.Panel):
   def __init__(self, parent):
      wx.Panel.__init__(self, parent, size = wx.Size(696, 24), pos = (2, 2))

      self.delta = None
      self.SetBackgroundColour(colors['background'])

      self.Bind(wx.EVT_LEFT_UP, self.OnLeftUp)
      self.Bind(wx.EVT_MOTION, self.OnMouseMove)
      self.Bind(wx.EVT_LEFT_DOWN, self.OnLeftDown)
      self.addPanelControls()

   def addPanelControls(self):
      TitleImage(self)
      CloseButton(self)
      MinimizeButton(self)

   def OnLeftDown(self, event):
      self.CaptureMouse()
      pos = window.ClientToScreen(event.GetPosition())
      origin = window.GetPosition()
      self.delta = wx.Point(pos.x - origin.x, pos.y - origin.y)

   def OnMouseMove(self, event):
      if event.Dragging() and event.LeftIsDown() and self.delta != None:
         pos = window.ClientToScreen(event.GetPosition())
         newPos = (pos.x - self.delta.x, pos.y - self.delta.y)
         window.Move(newPos)

   def OnLeftUp(self, event):
      if self.HasCapture():
         self.ReleaseMouse()

class ScrollIndicator (wx.Button):
   def __init__(self, parent, size, pos):
      self.passiveColor = colors['button']
      self.hoverColor = colors['button-hover']
      self.delta = None
      self.maxY = 0
      self.scrollBar = parent

      wx.Button.__init__(
         self,
         parent,
         size = size,
         style = wx.BORDER_NONE,
         pos = pos,
         label='',
      )
      self.SetBackgroundColour(self.passiveColor)

      self.Bind(wx.EVT_LEFT_UP, self.OnLeftUp)
      self.Bind(wx.EVT_MOTION, self.OnMouseMove)
      self.Bind(wx.EVT_LEFT_DOWN, self.OnLeftDown)

   def OnLeftDown(self, event):
      self.CaptureMouse()
      pos = self.ClientToScreen(event.GetPosition())
      origin = self.GetPosition()
      self.delta = wx.Point(pos.x - origin.x, pos.y - origin.y)

   def OnMouseMove(self, event):
      if event.Dragging() and event.LeftIsDown() and self.delta != None:
         pos = self.ClientToScreen(event.GetPosition())
         posY = pos.y - self.delta.y

         if posY < 0:
            posY = 0
         if posY > self.maxY:
            posY = self.maxY

         self.SetPosition((0, posY))
         self.SetBackgroundColour(self.hoverColor)
         self.scrollBar.scrollContentByIndicator(posY)

   def OnLeftUp(self, event):
      if self.HasCapture():
         self.ReleaseMouse()
         self.SetBackgroundColour(self.passiveColor)

class ListScrollBar (wx.Panel):
   def __init__(self, parent, pos):
      wx.Panel.__init__(self, parent, size = (12, parent.ContentHeight), pos = pos)
      self.SetBackgroundColour(colors['text-input'])
      self.list = parent

      self.scrollIndicator = ScrollIndicator(self, size = (12, 48), pos = (0, 0))
      self.scrollIndicator.maxY = parent.ContentHeight - 48

   def setScrollableHeight(self, height):
      if not height:
         self.scrollableHeight = 0
         self.scrollMultiplier = 0
      else:
         self.scrollableHeight = height
         self.scrollMultiplier = float(height) / float(self.list.ContentHeight - 48)

   def scrollContentByIndicator(self, height):
      posY = int(float(height) * self.scrollMultiplier)
      self.list.container.SetPosition((0, -posY))

   def scrollContentByWheel(self, up):
      if self.scrollMultiplier > 0.0:
         posY = 0
         if up:
            posY = self.list.container.GetPosition().y + 35
            if posY > 0:
               posY = 0
         else:
            posY = self.list.container.GetPosition().y - 35
            if (posY * -1) > self.scrollableHeight:
               posY = self.scrollableHeight * -1

         self.list.container.SetPosition((0, posY))
         posY = int(float(-posY) / self.scrollMultiplier)
         self.scrollIndicator.SetPosition((0, posY))

class ListMenuButton (ActionBitmapButton):
   def __init__(self, parent, pos, name, path, data, mouseMoveHandler):
      self.parent = parent
      self.name = name
      self.path = path
      self.onMouseMove = mouseMoveHandler

      ActionBitmapButton.__init__(
         self,
         parent,
         bitmap = ScaledBitmap(data, 36, 36, wx.IMAGE_QUALITY_NEAREST),
         size = wx.Size(36, 36),
         style = wx.BORDER_NONE,
         pos = pos
      )

      self.boderElement = []
      self.SetBackgroundColour(self.passiveColor)

   def setUpBorder(self):
      if len(self.boderElement) > 0:
         for element in self.boderElement:
            element.Destroy()
         self.boderElement = []

      size = self.GetSize()
      positions = [
         (0, 0),
         (size.GetWidth() - 2, 0),
         (0, size.GetHeight() - 2),
         (size.GetWidth() - 2, size.GetHeight() - 2)
      ]

      for pos in positions:
         self.boderElement.append(wx.Panel(self, pos = pos, size = (2, 2)))
         self.boderElement[-1].SetBackgroundColour(self.parent.GetBackgroundColour())

   def onMouseEnter(self, event):
      self.SetBackgroundColour(self.hoverColor)
      self.onMouseMove(event)

   def onMouseLeave(self, event):
      self.SetBackgroundColour(self.passiveColor)
      self.onMouseMove(event)

class LoadSaveButton (ListMenuButton):
   def __init__(self, parent, pos, name, path, mouseMoveHandler):
      self.passiveColor = colors['background']
      self.hoverColor = colors['hover-light']

      ListMenuButton.__init__(self, parent, pos, name, path, resources_load_png, mouseMoveHandler)
      self.setUpBorder()

   def PerformAction(self):
      window.makeLoad(self.path)

class DeleteSaveButton (ListMenuButton):
   def __init__(self, parent, pos, name, path, mouseMoveHandler):
      self.passiveColor = colors['background']
      self.hoverColor = colors['hover-red']

      ListMenuButton.__init__(self, parent, pos, name, path, resources_close_png, mouseMoveHandler)
      self.setUpBorder()

   def PerformAction(self):
      window.openDeleteMenu(self.path)

class ScrollableList (wx.Panel):
   def __init__(self, parent, size, pos):
      wx.Panel.__init__(self, parent, size = size, pos = pos)
      self.SetBackgroundColour(colors['border-light'])
      self.disabled = False

      self.ContentWidth = size[0] - 18
      self.ContentHeight = size[1] - 4

      wx.Panel(self, pos = (self.ContentWidth + 2, 0), size = (2, 2)).SetBackgroundColour(colors['content'])
      wx.Panel(self, pos = (self.ContentWidth + 2, self.ContentHeight + 2), size = (2, 2)).SetBackgroundColour(colors['content'])

      self.containerWrapper = wx.Panel(self, size = (self.ContentWidth, self.ContentHeight), pos = (2, 2))
      self.containerWrapper.SetBackgroundColour(colors['text-input'])

      wx.Panel(self, pos = (self.ContentWidth + 2, 2), size = (2, self.ContentHeight)).SetBackgroundColour(colors['border-light'])
      self.scrollBar = ListScrollBar(self, pos = (self.ContentWidth + 4, 2))

      self.container, self.contentSizer = self.CreateContainer()
      self.container.Show()

   def CreateContainer(self):
      container = wx.Panel(self.containerWrapper, size = (self.ContentWidth, self.ContentHeight), pos = (0, 0))
      container.Hide()
      container.SetBackgroundColour(colors['text-input'])
      itemIndex = 0

      contentSizer = wx.BoxSizer(orient=wx.VERTICAL)
      container.SetSizer(contentSizer)
      container.Bind(wx.EVT_MOUSEWHEEL, self.OnWheel)

      return container, contentSizer

   def OnWheel(self, event):
      if not self.disabled:
         amt = event.GetWheelRotation()
         if amt > 0:
            self.scrollBar.scrollContentByWheel(True)
         elif amt < 0:
            self.scrollBar.scrollContentByWheel(False)

   def SetHeight(self, height):
      if height < self.ContentHeight:
         height = self.ContentHeight
      self.container.SetSize((self.container.GetSize().GetWidth(), height))
      self.scrollBar.setScrollableHeight(height - self.ContentHeight)

   def DestroyContainer(self):
      self.container.Destroy()

   def ShowLoadingStatus(self):
      self.contentSizer.AddStretchSpacer()
      font = wx.Font(14, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      text = wx.StaticText(self.container, size = wx.Size(-1, -1), label = "Searching for save files ...")
      text.SetForegroundColour(colors['secondary-text'])
      text.SetFont(font)

      stringSizer = wx.BoxSizer(orient=wx.HORIZONTAL)
      stringSizer.AddSpacer(130)
      stringSizer.Add(text)

      self.contentSizer.Add(stringSizer)
      self.contentSizer.AddStretchSpacer()
      self.container.Layout()

   def disable(self):
      self.disabled = True
      self.scrollBar.Disable()
      for child in self.container.GetChildren():
         child.disable()

   def enable(self):
      self.disabled = False
      self.scrollBar.Enable()
      for child in self.container.GetChildren():
         child.enable()

class ContentPanel (wx.Panel):
   def __init__(self, parent):
      wx.Panel.__init__(self, parent, size = wx.Size(532, 670), pos = (166, 28))
      self.SetBackgroundColour(colors['content'])
      self.CreateContent()

      linePieces = [
         ('Noita Save Scummer', wx.FONTWEIGHT_LIGHT, 20, wx.FONTSTYLE_NORMAL, 40, colors['main-text']),
         (' ' + versionNumber, wx.FONTWEIGHT_LIGHT, 16, wx.FONTSTYLE_NORMAL, 35, colors['main-text'])
      ]

      contentSizer = wx.BoxSizer(wx.VERTICAL)
      contentSizer.AddSpacer(10)
      contentSizer.Add(self.CreateFormatedString(20, linePieces))
      self.SetSizer(contentSizer)
      self.Layout()

   def CreateContent(self):
      raise NotImplementedError('Method \'CreateContent\' is not implemented')

   def CreateFormatedString(self, padding, pieces, container = None):
      if (not container):
         container = self
      stringSizer = wx.BoxSizer(orient=wx.HORIZONTAL)
      stringSizer.AddSpacer(padding)

      for text, fontWeight, fontSize, fontStyle, height, color in pieces:
         font = wx.Font(fontSize, wx.FONTFAMILY_DEFAULT, fontStyle, fontWeight, faceName = 'GamePixies')
         text = wx.StaticText(container, size = wx.Size(-1, height), label = text)
         text.SetForegroundColour(color)
         text.SetFont(font)

         stringSizer.Add(text, 0, wx.ALIGN_BOTTOM)

      return stringSizer

class SaveInstance (wx.Panel):
   def __init__(self, parent, sizeX, info, parentRect):
      wx.Panel.__init__(self, parent = parent, size = (sizeX, 70))
      self.saveName = info[0]
      self.savePath = info[1]
      self.enabled = True
      self.parentRect = parentRect

      self.SetBackgroundColour(colors['text-input'])

      self.interactivePanel = wx.Panel(self, size = (sizeX - 30, 70), pos = (15, 0))
      self.hoverColor = colors['border']
      self.passiveColor = colors['border-light']
      self.interactivePanel.SetBackgroundColour(self.passiveColor)
      stylizeBorder(self.interactivePanel)

      panel = wx.Panel(self.interactivePanel, size = (sizeX - 34, 66), pos = (2,2))
      panel.SetBackgroundColour(colors['save-item'])

      sizerVertical = wx.BoxSizer(orient=wx.VERTICAL)
      mainTextSizer = wx.BoxSizer(orient=wx.HORIZONTAL)
      secondaryTextSizer = wx.BoxSizer(orient=wx.HORIZONTAL)

      sizerVertical.AddStretchSpacer(3)
      sizerVertical.Add(mainTextSizer)
      sizerVertical.AddSpacer(3)
      sizerVertical.Add(secondaryTextSizer)
      sizerVertical.AddStretchSpacer(2)
      panel.SetSizer(sizerVertical)

      mainTextSizer.AddSpacer(25)
      font = wx.Font(14, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      text = wx.StaticText(panel, size = wx.Size(-1, -1), label = self.saveName)
      text.SetForegroundColour(colors['main-text'])
      text.SetFont(font)
      mainTextSizer.Add(text)

      time_str = datetime.datetime.fromtimestamp(
         os.path.getmtime(self.savePath)).strftime('%H : %M : %S        %d %b %Y')
      secondaryTextSizer.AddSpacer(25)
      font = wx.Font(10, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      text = wx.StaticText(panel, size = wx.Size(-1, -1), label = time_str)
      text.SetForegroundColour(colors['secondary-text'])
      text.SetFont(font)
      secondaryTextSizer.Add(text)

      panel.Layout()

      elements = [self.interactivePanel]
      elements += self.interactivePanel.GetChildren()
      for child in self.interactivePanel.GetChildren():
         elements += child.GetChildren()
      for element in elements:
         element.Bind(wx.EVT_ENTER_WINDOW, self.onMouseMove)
         element.Bind(wx.EVT_LEAVE_WINDOW, self.onMouseMove)

      self.loadButton = LoadSaveButton(panel, (panel.GetSize().GetWidth() - 102, 15), self.saveName, self.savePath, self.onMouseMove)
      self.deleteButton = DeleteSaveButton(panel, (panel.GetSize().GetWidth() - 51, 15), self.saveName, self.savePath, self.onMouseMove)

   def onMouseMove(self, event):
      if self.enabled:
         rect = self.interactivePanel.GetScreenRect()
         pos = wx.GetMousePosition()
         topLeft = (rect[0], rect[1])
         bottomLeft = (rect[0], rect[1] + rect[3])

         if hitTest(self.parentRect, topLeft) and (rect[1] + rect[3]) > (self.parentRect[1] + self.parentRect[3]):
            rect[3] = (self.parentRect[1] + self.parentRect[3]) - rect[1]

         if hitTest(self.parentRect, bottomLeft) and rect[1] < self.parentRect[1]:
            rect[3] = (rect[1] + rect[3]) - self.parentRect[1]
            rect[1] = self.parentRect[1]

         if hitTest(rect, pos):
            self.interactivePanel.SetBackgroundColour(self.hoverColor)
         else:
            self.interactivePanel.SetBackgroundColour(self.passiveColor)
         self.Refresh()

   def disable(self):
      self.loadButton.Disable()
      self.deleteButton.Disable()
      self.enabled = False

   def enable(self):
      self.loadButton.Enable()
      self.deleteButton.Enable()
      self.enabled = True

class ContentButton (wx.Button):
   def __init__(self, parent, label, size, pos):
      wx.Button.__init__(self, parent, label = label, size = size, style = wx.BORDER_NONE, pos = pos)
      self.border = parent
      self.passiveColor = colors['background']
      self.hoverColor = colors['hover-light']

      self.SetForegroundColour(colors['main-text'])
      self.SetBackgroundColour(self.passiveColor)
      stylizeBorder(parent)
      font = wx.Font(18, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL, faceName = 'GamePixies')
      self.SetFont(font)

      self.Bind(wx.EVT_ENTER_WINDOW, self.onMouseEnter)
      self.Bind(wx.EVT_LEAVE_WINDOW, self.onMouseLeave)
      self.Bind(wx.EVT_BUTTON, self.onClick)

   def onMouseEnter(self, event):
      self.SetBackgroundColour(self.hoverColor)
      self.border.SetBackgroundColour(colors['button-hover'])
      self.border.Refresh()

   def onMouseLeave(self, event):
      self.SetBackgroundColour(self.passiveColor)
      self.border.SetBackgroundColour(colors['button'])
      self.border.Refresh()

class FolderButton (ContentButton):
   def __init__(self, parent):
      ContentButton.__init__(self, parent, 'Save Dir', (150, 32), (2, 2))

   def onClick(self, event):
      subprocess.run(['explorer', config['saveFolderPath']])

class OptionsButton (ContentButton):
   def __init__(self, parent):
      ContentButton.__init__(self, parent, 'Options', (150, 32), (2, 2))

   def onClick(self, event):
      window.openOptionsMenu()

class ClosePopupButton (ContentButton):
   def __init__(self, parent):
      ContentButton.__init__(self, parent, 'Close', (150, 36), (2, 2))

   def onClick(self, event):
      window.removePopup()

class SaveOptionsButton (ContentButton):
   def __init__(self, parent, optionsMenu):
      ContentButton.__init__(self, parent, 'Save', (150, 36), (2, 2))
      self.optionsMenu = optionsMenu

   def onClick(self, event):
      self.optionsMenu.saveConfig()
      window.removePopup()

class OptionChangePanel (wx.Panel):
   def __init__(self, parent, label, pos, align, config):
      wx.Panel.__init__(self, parent, pos = pos, size = (516, 50))

      self.config = config
      self.disabled = False

      self.font = wx.Font(12, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      description = wx.StaticText(self, size = wx.Size(160, 20), pos = (0, 16), style = wx.ST_ELLIPSIZE_START | wx.ALIGN_RIGHT | wx.ST_NO_AUTORESIZE)
      description.SetForegroundColour(colors['main-text'])
      description.SetFont(self.font)
      description.SetLabel(label)

      self.wrapper = wx.Panel(self, pos = (170, 6), size = (346, 38))
      self.wrapper.SetBackgroundColour(colors['button'])
      stylizeBorder(self.wrapper)

      self.textPanel = wx.Panel(self.wrapper, pos = (2, 2), size = (342, 34))
      self.textPanel.SetBackgroundColour(colors['text-input'])

      self.value = wx.StaticText(self.textPanel, pos = (10, 8), size = (322, 20), style = wx.ST_ELLIPSIZE_START | align | wx.ST_NO_AUTORESIZE)
      self.value.SetForegroundColour(colors['main-text'])
      self.value.SetFont(self.font)

      for element in [self.wrapper, self.textPanel, self.value]:
         element.Bind(wx.EVT_ENTER_WINDOW, self.onMouseMove)
         element.Bind(wx.EVT_LEAVE_WINDOW, self.onMouseMove)
         element.Bind(wx.EVT_LEFT_UP, self.onClick)

   def onMouseMove(self, event):
      if not self.disabled:
         rect = self.wrapper.GetScreenRect()
         pos = wx.GetMousePosition()

         if hitTest(rect, pos):
            self.wrapper.SetBackgroundColour(colors['button-hover'])
         else:
            self.wrapper.SetBackgroundColour(colors['button'])

         self.wrapper.Refresh()

   def disable(self):
      self.disabled = True

   def enable(self):
      self.disabled = False

class OptionCheckbox (OptionChangePanel):
   def __init__(self, parent, pos, optionsMenu, config, label, option):
      OptionChangePanel.__init__(self, parent, label = label, pos = pos, align = wx.ALIGN_RIGHT, config = config)
      self.value.Destroy()
      self.wrapper.SetSize((38, 38))
      self.textPanel.SetSize((34, 34))
      self.value = wx.Panel(self.textPanel, pos = (8, 8), size = (18, 18))
      self.value.Bind(wx.EVT_ENTER_WINDOW, self.onMouseMove)
      self.value.Bind(wx.EVT_LEAVE_WINDOW, self.onMouseMove)
      self.value.Bind(wx.EVT_LEFT_UP, self.onClick)

      self.option = option
      stylizeBorder(self.wrapper)
      self.setValue()

   def setValue(self):
      if self.config[self.option]:
         self.value.SetBackgroundColour(colors['button'])
      else:
         self.value.SetBackgroundColour(colors['text-input'])

      self.wrapper.Refresh()

   def onClick(self, event):
      if not self.disabled:
         self.config[self.option] = not self.config[self.option]
         self.setValue()

class OptionAutoclose (OptionCheckbox):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionCheckbox.__init__(self, parent, pos, optionsMenu, config, 'Autoclose Noita :', 'autoclose')

class OptionLoadLaunch (OptionCheckbox):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionCheckbox.__init__(self, parent, pos, optionsMenu, config, 'Launch Noita on load :', 'launch_on_load')
      self.Raise()

class OptionUseSteamLaunch (OptionCheckbox):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionCheckbox.__init__(self, parent, pos, optionsMenu, config, 'Use Steam launch :', 'use_steam_launch')

class OptionDisplayStatus (OptionCheckbox):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionCheckbox.__init__(self, parent, pos, optionsMenu, config, 'Show save info :', 'display_save_status')
      self.Raise()

class FolderSelectSetting (OptionChangePanel):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionChangePanel.__init__(self, parent, label = "Path to save folder :", pos = pos, align = wx.ALIGN_LEFT, config = config)
      self.optionsMenu = optionsMenu
      self.setValue()

   def setValue(self):
      self.value.SetLabel(self.config['saveFolderPath'])
      self.wrapper.Refresh()

   def onClick(self, event):
      if not self.disabled:
         dialog = wx.DirDialog(
            self,
            message='Select Folder',
            defaultPath=self.config['saveFolderPath'],
            style=wx.DD_DEFAULT_STYLE,
            pos=wx.DefaultPosition,
            size=wx.DefaultSize
         )
         dialog.ShowModal()

         self.config['saveFolderPath'] = dialog.GetPath()
         self.setValue()

class OptionExecutableSelect (OptionChangePanel):
   def __init__(self, parent, pos, optionsMenu, config, label, option, hint):
      OptionChangePanel.__init__(self, parent, label = label, pos = pos, align = wx.ALIGN_LEFT, config = config)
      self.optionsMenu = optionsMenu
      self.option = option
      self.hint = hint
      self.setValue()

   def setValue(self):
      self.value.SetLabel(self.config[self.option])
      self.wrapper.Refresh()

   def onClick(self, event):
      defaultPath = self.config[self.option]
      if defaultPath == '':
         defaultPath = os.path.expanduser('~')

      if not self.disabled:
         dialog = wx.FileDialog(
            self,
            message = self.hint,
            defaultDir = os.path.dirname(defaultPath),
            style = wx.FD_DEFAULT_STYLE | wx.FD_FILE_MUST_EXIST,
            pos = wx.DefaultPosition,
            size = wx.DefaultSize,
            wildcard = 'Executable files (*.exe)|*.exe'
         )
         if not dialog.ShowModal() == wx.ID_CANCEL:
            self.config[self.option] = dialog.GetPath()
            self.setValue()

class NoitaExeSelectSetting (OptionExecutableSelect):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionExecutableSelect.__init__(
         self,
         parent,
         pos,
         optionsMenu,
         config,
         'Path to executable :',
         'executable_path',
         'Select Noita executable')

class SteamExeSelectSetting (OptionExecutableSelect):
   def __init__(self, parent, pos, optionsMenu, config):
      OptionExecutableSelect.__init__(
         self,
         parent,
         pos,
         optionsMenu,
         config,
         'Path to steam :',
         'steam_launch',
         'Select Steam executable')

class BindingSetting (OptionChangePanel):
   def __init__(self, parent, pos, optionsMenu, binding, label, config):
      OptionChangePanel.__init__(self, parent, label = label, pos = pos, align = wx.ALIGN_LEFT, config = config)
      self.optionsMenu = optionsMenu
      self.binding = binding
      self.setValue()

      self.keysPressedEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.onKeysPressed)

   def setValue(self):
      value = ''
      if self.config[self.binding]:
         for key in self.config[self.binding]:
            value += key + ' + '
         value = value[:-3]

      self.value.SetLabel(value)
      self.wrapper.Refresh()

   def filterKeys(self):
      keys = []

      for code in self.bound_keys:
         char = toAscii(code)
         if char:
            keys.append(char)

      keys = set(keys)
      sorted_keys = []

      for special in ['alt', 'shift', 'control', 'super']:
         for key in keys:
            if special == key:
               sorted_keys.insert(0, key)

      for key in keys:
         if len(key) == 1 or (len(key) < 4 and key[0] == 'f'):
            sorted_keys.append(key)

      return sorted_keys

   def onKeysPressed(self, event):
      if len(event.data) == 0:
         self.removeHook()
         self.listening = False
         self.onMouseMove(event)
         self.optionsMenu.enable()
      else:
         for key in event.data:
            if key not in self.bound_keys:
               self.bound_keys.append(key)

      self.config[self.binding] = tuple(self.filterKeys())
      self.setValue()

   def keyPressHandler(self):
      keys = []
      for e in keyboard._pressed_events:
         keys.append(e)

      wx.PostEvent(self, self.keysPressedEvent(data = keys))

   def listenToKeys(self):
      self.listening = True
      self.removeHook = keyboard.hook(lambda e: self.keyPressHandler())
      while self.listening:
         time.sleep(0.1)

   def onClick(self, event):
      if not self.disabled:
         self.bound_keys = []
         self.config[self.binding] = None
         self.setValue()

         self.optionsMenu.disable()
         thread = Thread(target = self.listenToKeys)
         thread.start()

class OptionsMenu (wx.Panel):
   def __init__(self, parent):
      wx.Panel.__init__(self, parent, size = (550, 680), pos = (75, 10))
      self.Raise()
      self.SetBackgroundColour(colors['border'])
      stylizeBorder(self)

      global config
      self.config = dict(config)

      contentPanel = wx.Panel(self, size = (546, 676), pos = (2,2))
      contentPanel.SetBackgroundColour(colors['content'])

      panel = wx.Panel(contentPanel, pos = (45, 621), size = (154, 40))
      panel.SetBackgroundColour(colors['button'])
      self.closeButton = ClosePopupButton(panel)

      panel = wx.Panel(contentPanel, pos = (347, 621), size = (154, 40))
      panel.SetBackgroundColour(colors['button'])
      self.saveButton = SaveOptionsButton(panel, self)

      self.options = []
      self.options.append(
         FolderSelectSetting(contentPanel, (15, 15), self , self.config)
      )
      self.options.append(
         BindingSetting(contentPanel, (15, 80), self, 'hotkey_save', 'Save hotkey :', self.config)
      )
      self.options.append(
         BindingSetting(contentPanel, (15, 145), self, 'hotkey_saveQuick', 'Quick save hotkey :', self.config)
      )
      self.options.append(
         BindingSetting(contentPanel, (15, 210), self, 'hotkey_load', 'Load hotkey :', self.config)
      )
      self.options.append(
         BindingSetting(contentPanel, (15, 275), self, 'hotkey_loadQuick', 'Quick load hotkey :', self.config)
      )
      self.options.append(
         OptionAutoclose(contentPanel, (15, 340), self, self.config)
      )
      self.options.append(
         OptionLoadLaunch(contentPanel, (270, 340), self, self.config)
      )
      self.options.append(
         OptionUseSteamLaunch(contentPanel, (15, 405), self, self.config)
      )
      self.options.append(
         OptionDisplayStatus(contentPanel, (270, 405), self, self.config)
      )
      self.options.append(
         NoitaExeSelectSetting(contentPanel, (15, 470), self , self.config)
      )
      self.options.append(
         SteamExeSelectSetting(contentPanel, (15, 535), self, self.config)
      )

   def disable(self):
      for option in self.options:
         option.disable()

      self.closeButton.Disable()
      self.saveButton.Disable()

   def enable(self):
      for option in self.options:
         option.enable()

      self.closeButton.Enable()
      self.saveButton.Enable()

   def saveConfig(self):
      global config
      config = dict(self.config)
      writeConfig()

      #apply gui config gui changes
      window.statusInfo.Show(config['display_save_status'])

class SaveButton (ContentButton):
   def __init__(self, parent):
      ContentButton.__init__(self, parent, 'Save', (150, 32), (2, 2))

   def onClick(self, event):
      window.openNewSaveMenu()

class NewSaveButton (ContentButton):
   def __init__(self, parent, saveMenu):
      ContentButton.__init__(self, parent, 'Save', (150, 36), (2, 2))
      self.saveMenu = saveMenu
      self.overwriteCooldownEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.enable)
      self.overwrite = False

   def manualHoverDetect(self):
      rect = self.GetScreenRect()
      pos = wx.GetMousePosition()

      if hitTest(rect, pos):
         self.onMouseEnter(None)
      else:
         self.onMouseLeave(None)

      self.Refresh()

   def enable(self, event):
      self.Enable()
      self.manualHoverDetect()

   def overwriteCooldown(self):
      time.sleep(0.5)
      self.overwrite = True
      wx.PostEvent(self, self.overwriteCooldownEvent())

   def onClick(self, event):
      global saveFiles
      name = self.saveMenu.textInput.GetValue()

      if not self.overwrite and name in saveFiles:
         self.hoverColor = colors['button-red']
         self.SetLabel('Overwrite')
         self.manualHoverDetect()
         self.Disable()

         thread = Thread(target = self.overwriteCooldown)
         thread.start()
         return

      window.makeSave(name)

class PlaceholderPanel (wx.Panel):
   def __init__(self, parent, label):
      wx.Panel.__init__(self, parent, size = (550, 230), pos = (75, 235))
      self.Raise()
      self.SetBackgroundColour(colors['border'])
      stylizeBorder(self)

      self.label = label

      self.contentPanel = wx.Panel(self, size = (546, 226), pos = (2,2))
      self.contentPanel.SetBackgroundColour(colors['content'])

      font = wx.Font(18, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      self.text = wx.StaticText(self.contentPanel, size = wx.Size(-1, -1), label = self.label)
      self.text.SetForegroundColour(colors['secondary-text'])
      self.text.SetFont(font)

      horSizer = wx.BoxSizer(orient=wx.HORIZONTAL)
      horSizer.Add(self.text, 1, wx.CENTER)

      verSizer = wx.BoxSizer(orient=wx.VERTICAL)
      verSizer.Add(horSizer, 1, wx.CENTER)

      self.contentPanel.SetSizer(verSizer)
      self.contentPanel.Layout()
      self.setText(self.label)

   def setText(self, text):
      self.text.SetLabel(text)
      self.contentPanel.Layout()

class WaitingPlaceholder (PlaceholderPanel):
   def __init__(self, parent, label):
      PlaceholderPanel.__init__(self, parent, label)
      self.setText('Waiting for Noita to close ...')

   def setActionLabel(self):
      self.setText(self.label)

class SavingPlaceholder (WaitingPlaceholder):
   def __init__(self, parent):
      WaitingPlaceholder.__init__(self, parent, 'Saving, please wait ...')

class LoadingPlaceholder (WaitingPlaceholder):
   def __init__(self, parent):
      WaitingPlaceholder.__init__(self, parent, 'Loading, please wait ...')

class DeletingPlaceholder (PlaceholderPanel):
   def __init__(self, parent):
      PlaceholderPanel.__init__(self, parent, 'Deleting, please wait ...')

class NewSaveMenu (wx.Panel):
   def __init__(self, parent):
      wx.Panel.__init__(self, parent, size = (550, 230), pos = (75, 235))

      self.Raise()
      self.SetBackgroundColour(colors['border'])
      stylizeBorder(self)

      contentPanel = wx.Panel(self, size = (546, 226), pos = (2,2))
      contentPanel.SetBackgroundColour(colors['content'])

      font = wx.Font(14, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      text = wx.StaticText(contentPanel, size = wx.Size(-1, -1), label = 'Save game as:', pos = (30, 30))
      text.SetForegroundColour(colors['main-text'])
      text.SetFont(font)

      panel = wx.Panel(contentPanel, size = (486, 50), pos = (30, 70))
      panel.SetBackgroundColour(colors['button'])
      stylizeBorder(panel)
      panel = wx.Panel(panel, size = (482, 46), pos = (2, 2))
      panel.SetBackgroundColour(colors['text-input'])

      saveName = 'save-{date:%Y_%m_%d_%H_%M_%S}'.format(date=datetime.datetime.now())
      self.textInput = wx.TextCtrl(panel, value=saveName, pos=(10, 11), size=(462, 30), style=wx.NO_BORDER)
      self.textInput.SetBackgroundColour(colors['text-input'])
      self.textInput.SetForegroundColour(colors['main-text'])
      self.textInput.SetFont(font)

      panel = wx.Panel(contentPanel, size = (154, 40), pos = (30, 160))
      panel.SetBackgroundColour(colors['button'])
      NewSaveButton(panel, self)

      panel = wx.Panel(contentPanel, size = (154, 40), pos = (362, 160))
      panel.SetBackgroundColour(colors['button'])
      ClosePopupButton(panel)

class SaveFileListPanel (ContentPanel):
   def __init__(self, parent):
      ContentPanel.__init__(self, parent)

      self.displayEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.updateDisplay)

   def updateDisplay(self, event):
      newContainer, newContentSizer = self.saveList.CreateContainer()
      height = 15
      newContentSizer.AddSpacer(15)
      global saveFiles

      contentRect = self.saveList.containerWrapper.GetScreenRect()
      for saveFile in saveFiles:
         saveInstance = SaveInstance(newContainer, self.saveList.ContentWidth, (saveFile, saveFiles[saveFile]), contentRect)
         newContentSizer.Add(saveInstance)
         newContentSizer.AddSpacer(15)
         height += saveInstance.GetSize().GetHeight() + 15

      self.saveList.DestroyContainer()
      self.saveList.container = newContainer
      self.saveList.contentSizer = newContentSizer
      self.saveList.container.Layout()
      self.saveList.SetHeight(height)
      self.saveList.container.Show()

   def findSaveFiles(self, initInProcess = False):
      saveMng.findSaveFiles()

      if initInProcess:
         time.sleep(0.25)
      wx.PostEvent(self, self.displayEvent())

   def CreateContent(self):
      self.saveList = ScrollableList(self, size = (502, 555), pos = (15, 50))
      stylizeBorder(self.saveList)
      self.saveList.ShowLoadingStatus()

      panel = wx.Panel(self, pos = (15, 619), size = (154, 36))
      panel.SetBackgroundColour(colors['button'])
      self.saveButton = SaveButton(panel)

      panel = wx.Panel(self, pos = (189, 619), size = (154, 36))
      panel.SetBackgroundColour(colors['button'])
      self.optionsButton = OptionsButton(panel)

      panel = wx.Panel(self, pos = (363, 619), size = (154, 36))
      panel.SetBackgroundColour(colors['button'])
      self.folderButton = FolderButton(panel)

      thread = Thread(target = self.findSaveFiles, args=(True,))
      thread.start()

   def disable(self):
      self.saveList.disable()
      self.saveButton.Disable()
      self.optionsButton.Disable()
      self.folderButton.Disable()

   def enable(self):
      self.saveList.enable()
      self.saveButton.Enable()
      self.optionsButton.Enable()
      self.folderButton.Enable()

class DeleteSavePopupButton (ContentButton):
   def __init__(self, parent, savePath):
      ContentButton.__init__(self, parent, 'Delete', (150, 36), (2, 2))
      self.hoverColor = colors['button-red']
      self.savePath = savePath

   def onClick(self, event):
      window.makeDelete(self.savePath)

class DeleteSavePopup (wx.Panel):
   def __init__(self, parent, savePath):
      wx.Panel.__init__(self, parent, size = (550, 160), pos = (75, 270))

      self.Raise()
      self.SetBackgroundColour(colors['border'])

      contentPanel = wx.Panel(self, size = (546, 156), pos = (2,2))
      contentPanel.SetBackgroundColour(colors['content'])

      font = wx.Font(14, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      text = wx.StaticText(contentPanel, size = wx.Size(-1, -1), label = 'Do you really want to delete this save?', pos = (30, 30))
      text.SetForegroundColour(colors['main-text'])
      text.SetFont(font)

      panel = wx.Panel(contentPanel, size = (154, 40), pos = (362, 86))
      panel.SetBackgroundColour(colors['button'])
      ClosePopupButton(panel)

      panel = wx.Panel(contentPanel, size = (154, 40), pos = (30, 86))
      panel.SetBackgroundColour(colors['button'])
      DeleteSavePopupButton(panel, savePath)

class SaveStatusInfo (wx.Panel):
   def __init__(self, parent):
      wx.Panel.__init__(self, parent, size = (132, 55), pos = (17, 435), style=wx.TRANSPARENT_WINDOW)

      self.Raise()
      self.SetBackgroundColour(colors['border-light'])
      stylizeBorder(self)

      content = wx.Panel(self, pos = (2, 2), size = (128, 51))
      content.SetBackgroundColour(colors['text-input'])

      font = wx.Font(13, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_LIGHT, faceName = 'GamePixies')
      self.playerX = wx.StaticText(content, size = wx.Size(-1, -1), label = 'x :  ???', pos = (15, 5))
      self.playerX.SetForegroundColour(colors['secondary-text'])
      self.playerX.SetFont(font)

      self.playerY = wx.StaticText(content, size = wx.Size(-1, -1), label = 'y :  ???', pos = (15, 23))
      self.playerY.SetForegroundColour(colors['secondary-text'])
      self.playerY.SetFont(font)

   def updateStatus(self):
      if saveStatus['player_pos']:
         self.playerX.SetLabel('x :  ' + str(saveStatus['player_pos'][0]))
         self.playerY.SetLabel('y :  ' + str(saveStatus['player_pos'][1]))

class MainWindow (wx.Frame):
   def __init__(self, parent):
      wx.Frame.__init__(
         self,
         parent,
         id = wx.ID_ANY,
         title = wx.EmptyString,
         pos = wx.DefaultPosition,
         size = wx.Size(700, 700),
         style = wx.NO_BORDER | wx.SIMPLE_BORDER
      )

      self.SetDoubleBuffered(True)
      self.ReadyToClose = True
      self.popup = None
      self.SetBackgroundColour(colors['border'])
      self.Centre(wx.BOTH)

      stylizeBorder(self)

      self.hotkeyEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.hotkeyEventHandler)

      self.processCompletedEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.processComplete)

      self.noitaWaitEndEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.waitForNoitaEneded)

      self.saveStatusChangedEvent, EVT_RESULT = NewEvent()
      self.Bind(EVT_RESULT, self.updateSaveStatus)

      TitlePanel(self)
      self.contentPanel = SaveFileListPanel(self)
      wx.Panel(self, pos = (164, 28), size = (3, 670)).SetBackgroundColour(colors['border-light'])
      line = wx.Panel(self, pos = (2, 26), size = (696, 2))
      line.SetBackgroundColour(colors['border-light'])
      wx.StaticBitmap(self, bitmap=ScaledBitmap(resources_background_png, 696, 670), pos = (2, 28), size = (162, 670))
      wx.Panel(line, pos = (162, 0), size = (2, 2)).SetBackgroundColour(colors['background'])
      self.statusInfo = SaveStatusInfo(self)
      self.statusInfo.Show(config['display_save_status'])

   def __del__( self ):
      pass

   def updateSaveStatus(self, event):
      self.statusInfo.updateStatus()

   def saveStatusChanged(self):
      wx.PostEvent(self, self.saveStatusChangedEvent())

   def deleteThread(self, path):
      self.needToLaunch = False
      saveMng.deleteSave(path)
      wx.PostEvent(self, self.processCompletedEvent())

   def waitForNoitaThenAction(self, callback, action):
      self.needToLaunch, canDoAction = waitForNoitaTermination(action)
      wx.PostEvent(self, self.noitaWaitEndEvent())

      if canDoAction:
         callback()
      wx.PostEvent(self, self.processCompletedEvent())

   def saveThread(self, name):
      self.waitForNoitaThenAction(lambda: saveMng.backupSave(name), Action.save)

   def loadThread(self, path):
      self.waitForNoitaThenAction(lambda: saveMng.loadSave(path), Action.load)

   def makeSave(self, name):
      self.removePopup()
      self.showSavePlaceholder()

      thread = Thread(target = self.saveThread, args=(name,))
      thread.start()

   def makeLoad(self, path):
      self.removePopup()
      self.showLoadPlaceholder()

      thread = Thread(target = self.loadThread, args=(path,))
      thread.start()

   def makeDelete(self, path):
      self.removePopup()
      self.showDeletePlaceholder()

      thread = Thread(target = self.deleteThread, args=(path,))
      thread.start()

   def waitForNoitaEneded(self, event):
      self.popup.setActionLabel()

   def processComplete(self, event):
      self.contentPanel.findSaveFiles()
      self.removePopup()

      if self.needToLaunch:
         if config['steam_launch'] != '' and config['use_steam_launch']:
            launch = [config['steam_launch'], '-applaunch', '881100']

         elif config['executable_path'] != '':
            os.chdir(os.path.dirname(config['executable_path']))
            launch = [config['executable_path']]

         if launch:
            for argument in config['launch_arguments']:
               for word in argument.split():
                  if word != '':
                     launch.append(word)
            subprocess.Popen(launch, close_fds=True, creationflags=subprocess.DETACHED_PROCESS)

   def openOptionsMenu(self):
      hkm.unregisterAll()
      self.contentPanel.disable()
      self.popup = OptionsMenu(self)

   def openNewSaveMenu(self):
      hkm.unregisterAll()
      self.contentPanel.disable()
      self.popup = NewSaveMenu(self)

   def openDeleteMenu(self, savePath):
      hkm.unregisterAll()
      self.contentPanel.disable()
      self.popup = DeleteSavePopup(self, savePath)

   def removePopup(self):
      if self.popup:
         self.popup.Destroy()
         self.popup = None
      self.contentPanel.enable()
      hkm.registerAll()

   def showSavePlaceholder(self):
      hkm.unregisterAll()
      self.contentPanel.disable()
      self.popup = SavingPlaceholder(self)

   def showLoadPlaceholder(self):
      hkm.unregisterAll()
      self.contentPanel.disable()
      self.popup = LoadingPlaceholder(self)

   def showDeletePlaceholder(self):
      hkm.unregisterAll()
      self.contentPanel.disable()
      self.popup = DeletingPlaceholder(self)

   def hotkeyEventHandler(self, event):
      # 'load' event has no special behavior
      if event.data == 'save-quick':
         saveNumber = saveMng.getQuicksaveNumber()
         self.makeSave('!!quicksave~' + str(1 if saveNumber == 3 else saveNumber + 1))
      elif event.data == 'save':
         self.openNewSaveMenu()
      if event.data == 'load-quick':
         saveName = '!!quicksave~' + str(saveMng.getQuicksaveNumber())
         if saveName in saveFiles:
            self.makeLoad(saveFiles[saveName])

      self.Refresh()

class HotkeyManager():
   def loadSave(self, *args):
      focusWindow()
      wx.PostEvent(window, window.hotkeyEvent(data = 'load'))

   def loadQuick(self, *args):
      wx.PostEvent(window, window.hotkeyEvent(data = 'load-quick'))

   def backupSave(self, *args):
      focusWindow()
      wx.PostEvent(window, window.hotkeyEvent(data = 'save'))

   def backupQuick(self, *args):
      wx.PostEvent(window, window.hotkeyEvent(data = 'save-quick'))

   def __init__(self):
      self.reg_backup = False
      self.reg_backupQuick = False
      self.reg_load = False
      self.reg_loadQuick = False

      self.hk = SystemHotkey()
      self.registerAll()

   def unregisterAll(self):
      if self.reg_backup:
         self.hk.unregister(config['hotkey_save'])
         self.reg_backup = False
      if self.reg_backupQuick:
         self.hk.unregister(config['hotkey_saveQuick'])
         self.reg_backupQuick = False
      if self.reg_load:
         self.hk.unregister(config['hotkey_load'])
         self.reg_load = False
      if self.reg_loadQuick:
         self.hk.unregister(config['hotkey_loadQuick'])
         self.reg_loadQuick = False

   def registerAll(self):
      if config['hotkey_save'] and not self.reg_backup:
         self.hk.register(config['hotkey_save'], callback = lambda x: self.backupSave(x))
         self.reg_backup = True
      if config['hotkey_saveQuick'] and not self.reg_backupQuick:
         self.hk.register(config['hotkey_saveQuick'], callback = lambda x: self.backupQuick(x))
         self.reg_backupQuick = True
      if config['hotkey_load'] and not self.reg_load:
         self.hk.register(config['hotkey_load'], callback = lambda x: self.loadSave(x))
         self.reg_load = True
      if config['hotkey_loadQuick'] and not self.reg_loadQuick:
         self.hk.register(config['hotkey_loadQuick'], callback = lambda x: self.loadQuick(x))
         self.reg_loadQuick = True

class SaveManager():
   def __init__(self, extension):
      self.extension = extension

   def deleteSaveFolder(self):
      saveFolderPath = config['saveFolderPath'] + '\\save00'
      if not os.path.exists(saveFolderPath):
         return

      shutil.rmtree(saveFolderPath)

   def findSaveFiles(self):
      global saveFiles
      saveFiles = {}

      if not os.path.exists(config['saveFolderPath']):
         os.makedirs(config['saveFolderPath'])

      files = os.listdir(config['saveFolderPath'])
      for file in files:
         name, extension = os.path.splitext(file)
         if extension in supportedExtensions:
            saveFiles[name] = config['saveFolderPath'] + '\\' + file

      saveFiles = dict(sorted(saveFiles.items(), key=lambda item: os.path.getmtime(item[1]), reverse=True))

   def getQuicksaveNumber(self):
      global saveFiles
      latestSave = None
      saveTime = 0

      for saveFile in saveFiles:
         if saveFile.startswith('!!quicksave'):
            latestSave = saveFile
            break

      if latestSave == '!!quicksave':
         try:
            name, extension = os.path.splitext(saveFiles[latestSave])
            os.rename(saveFiles[latestSave], name + '~1' + extension)
         except:
            pass

         return 1
      else:
         try:
            return int(latestSave[-1])
         except:
            return 1

   def backupSave(self, saveName):
      global saveFiles
      for saveFile in saveFiles:
         if saveFile == saveName:
            self.deleteSave(saveFiles[saveName])

      os.chdir(config['saveFolderPath'])

      if self.extension == '.tar':
         with tarfile.open(saveName + self.extension, 'w') as tar:
            tar.add('save00', arcname = 'save00')
      elif self.extension == '.7z':
         si = subprocess.STARTUPINFO()
         si.dwFlags |= subprocess.STARTF_USESHOWWINDOW

         subprocess.call('"' + config['7z_path'] + '" a ' + saveName + self.extension + ' save00/* -mmt4 -mx0 -t7z', startupinfo=si)

   def loadSave(self, savePath):
      os.chdir(config['saveFolderPath'])

      if not os.path.exists(savePath):
         return

      self.deleteSaveFolder()
      extension = os.path.splitext(savePath)[1]
      if extension == '.tar':
         with tarfile.open(savePath, 'r') as tar:
            tar.extractall(path = config['saveFolderPath'])
      elif extension == '.7z':
         si = subprocess.STARTUPINFO()
         si.dwFlags |= subprocess.STARTF_USESHOWWINDOW

         subprocess.call('"' + config['7z_path'] + '" x ' + savePath + ' -y -mmt4', startupinfo=si)

   def deleteSave(self, savePath):
      if not os.path.exists(savePath):
         return

      try:
         os.remove(savePath)
      except:
         pass

class NoitaSaveScummer(wx.App):
   def OnInit(self):
      global window

      window = MainWindow(None)
      window.Show()

      return True

   def InitLocale(self):
      locale.setlocale(locale.LC_ALL, 'C')

versionNumber = 'v0.5.6'

locale.setlocale(locale.LC_ALL, 'C')
working_dir = os.getcwd()

num = ctypes.c_uint32()
data = (ctypes.c_char * len(resources_Gamepixies_8MO6n_ttf))(*resources_Gamepixies_8MO6n_ttf)
ctypes.windll.gdi32.AddFontMemResourceEx(data, len(data), 0, ctypes.byref(num))

readConfig()
findNoita()
findSteam()

hkm = HotkeyManager()
saveMng = SaveManager(selectArchiveTool())

supportedExtensions = ['.tar']
if config['7z_path'] != '':
   supportedExtensions.append('.7z')

window = None
app = NoitaSaveScummer()

saveDirObserver = watchSaveDirectory()
app.MainLoop()

#exit program
saveDirObserver.stop()
saveDirObserver.join()
hkm.unregisterAll()
writeConfig()
