package {
	
	import com.frigidfish.Grid;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class main extends MovieClip{
		
		var movementDelay = new Timer(500, 4);
		
		// East = 0, South = 1, West = 2, North = 3
		var playerDirection:int = 0;
		
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
			character.gotoAndStop(1);
			playerDirection = 0;
			
			addChild(checkList);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveCharacterEasy);
		}
		
		public function startIntermediateMode() {
			var gameGrid:Grid = new Grid(Token,8,8,0);
			gameGrid.x = 400;
			addChild(gameGrid);
			
			character = new yourDude(480, 130, this);
			addChild(character);
			character.gotoAndStop(1);
			playerDirection = 0;
			
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
			
			//Player turns left
			if(e.keyCode == 37) {
				playerDirection = (playerDirection - 1)%4;
				if (playerDirection < 0) {
					playerDirection += 4;
				}
				character.gotoAndStop(playerDirection + 1);
			}
			
			//Player turns right
			else if(e.keyCode == 39) {
				playerDirection = (playerDirection + 1)%4;
				if (playerDirection < 0) {
					playerDirection += 4;
				}
				character.gotoAndStop(playerDirection + 1);
			}
			
			//player moves in direction
			else if(e.keyCode == 38) {
				if (playerDirection == 0 && character.x < 1271) {
					//move east
					character.setX(character.getX() + speed);
				} else if (playerDirection == 1 && character.y < 921) {
					//move south
					character.setY(character.getY() + speed);
				} else if (playerDirection == 2 && character.x > 480) {
					//move west
					character.setX(character.getX() - speed);
				} else if (playerDirection == 3  && character.y > 130) {
					//move north
					character.setY(character.getY() - speed);
				}
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
			var speed = 113;
			
			if(intermediateMoves[0] == 37) {
				playerDirection = (playerDirection - 1)%4;
				if (playerDirection < 0) {
					playerDirection += 4;
				}
				character.gotoAndStop(playerDirection + 1);
				intermediateMoves.shift();
			}
			else if (intermediateMoves[0] == 39) {
				playerDirection = (playerDirection + 1)%4;
				if (playerDirection < 0) {
					playerDirection += 4;
				}
				character.gotoAndStop(playerDirection + 1);
				intermediateMoves.shift();
			}
			else if (intermediateMoves[0] == 38) {
				if (playerDirection == 0 && character.x < 1271) {
					//move east
					character.setX(character.getX() + speed);
				} else if (playerDirection == 1 && character.y < 921) {
					//move south
					character.setY(character.getY() + speed);
				} else if (playerDirection == 2 && character.x > 480) {
					//move west
					character.setX(character.getX() - speed);
				} else if (playerDirection == 3  && character.y > 130) {
					//move north
					character.setY(character.getY() - speed);
				}
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