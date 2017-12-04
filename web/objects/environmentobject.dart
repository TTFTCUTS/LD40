import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../main.dart';
import '../weapons/weapon.dart';
import "actor.dart";
import "arenamover.dart";
import "particles/arenaparticle.dart";
import "refuse.dart";

abstract class EnvironmentObject extends Actor {
    static Random rand = new Random();
    String tilekey = null;
    static THREE.Vector3 _hurtTint = new THREE.Vector3(0.75, 0.75, 0.75);

    EnvironmentObject(num x, num y, int width, int height, double size, int hp, double angle) : super(x, y, width, height, (size*2).ceil(), (size*2).ceil()) {
        this.setMaxHealth(hp);
        this.hurtTint = _hurtTint;
        this.angle = angle;
        this.takesContactDamage = false;
    }

    Refuse createRefuse();

    @override
    void onDeath() {
        this.createRefuse()..register(game)..tilekey = this.tilekey..angle = this.angle;
    }

    @override
    String getFrame() => tilekey;

    @override
    bool testCollision(Collider other) {
        if (other is Refuse || other is EnvironmentObject) { return false; }
        return super.testCollision(other);
    }

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

    @override
    void updateGraphics(num dt) {
        this.rot.setFromEuler(new THREE.Euler(0,0, this.angle));

        super.updateGraphics(dt);
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
    double burn = 0.0;

    Barrels(num x, num y, double angle) : super(x, y, 32,32, 16.0, 30, angle){
        this.tileset = TileSet.tilesets["objects"];
        getTexture("assets/sprites/objects.png").then((THREE.Texture t) { this.texture = t; });

        this.tilekey = "barrel";
    }

    @override
    void update(num dt) {
        if (this.health < this.maxhealth) {
            double percent = 1.0 - (this.health / this.maxhealth);
            if (percent > 0.25) {
                burn += 20 * percent * dt;
                double fraction = burn % 1.0;
                double whole = burn - fraction;
                burn = fraction;

                if (whole > 0) {
                    this.hurt(whole.floor());
                    new FireParticle(this.pos.x, this.pos.y, 0.1, 0.05)..register(game);
                    if (EnvironmentObject.rand.nextDouble() > 0.7) {
                        new SmokeParticle(this.pos.x + EnvironmentObject.rand.nextDouble() * 10 - 5, this.pos.y + EnvironmentObject.rand.nextDouble() * 10 - 5, 0.3, 0.05)..register(game);
                    }
                }
            }
        }
        super.update(dt);
    }

    @override
    void onDeath() {
        double fraction = 0.5 + EnvironmentObject.rand.nextDouble() * 0.5;
        new RocketExplosion(this.pos.x, this.pos.y, true, 30.0 * fraction, 20.0 * fraction)..register(game);
        super.onDeath();
    }

    @override
    EnvironmentRefuse createRefuse() {
        return new BarrelsRefuse(this.pos.x, this.pos.y, this.angle);
    }
}

class BarrelsRefuse extends EnvironmentRefuse {
    BarrelsRefuse(num x, num y, double angle) : super(x, y, 32,32, 16.0, angle){
        this.tileset = TileSet.tilesets["objects"];
        getTexture("assets/sprites/objects.png").then((THREE.Texture t) { this.texture = t; });;
    }

    @override
    EnvironmentObject createEnvObject() => new Barrels(this.pos.x, this.pos.y, this.angle);
}

// car

class Car extends EnvironmentObject {
    Car(num x, num y, double angle) : super(x,y, 96,48, 48.0, 50, angle){
        this.tileset = TileSet.tilesets["objects"];
        getTexture("assets/sprites/objects.png").then((THREE.Texture t) { this.texture = t; });

        this.tilekey = "car";
    }

    @override
    EnvironmentRubble createRefuse() {
        new RocketExplosion(this.pos.x, this.pos.y, true, 80.0, 100.0)..register(game);
        return new CarRefuse(this.pos.x, this.pos.y, this.angle);
    }
}

class CarRefuse extends EnvironmentRubble {
    CarRefuse(num x, num y, double angle) : super(x,y, 96,48, 48.0, angle){
        this.tileset = TileSet.tilesets["objects"];
        getTexture("assets/sprites/objects.png").then((THREE.Texture t) { this.texture = t; });
    }

    @override
    EnvironmentObject createEnvObject() => new Car(this.pos.x, this.pos.y, this.angle);
}

class Blood extends Refuse {
    int bloodamount;

    Blood(num x, num y, int this.bloodamount) : super(x, y, 16, 16, 32.0, EnvironmentObject.rand.nextDouble() * PI * 2) {
        this.setScale(new THREE.Vector3.all(sqrt(bloodamount)));
        this.tileset = TileSet.tilesets["blood"];
        getTexture("assets/sprites/blood.png").then((THREE.Texture t) { this.texture = t; });

        bool big = bloodamount > 4;
        this.tilekey = "blood_${big ? "big" : "small"}_${EnvironmentObject.rand.nextInt(big ? 7 : 4)+1}";
    }

    @override
    String getFrame() => tilekey;
}