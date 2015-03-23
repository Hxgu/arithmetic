import numpy as np
import matplotlib.pyplot as plt
import sys

pwA = float(sys.argv[1])
pwB = float(sys.argv[2])

fig, ax = plt.subplots()
bar_width = 0.35

opacity = 0.4

r1 = plt.bar(0.35,pwA,bar_width,color='b',label=sys.argv[3])
r2 = plt.bar(1,pwB,bar_width,color='r',label=sys.argv[4])

plt.xlabel('Module')
plt.ylabel('Power/mW')
plt.title('Power use for both modules')
plt.legend()
#plt.tight_layout()
#plt.show()
plt.savefig('bar.png')

