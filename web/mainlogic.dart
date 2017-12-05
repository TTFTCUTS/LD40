import "dart:async";
import "dart:html";
import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import 'director.dart';
import 'main.dart';
import "objects/mapobject.dart";
import "objects/player.dart";
import 'room.dart';

class MainLogic extends GameLogic {
    Map<int, bool> keys = <int,bool>{};
    Map<int, bool> buttons = <int,bool>{};
    Point<num> mousepos;

    bool paused = false;
    bool allowControl = false;

    THREE.Mesh bgmodel;

    int width;
    int height;

    WorldGrid grid = null;

    THREE.Mesh worldModelFore;
    THREE.Mesh worldModelBack;

    Player player;
    Player janitor;
    Director director;

    MainLogic(DivElement container, int width, int height) : super(container, width, height, width*2.0, height*5.0, 64.0, 64.0) {
        this.width = width;
        this.height = height;
        this.simstep = 1/30.0;

        this.mousepos = new Point<num>(width~/2, height~/2);

        this.resetRenderer();

        //this.start();
    }

    @override
    void logicUpdate(num dt) {
        if (!paused) {
            for (GameObject o in objects) {
                if (o is RoomObject && o.destroyed) {
                    (o as RoomObject).removeFromRoom();
                }
            }

            super.logicUpdate(dt);
            director.update(dt);
        }
        this.updateUI(dt);
        
        //this.debugCommands();
    }

    @override
    void update(num dt) {
        super.update(dt);
        if (this.director != null) {
            this.director.announcer.update(dt);
        }
    }
    
    void debugCommands() {
        if (this.getKey(103)) {
            keys[103] = false;
            this.director.phaserooms[director.phase].removeEnemies();
        }

        if (this.getKey(104)) {
            keys[104] = false;
            this.director.timer = max(0.0,this.director.timer - 30.0);
        }

        if (this.getKey(105)) {
            keys[105] = false;
            print(this.director.tallyFilth());
        }
    }

    void togglePause() {
        if (this.paused) {
            this.paused = false;
            querySelector("#pause").style.display = "none";
        } else {
            this.paused = true;
            querySelector("#pause").style.display = "block";
        }
    }

    void moveCamera(num x, num y) {
        double px = x.floorToDouble();
        double py = y.floorToDouble();
        this.render.camera.position.set(px, py, this.render.camera.position.z);
    }

    void moveCameraToRoom(int x, int y) {
        moveCamera(width * (0.5+x), height * (0.5+y));
    }

    void keyDown(KeyboardEvent e) {
        this.keys[e.keyCode] = true;

        // p for pause!
        if(this.allowControl && e.keyCode == 80) {
            this.togglePause();
        }

        e.preventDefault();
        e.stopPropagation();
    }

    void keyUp(KeyboardEvent e) {
        this.keys[e.keyCode] = false;
    }

    bool getKey(int keycode) {
        return (!this.allowControl) ? false : this.keys.containsKey(keycode) ? this.keys[keycode] : false;
    }

    bool getButton(int button) {
        return (!this.allowControl) ? false : this.buttons.containsKey(button) ? this.buttons[button] : false;
    }

    void resetRenderer() {
        this.render.scene = new THREE.Scene();

        THREE.Camera c = new THREE.OrthographicCamera(-width*0.5,width*0.5,-height*0.5,height*0.5, 0, 100);
        c.position.set(0.0, 0.0, 50.0);
        c.lookAt(new THREE.Vector3.zero());
        this.render.setCamera(c);

        this.moveCameraToRoom(0,4);

        THREE.Light l = new THREE.DirectionalLight(0xFFFFFF);
        l.position.set(0.0, 0.0, -100.0);
        l.lookAt(new THREE.Vector3.zero());
        this.render.scene.add(l);
    }

