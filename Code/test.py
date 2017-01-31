import os
import ntpath

inputpath = "../Dataset/Songs/BOTU.mp3"
outputpath = "../Dataset/Segments/BOTU_segment.txt"

command_str = "python run_msaf.py -i " + inputpath + " -o " + outputpath
os.system(command_str)


