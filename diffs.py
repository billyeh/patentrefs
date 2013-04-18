#!/usr/bin/env python

import json

fung = json.loads(open('fung_ref_hash.json').read())
uspto = json.loads(open('uspto_ref_hash.json').read())
google = json.loads(open('google_ref_hash.json').read())

for patent in fung.keys():
  print(patent + ' ' + str(len(fung[patent])) + ' ' + str(len(uspto[patent])) + ' ' + str(len(google[patent])))
  uspto_pats = 'USPTO'
  for ref in uspto[patent]:
    if ref not in fung[patent]:
      uspto_pats += ' ' + ref
  # print(uspto_pats)
  google_pats = 'GOOGLE'
  for ref in google[patent]:
    if ref.replace('US', '0') not in fung[patent]:
      google_pats += ' ' + ref
  # print(google_pats)
