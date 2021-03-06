package hashds.ds;
import de.polygonal.core.math.Mathematics;
import flash.Vector;

/**
 * ...
 * @author Glidias
 */
class FractalNoise
{
	
		
		private var hash:Vector<Int>;
		
		// generic hash table, left it public cos could be useful for other applications
		static public var HASH:Vector<Int> = {
			var vec:Vector<Int> = new Vector<Int>();
			var arr:Array<Int> = [0xA2,0xA0,0x19,0x3B,0xF8,0xEB,0xAA,0xEE,0xF3,0x1C,0x67,0x28,0x1D,0xED,0x0,0xDE,0x95,0x2E,0xDC,0x3F,0x3A,0x82,0x35,0x4D,0x6C,0xBA,0x36,0xD0,0xF6,0xC,0x79,0x32,0xD1,0x59,0xF4,0x8,0x8B,0x63,0x89,0x2F,0xB8,0xB4,0x97,0x83,0xF2,0x8F,0x18,0xC7,0x51,0x14,0x65,0x87,0x48,0x20,0x42,0xA8,0x80,0xB5,0x40,0x13,0xB2,0x22,0x7E,0x57,
								0xBC,0x7F,0x6B,0x9D,0x86,0x4C,0xC8,0xDB,0x7C,0xD5,0x25,0x4E,0x5A,0x55,0x74,0x50,0xCD,0xB3,0x7A,0xBB,0xC3,0xCB,0xB6,0xE2,0xE4,0xEC,0xFD,0x98,0xB,0x96,0xD3,0x9E,0x5C,0xA1,0x64,0xF1,0x81,0x61,0xE1,0xC4,0x24,0x72,0x49,0x8C,0x90,0x4B,0x84,0x34,0x38,0xAB,0x78,0xCA,0x1F,0x1,0xD7,0x93,0x11,0xC1,0x58,0xA9,0x31,0xF9,0x44,0x6D,
								0xBF,0x33,0x9C,0x5F,0x9,0x94,0xA3,0x85,0x6,0xC6,0x9A,0x1E,0x7B,0x46,0x15,0x30,0x27,0x2B,0x1B,0x71,0x3C,0x5B,0xD6,0x6F,0x62,0xAC,0x4F,0xC2,0xC0,0xE,0xB1,0x23,0xA7,0xDF,0x47,0xB0,0x77,0x69,0x5,0xE9,0xE6,0xE7,0x76,0x73,0xF,0xFE,0x6E,0x9B,0x56,0xEF,0x12,0xA5,0x37,0xFC,0xAE,0xD9,0x3,0x8E,0xDD,0x10,0xB9,0xCE,0xC9,0x8D,
								0xDA,0x2A,0xBD,0x68,0x17,0x9F,0xBE,0xD4,0xA,0xCC,0xD2,0xE8,0x43,0x3D,0x70,0xB7,0x2,0x7D,0x99,0xD8,0xD,0x60,0x8A,0x4,0x2C,0x3E,0x92,0xE5,0xAF,0x53,0x7,0xE0,0x29,0xA6,0xC5,0xE3,0xF5,0xF7,0x4A,0x41,0x26,0x6A,0x16,0x5E,0x52,0x2D,0x21,0xAD,0xF0,0x91,0xFF,0xEA,0x54,0xFA,0x66,0x1A,0x45,0x39,0xCF,0x75,0xA4,0x88,0xFB,0x5D,
								0xA2,0xA0,0x19,0x3B,0xF8,0xEB,0xAA,0xEE,0xF3,0x1C,0x67,0x28,0x1D,0xED,0x0,0xDE,0x95,0x2E,0xDC,0x3F,0x3A,0x82,0x35,0x4D,0x6C,0xBA,0x36,0xD0,0xF6,0xC,0x79,0x32,0xD1,0x59,0xF4,0x8,0x8B,0x63,0x89,0x2F,0xB8,0xB4,0x97,0x83,0xF2,0x8F,0x18,0xC7,0x51,0x14,0x65,0x87,0x48,0x20,0x42,0xA8,0x80,0xB5,0x40,0x13,0xB2,0x22,0x7E,0x57,
								0xBC,0x7F,0x6B,0x9D,0x86,0x4C,0xC8,0xDB,0x7C,0xD5,0x25,0x4E,0x5A,0x55,0x74,0x50,0xCD,0xB3,0x7A,0xBB,0xC3,0xCB,0xB6,0xE2,0xE4,0xEC,0xFD,0x98,0xB,0x96,0xD3,0x9E,0x5C,0xA1,0x64,0xF1,0x81,0x61,0xE1,0xC4,0x24,0x72,0x49,0x8C,0x90,0x4B,0x84,0x34,0x38,0xAB,0x78,0xCA,0x1F,0x1,0xD7,0x93,0x11,0xC1,0x58,0xA9,0x31,0xF9,0x44,0x6D,
								0xBF,0x33,0x9C,0x5F,0x9,0x94,0xA3,0x85,0x6,0xC6,0x9A,0x1E,0x7B,0x46,0x15,0x30,0x27,0x2B,0x1B,0x71,0x3C,0x5B,0xD6,0x6F,0x62,0xAC,0x4F,0xC2,0xC0,0xE,0xB1,0x23,0xA7,0xDF,0x47,0xB0,0x77,0x69,0x5,0xE9,0xE6,0xE7,0x76,0x73,0xF,0xFE,0x6E,0x9B,0x56,0xEF,0x12,0xA5,0x37,0xFC,0xAE,0xD9,0x3,0x8E,0xDD,0x10,0xB9,0xCE,0xC9,0x8D,
								0xDA, 0x2A, 0xBD, 0x68, 0x17, 0x9F, 0xBE, 0xD4, 0xA, 0xCC, 0xD2, 0xE8, 0x43, 0x3D, 0x70, 0xB7, 0x2, 0x7D, 0x99, 0xD8, 0xD, 0x60, 0x8A, 0x4, 0x2C, 0x3E, 0x92, 0xE5, 0xAF, 0x53, 0x7, 0xE0, 0x29, 0xA6, 0xC5, 0xE3, 0xF5, 0xF7, 0x4A, 0x41, 0x26, 0x6A, 0x16, 0x5E, 0x52, 0x2D, 0x21, 0xAD, 0xF0, 0x91, 0xFF, 0xEA, 0x54, 0xFA, 0x66, 0x1A, 0x45, 0x39, 0xCF, 0x75, 0xA4, 0x88, 0xFB, 0x5D];
			var len:Int = arr.length;
			for (i in 0...len) {
				vec[i] = arr[i];
			}
			vec.fixed = true;
			vec;
			
		}
		
