#!/usr/bin/python

import sys, getopt
import msaf

def main(argv):
   inputfile = ''
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
   except getopt.GetoptError:
      print 'run_msaf.py -i <inputfile> -o <outputfile>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'run_msaf.py -i <inputfile> -o <outputfile>'
         sys.exit()
      elif opt in ("-i", "--ifile"):
         inputfile = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
   print 'Input file is "', inputfile
   print 'Output file is "', outputfile
   boundaries, labels = msaf.process(inputfile, labels_id='scluster')
   print('Estimated boundaries:', boundaries)
   print('Estimated labels:', labels)
   msaf.io.write_mirex(boundaries, labels, outputfile)

if __name__ == "__main__":
   main(sys.argv[1:])