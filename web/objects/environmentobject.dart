import "dart:html";
import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "actor.dart";
import "arenamover.dart";
import "particles/arenaparticle.dart";
import "refuse.dart";

abstract class EnvironmentObject extends Actor {
    String tilekey = null;
    static THREE.Vector3 _hurtTint = new THREE.Vector3(0.75, 0.75, 0.75);

    EnvironmentObject(num x, num y, int width, int height, double size, int hp, double angle) : super(x, y, width, height, (size*2).ceil(), (size*2).ceil()) {
        this.setMaxHealth(hp);
        this.hurtTint = _hurtTint;
        this.angle = angle;
    }

    Refuse createRefuse();

    @override
    void onDeath() {
        this.createRefuse()..register(game)..tilekey = this.tilekey..angle = this.angle;
    }

    @override
    String getFrame() => tilekey;

    @override
    void collide(Collider other) {
        if (other is ArenaMover && !(other is ArenaParticle)) {
            THREE.Vector2 diff = THREE.v3_xy(this.getPos())..sub(THREE.v3_xy(other.pos));
            double dot = max(0.0,THREE.v3_xy(other.vel).dot(diff) / diff.length());
            THREE.Vector2 proj = diff.clone().normalize()..multiplyScalar(dot);
            other.vel.x -= proj.x;
            other.vel.y -= proj.y;
        }

        super.collide(other);
    }
}

abstract class EnvironmentRefuse extends Refuse {
    EnvironmentRefuse(num x, num y, int width, int height, double size, double angle) : super(x, y, width, height, size, angle){

    }

    EnvironmentObject createEnvObject();

    @override
    void cleanUp() {
        this.createEnvObject()..register(game)..tilekey = this.tilekey..angle = this.angle;
        this.destroy();
    }

    @override
    String getFrame() => "${tilekey}_refuse";
}

abstract class EnvironmentRubble extends Rubble {
    EnvironmentRubble(num x, num y, int width, int height, double size, double angle) : super(x, y, width, height, size, angle){

    }

    EnvironmentObject createEnvObject();

    @override
    void cleanUp() {
        this.createEnvObject()..register(game)..tilekey = this.tilekey..angle = this.angle;
        this.destroy();
    }
}

// barrels

class Barrels extends EnvironmentObject {
    Barrels(num x, num y, double angle) : super(x, y, 32,32, 16.0, 5, angle){

    }

    @override
    EnvironmentRefuse createRefuse() {
        return new BarrelsRefuse(this.pos.x, this.pos.y, this.angle);
    }
}

class BarrelsRefuse extends EnvironmentRefuse {
    BarrelsRefuse(num x, num y, double angle) : super(x, y, 32,32, 16.0, angle){

    }

    @override
    EnvironmentObject createEnvObject() => new Barrels(this.pos.x, this.pos.y, this.angle);
}

// car

class Car extends EnvironmentObject {
    Car(num x, num y, double angle) : super(x,y, 64,64, 32.0, 50, angle){
        this.tileset = TileSet.tilesets["arena"];
        Loader.getResource("assets/tiles/arena.png").then((ImageElement img){
            this.texture = new THREE.Texture(img)..flipY=false..needsUpdate=true;
        });

        this.tilekey = "test_0";
    }

    @override
    EnvironmentRubble createRefuse() {
        return new CarRefuse(this.pos.x, this.pos.y, this.angle);
    }
}

class CarRefuse extends EnvironmentRubble {
    CarRefuse(num x, num y, double angle) : super(x,y, 64,64, 32.0, angle){
        this.tileset = TileSet.tilesets["arena"];
        Loader.getResource("assets/tiles/arena.png").then((ImageElement img){
            this.texture = new THREE.Texture(img)..flipY=false..needsUpdate=true;
        });
    }

    @override
    EnvironmentObject createEnvObject() => new Car(this.pos.x, this.pos.y, this.angle);
}