				/****** initObject parameters *******/
		// common parameters		
		//static private var noiseBasis:Function			= improved;
		//static private var interpolation:Function		= smooth5;		// the function used for interpolating the noise
		
		// fBm
		 private var octaves:Int					= 4;			// number of frequencies in the fractal
		 private var lacunarity:Float			= 2;			// gap between successive frequencies
		 private var H:Float						= 0.5;			// fractal implement parameter

		// multifractals
		 private var offset:Float				= 0.8;

		/****** END initObject parameters *******/
		
		 private var maxAmp:Float				= 0;
		
	
		// linear interpolation of t from a to b
		inline static public function lerp(t:Float, a:Float, b:Float):Float {
			return a + t * (b - a);
		}
		
		
				
		// clamps a Float between 0..1 and smooths the cutoff points
		inline static public function smoothClamp(n:Float):Float {
			return smooth5(clamp(n));
		}
	
		
		 public function setParams(initObject:Dynamic):Void {
			
			
			if(initObject.octaves)			octaves			= initObject.octaves;
			if(initObject.lacunarity)		lacunarity		= initObject.lacunarity;
			if(initObject.H)				H				= initObject.H;
			if(initObject.offset)			offset			= initObject.offset;
			
			calcMax();
		}
		
		public inline function setParamsI(octaves:Int, lacunarity:Float, H:Float, offset:Float = .8) {
			this.octaves = octaves;
			this.lacunarity = lacunarity;
			this.H = H;
			this.offset = offset;
		}
		
	
		
		
		// clamps a Float between 0, 1 
		inline static public function clamp(n:Float):Float {
			return n < 0 ? 0 : n > 1 ? 1 : n;
		}
		
		
		inline static public function smooth5(t:Float):Float {
			return t * t * t * (t * (t * 6 - 15) + 10);
		}
		
		
		inline static public function smooth3(t:Float):Float {
			return t * t * (3 - 2 * t);
		}
		

