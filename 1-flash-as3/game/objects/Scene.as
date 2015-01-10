package game.objects {
	/*
		Основной класс игры
		Сцена, на которую помещаются игровые объекты
	*/

	// подключим зависимости
	import flash.display.*; // дисплей лист
	import flash.events.*; // события
	import game.data.*; // класс Gameplay
	import game.graphics.*; // графические объекты с текстом

	public class Scene extends Sprite {
		public function Scene(){
			// отреагируем на событие помещения сцены на Stage,
			// чтобы была возможность задать частоту отрисовки кадров
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		// ссылки на игровые обьекты
		private var gameplay:Gameplay;
		private var paddle:Paddle;
		private var ball:Ball;
		private var scoreText:ScoreText;
		private var bricks:Vector.<Block>; // типизированный массив блоков

		private function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			// игровая сцена добавлена

			// заполним экран цветом
			graphics.beginFill(0xAABBFF);
			graphics.drawRect(0,0,Gameplay.SCREEN_WIDTH,Gameplay.SCREEN_HEIGHT);
			graphics.endFill();

			// установим приятную частоту отрисовки игрового экрана
			stage.frameRate = 60;

			// запустим игру
			startGame();
		}

		private function startGame(event:Event = null):void
		{
			// Начата новая игра
			gameplay = new Gameplay();

			// создадим игровые объекты
			paddle = new Paddle();
			ball = new Ball(paddle, gameplay);
			scoreText = new ScoreText(gameplay);

			// расставим их на сцене
			addChild(paddle);
			addChild(ball);
			addChild(scoreText);

			bricks = new Vector.<Block>();

			addEventListener(Event.ENTER_FRAME, onFrame);
			startLevel();
		}

		private function startLevel():void
		{
			// уберем слушатель события отрисовки жкрана
			removeEventListener(Event.ENTER_FRAME, onFrame);

			// рассчитаем необходимое количество блоков для разрушения
			gameplay.blocks = Gameplay.BLOCKS_PER_LINE * gameplay.level;

			var block:Block;

			// удалим старые блоки со сцены
			while(bricks.length > 0) {
				block = bricks.pop();
				block.parent.removeChild(block);
			}

			bricks = new Vector.<Block>();

			var col:int = 0; // столбец
			var row:int = 0; // строка

			while(bricks.length < gameplay.blocks) {
				block = new Block(gameplay, ball);

				block.x = 15 + col * 75;
				block.y = 10 + row * 20;

				col++;

				// переход на новую строку
				if(col == Gameplay.BLOCKS_PER_LINE) {
					row++;
					col = 0;
				}

				addChild(block);
				bricks.push(block);
			}

			// центрируем игровые объекты
			paddle.y = Gameplay.SCREEN_HEIGHT * (3.0/4.0)
				+ Gameplay.SCREEN_HEIGHT * (1.0/4.0) * (3.0/4.0);
			paddle.x = Gameplay.SCREEN_WIDTH / 2.0;

			ball.x = Gameplay.SCREEN_WIDTH / 2.0;
			ball.y = Gameplay.SCREEN_HEIGHT / 2.0;
			// остановим шар
			ball.ballXSpeed = 0.0;
			ball.ballYSpeed = 0.0;

			// попросим игрока нажать на экран для старта
			addChild(new ClickToPlayScreen(play));
		}

		private function play():void {
			// запустим шар
			ball.ballXSpeed = 6.0;
			ball.ballYSpeed = 6.0;

			// добавим слушатель на событие отрисовки экрана
			addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function restart():void
		{
			// перезапустим игру
			// очистим игровое поле
			ball.parent.removeChild(ball);
			paddle.parent.removeChild(paddle);
			scoreText.parent.removeChild(scoreText);
			while(bricks.length > 0) {
				var block = bricks.pop();
				block.parent.removeChild(block);
			}
			// запустим игру
			startGame();
		}

		private function onFrame(event:Event):void {
			// если число жизней равно нулю,
			if(gameplay.lives < 1) {
				// приостановим игру
				removeEventListener(Event.ENTER_FRAME, onFrame);
				ball.ballXSpeed = 0.0;
				ball.ballYSpeed = 0.0;
				// сообщим игроку о проигрыше
				addChild(new YouLoseScreen(gameplay.score, gameplay.level, restart));
			} else
			// если число блоков для разрушения равно нулю,
			if(gameplay.blocks < 1) {
				// приостановим игру
				removeEventListener(Event.ENTER_FRAME, onFrame);
				ball.ballXSpeed = 0.0;
				ball.ballYSpeed = 0.0;
				// увеличим номер уровня
				gameplay.level++;
				// провреим, не прошел ли он все уровни
				if(gameplay.level > Gameplay.LEVELS) {
					// сообщим о победе
					addChild(new YouWonScreen(gameplay.score, gameplay.level, restart));
				} else {
					// попросим кликнуть на экран для продолжения
					addChild(new ClickToPlayScreen(startLevel));
				}
			}
		}
	}
}