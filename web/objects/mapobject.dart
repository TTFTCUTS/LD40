import "package:GameLib2/GameLib2.dart";

import "../mainlogic.dart";
import "actor.dart";

class MapObject extends Actor {
	MapObject(num x, num y, int width, int height, int colwidth, int colheight) : super(x,y,width,height,colwidth,colheight) {
		this.pos.z = 1.0;
		this.takesContactDamage = false;
	}
	
	static MapObject loadMapObject(MainLogic game, int id, int x, int y) {
		double tx = game.grid.tilesize * (x+0.5);
		double ty = game.grid.tilesize * (y+0.5);
		double dy = game.grid.tilesize * y.toDouble();
		if (id == 30) {
			//game.player = new Player(tx, dy)..register(game);
		}
		
		return null;
	}
}