    Future<Null> start() async {
        this.director = new Director(this);
        await loadLevel();
        this.director.levelsetup();

        DivElement countdown = querySelector("#countdown");

        Audio.play("instructions", "voice", subtitle: "HOST: Eliminate the opponents, and smash as many prizes as you can. Get out there!");

        int count = 5;
        countdown.text = count.toString();

        for (int i=1; i<5; i++) {
            new Future<Null>.delayed(new Duration(seconds: i), () {
                countdown.text = (count-i).toString();
            });
        }

        new Future<Null>.delayed(new Duration(seconds: count), () {
            countdown.text = "Refuse!";
        });

        new Future<Null>.delayed(new Duration(seconds: 2), () {
            director.startOfShooty();
        });

        new Future<Null>.delayed(new Duration(seconds:count+1), () {
            countdown.style.display = "none";
            startGameLoop();
            this.allowControl = true;
        });
    }

    Future<Null> loadLevel() async {
        ImageElement img = await Loader.getResource("assets/level.png");

        int w = img.width;
        int h = img.height;

        this.grid = new WorldGrid(32, w, h);

        CanvasElement canvas = new CanvasElement()..width=w..height=h;
        CanvasRenderingContext2D ctx = canvas.context2D;
        ctx.drawImage(img,0,0);
        List<int> pixels = ctx.getImageData(0, 0, w, h).data;
        int len = w*h;

        int x,y,i,r,g,b;
        for (int p=0; p<len; p++) {
            i = p*4;
            r = pixels[i];
            g = pixels[i+1];
            b = pixels[i+2];

            y = p ~/ w;
            x = p % w;

            if (r > 0) {
                this.grid.setTileById(x, y, r);
            }
            if (g > 0) {
                this.grid.setTileById(x, y, g, true);
            }
            if (b > 0) {
                MapObject.loadMapObject(this, b, x, y);
            }
        }

        if (worldModelFore != null) {
            this.render.scene.remove(worldModelFore);
        }
        if (worldModelBack != null) {
            this.render.scene.remove(worldModelBack);
        }

        THREE.Texture arenaTex = await getTexture("assets/tiles/arena.png"); //new THREE.Texture(await Loader.getResource("assets/tiles/arena.png"))..flipY=false..needsUpdate=true;

        this.worldModelBack = await this.grid.buildGeometry("arena", true, arenaTex, "assets/shader/basic.vert", "assets/shader/sprite.frag", 1.0);
        this.render.scene.add(this.worldModelBack);

        this.worldModelFore = await this.grid.buildGeometry("arena", false, arenaTex, "assets/shader/basic.vert", "assets/shader/sprite.frag");
        this.render.scene.add(this.worldModelFore);

        this.worldModelFore.material.transparent = true;

        /*if (this.player != null) {
            this.cameraTarget.setValues(player.pos.x, player.pos.y);
            this.moveCamera(player.pos.x, player.pos.y);
        }*/
    }

    THREE.Vector2 screenToWorld(THREE.Vector2 screen) {
        THREE.Vector2 world = new THREE.Vector2.zero();

        world.x = (render.camera.position.x - width * 0.5 + screen.x).floorToDouble();
        world.y = (render.camera.position.y - height * 0.5 + screen.y).floorToDouble();

        return world;
    }

    void mouseMove(MouseEvent e) {
        this.mousepos = (e.offset - this.container.documentOffset);
    }

    void mouseDown(MouseEvent e) {
        buttons[e.button] = true;
    }

    void mouseUp(MouseEvent e) {
        buttons[e.button] = false;
    }

    DivElement timeElement = querySelector("#timer");
    DivElement scoreElement = querySelector("#score");
    DivElement filthElement = querySelector("#filth");
    DivElement filthBox = querySelector("#filthbox");
    void updateUI(num dt) {
        if (!this.paused) {
            double time = director.timer;
            double seconds = time % 60.0;
            double minutes = (time - seconds) / 60.0;

            String timeString = "${"${minutes.floor()}".padLeft(1, "0")}:${"${seconds.floor()}".padLeft(2, "0")}";

            timeElement.text = timeString;
            scoreElement.text = director.score.toString();

            if (this.director.phase >= 6) {
                filthElement.text = "${(this.director.filthfraction * 100.0).floor()}%";
            }
        }
    }
}