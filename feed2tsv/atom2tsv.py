#!/usr/bin/env python3

import sys
import datetime
import xml.etree.ElementTree as ET

tree = ET.parse(sys.stdin)
root = tree.getroot()

ns = {'atom': 'http://www.w3.org/2005/Atom'}

def parse_date(s):
    try:
        return datetime.datetime.strptime(date, '%Y-%m-%dT%H:%M:%S%z')
    except:
        return datetime.datetime.strptime(date, '%Y-%m-%dT%H:%M:%S.%f%z')

for item in root.findall('atom:entry', ns):
    sys.stdout.write(item.find('atom:id', ns).text.strip()); sys.stdout.write('\t')
    date = item.find('atom:published', ns).text
    timestamp = int(parse_date(date).timestamp())
    sys.stdout.write(str(timestamp)); sys.stdout.write('\t')
    sys.stdout.write(item.find('atom:title', ns).text.strip()); sys.stdout.write('\t')
    sys.stdout.write(item.find('atom:link[@rel=\'alternate\']', ns).attrib['href'].strip()); sys.stdout.write('\n')
