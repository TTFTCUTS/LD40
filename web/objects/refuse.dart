import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "actor.dart";
import "arenamover.dart";
import 'environmentobject.dart';
import "particles/arenaparticle.dart";
import "projectile.dart";

class Refuse extends Actor {
    String tilekey = null;

    Refuse(num x, num y, int width, int height, double size, double angle) : super(x, y, width, height, (size*2).ceil(), (size*2).ceil()) {
        this.size = size;
        this.angle = angle;
        this.takesContactDamage = false;
    }

    @override
    bool testCollision(Collider other) {
        if (other is Refuse || other is EnvironmentObject) { return false; }
        return super.testCollision(other);
    }

    void cleanUp() {
        this.destroy();
    }

    @override
    void updateGraphics(num dt) {
        super.updateGraphics(dt);
        if (this.model != null) {
            this.model.position.z = -2.5;
        }
        this.rot.setFromEuler(new THREE.Euler(0,0, this.angle));
    }

    @override
    String getFrame() => "${tilekey}_refuse";
}

class Rubble extends Refuse {
    Rubble(num x, num y, int width, int height, double size, double angle) : super(x, y, width, height, size, angle) {

    }
    @override
    bool testCollision(Collider other) {
        if (other is Refuse || other is EnvironmentObject) { return false; }
        return super.testCollision(other);
    }

    @override
    void updateGraphics(num dt) {
        super.updateGraphics(dt);
        if (this.model != null) {
            this.model.position.z = 2.5;
        }
    }

    @override
    void collide(Collider other) {
        if (other is Projectile) {
            other.kill();
        } else if (other is ArenaMover && !(other is ArenaParticle)) {
            THREE.Vector2 diff = THREE.v3_xy(this.getPos())..sub(THREE.v3_xy(other.pos));
            double dot = max(0.0,THREE.v3_xy(other.vel).dot(diff) / diff.length());
            THREE.Vector2 proj = diff.clone().normalize()..multiplyScalar(dot);
            other.vel.x -= proj.x;
            other.vel.y -= proj.y;
        }

        super.collide(other);
    }
}