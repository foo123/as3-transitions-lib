package com.nikos.mytransitions
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.BoundingSphere;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	public class ShadowCaster
	{
		private var vertexRefs:Dictionary;
		private var numberRefs:Dictionary;
		private var lightRay:Number3D = new Number3D()
		private var p3d:Plane3D = new Plane3D();
		public var color:uint = 0;
		public var alpha:Number = 0;
		public var blend:String = "";
		public var filters:Array;
		public var uid:String;
		private var _type:String = "point";
		private var dir:Number3D;
		private var planeBounds:Dictionary;
		private var targetBounds:Dictionary;
		private var models:Dictionary;
		
		
		public static var DIRECTIONAL:String = "dir";
		public static var SPOTLIGHT:String = "spot";
		
		
		public function ShadowCaster(uid:String, color:uint = 0, blend:String = "multiply", alpha:Number = 1, filters:Array=null)
		{
			this.uid = uid;
			this.color = color;
			this.alpha = alpha;
			this.blend = blend;	
			this.filters = filters ? filters : [new BlurFilter()];
			numberRefs = new Dictionary(true);
			targetBounds = new Dictionary(true);
			planeBounds = new Dictionary(true);
			models = new Dictionary(true);
		}

		public function castModel(model:DisplayObject3D, light:PointLight3D, plane:Plane, faces:Boolean = true, cull:Boolean = false):void{
			
			var ar:Array;
			if(models[model])
			{
				ar = models[model];
			}else{
				ar = new Array();
				getChildMesh(model, ar);
				models[model] = ar;
			}
			
			
			var reset:Boolean = true;
			
			for each(var t:TriangleMesh3D in ar){
				if(faces)
					castFaces(light, t, plane, cull, reset);
				else
					castBoundingSphere(light, t, plane, 0.75, reset);
				reset = false;
			}
		
		}
		
		private function getChildMesh(do3d:DisplayObject3D, ar):void{
			if(do3d is TriangleMesh3D)
				ar.push(do3d);
				
			for each(var d:DisplayObject3D in do3d.children)
				getChildMesh(d, ar);
		}

		public function setType(type:String="point"):void{
			_type = type;
		}
		public function getType():String{
			return _type;
		}
		
		public function castBoundingSphere(light:PointLight3D, target:TriangleMesh3D, plane:Plane, scaleRadius:Number=0.8, clear:Boolean = true):void{
			var planeVertices:Array = plane.geometry.vertices;
			
			//convert to target space?
			var world:Matrix3D = plane.world;
			var inv:Matrix3D = Matrix3D.inverse(plane.transform);
			
			var lp:Number3D = new Number3D(light.x, light.y, light.z);
			Matrix3D.multiplyVector(inv, lp);
			
			p3d.setNormalAndPoint(plane.geometry.faces[0].faceNormal, new Number3D());
			
			var b:BoundingSphere = target.geometry.boundingSphere;
			
			
			var bounds:Object = planeBounds[plane];
			if(!bounds){
				bounds = plane.boundingBox();
				planeBounds[plane] = bounds;
			}
				
			
			var tbounds:Object = targetBounds[target];
			if(!tbounds){
				tbounds = target.boundingBox();
				targetBounds[target] = tbounds;
			}
				
			
			var planeMovie:Sprite = Sprite(MovieMaterial(plane.material).movie);
			var movieSize:Point = new Point(planeMovie.width, planeMovie.height);
		
			var castClip:Sprite = getCastClip(plane);
				castClip.blendMode = this.blend;
				castClip.filters = this.filters;
				castClip.alpha = this.alpha;
			
			if(clear)
				castClip.graphics.clear();
						
			vertexRefs = new Dictionary(true);
			
			var tlp:Number3D = new Number3D(light.x, light.y, light.z);
			Matrix3D.multiplyVector(Matrix3D.inverse(target.world), tlp);
			
			var center:Number3D = new Number3D(tbounds.min.x+tbounds.size.x*0.5, tbounds.min.y+tbounds.size.y*0.5, tbounds.min.z+tbounds.size.z*0.5);
			
			
			var dif:Number3D = Number3D.sub(lp, center);
			dif.normalize();
			
			var other:Number3D = new Number3D();
			other.x = -dif.y;
			other.y = dif.x;
			other.z = 0;
			
			other.normalize();
			
			
			var cross:Number3D = Number3D.cross(new Number3D(plane.transform.n12, plane.transform.n22, plane.transform.n32), p3d.normal);
			cross.normalize();
			
			//cross = new Number3D(-dif.y, dif.x, 0);
			//cross.normalize();
			
			cross.multiplyEq(b.radius*scaleRadius);
			
			
			if(_type == DIRECTIONAL){
				var oPos:Number3D = new Number3D(target.x, target.y, target.z);
				Matrix3D.multiplyVector(target.world, oPos);
				Matrix3D.multiplyVector(inv, oPos);
				dir = new Number3D(oPos.x-lp.x, oPos.y-lp.y, oPos.z-lp.z);
			}
			
			//numberRefs = new Dictionary(true);
			var pos:Number3D;			
			var c2d:Point;
			var r2d:Point;
		
			//_type = SPOTLIGHT;
			pos = projectVertex(new Vertex3D(center.x, center.y, center.z), lp, inv, target.world);
			c2d = get2dPoint(pos, bounds.min, bounds.size, movieSize);
			//trace(pos, bounds.min, bounds.size, movieSize);
			pos = projectVertex(new Vertex3D(center.x+cross.x, center.y+cross.y, center.z+cross.z), lp, inv, target.world);
			r2d = get2dPoint(pos, bounds.min, bounds.size, movieSize);
			//trace(pos, bounds.min, bounds.size, movieSize);
			
			var dx:Number = r2d.x-c2d.x;
			var dy:Number = r2d.y-c2d.y;
			var rad:Number = Math.sqrt(dx*dx+dy*dy);
			
			castClip.graphics.beginFill(color);
			castClip.graphics.moveTo(c2d.x, c2d.y);
			castClip.graphics.drawCircle(c2d.x, c2d.y, rad);
			castClip.graphics.endFill();
			
			
			
		}
		
		public function getCastClip(plane:Plane):Sprite{
			
			var planeMovie:Sprite = Sprite(MovieMaterial(plane.material).movie);
			var movieSize:Point = new Point(planeMovie.width, planeMovie.height);
			var castClip:Sprite;// = new Sprite();
			if(planeMovie.getChildByName("castClip"+uid))
				return Sprite(planeMovie.getChildByName("castClip"+uid));
			else{
				castClip = new Sprite();
				castClip.name = "castClip"+uid;
				castClip.scrollRect = new Rectangle(0, 0, movieSize.x, movieSize.y);
				//castClip.alpha = 0.4;
				planeMovie.addChild(castClip);
				return castClip;
			}
		}
		
		public function castFaces(light:PointLight3D, target:TriangleMesh3D, plane:Plane, cull:Boolean=false, clear:Boolean = true):void{
			
			
			var planeVertices:Array = plane.geometry.vertices;
		
			//convert to target space?
			var world:Matrix3D = plane.world;
			var inv:Matrix3D = Matrix3D.inverse(plane.transform);
			
			var lp:Number3D = new Number3D(light.x, light.y, light.z);
			Matrix3D.multiplyVector(inv, lp);
			
			var tlp:Number3D;
			if(cull){
				tlp = new Number3D(light.x, light.y, light.z);
				Matrix3D.multiplyVector(Matrix3D.inverse(target.world), tlp);
			}
			//Matrix3D.multiplyVector(Matrix3D.inverse(target.transform), tlp);
			
			//p3d.setThreePoints(planeVertices[0].getPosition(), planeVertices[1].getPosition(), planeVertices[2].getPosition());
			p3d.setNormalAndPoint(plane.geometry.faces[0].faceNormal, new Number3D());
			
			if(_type == DIRECTIONAL){
				var oPos:Number3D = new Number3D(target.x, target.y, target.z);
				Matrix3D.multiplyVector(target.world, oPos);
				Matrix3D.multiplyVector(inv, oPos);
				dir = new Number3D(oPos.x-lp.x, oPos.y-lp.y, oPos.z-lp.z);
			}

			var bounds:Object = planeBounds[plane];
			if(!bounds){
				bounds = plane.boundingBox();
				planeBounds[plane] = bounds;
			}
			
			var castClip:Sprite = getCastClip(plane);	
				castClip.blendMode = this.blend;
				castClip.filters = this.filters;
				castClip.alpha = this.alpha;
			
			
			var planeMovie:Sprite = Sprite(MovieMaterial(plane.material).movie);
			var movieSize:Point = new Point(planeMovie.width, planeMovie.height);
			
			if(clear)
				castClip.graphics.clear();
						
			vertexRefs = new Dictionary(true);
			//numberRefs = new Dictionary(true);
			var pos:Number3D;			
			var p2d:Point;
			var s2d:Point;
			var hitVert:Number3D = new Number3D();
			
			for each(var t:Triangle3D in target.geometry.faces){
				
				if( cull){
					
					hitVert.x = t.v0.x;
					hitVert.y = t.v0.y;
					hitVert.z = t.v0.z;
					
					if(Number3D.dot(t.faceNormal, Number3D.sub(tlp, hitVert)) <= 0)
						continue;
				}
				
				castClip.graphics.beginFill(color);
				pos = projectVertex(t.v0, lp, inv, target.world);
				s2d = get2dPoint2(pos, bounds.min, bounds.size, movieSize);
				castClip.graphics.moveTo(s2d.x, s2d.y);
				//trace(pos,bounds.min, bounds.size, movieSize);
				
				pos = projectVertex(t.v1, lp, inv, target.world);
				p2d = get2dPoint2(pos, bounds.min, bounds.size, movieSize);
				castClip.graphics.lineTo(p2d.x, p2d.y); 
				//trace(pos,bounds.min, bounds.size, movieSize);
				
				pos = projectVertex(t.v2, lp, inv, target.world);
				p2d = get2dPoint2(pos, bounds.min, bounds.size, movieSize);
				castClip.graphics.lineTo(p2d.x, p2d.y);
				//trace(pos,bounds.min, bounds.size, movieSize);

				castClip.graphics.lineTo(s2d.x, s2d.y);
				
				castClip.graphics.endFill();
				
			}

		}
		
		public function invalidate():void{
			invalidateModels();
			invalidatePlanes();
		}
		
		public function invalidatePlanes():void{
			planeBounds = new Dictionary(true);
		}
		public function invalidateTargets():void{
			numberRefs = new Dictionary(true);
			targetBounds = new Dictionary(true);
		}
		
		public function invalidateModels():void{
			models = new Dictionary(true);
			invalidateTargets();
		}
		
		private function get2dPoint(pos3D:Number3D, min3D:Number3D, size3D:Number3D, movieSize:Point):Point{
			return new Point((pos3D.x-min3D.x)/size3D.x*movieSize.x, (-pos3D.y-min3D.y)/size3D.y*movieSize.y);
		}
		
		private function get2dPoint2(pos3D:Number3D, min3D:Number3D, size3D:Number3D, movieSize:Point):Point{
			return new Point((pos3D.x-min3D.x)/size3D.x*movieSize.x, -(pos3D.y-min3D.y)/size3D.y*movieSize.y);
		}
		
		private function projectVertex(v:Vertex3D, light:Number3D, invMat:Matrix3D, world:Matrix3D):Number3D{

			var pos:Number3D = vertexRefs[v];
			if(pos)
				return pos;
			
			var n:Number3D = numberRefs[v];
			
			if(!n){
				n = new Number3D(v.x, v.y, v.z);
				Matrix3D.multiplyVector(world, n);
				Matrix3D.multiplyVector(invMat, n);
				numberRefs[v] = n;
			}
			
			
			if(_type == SPOTLIGHT){
			
				lightRay.x = light.x;
				lightRay.y = light.y;
				lightRay.z = light.z;  
				
			}else{
				lightRay.x = n.x-dir.x;
				lightRay.y = n.y-dir.y;
				lightRay.z = n.z-dir.z;
			}
			
			pos = p3d.getIntersectionLineNumbers(lightRay, n);
			vertexRefs[v] = pos;
			return pos;
		}

	}
}