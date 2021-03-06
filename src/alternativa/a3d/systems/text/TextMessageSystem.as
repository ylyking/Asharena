package alternativa.a3d.systems.text 
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	/**
	 * A GPU accelerated text messaging display system for Alternativa3D using SpriteSets, MaskColorAtlasMaterials, and Fontsheets
	 * 
	 * @author Glenn Ko
	 */
	public class TextMessageSystem extends System
	{
		
		
		public function TextMessageSystem() 
		{
		
		}
		
		public var textMessageNodes:NodeList;
		
		override public function addToEngine(engine:Engine):void {
			textMessageNodes = engine.getNodeList(TextMessageNode);
			
		}
		
		
		override public function update(time:Number):void {
			for (var t:TextMessageNode = textMessageNodes.head as TextMessageNode; t != null; t = t.next as TextMessageNode) {
				t.textBoxChannel.update(time);
			}
		}
		
	}

}
import ash.ClassMap;
import ash.core.Node;
import alternativa.a3d.systems.text.*;

class TextMessageNode extends Node {
	public var textBoxChannel:TextBoxChannel;
	//public var hud	
	public function TextMessageNode() {
		
	}
	private static var _components:ClassMap;
	
	public static function _getComponents():ClassMap {
		if(_components == null) {
				_components = new ClassMap();
				_components.set(TextBoxChannel, "textBoxChannel");
			
		}
			return _components;
	}
}

class FadeMessageNode extends Node {
	public var txtMessage:FadeTextMessage;  // when fade text message is reduced to zero, set name  to empty string. This would trigger signal for stack spawners.
	//public var hud	
		public function FadeMessageNode() {
			
		}
		
		private static var _components:ClassMap;
	
	public static function _getComponents():ClassMap {
		if(_components == null) {
				_components = new ClassMap();
				_components.set(FadeTextMessage, "txtMessage");
			
		}
			return _components;
	}
}
