#!/usr/bin/env python3

import sys
import time
import xml.etree.ElementTree as ET

tree = ET.parse(sys.stdin)
root = tree.getroot()

for item in root.find('channel').findall('item'):
    guidNode = item.find('guid')
    if guidNode == None:
        guidNode = item.find('link')
    sys.stdout.write(guidNode.text.strip()); sys.stdout.write('\t')
    timestamp = int(time.time())
    sys.stdout.write(str(timestamp)); sys.stdout.write('\t')
    sys.stdout.write(item.find('title').text.strip()); sys.stdout.write('\t')
    sys.stdout.write(item.find('link').text.strip()); sys.stdout.write('\n')
