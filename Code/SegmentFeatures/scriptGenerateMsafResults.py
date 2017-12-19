# script to generate MSAF structural segmentation for the audio in dataset

import os
import ntpath

inputpath = "../../Dataset/Songs/"
outputpath = "../../Dataset/Segments/"

i = 1
for root, dirs, files in os.walk(inputpath):
   for f in files:
       filepath = os.path.join(root, f)
       if filepath.endswith('.mp3'):
           filename = ntpath.basename(filepath)
           print(filename)
           i = i + 1
           outputfilename = filename.replace(' ', '')[:-4].upper()
           outputfilename = outputfilename + ".txt"
           outputfilepath = outputpath + outputfilename
           print(outputfilepath)
           command_str = "python run_msaf.py -i " + filepath + " -o " + outputfilepath
           os.system(command_str)


