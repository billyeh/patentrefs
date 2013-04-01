import csv, json, os
from urllib import urlopen

## Process reffedby.csv into a random sample of 200
## patents, showing each patent which references it

random_patents = []

with open('clean_200_random.csv', 'rb') as csvfile:
  reader = csv.reader(csvfile, delimiter=' ')
  for row in reader:
    random_patents += row

samples = ''
if not os.path.exists('reffedby_sample.csv'):
  with open('reffedby.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
      if (row[0] in random_patents):
        samples += ', '.join(row) + '\n'

with open('reffedby_sample.csv', 'w+') as newfile:
  newfile.write(samples)

## Note: get output from command line, copy to reffedby_sample.csv

## Turn the sample of patents from our data referencing each random
## patent into a hash

if not os.path.exists('ref_hash.json'):
  ref_hash = {}

  with open('reffedby_sample.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
      if (row[0] not in ref_hash.keys()):
        ref_hash[row[0]] = []
      ref_hash[row[0]] += [row[1]]

  open('ref_hash.json', 'w').write(json.dumps(ref_hash))

## Note: ref data now in ref_hash.json

## Download USPTO webpages for each random patent

ref_hash = json.loads(open('ref_hash.json', 'r').read())
base_url = 'http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2Fsearch-adv.htm&r=0&f=S&l=50&d=PALL&Query=ref/'
url = base_url
uspto_ref_hash = {}

if not os.path.exists('uspto_refs'):
  print('hello')
  os.makedirs('uspto_refs')

for patent_number in ref_hash.keys():
  url += patent_number
  d = './uspto_refs/' + patent_number + '.html'
  if not os.path.exists(d):
    open('./uspto_refs/' + patent_number + '.html', 'w+').write((urlopen(url).read().decode('utf-8')))
  url = base_url

## Note: HTML pages now in ./uspto_refs