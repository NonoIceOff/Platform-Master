#SOFTNOISE
#MIT License
#
#Copyright (c) 2017 PerduGames
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#softnoise.gd by perdugames
#Based on the studies on this page:
#http://www.angelcode.com/dev/perlin/perlin.html
#I recommend reading, to understand more about perlin noise.
#Original implementation opensimplex in java:
#https://gist.github.com/KdotJPG/b1270127455a94ac5d19
#Example of how to use:
#https://github.com/PerduGames/SoftNoise-GDScript-

class SoftNoise:

	#Permutation table
	var perm = []
	#Gradient x table
	var gx = []
	#Gradient y table
	var gy = []

	#--------------OPENSIMPLEX-----------------------------------
	const STRETCH_CONSTANT_2D = -0.211324865405187 # (1/Math.sqrt(2+1)-1)/2
	const SQUISH_CONSTANT_2D  = 0.366025403784439  # (Math.sqrt(2+1)-1)/2

	const NORM_CONSTANT_2D = 47

	const DEFAULT_SEED = 0

	var permGradIndex3D = []

	#Gradients for 2D. They approximate the directions to the
	#vertices of an octagon from the center.
	var gradients2D = [
			 5,  2,    2,  5,
			-5,  2,   -2,  5,
			 5, -2,    2, -5,
			-5, -2,   -2, -5
		]

	func _init(_seed=0):
		generateTable(_seed)

	#---------PSEUDO-RANDOM NUMBER GENERATOR------------------------------------
	func simple_noise1d(x):
		x = (int(x) >> 13) ^ int(x)
		var _x = int((x * (x * x * 60493 + 19990303) + 1376312589) & 0x7fffffff)
		return 1.0 - (float(_x) / 1073741824.0)

	func simple_noise2d(x, y):
		var n=int(x)+int(y)*57
		n=(n<<13)^n
		var nn=(n*(n*n*60493+19990303)+1376312589)&0x7fffffff
		return 1.0-(float(nn/1073741824.0))

	#---------INTERPOLATION-----------------------------------------------------
	func cosineInterpolation(v1, v2, mu):
		var mu2 = (1.0 - cos( mu * PI ))/2
		return(v1 * (1.0 - mu2) + v2 * mu2)

	func linearInterpolation(v1, v2, mu):
		return (1.0-mu)*v1 + mu * v2

	#---------NOISE-----------------------------------------------------
	func value_noise2d(x, y):
		var source = []
		var floor_x = x
		var floor_y = y

		var g1=simple_noise2d(floor_x,floor_y)
		var g2=simple_noise2d(floor_x+1,floor_y)
		var g3=simple_noise2d(floor_x,floor_y+1)
		var g4=simple_noise2d(floor_x+1,floor_y+1)

		var int1 = cosineInterpolation(g1, g2, x - floor_x)
		var int2 = cosineInterpolation(g3 , g4, x - floor_x)
		return cosineInterpolation(int1, int2, y - floor_y)

	func generateTable(_seed):
		var source = []
		if _seed == 0:
			randomize()
			_seed = randi() % 256
		else:
			_seed = int(simple_noise1d(_seed) * 32767) % 256
		#Start the permutation table
		for i in range(256):
			source.append(i)
			perm.append(0)
		_seed = _seed * 6364136223846793005 + 1442695040888963407
		_seed = _seed * 6364136223846793005 + 1442695040888963407
		_seed = _seed * 6364136223846793005 + 1442695040888963407
		for ii in range(256):
			gx.append(2.0 - simple_noise1d(_seed * ii) - 1.0)
			gy.append(2.0 - simple_noise1d(_seed * ii) - 1.0)

	func perlin_noise2d(x, y):
		#Compute the integer positions of the four surrounding points
		var qx0 = int(floor(x))
		var qx1 = qx0 + 1
		var qy0 = int(floor(y))
		var qy1 = qy0 + 1
		#Permutate values to get indices to use with the gradient look-up tables
		var q00 = int(perm[(qy0 + perm[qx0 % 256]) % 256])
		var q01 = int(perm[(qy0 + perm[qx1 % 256]) % 256])
		var q10 = int(perm[(qy1 + perm[qx0 % 256]) % 256])
		var q11 = int(perm[(qy1 + perm[qx1 % 256]) % 256])
		#Vectors from the four points to the input point
		var tx0 = x - floor(x)
		var tx1 = tx0 - 1
		var ty0 = y - floor(y)
		var ty1 = ty0 - 1
		#Dot-product between the vectors and the gradients
		var v00 = gx[q00]*tx0 + gy[q00]*ty0
		var v01 = gx[q01]*tx1 + gy[q01]*ty0
		var v10 = gx[q10]*tx0 + gy[q10]*ty1
		var v11 = gx[q11]*tx1 + gy[q11]*ty1
		#Bi-cubic interpolation
		var wx = (3 - 2*tx0)*tx0*tx0
		var v0 = v00 - wx*(v00 - v01)
		var v1 = v10 - wx*(v10 - v11)

		var wy = (3 - 2*ty0)*ty0*ty0
		var v = v0 - wy*(v0 - v1)
		return v

	#2D OpenSimplex Noise.
	func openSimplex2D(x, y):

		#Place input coordinates onto grid.
		var stretchOffset = (x + y) * STRETCH_CONSTANT_2D
		var xs = x + stretchOffset
		var ys = y + stretchOffset

		#Floor to get grid coordinates of rhombus (stretched square) super-cell origin.
		var xsb = int(floor(xs))
		var ysb = int(floor(ys))

		#Skew out to get actual coordinates of rhombus origin. We'll need these later.
		var squishOffset = (xsb + ysb) * SQUISH_CONSTANT_2D
		var xb = xsb + squishOffset
		var yb = ysb + squishOffset

		#Compute grid coordinates relative to rhombus origin.
		var xins = xs - xsb
		var yins = ys - ysb

		#Sum those together to get a value that determines which region we're in.
		var inSum = xins + yins

		#Positions relative to origin point.
		var dx0 = x - xb
		var dy0 = y - yb

		#We'll be defining these inside the next block and using them afterwards.
		var dx_ext
		var dy_ext
		var xsv_ext
		var ysv_ext

		var value = 0

		#Contribution (1,0)
		var dx1 = dx0 - 1 - SQUISH_CONSTANT_2D
		var dy1 = dy0 - 0 - SQUISH_CONSTANT_2D
		var attn1 = 2 - dx1 * dx1 - dy1 * dy1
		if(attn1 > 0):
			attn1 *= attn1
			value += attn1 * attn1 * extrapolate2d(xsb + 1, ysb + 0, dx1, dy1)

		#Contribution (0,1)
		var dx2 = dx0 - 0 - SQUISH_CONSTANT_2D
		var dy2 = dy0 - 1 - SQUISH_CONSTANT_2D
		var attn2 = 2 - dx2 * dx2 - dy2 * dy2
		if(attn2 > 0):
			attn2 *= attn2
			value += attn2 * attn2 * extrapolate2d(xsb + 0, ysb + 1, dx2, dy2)

		if(inSum <= 1): #We're inside the triangle (2-Simplex) at (0,0)
			var zins = 1 - inSum
			if(zins > xins || zins > yins): #(0,0) is one of the closest two triangular vertices
				if(xins > yins):
					xsv_ext = xsb + 1
					ysv_ext = ysb - 1
					dx_ext = dx0 - 1
					dy_ext = dy0 + 1
				else:
					xsv_ext = xsb - 1
					ysv_ext = ysb + 1
					dx_ext = dx0 + 1
					dy_ext = dy0 - 1
			else: #(1,0) and (0,1) are the closest two vertices.
				xsv_ext = xsb + 1
				ysv_ext = ysb + 1
				dx_ext = dx0 - 1 - 2 * SQUISH_CONSTANT_2D
				dy_ext = dy0 - 1 - 2 * SQUISH_CONSTANT_2D

		else: #We're inside the triangle (2-Simplex) at (1,1)
			var zins = 2 - inSum
			if(zins < xins || zins < yins): #(0,0) is one of the closest two triangular vertices
				if(xins > yins):
					xsv_ext = xsb + 2
					ysv_ext = ysb + 0
					dx_ext = dx0 - 2 - 2 * SQUISH_CONSTANT_2D
					dy_ext = dy0 + 0 - 2 * SQUISH_CONSTANT_2D
				else:
					xsv_ext = xsb + 0
					ysv_ext = ysb + 2
					dx_ext = dx0 + 0 - 2 * SQUISH_CONSTANT_2D
					dy_ext = dy0 - 2 - 2 * SQUISH_CONSTANT_2D

			else: #(1,0) and (0,1) are the closest two vertices.
				dx_ext = dx0
				dy_ext = dy0
				xsv_ext = xsb
				ysv_ext = ysb

			xsb += 1
			ysb += 1
			dx0 = dx0 - 1 - 2 * SQUISH_CONSTANT_2D
			dy0 = dy0 - 1 - 2 * SQUISH_CONSTANT_2D

		#Contribution (0,0) or (1,1)
		var attn0 = 2 - dx0 * dx0 - dy0 * dy0
		if(attn0 > 0):
			attn0 *= attn0
			value += attn0 * attn0 * extrapolate2d(xsb, ysb, dx0, dy0)

		#Extra Vertex
		var attn_ext = 2 - dx_ext * dx_ext - dy_ext * dy_ext
		if(attn_ext > 0):
			attn_ext *= attn_ext
			value += attn_ext * attn_ext * extrapolate2d(xsv_ext, ysv_ext, dx_ext, dy_ext)

		return value / NORM_CONSTANT_2D

	func extrapolate2d(xsb, ysb, dx, dy):
		var index = perm[(perm[xsb & 0xFF] + ysb) & 0xFF] & 0x0E
		return gradients2D[index] * dx + gradients2D[index + 1] * dy
