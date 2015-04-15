package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	public class yourDude extends MovieClip{
		
		var document:main; 

		public function yourDude(xPosition,yPosition, d:main) {
			this.document = d;
			 
	 	 	this.x = xPosition;
	 	 	this.y = yPosition;
	 	 }
		 
		public function setX(newX) {
			 this.x = newX;
		}
		 
		public function getX() {
			 return this.x;
		}
		 
		public function setY(newY) {
			 this.y = newY;
		}
		 
		public function getY() {
			 return this.y;
		}

	}
	
}
