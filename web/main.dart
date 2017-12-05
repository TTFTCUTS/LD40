import "dart:async";
import 'dart:html';
import 'dart:web_audio';

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "mainlogic.dart";
import "preloader.dart";
import "tiles.dart";

MainLogic game;

Future<Null> main() async {
    new Audio("assets/sound", querySelector("#subtitles"));
    Audio.INSTANCE.volumeNode.gain.value = 0.5;
    Audio.createChannel("effects", 0.65);
    Audio.createChannel("automatics", 0.3);
    Audio.createChannel("riccochet", 0.2);
    Audio.createChannel("loudeffects", 1.0);
    Audio.createChannel("voice", 0.75);
    Audio.createChannel("music", 0.50);

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

    AudioBufferSourceNode titleMusic = await Audio.play("45secSynthSax", "music")..loop = true;

    querySelector("#play").onClick.listen((MouseEvent e) {
        querySelector("#menu").style.display = "none";
        titleMusic.stop(0);
        game.start();
    });

    querySelector("#loading").style.display = "none";

    querySelector("#retry").onClick.listen((MouseEvent e){
        window.location.reload();
    });
    querySelector("#endrestart").onClick.listen((MouseEvent e){
        window.location.reload();
    });
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
        //print("loaded $path: $tex");
        return tex;
    }
}
