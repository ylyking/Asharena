package systems.player.a3d 
{
	
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import arena.components.weapon.Weapon;
	import arena.systems.player.IStance;
	import ash.core.Entity;
	import ash.core.System;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import haxe.Log;
	import util.geom.Ray;
	use namespace alternativa3d;
	/**
	 * ...
	 * @author Glidias
	 */
	public class ThirdPersonAiming extends System
	{
		public var cameraRay:Ray = new Ray();
		public var stance:IStance;
		public var maxRange:Number = 9999999;
		public var minPitch:Number = -Math.PI * .5;
		public var maxPitch:Number = Math.PI * .5;
		private const ORIGIN:Vector3D = new Vector3D();
		private var camera:Camera3D;
		private var followObject:Object3D;
	
		private var spherePos:Vector3D = new Vector3D();
		private var sphereSideOffset:Number;
		private var sphereHeightOffset:Number;
		private var camForward:Vector3D;
		
		public function setEntity(entity:Entity):void {
			stance = entity.get(IStance) as IStance;
			var weapon:Weapon = entity.get(Weapon) as Weapon;
			maxRange = weapon.range;
			minPitch = weapon.minPitch;
			maxPitch = weapon.maxPitch;
			if (maxPitch == minPitch) maxPitch++;
			
			sphereSideOffset = weapon.sideOffset;
			sphereHeightOffset = weapon.heightOffset;
			
		}
		
		
		
		public function setCameraParameters(followObject:Object3D, camera:Camera3D, camForward:Vector3D):void {
			this.followObject = followObject;
			this.camera = camera;
			this.camForward = camForward;
			
		}
		
		public function ThirdPersonAiming() 
		{
			
		}
		
		override public function update(time:Number):void {
			var dz:Number;
			var dy:Number;
			var dx:Number;
			//stance.setPitchAim();
			
			if (stance == null || camera == null) return;
			
			cameraRay._orig.x = camera._x;
			cameraRay._orig.y = camera._y;
			cameraRay._orig.z = camera._z;
			
			if (camForward.lengthSquared != 0){
			cameraRay._dir.x = camForward.x;
			cameraRay._dir.y = camForward.y;
			cameraRay._dir.z = camForward.z;
			}
			else {
				camera.calculateRay( new Vector3D(), cameraRay._dir, camera.view._width * .5, camera.view._height * .5);
			}
			
			spherePos.x = followObject._x;
			spherePos.y = followObject._y;
			spherePos.z = followObject._z;

			/*
			if (!cameraRay.intersectsSphere( cameraRay._orig, cameraRay._dir, spherePos, maxRange) ) {
				throw new Error("SHOuld intersect!:" + (cameraRay._orig.subtract(spherePos).length < maxRange) + ", "+cameraRay._dir );
				return;
			}
			*/
			dx = cameraRay._orig.x - spherePos.x;
			dy = cameraRay._orig.y - spherePos.y;
			dz = cameraRay._orig.z - spherePos.z;
			/*
			if (( dx * dx + dy * dy + dz * dz > maxRange * maxRange) ) {
				Log.trace("Assert inside failed!");
			}
			*/
			
			var vec:Vector3D = cameraRay.getRayToSphereIntersection(cameraRay._orig, cameraRay._dir, spherePos, maxRange, dx*dx+dy*dy+dz*dz > maxRange*maxRange );
				
			dx = vec.x - spherePos.x;
			dy = vec.y - spherePos.y;
			dz = vec.z - spherePos.z;
			
		
			var diffAngle:Number = Math.atan2(dz, Math.sqrt( dx * dx + dy * dy) );
			
			diffAngle  = diffAngle < minPitch ? minPitch : diffAngle > maxPitch ? maxPitch : diffAngle;
			//Log.trace(diffAngle+  ", " +(diffAngle-minPitch) / (maxPitch - minPitch) + ", "+ cameraRay._a);
			stance.setPitchAim((diffAngle-minPitch) / (maxPitch - minPitch), time)
			//if (vec.x*vec.x + vec.y*vec.y + vec.z*vec.z <=
		}
		
	}

}