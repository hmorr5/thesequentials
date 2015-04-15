package {
	
	import com.frigidfish.Grid;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class main extends MovieClip{
		
		var movementDelay = new Timer(500, 4);
		
		var checkList;
		var character;
		var mainMenu;
		var gameGrid;
		var intermediateMoves:Array = [];
		var goButton;

		public function main() {
			mainMenu = new menu(this);
			addChild(mainMenu);
			
			checkList = new mockList;
			checkList.x = 1500;
			checkList.y = 260;
			
			goButton = new goText;
			goButton.x = 200;
			goButton.y = 200;
		}
		
		public function startEasyMode() {
			var gameGrid:Grid = new Grid(Token,8,8,0);
			gameGrid.x = 400;
			addChild(gameGrid);
			
			character = new yourDude(480, 130, this);
			addChild(character);
			
			addChild(checkList);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveCharacterEasy);
		}
		
		public function startIntermediateMode() {
			var gameGrid:Grid = new Grid(Token,8,8,0);
			gameGrid.x = 400;
			addChild(gameGrid);
			
			character = new yourDude(480, 130, this);
			addChild(character);
			
			addChild(checkList);
			
			addChild(goButton);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
			goButton.addEventListener(MouseEvent.CLICK, clickGo);
			movementDelay.addEventListener(TimerEvent.TIMER, executeIntermediateMoves);
			movementDelay.addEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);
		}
		
		//Player movement for easy mode; real time movement
		public function moveCharacterEasy(e:KeyboardEvent){
			var speed = 113;
			
			//Player moves left
			if(e.keyCode == 37 && character.x > 480) {
				character.setX(character.getX() - speed);
			}
			
			//Player moves right
			else if(e.keyCode == 39 && character.x < 1271) {
				character.setX(character.getX() + speed);
			}
			
			//player moves down
			else if(e.keyCode == 40 && character.y < 921) {
				character.setY(character.getY() + speed);
			}
			
			//player moves up
			else if(e.keyCode == 38 && character.y > 130) {
				character.setY(character.getY() - speed);
			}
		}
		
		//Player movement for intermediate mode; movement every 4 inputs
		public function pushCharacterIntermediate(e:KeyboardEvent){
			if (intermediateMoves.length < 4) {
				//Player moves left
				if(e.keyCode == 37) {
					intermediateMoves.push("37");
					trace("What's in array: " + intermediateMoves);
				}
			
				//Player moves right
				else if(e.keyCode == 39) {
					intermediateMoves.push("39");
					trace("What's in array: " + intermediateMoves);
				}
			
				//player moves down
				else if(e.keyCode == 40) {
					intermediateMoves.push("40");
					trace("What's in array: " + intermediateMoves);
				}
			
				//player moves up
				else if(e.keyCode == 38) {
					intermediateMoves.push("38");
					trace("What's in array: " + intermediateMoves);
				}
			} 
		}
		
		public function executeIntermediateMoves(e:TimerEvent=null){
			if(intermediateMoves[0] == 37 && character.x > 480) {
				character.setX(character.getX() - 113);
				intermediateMoves.shift();
			}
			else if (intermediateMoves[0] == 39 && character.x <1271) {
				character.setX(character.getX() + 113);
				intermediateMoves.shift();
			}
			else if (intermediateMoves[0] == 40 && character.y < 921) {
				character.setY(character.getY() + 113);
				intermediateMoves.shift();
			} 
			else if (intermediateMoves[0] == 38 && character.y > 130) {
				character.setY(character.getY() - 113);
				intermediateMoves.shift();
			}
		}
		
		public function clickGo(Event:MouseEvent) {
			movementDelay.start();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
		}
		
		public function resetTimer(e:TimerEvent) {
			movementDelay.reset();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
		}
	}
}

///http://www.as3blog.org/2010/03/01/how-to-create-an-as3-game-grid/