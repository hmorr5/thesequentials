package {
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class Map extends Grid {
		public static const MAPPATH:String = "../Maps/";
		public static const MAPFOLDER_PREFIX:String = "map";
		public static const FILE:String = "examplemap.jpg";
		
		private var path;
		private var loader;

		public function Map(rows, cols, map:uint) {
			super(rows, cols, 7, 7);
			this.path = MAPPATH + MAPFOLDER_PREFIX + map + "/";
			
			this.loader = new Loader();
			loader.load(new URLRequest(path + FILE));
			addChild(loader);
			
			this.loader = new Loader();
			loader.load(new URLRequest(path + "1.png"));
			loader.x = 1100;
			loader.y = 55;
			addChild(loader);
			
			block[0][4] = true;
			block[0][5] = true;
			block[0][6] = true;
			block[0][7] = true;
			block[1][5] = true;
			block[1][6] = true;
			block[1][7] = true;
			block[2][7] = true;
			block[3][0] = true;
			block[4][0] = true;
			block[4][2] = true;
			block[4][3] = true;
			block[4][4] = true;
			block[5][0] = true;
			block[5][1] = true;
			block[5][2] = true;
			block[5][3] = true;
			block[6][0] = true;
			block[6][1] = true;
			block[6][2] = true;
			block[7][0] = true;
			block[7][1] = true;
			block[7][2] = true;
			block[7][3] = true;
			block[7][4] = true;
		}
	}
}
