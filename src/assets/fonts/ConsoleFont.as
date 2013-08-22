package assets.fonts 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class ConsoleFont extends Fontsheet
	{
		[Embed(source="../../../resources/fonts/console.png")]
		public static var FONT:Class;
		
		[Embed(source="../../../resources/fonts/console-bounds.bin", mimeType="application/octet-stream")]
		public static var BOUNDS:Class;
		
		public function ConsoleFont() 
		{
			var bytes:ByteArray = new BOUNDS();
			bytes.uncompress();
			init( new FONT().bitmapData, bytes);
		}
		
	}

}