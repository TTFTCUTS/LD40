import "dart:html";
import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../mainlogic.dart";
import "../weapons/autorifle.dart";
import "../weapons/weapon.dart";
import "arenamover.dart";

class Player extends ArenaMover {
    Weapon weapon;

    Player(num x, num y) : super(x,y, 32, 32, 16,16) {
        this.tileset = TileSet.tilesets["arena"];
        Loader.getResource("assets/tiles/arena.png").then((ImageElement img){
            this.texture = new THREE.Texture(img)..flipY=false..needsUpdate=true;
        });

        this.weapon = new AutoRifle(this);
    }

    @override
    void update(num dt) {
        MainLogic game = this.game as MainLogic;

        int dx = 0;
        int dy = 0;

        if (game.allowControl) {
            if (game.getKey(65) || game.getKey(37)) {
                dx -= 1;
            }

            if (game.getKey(68) || game.getKey(39)) {
                dx += 1;
            }

            if (game.getKey(87) || game.getKey(38)) {
                dy -= 1;
            }

            if (game.getKey(83) || game.getKey(40)) {
                dy += 1;
            }

            if (this.weapon != null) {
                if (game.getButton(0)) {
                    this.weapon.trigger = true;
                } else {
                    this.weapon.trigger = false;
                }

                if (game.getKey(82) || game.getKey(96)) {
                    this.weapon.forceReload();
                }
            }
        }

        super.update(dt);

        if (weapon != null) {
            weapon.update(dt);
        }

        THREE.Vector2 dir = new THREE.Vector2(dx,dy)..normalize();

        this.move(dir);

        //print("${pos.x},${pos.y}, ${model.position.x},${model.position.y},${model.position.z}, ${model.quaternion.x},${model.quaternion.y},${model.quaternion.z},${model.quaternion.w}");
    }

    @override
    void updateMovement(num dt) {
        MainLogic game = (this.game as MainLogic);
        super.updateMovement(dt);

        THREE.Vector2 lookpoint = game.screenToWorld(new THREE.Vector2(game.mousepos.x, game.mousepos.y));
        THREE.Vector2 diff = lookpoint.sub(THREE.v3_xy(this.pos));

        this.setHeadingVec(diff);
        this.angle += PI * 0.5;
    }

    @override
    String getFrame() {
        return "test_0";
    }
}