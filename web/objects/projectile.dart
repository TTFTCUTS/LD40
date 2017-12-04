import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../main.dart';

import "arenamover.dart";

import "enemy.dart";
import "environmentobject.dart";
import "player.dart";
import "wallobject.dart";

class Projectile extends ArenaMover with Lifetime {
    String tilekey = "bullet";

    Projectile(num x, num y, int size, int colsize) : super(x, y, size, size, colsize, colsize) {
        this.maxSpeed = 100000.0;
        this.maxlifetime = 5.0;
        this.resistance = 1.0;

        this.tileset = TileSet.tilesets["projectiles"];
        getTexture("assets/sprites/projectiles.png").then((THREE.Texture t) { this.texture = t; });

        this.pos.z = 1.0;

        this.takesContactDamage = false;
    }

    @override
    void update(num dt) {
        this.updateLifetime(dt);
        super.update(dt);
        this.setHeadingVec(THREE.v3_xy(this.vel));
        this.angle += PI * 0.5;
    }

    @override
    String getFrame() => tilekey;

    @override
    void wallImpact(THREE.Vector3 dir, bool left, bool right, bool top, bool bot, [WallObject object = null]) {
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