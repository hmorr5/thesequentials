package  {
	
	import flash.display.*;
	import flash.events.*;
	
	public class menu extends MovieClip{
		
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
			
			intermediateLevelButton = new intermediateText;
			intermediateLevelButton.x = 950;
			intermediateLevelButton.y = 600;
			
			advnacedLevelButton = new advancedText;
			advnacedLevelButton.x = 950;
			advnacedLevelButton.y = 800;
			
			beginnerLevelButton.addEventListener(MouseEvent.CLICK, beginnerButtonClick);
			intermediateLevelButton.addEventListener(MouseEvent.CLICK, intermediateButtonClick);
			advnacedLevelButton.addEventListener(MouseEvent.CLICK, advancedButtonClick);
			
			loadMenu();
		}
		
		public function beginnerButtonClick(Event:MouseEvent):void {
			removeMenu();
			document.startEasyMode();
		}
		
		public function intermediateButtonClick(Event:MouseEvent):void {
			removeMenu();
			document.startIntermediateMode();
		}
		
		public function advancedButtonClick(Event:MouseEvent):void {
			removeMenu();
			document.startEasyMode();
		}
		
		public function removeMenu() {
			removeChild(titleText);
			removeChild(beginnerLevelButton);
			removeChild(intermediateLevelButton);
			removeChild(advnacedLevelButton);
		}
		
		public function loadMenu(){
			addChild(titleText);
			addChild(beginnerLevelButton);
			addChild(intermediateLevelButton);
			addChild(advnacedLevelButton);
		}

	}
	
}
