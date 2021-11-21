import io
import os
import re

def dirFileSearch(path):
   fileCount, fileStructure = 0, []

   for root, _, filenames in os.walk(path):
      list(map(lambda fileName: fileStructure.append(fileName), list(map(lambda fileName: root + '\\' + fileName, filenames))))
      fileCount += len(filenames)

   return fileStructure, fileCount

def dirRecursiveDelete(path):
   if os.path.exists(path):
      for root, dirs, files in os.walk(path, topdown=False):
         for name in files:
            os.remove(os.path.join(root, name))
         for name in dirs:
            os.rmdir(os.path.join(root, name))

      os.rmdir(path)

def normalizeVariableName(name):
   res = re.sub(r'[^a-zA-Z\d]', '_', name)
   if res[0].isnumeric():
      res = '_' + res

   return res


def fileToBytearray(filePath):
   varName = normalizeVariableName(filePath)
   fileString = f'{varName} = bytearray([\n'
   with io.open(filePath, mode='rb') as file:
      while (True):
         byteArr = file.read(20)
         if len(byteArr) < 1:
            break     
         hexString = '    '
         for byte in byteArr:
            hexString += '0x{0:02X}, '.format(byte)
         fileString += hexString + '\n'

   fileString = fileString[: -3] + '\n])\n'
   return fileString

dirRecursiveDelete('mem_resources')
os.mkdir('mem_resources')

fileStructure, fileCount = dirFileSearch('resources')
with io.open('mem_resources/resources.py', mode='w') as output_file:
   for file in fileStructure:
      output_file.write(fileToBytearray(file))
      output_file.write('\n')