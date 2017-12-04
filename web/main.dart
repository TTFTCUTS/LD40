import "dart:async";
import 'dart:html';

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

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

    //await Loader.loadJavaScript("assets/three.min.js");
    await Preloader.init();
    await Preloader.initTextures();

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

Map<String,THREE.Texture> _textureCache = <String,THREE.Texture>{};
Future<THREE.Texture> getTexture(String path) async {
    if (_textureCache.containsKey(path)) {
        THREE.Texture tex = _textureCache[path];
        return tex;
    } else {
        ImageElement img = await Loader.getResource(path);
        THREE.Texture tex = new THREE.Texture(img)
            ..flipY = false
            ..needsUpdate = true;

        _textureCache[path] = tex;
        print("loaded $path: $tex");
        return tex;
    }
}
