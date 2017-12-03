import "dart:async";
import 'dart:html';

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "helpers.dart";

import "mainlogic.dart";
import "preloader.dart";
import "tiles.dart";

MainLogic game;

Future<Null> main() async {
    new Audio("assets/sound", querySelector("#subtitles"));
    Audio.INSTANCE.volumeNode.gain.value = 0.5;
    Audio.createChannel("effects", 0.5);
    Audio.createChannel("voice");
    Audio.createChannel("music");

    await Loader.loadJavaScript("assets/three.min.js");
    await Preloader.init();

    int w = 800;
    int h = 800;

    Tiles.init();
    game = new MainLogic(querySelector("#container"), w,h);

    document.onKeyDown.listen(game.keyDown);
    document.onKeyUp.listen(game.keyUp);
    document.onMouseMove.listen(game.mouseMove);
    document.onMouseUp.listen(game.mouseUp);
    querySelector("#outer").onMouseDown.listen(game.mouseDown);
}
