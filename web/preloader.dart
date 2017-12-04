import "dart:async";

import 'main.dart';
import "package:GameLib2/GameLib2.dart";

abstract class Preloader {
    static Future<List<dynamic>> init() => Future.wait(<Future<dynamic>>[
        Loader.getResource("assets/level.png"),

        Loader.getResource("assets/tiles/arena.png"),

        Loader.getResource("assets/shader/basic.vert"),
        Loader.getResource("assets/shader/sprite.frag"),

        Loader.getResource("assets/sprites/projectiles.png"),
        Loader.getResource("assets/sprites/objects.png"),
        Loader.getResource("assets/sprites/dude.png"),
        Loader.getResource("assets/sprites/blood.png"),
        
        Loader.getResource(Audio.INSTANCE.processSoundName("boydhurt1")),
    ]);

    static Future<List<dynamic>> initTextures() => Future.wait(<Future<dynamic>>[
        getTexture("assets/tiles/arena.png"),

        getTexture("assets/sprites/projectiles.png"),
        getTexture("assets/sprites/objects.png"),
        getTexture("assets/sprites/dude.png"),
        getTexture("assets/sprites/blood.png"),
    ]);
}