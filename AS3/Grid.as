package {
	import flash.display.MovieClip;
	
	public class Grid extends MovieClip {

		public static const EAST:uint = 0;
		public static const SOUTH:uint = 1;
		public static const WEST:uint = 2;
		public static const NORTH:uint = 3;

		public static const DX:uint = 112;
		public static const DY:uint = 112;
		
		public var rows;
		public var cols;
		
		private var goalX:uint;
		private var goalY:uint;
		
		protected var block:Vector.<Vector.<Boolean>>;
		
		public function Grid(rows, cols, goalX = 7, goalY = 7) {
			this.goalX = goalX;
			this.goalY = goalY;
			this.rows = rows;
			this.cols = cols;
			
			block = new Vector.<Vector.<Boolean>>(rows, true);
			for (var i:Number = 0; i < rows; i++) {
				block[i] = new Vector.<Boolean>(cols, true);
			}
		}
		
		public function isAccessible(posX:uint, posY:uint, fromDirection:uint):Boolean {
			return (0 <= posX && posX < this.cols && 0 <= posY && posY < this.rows && !block[posY][posX]);
		}
		
		public function isGoal(posX:uint, posY:uint):Boolean {
			return (posX == goalX && posY == goalY);
		}
	}
}