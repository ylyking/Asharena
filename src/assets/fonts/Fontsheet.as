package assets.fonts 
{
	import alternativa.engine3d.materials.compiler.Procedure;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import de.polygonal.gl.text.VectorFont;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import util.SpawnerBundle;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class Fontsheet 
	{
		private static var _transformProcedures:Dictionary = new Dictionary();
		
		public var rectsInt:Vector.<uint> = new Vector.<uint>();
		public var rects:Vector.<Number> = new Vector.<Number>();
		public var charRectIndices:Vector.<int>;
		public var sheet:BitmapData;
		public var bmpResource:BitmapTextureResource;
		public var padding:uint;
		public var fontV:VectorFont;
		public var tight:Boolean = true;  // for now, this setting should not change!
		
		public function Fontsheet() 
		{
			
		}
		
		protected function init(texture:BitmapData, rectBytes:ByteArray):void {
			
			if (fontV == null) throw new Error("Please define a vector font fontV variable before calling init()!");
			charRectIndices = fontV.getCharSetIndices();
			
			sheet = texture;
			
			var sheetWidthMult:Number = 1/ sheet.width;
			var sheetHeightMult:Number = 1 / sheet.height;
			
			var len:int =  rectBytes.length / 4 / 4;//*4/4;  //4 bytes per number
			
			padding = rectBytes.readUnsignedInt();
			
			var count:int = 0;
			var countI:int = 0;
			for (var i:int = 0; i < len; i++) {
				var x:uint=rectBytes.readUnsignedInt();
				var y:uint=  rectBytes.readUnsignedInt();
				var width:uint = rectBytes.readUnsignedInt();
				var height:uint = rectBytes.readUnsignedInt();
				rectsInt[countI++] = x;
				rectsInt[countI++] = y;
				rectsInt[countI++] = width;
				rectsInt[countI++] = height;
				rects[count++] = x * sheetWidthMult;
				rects[count++] = y * sheetHeightMult;
				rects[count++] = width * sheetWidthMult;
				rects[count++] = height * sheetHeightMult;
			}
			rects.fixed = true;
			
			bmpResource = new BitmapTextureResource(sheet);
			bmpResource.upload( SpawnerBundle.context3D );
		}
		
		public function getRandomRect(rect:Rectangle=null):Rectangle {
			rect = rect || (new Rectangle());
			var index:uint = Math.random() * getNumLetters();
			rect.width = rects[(index << 2) + 2];
			rect.height = rects[(index << 2) + 3];
			
			rect.x = rects[(index << 2)];
			rect.y = rects[(index << 2) + 1];
			
			//if (rect.x < 0) rect.x = 0;
			//if (rect.y < 0) rect.y = 0;
			//if (rect.x < 0 || rect.y <0) throw new Error("A:"+rect);
		
			return rect;
		}
		
	
		
		public function getRectangleAt(index:uint, rect:Rectangle = null):Rectangle {
			rect = rect || (new Rectangle());
			rect.x = rects[(index << 2)]
			rect.y = rects[(index << 2)+1]
			rect.width = rects[(index << 2) + 2];
			rect.height = rects[(index << 2) + 3];
			return rect;
		}
		
		public function getNumLetters():int {
			return (rects.length >> 2);
		}
		
		
		
	}

}