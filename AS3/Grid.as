package  {
	
	import com.frigidfish.Grid;
	
	public class Grid extends com.frigidfish.Grid {

		public var dx:uint;
		public var dy:uint;
		
		public function Grid(displayObject:*, rows, cols, spacer) {
			this.dx = 0;
			this.dy = 0;
			
			super(displayObject, rows, cols, spacer);
			
			if (rows > 0 && cols > 0) {
				this.dx = this.cells[0].width;
				this.dy = this.cells[0].height;
			}
		}

	}
	
}
