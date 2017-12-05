import "dart:math";

import "package:GameLib2/GameLib2.dart";

import "../mainlogic.dart";
import "actor.dart";
import 'enemy.dart';
import 'environmentobject.dart';
import 'player.dart';
import "wallobject.dart";

class MapObject extends Actor {
	MapObject(num x, num y, int width, int height, int colwidth, int colheight) : super(x,y,width,height,colwidth,colheight) {
		this.pos.z = 1.0;
		this.takesContactDamage = false;
	}
	
	static MapObject loadMapObject(MainLogic game, int id, int x, int y) {
		Random rand = new Random();
		double tx = game.grid.tilesize * (x+0.5);
		double ty = game.grid.tilesize * (y+0.5);
		double dy = game.grid.tilesize * y.toDouble();
		if (id == 30) {
			new Barrels(tx + rand.nextDouble() * 10 - 5, ty + rand.nextDouble() * 10 - 5, rand.nextDouble() * PI * 2)..register(game);
		} else if (id == 100) {
			new WallObject(x, y, TileType.typesByName["breakwall"], game.grid)..register(game);
		} else if (id == 120) {
			new Car(tx, ty, rand.nextDouble() * PI * 2)..register(game);
		} else if (id == 130) {
			new Boat(tx, ty, rand.nextDouble() * PI * 2)..register(game);
		} else if (id == 140) {
			new Bear(tx, ty)..register(game);
		} else if (id == 200) {
			new Grunt(tx, ty)..register(game);
		} else if (id == 205) {
			new Sarge(tx, ty)..register(game);
		} else if (id == 210) {
			new Fatty(tx, ty)..register(game);
		} else if (id == 215) {
			new Commando(tx, ty)..register(game);
		} else if (id == 240) {
			new Player(tx, ty)..register(game);
		} else if (id == 250) {
			new Player(tx, ty, true)..register(game);
		}
		
		return null;
	}
}