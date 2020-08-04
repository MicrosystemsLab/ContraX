import os, csv
import xmltodict

def extract_positions(xmlfile, write_name=True, outfile=None):
  indir = os.path.dirname(os.path.realpath(xmlfile))
  if not outfile: outfile = os.path.join(indir, 'positionlist_out.csv')

  print("Processing file '{:}'".format(xmlfile))
  
  with open(xmlfile) as fd:
    fd.readline() # the first line causes problems
    doc = xmltodict.parse(fd.read())
    singletiles = doc['HardwareExperiment']['ExperimentBlocks']['AcquisitionBlock']['SubDimensionSetups']['RegionsSetup']['SampleHolder']['SingleTileRegions']['SingleTileRegion']
    npos = len(singletiles)
    
    print('Found {:} positions'.format(npos))
    if npos < 1: return
    
    positionlist = []
    for tile in singletiles:
      row = (tile['@Name'], tile['X'], tile['Y'], tile['Z'])
      print(row)
      positionlist.append(row)
    
    with open(outfile, 'w', newline='', encoding='ascii') as outcsv:
      writer = csv.writer(outcsv)
      header = ['Name','X','Y','Z'][0 if write_name else 1:]
      writer.writerow(header)
      for row in positionlist:
        writer.writerow(row[0 if write_name else 1:])
      print("Saved positionlist to '{:}'".format(outfile))
    
infile = 'Gaspard_Survey_TL_multi Band_Triggered.czexp'
extract_positions(infile, True)
