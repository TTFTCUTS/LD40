import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../mainlogic.dart";
import "actor.dart";
import "arenacollider.dart";

class ArenaMover extends Actor with ArenaCollider {
    double maxSpeed = 1000.0;
    double acceleration = 120.0;

    ArenaMover(num x, num y, int width, int height, int colwidth, int colheight) : super(x, y, width, height, colwidth, colheight) {
          this.resistance = 0.65;
    }

    void move(THREE.Vector2 direction, [num speedOverride = null]) {
        THREE.Vector2 dir = direction.clone()..normalize();

        num v = speedOverride != null ? speedOverride : acceleration;

        this.getVel().add(new THREE.Vector3(dir.x,dir.y,0.0).multiplyScalar(v));

        num speed = this.vel.length();
        if (speed > maxSpeed) {
            this.vel.normalize().multiplyScalar(maxSpeed);
        }
    }

    @override
    void updateMovement(num dt) {
        this.updateWallMovement(dt);
    }

    @override
    void updateGraphics(num dt) {
        this.rot.setFromEuler(new THREE.Euler(0,0, this.angle));

        super.updateGraphics(dt);
    }



}