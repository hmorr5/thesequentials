package {
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class Map extends Grid {
		
		public static const PATH:String = "../Maps/";
		public static const PREFIX:String = "map";
		public static const FILE:String = "/suggestedmapstructure.jpg";
		
		private var map;
		private var loader;

		public function Map(rows, cols, map:uint) {
			super(rows, cols);
			this.map = map;
			
			this.loader = new Loader();
			loader.load(new URLRequest(PATH + PREFIX + map + FILE));
			addChild(loader);
		}

	}
	
}
