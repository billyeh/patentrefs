import csv
count = 0
with open('reffedby.csv', 'rb') as csvfile:
  reader = csv.reader(csvfile, delimiter=',')
  for row in reader:
    count += 1
print(count)