package saboteur.spawners 
{
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.materials.VertexLightZClipMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.utils.Object3DUtils;
	import ash.core.Engine;
	import ash.core.Entity;
	import components.DirectionVectors;
	import components.Pos;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import saboteur.util.CardinalVectors;
	import saboteur.util.GameBuilder3D;
	import saboteur.util.SaboteurPathUtil;
	import util.SpawnerBundle;
	import alternativa.engine3d.alternativa3d;
	use namespace alternativa3d;
	
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class JettySpawner extends SpawnerBundle
	{

		public var editorMat:FillMaterial = new FillMaterial(0, .1);
		static public const SPAWN_SCALE:Number = 17;
		private var genesis:Object3D;
		private var blueprint:Object3D;
		private var injectMaterial:VertexLightZClipMaterial;
		private var collision:Object3D;
		private var _floor:Plane;
		public var diffuse:BitmapTextureResource;


		public function JettySpawner() 
		{
		
			ASSETS = [JettyAssets];
			
			super();
		}
		
		override protected function init():void 
		{
			 var plane:Plane = new Plane(1, 1, 1, 1, false, false, editorMat, editorMat);
			 editorMat.color = GameBuilder3D.COLOR_OCCUPIED;
		
			_floor = plane;	
		 _floor.z += 8;
		 
			plane.geometry.upload(context3D);
			
			diffuse = new BitmapTextureResource(new JettyAssets.$_TEXTURE().bitmapData);
			
		
		//	var normalResource:BitmapTextureResource = new BitmapTextureResource(    new BitmapData(16, 16, false, 0x8080FF) );
			injectMaterial = new VertexLightZClipMaterial(diffuse);
			//injectMaterial.glossiness = 0;
		//	injectMaterial.specularPower = 0;
            
            
			var previewMaterial:TextureMaterial = injectMaterial.clone() as TextureMaterial;
			previewMaterial.alphaThreshold = .99;
			previewMaterial.alpha = .4;

			
			// Setup parsing of 3d stuff from a3d
			var parserA3D:ParserA3D = new ParserA3D();
            parserA3D.parse( new JettyAssets.$_MODEL() );
			
			var rootCont:Object3D = parserA3D.hierarchy[0];

			//throw new Error(rootCont.getChildByName("genesis"));
			genesis =  rootCont.getChildByName("genesis");
			if (genesis == null) throw new Error("Could not find genesis!");
			setMaterialToCont( injectMaterial, genesis );
			blueprint = genesis.clone();
			blueprint.name = "blueprint";
		
			setMaterialToCont( previewMaterial, blueprint );
			collision = rootCont.getChildByName("collision");
			if (collision == null) throw new Error("Could not find collision!");

			uploadResources(collision.getResources(true));
			uploadResources(rootCont.getResources(true, null));
			
			 
			super.init();
		}
		
		private function setMaterialToCont(mat:Material, cont:Object3D):void 
		{
			for (var c:Object3D = cont.childrenList; c != null; c = c.next) {
				var mesh:Mesh = c as Mesh;
				if (mesh != null) {
					mesh.setMaterialToAllSurfaces(mat);
				}
			}
		}
		
	
		public function spawn(engine:Engine, scene:Object3D, pos:Pos=null, rayDir:DirectionVectors=null):Entity {
			
			var root:Object3D = scene.addChild(new Object3D());
			root._scaleX = root._scaleY = root._scaleZ =  SPAWN_SCALE;
			
			var gameBuilder:GameBuilder3D = new GameBuilder3D(root, genesis, blueprint, collision, injectMaterial, editorMat, _floor);
			var cardinal:CardinalVectors = new CardinalVectors();
			var entity:Entity = new Entity().add(cardinal).add(gameBuilder);
			if (pos != null) entity.add(pos, Pos);
			if (rayDir != null) entity.add(rayDir, DirectionVectors);
			engine.addEntity(entity);
			return entity;
		}
		
	}

}