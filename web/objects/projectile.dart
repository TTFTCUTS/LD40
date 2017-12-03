import "dart:html";
import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../helpers.dart";

import "arenamover.dart";

import "enemy.dart";
import "environmentobject.dart";
import "player.dart";
import "wallobject.dart";

class Projectile extends ArenaMover with Lifetime {
    Projectile(num x, num y, int size, int colsize) : super(x, y, size, size, colsize, colsize) {
        this.maxSpeed = 100000.0;
        this.maxlifetime = 5.0;
        this.resistance = 1.0;

        this.tileset = TileSet.tilesets["projectiles"];
        Loader.getResource("assets/sprites/projectiles.png").then((ImageElement img){
            this.texture = new THREE.Texture(img)..flipY=false..needsUpdate=true;
        });

        this.pos.z = 1.0;
    }

    @override
    void update(num dt) {
        this.updateLifetime(dt);
        super.update(dt);
        this.setHeadingVec(THREE.v3_xy(this.vel));
        this.angle += PI * 0.5;
    }

    @override
    String getFrame() {
        return "bullet";
    }

    @override
    void wallImpact(THREE.Vector3 dir, bool left, bool right, bool top, bool bot, [WallObject object = null]) {
        /*THREE.Vector3 normal = new THREE.Vector3.zero();
        if (left) {
            normal.x += 1.0;
        } else if (right) {
            normal.x -= 1.0;
        }

        if (top) {
            normal.y += 1.0;
        } else if (bot) {
            normal.y -= 1.0;
        }

        if (normal.length() > 0.0) {
            THREE.Vector3 ref = dir.reflect(normal.normalize());

            this.setVel(ref);
        }*/

        if (object != null) {
            impactWall(object);
        } else {
            this.destroy();
        }
    }

    @override
    void collide(Collider other) {
        if (other is Player) {
            impactPlayer(other);
        }

        if (other is Enemy) {
            impactEnemy(other);
        }

        if (other is EnvironmentObject) {
            impactEnvironment(other);
        }

        if (other is WallObject) {
            impactWall(other);
        }

        super.collide(other);
    }

    void impactPlayer(Player other) {}
    void impactEnemy(Enemy other) {}
    void impactEnvironment(EnvironmentObject other) {}
    void impactWall(WallObject other) {}
}