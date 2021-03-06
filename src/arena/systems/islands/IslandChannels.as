package arena.systems.islands 
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	/**
	 * Cross-communication between IslandGen worker and Main application
	 * @author Glenn Ko
	 */
	public class IslandChannels 
	{
		public var doTrace:Function;
		public var initZoneChannel:MessageChannel;      // to listen from worker, dispatched from main
		public var initIslandChannel:MessageChannel;  // to listen from worker, dispatched from main
		public var mainResponseDone:MessageChannel; // to listen from worker, dispatched from main
		
		public var islandInitedChannel:MessageChannel;  // to notify main
		
		public var toMainErrorChannel:MessageChannel;  // to notify main
		public var toMainTraceChannel:MessageChannel;  // to notify main
		
		public var mainByteArray:ByteArray; // edit from Main. read-only from worker
		public var mainParamsArray:ByteArray; // edit from Main. read-only from worker
		
		public var workerByteArray:ByteArray;   // edit from worker, read-only from main (Payload raw numerical data or object data)
		public var workerParamsArray:ByteArray; // edit from worker, read-only from main (Parameters of all types)
		
		
		
		public static const CHARSET:String = 'iso-8859-1';
		
		// codes to notify worker to do work!
		public static const ON_POSITION_CHANGE:int = -1;    // notify a position change for updating surrounding zones and potentially visbile islands! 
		public static const ON_LODTREE_CHANGE:int = -2;  	// request LOD segments accordingly
		
		// event codes in order of execution
		// Tier 1
		public static const INITED_BLUEPRINT_HEIGHT:int = 0;	 // low-res height data (33x33)
		public static const INITED_BLUEPRINT_COLOR:int = 1;  	 // low-res color texture map ( <= 1024x1024 )
		
		// Tier 2
		public static const INITED_DETAIL_HEIGHT:int = 2; // detail height map   (<= 129x129 ) // naively recalculated for the different TerrainLODs
		
		public static const INITED_DETAIL_SPLAT:int = 3; 	 // detail rgb splat map. SplatTexureMaterial to be created on Main   (>= 128x128 combined sample from 128x128 grid worker samples. copyPixels() from <=1024x1024 image sources up to a certain LOD distance )
		public static const INITED_DETAIL_BIOMETILES:int = 4;  // detail tile map. TileAtlasTextureMaterial to be created on Main (>= 128x128 combined sample from 128x128 grid worker samples from 1x1 + bleed edges <=512x512 image sources up to a certain LOD distance )

		public static const INITED_DETAIL_PROPS:int = 5; // closed-ranged detail props per region  (MeshSetClonesContainer) positions.
		public static const INITED_FARAWAY_PROPS:int = 6; // faraway low-LOD combined props per region  (for Main to upload combined low-detailed mesh geometry data for large faraway regions)
	
		// Exploration settings
		public var zoneDistance:Number;
		public var minLODTreeLevels:int;
		public var minLODTreeTileDistance:int;
		
		public var zoneTileDistance:int;
		public var maxIslandTileDistance:int;
		
		public function IslandChannels() 
		{
			
		}
		
		public function receiveParams():void {  // called from Main. Somehow, the position doesn't seem to update on Main's end. I guess different worker domains have different position pointers!
			workerParamsArray.position = 0;
			workerByteArray.position = 0;
		}
		
		
		public function initPrimordial(worker:Worker, zoneTileDistance:int, maxIslandTileDistance:int, zoneDistance:Number=1, minLODTreeLevels:int=4, minLODTreeTileDistance:int=128):void {
			worker.setSharedProperty("initZoneChannel", initZoneChannel=Worker.current.createMessageChannel(worker) );
			worker.setSharedProperty("initIslandChannel", initIslandChannel = Worker.current.createMessageChannel(worker));
			worker.setSharedProperty("mainResponseDone", mainResponseDone = Worker.current.createMessageChannel(worker));
			worker.setSharedProperty("islandInitedChannel", islandInitedChannel = worker.createMessageChannel(Worker.current));
			worker.setSharedProperty("toMainErrorChannel", toMainErrorChannel = worker.createMessageChannel(Worker.current));
			worker.setSharedProperty("toMainTraceChannel", toMainTraceChannel = worker.createMessageChannel(Worker.current));
			
			
			worker.setSharedProperty("zoneDistance", this.zoneDistance = zoneDistance);
			worker.setSharedProperty("zoneTileDistance", this.zoneTileDistance = zoneTileDistance);
			worker.setSharedProperty("maxIslandTileDistance", this.maxIslandTileDistance=maxIslandTileDistance);
			worker.setSharedProperty("minLODTreeLevels",this.minLODTreeLevels= minLODTreeLevels);
			worker.setSharedProperty("minLODTreeTileDistance", this.minLODTreeTileDistance=minLODTreeTileDistance );
			
			
			workerByteArray = new ByteArray();
			
			workerByteArray.endian = Endian.LITTLE_ENDIAN;
			workerByteArray.shareable = true;
			workerParamsArray = new ByteArray();
		//	workerParamsArray.endian = Endian.LITTLE_ENDIAN;
			workerParamsArray.shareable = true;
			worker.setSharedProperty("workerByteArray", workerByteArray);
			worker.setSharedProperty("workerParamsArray", workerParamsArray);
			
			
			mainParamsArray = new ByteArray();
			//mainParamsArray.endian = Endian.LITTLE_ENDIAN;
			mainParamsArray.shareable = true;
			mainByteArray = new ByteArray();
			mainByteArray.endian = Endian.LITTLE_ENDIAN;
			mainByteArray.shareable = true;
			worker.setSharedProperty("mainParamsArray", mainParamsArray);
			worker.setSharedProperty("mainByteArray", mainByteArray);
			
			
			toMainErrorChannel.addEventListener(Event.CHANNEL_MESSAGE, onErrorReceived);
			toMainTraceChannel.addEventListener(Event.CHANNEL_MESSAGE, onTraceReceived);
			
			doTrace = getDefinitionByName("haxe::Log").trace;
		}
		
		private function onErrorReceived(e:Event):void 
		{
			throw new Error( toMainErrorChannel.receive() );
		}
		
		private function onTraceReceived(e:Event):void {
			doTrace( toMainTraceChannel.receive());
		}
		
		public function initFromChild():void {
			initZoneChannel = Worker.current.getSharedProperty("initZoneChannel");
			initIslandChannel = Worker.current.getSharedProperty("initIslandChannel");
			islandInitedChannel = Worker.current.getSharedProperty("islandInitedChannel");
			mainResponseDone = Worker.current.getSharedProperty("mainResponseDone");
			toMainErrorChannel = Worker.current.getSharedProperty("toMainErrorChannel");
			toMainTraceChannel = Worker.current.getSharedProperty("toMainTraceChannel");
			workerByteArray = Worker.current.getSharedProperty("workerByteArray");
			workerByteArray.endian = Endian.LITTLE_ENDIAN;
			workerParamsArray = Worker.current.getSharedProperty("workerParamsArray");
			
			mainParamsArray = Worker.current.getSharedProperty("mainParamsArray");
			mainByteArray = Worker.current.getSharedProperty("mainByteArray");
			mainByteArray.endian = Endian.LITTLE_ENDIAN;
			
			zoneDistance = Worker.current.getSharedProperty("zoneDistance");
			zoneTileDistance = Worker.current.getSharedProperty("zoneTileDistance");
			maxIslandTileDistance = Worker.current.getSharedProperty("maxIslandTileDistance");
			
			minLODTreeLevels = Worker.current.getSharedProperty("minLODTreeLevels");
			minLODTreeTileDistance = Worker.current.getSharedProperty("minLODTreeTileDistance");
		}
		
		public function sendTrace(str:Object):void {
			toMainTraceChannel.send(str.toString());
		}
		
		public function sendError(err:Error):void {
			toMainErrorChannel.send(err.name + "\n"+err.message + "\n"+ err.getStackTrace());
		}
		
	
		
	}

}