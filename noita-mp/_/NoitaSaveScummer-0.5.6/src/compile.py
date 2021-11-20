import os
import shutil
import subprocess
import pkg_resources

required = ['system_hotkey', 'pypiwin32', 'pyinstaller', 'pyyaml', 'keyboard', 'psutil', 'wxPython']
missing = []
for package in required:
   try:
      dist = pkg_resources.get_distribution(package)
   except:
      missing.append(package)

if len(missing):
   try:
      subprocess.call(['powershell', '-ExecutionPolicy', 'Bypass', '-File', './install_modules.ps1', *missing])
   except:
      pass

if os.path.exists('.\\dist'):
   shutil.rmtree('.\\dist')

subprocess.call(['pyinstaller', '--onefile', '--icon=./resources/icon.ico', 'main.pyw'])

if os.path.exists('.\\dist\\main.exe'):
   os.rename('.\\dist\\main.exe', '.\\dist\\NoitaSaveScummer.exe')
