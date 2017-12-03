import "dart:async";

import "package:GameLib2/GameLib2.dart";

abstract class Preloader {
    static Future<List<dynamic>> init() => Future.wait(<Future<dynamic>>[
        Loader.getResource("assets/level.png"),

        Loader.getResource("assets/tiles/arena.png"),

        Loader.getResource("assets/shader/basic.vert"),
        Loader.getResource("assets/shader/sprite.frag"),

        Loader.getResource("assets/sprites/projectiles.png"),
        
        Loader.getResource(Audio.INSTANCE.processSoundName("boydhurt1")),
    ]);
}