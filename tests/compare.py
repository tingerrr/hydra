#! /usr/bin/env python

import sys
import numpy as np
from PIL import Image

a = np.asarray(Image.open(sys.argv[1]))
b = np.asarray(Image.open(sys.argv[2]))
tmp = sys.argv[3]

if a.shape != b.shape:
	a_x, a_y = a.shape[1], a.shape[0]
	b_x, b_y = b.shape[1], b.shape[0]
	print(f"image sizes did not match ({a_x}x{a_y} != {b_x}x{b_y})")
	exit(1)
elif (a != b).any():
	print("images did not match")
	print(f"diff saved at {tmp}")
	im = Image.fromarray(np.abs(a[:,:,:2] - b[:,:,:2]))
	im.save(tmp)
	exit(2)
