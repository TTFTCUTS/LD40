import "package:GameLib2/GameLib2.dart";

abstract class Tiles {
    static void init() {

        new TileSet("arena", 512, 512)

            // base floor
            ..fixedTile("base_0", 0, 0, 32)
            ..fixedTile("base_1", 1, 0, 32)
            ..fixedTile("base_2", 2, 0, 32)
            ..fixedTile("base_3", 3, 0, 32)
            ..fixedTile("base_4", 0, 1, 32)
            ..fixedTile("base_5", 1, 1, 32)
            ..fixedTile("base_6", 2, 1, 32)
            ..fixedTile("base_7", 3, 1, 32)

            // wall

        ;

        new TileType(20, "base", <String>["0", "1", "2", "3", "4", "5", "6", "7"])..solid=false;
        new TileTypeConnected(255, "wall")..solid=true;


        new TileSet("projectiles", 128,128)
            ..fixedTile("bullet", 0, 0, 16)
            ..fixedTile("ball_med", 1, 0, 16)
            ..fixedTile("ball_small", 0, 1, 16)
            ..fixedTile("ball_tiny", 1, 1, 16)
            ..addTile("rocket", 32, 0, 32, 32);
    }
}