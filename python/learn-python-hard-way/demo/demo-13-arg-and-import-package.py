# -- coding: utf-8 --
#
# python .\demo-13-arg-and-import-package.py a1 a2 a3

from sys import argv

script, first, second, third = argv

print "The script is called:", script
print "Your first variable is:", first
print "Your second variable is:", second
print "Your third variable is:", third
