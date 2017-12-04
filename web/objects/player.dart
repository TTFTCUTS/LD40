import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../main.dart';
import "../mainlogic.dart";
import '../mixins/bleeder.dart';
import '../mixins/delegateparts.dart';
import "../weapons/weapon.dart";
import "arenamover.dart";

class Player extends ArenaMover with DelegateParts, Bleeder {
    Weapon weapon;

    Player(num x, num y) : super(x,y, 32, 32, 16,16) {
        this.takesContactDamage = true;
        this.setMaxHealth(100);

        this.tileset = TileSet.tilesets["dude"];
        getTexture("assets/sprites/dude.png").then((THREE.Texture t) { this.texture = t; });

        this.weapon = new AutoRifle(this); // new RocketLauncher(this); //
    }

    @override
    void register(GameLogic game) {
        super.register(game);
        this.createDelegates();
        (game as MainLogic).player = this;
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
        this.updateBlood(dt);

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
        return "body";
    }

    @override
    void onDeath() {
        super.onDeath();
        this.deathBlood();
    }

    @override
    void destroy() {
        this.destroyDelegates();
        super.destroy();
    }

    @override
    void createDelegates() {
        new PartDelegate(this, 6, -10, 0.0, 24, 24, "dude", this.weapon.sprite, "assets/sprites/dude.png")..register(game);
        new PartDelegate(this, 0, -7.5, 0.0, 16, 16, "dude", "head", "assets/sprites/dude.png")
            ..baseTint.x = 0.2
            ..baseTint.y = 0.2
            ..baseTint.z = 0.8
            ..register(game);
    }
}