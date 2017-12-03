import "package:GameLib2/GameLib2.dart";

abstract class Tiles {
    static void init() {

        new TileSet("arena", 64, 64)
            ..fixedTile("test_0", 0, 0, 32)
            ..fixedTile("test_1", 1, 0, 32)
            ..fixedTile("test_2", 0, 1, 32)
            ..fixedTile("test_3", 1, 1, 32);

        new TileType(255, "test", <String>["0", "1", "2", "3"])..solid=true;


        new TileSet("projectiles", 128,128)
            ..fixedTile("bullet", 0, 0, 16)
            ..fixedTile("ball_med", 1, 0, 16)
            ..fixedTile("ball_small", 0, 1, 16)
            ..fixedTile("ball_tiny", 1, 1, 16)
            ..addTile("rocket", 32, 0, 32, 32);
    }
}