		inline static public function grad(hash:Int, x:Float, y:Float, z:Float):Float {
			var h:Int = hash & 15;                  								// CONVERT LO 4 BITS OF HASH CODE
			var u:Float = h<8 ? x : y;
			var v:Float = h<4 ? y : (h == 12 || h==14) ? x : z;     				// INTO 12 GRADIENT DIRECTIONS.
			return ( (h&1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
		}
		
		
		
				
		// improved perlin noise function (to be iterated in other functions such as fractalNoise, turbulence etc.
		 public inline function improved(x:Float, y:Float, z:Float):Float {
			var fx:Int =  Math.floor(x);
			var fy:Int = Math.floor(y);
			var fz:Int = Math.floor(z);
			var X:Int = fx & 255;					// FIND UNIT CUBE THAT CONTAINS POINT.
			var Y:Int = fy & 255;              
			var Z:Int = fz & 255;
			x -= fx;									// FIND RELATIVE X,Y,Z
			y -= fy;									// OF POINT IN CUBE.
			z -=  fz;
			var u:Float = smooth5(x);						// COMPUTE FADE CURVES
			var v:Float = smooth5(y);						// FOR EACH OF X,Y,Z.
			var w:Float = smooth5(z);
			var h:Vector<Int> = hash;
			var A:Int = h[X]+Y;									// HASH COORDINATES OF THE 8 CUBE CORNERS,
			var AA:Int = h[A]+Z;
			var AB:Int = h[A+1]+Z;
			var B:Int = h[X+1]+Y;
			var BA:Int = h[B]+Z;
			var BB:Int = h[B+1]+Z;	
		
			return lerp(w, lerp(v, lerp(u, grad(h[AA  ], x  , y  , z   ),
										 grad(h[BA  ], x-1, y  , z   )), 
								 lerp(u, grad(h[AB  ], x  , y-1, z   ), 
										 grad(h[BB  ], x-1, y-1, z   ))),
						 lerp(v, lerp(u, grad(h[AA+1], x  , y  , z-1 ),  
										 grad(h[BA+1], x-1, y  , z-1 )), 
								 lerp(u, grad(h[AB+1], x  , y-1, z-1 ),
										 grad(h[BB+1], x-1, y-1, z-1 ))));
		}
		
		// returns -1...1 (needed for BLU_gnoise, BLI_gTurbuluence)
		 private inline function improvedU(x:Float, y:Float, z:Float):Float {
			return 0.5 + 0.5 * improved(x, y, z);
		}
		
		
		public inline  function noise(x:Float, y:Float, z:Float):Float {
			var amp:Float = 1;
			var fscale:Float = 1;
			var sum:Float = 0;
			
			if (maxAmp == 0) calcMax();
			var i:Int = 0;
			while ( i < octaves) {
				sum  += amp * improved(fscale * x, fscale * y, fscale * z);
				 amp *= H; 
				 fscale *= lacunarity;
				i++;
			}
	
			return (sum * maxAmp + 1) * 0.5;
		}
		
		private inline function calcMax():Void {
			maxAmp = 0;
			for (i in 0...octaves) maxAmp += Math.pow(H, i);
			maxAmp = 1/maxAmp;
		}

	public function new() 
	{
		hash = FractalNoise.HASH;
	}
	
}