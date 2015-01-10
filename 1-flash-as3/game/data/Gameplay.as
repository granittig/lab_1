package game.data {
	/*
		Данный класс содержит глобальные игровые параметры,
		на основе которых строится гровой уровень.

		Инстанс класса Gameplay хранит в себе изменяемые глобальные параметры.
		Для передачи этих параметров достаточно передать ссылку на инстанс.
		Такой прием позволяет не использовать (анти)паттерн Singleton
	*/
	public class Gameplay {
		public var level:int = 1; // текущий уровень
		public var score:int = 0; // количество очков
		public var lives:int = 3; // жизни
		public var blocks:int = 7; // количество оставшихся блоков

		public static const LEVELS:int = 4; // всего уровней в игре
		public static const SCREEN_WIDTH:int = 550; // ширина игрового поля
		public static const SCREEN_HEIGHT:int = 400; // высота игрового поля
		public static const BLOCKS_PER_LINE:int = 7; // количество блоков на полосе по горизонтали
		// число же полос блоков равно текущему уровню
	}
}