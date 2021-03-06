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
        Loader.getResource("assets/sprites/bear.png"),
        
        Loader.getResource(Audio.INSTANCE.processSoundName("boydhurt1")),

        Loader.getResource(Audio.INSTANCE.processSoundName("DEATH")),
        Loader.getResource(Audio.INSTANCE.processSoundName("EXPLOSION")),
        Loader.getResource(Audio.INSTANCE.processSoundName("GUNFIRE")),
        Loader.getResource(Audio.INSTANCE.processSoundName("RELOAD")),
        Loader.getResource(Audio.INSTANCE.processSoundName("ROCKETLAUNCH")),
        Loader.getResource(Audio.INSTANCE.processSoundName("SHOTGUNFIRE")),

        Loader.getResource(Audio.INSTANCE.processSoundName("BULLETIMPACTONE")),
        Loader.getResource(Audio.INSTANCE.processSoundName("BULLETIMPACTTWO")),
        Loader.getResource(Audio.INSTANCE.processSoundName("BULLETIMPACTTHREE")),
        Loader.getResource(Audio.INSTANCE.processSoundName("BULLETIMPACTMETAL")),

        Loader.getResource(Audio.INSTANCE.processSoundName("instructions")),
        Loader.getResource(Audio.INSTANCE.processSoundName("cuddlytoy")),
        Loader.getResource(Audio.INSTANCE.processSoundName("elbowgrease")),
        Loader.getResource(Audio.INSTANCE.processSoundName("fantastic")),
        Loader.getResource(Audio.INSTANCE.processSoundName("goandcleanup")),
        Loader.getResource(Audio.INSTANCE.processSoundName("lovely")),
        Loader.getResource(Audio.INSTANCE.processSoundName("scrubit")),
        Loader.getResource(Audio.INSTANCE.processSoundName("skegness")),
        Loader.getResource(Audio.INSTANCE.processSoundName("thatshowedim")),
        Loader.getResource(Audio.INSTANCE.processSoundName("toaster")),
        Loader.getResource(Audio.INSTANCE.processSoundName("whatamess")),
        Loader.getResource(Audio.INSTANCE.processSoundName("30secondsremain")),
        Loader.getResource(Audio.INSTANCE.processSoundName("oneminuteremains")),

        Loader.getResource(Audio.INSTANCE.processSoundName("Janitor")),
        Loader.getResource(Audio.INSTANCE.processSoundName("45secSynthSax")),
        Loader.getResource(Audio.INSTANCE.processSoundName("combattheme")),
    ]);

    static Future<List<dynamic>> initTextures() => Future.wait(<Future<dynamic>>[
        getTexture("assets/tiles/arena.png"),

        getTexture("assets/sprites/projectiles.png"),
        getTexture("assets/sprites/objects.png"),
        getTexture("assets/sprites/dude.png"),
        getTexture("assets/sprites/blood.png"),
        getTexture("assets/sprites/bear.png"),
    ]);


}