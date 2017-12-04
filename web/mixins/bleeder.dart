import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../objects/environmentobject.dart";

abstract class Bleeder {
    static Random rand = new Random();
    int bloodbank = 0;
    double bloodclock = 0.0;
    double nextbloodtick = 1.0;

    THREE.Vector3 get pos;
    double get size;
    GameLogic get game;
    int get maxhealth;

    void updateBlood(num dt) {
        bloodclock += dt;
        if (bloodclock > nextbloodtick) {
            bloodclock -= nextbloodtick;
            nextbloodtick = rand.nextDouble() * 0.7 + 0.7;

            if (this.bloodbank > 0) {
                THREE.Vector2 offset = new THREE.Vector2(rand.nextDouble() * this.size, 0).rotateAround(new THREE.Vector2.zero(), rand.nextDouble() * PI * 2);
                new Blood(this.pos.x + offset.x, this.pos.y + offset.y, this.bloodbank)..register(game);

                this.bloodbank = 0;
            }
        }
    }

    void deathBlood() {
        this.nextbloodtick = -10.0;
        this.bloodbank += maxhealth ~/2;
        this.updateBlood(1.0);
    }
}