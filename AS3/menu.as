package  {
	
	import flash.display.*;
	import flash.events.*;
	
	public class menu extends MovieClip {
		
		public var document:main;
		
		var titleText;
		var beginnerLevelButton;
		var intermediateLevelButton;
		var advnacedLevelButton;

		public function menu(d:main) {
			this.document = d;
			
			titleText = new mainTitle;
			titleText.x = 950;
			titleText.y = 125;
			
			beginnerLevelButton = new beginnerText;
			beginnerLevelButton.x = 950;
			beginnerLevelButton.y = 400;
			beginnerLevelButton.addEventListener(MouseEvent.CLICK, beginnerButtonClick);
			
			intermediateLevelButton = new intermediateText;
			intermediateLevelButton.x = 950;
			intermediateLevelButton.y = 600;
			intermediateLevelButton.addEventListener(MouseEvent.CLICK, intermediateButtonClick);
			
			advnacedLevelButton = new advancedText;
			advnacedLevelButton.x = 950;
			advnacedLevelButton.y = 800;
			advnacedLevelButton.addEventListener(MouseEvent.CLICK, advancedButtonClick);
			
			loadMenu();
		}
		
		function beginnerButtonClick(Event:MouseEvent):void {
			removeMenu();
			document.startEasyMode();
		}
		
		function intermediateButtonClick(Event:MouseEvent):void {
			removeMenu();
			document.startIntermediateMode();
		}
		
		function advancedButtonClick(Event:MouseEvent):void {
			removeMenu();
			document.startAdvancedMode();
		}
		
		private function loadMenu(){
			addChild(titleText);
			addChild(beginnerLevelButton);
			addChild(intermediateLevelButton);
			addChild(advnacedLevelButton);
		}
		
		private function removeMenu() {
			removeChild(titleText);
			removeChild(beginnerLevelButton);
			removeChild(intermediateLevelButton);
			removeChild(advnacedLevelButton);
		}
	}
}
