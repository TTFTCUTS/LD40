import "dart:html";
import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../../mixins/bouncer.dart";
import "../../mixins/trail.dart";
import "../spriteobject.dart";

class ArenaParticle extends SpriteObject with Lifetime, Bouncer {
    static Random rand = new Random();
    int colwidth;
    int colheight;

    int frameCount;
    String frameName;

    ArenaParticle(num x, num y, int width, int height, double lifetime, double lifevariance, int this.frameCount, String this.frameName, String tileset, String image) : super(x, y, width, height) {
        this.colwidth = width ~/2;
        this.colheight = height ~/2;
        this.size = ((height + width) * 0.25);

        this.tileset = TileSet.tilesets[tileset];
        Loader.getResource(image).then((ImageElement img){
            this.texture = new THREE.Texture(img)..flipY=false..needsUpdate=true;
        });

        this.setLifetime(lifetime + rand.nextDouble() * lifevariance * 2 - lifevariance);
    }

    /*@override
    THREE.Box3 getBounds() {
        return new THREE.Box3.zero()..setFromCenterAndSize(this.pos, new THREE.Vector3(this.colwidth, this.colheight, 1.0));
    }*/

    /*@override
    void updateMovement(num dt) {
        super.updateMovement(dt);
        //this.updateWallMovement(dt);
    }*/

    @override
    String getFrame() {
        if (frameCount == 1) {
            return frameName;
        }
        double frac = 1.0 - this.getLifetimeFraction();
        int frame = (frac * frameCount).floor()+1;
        return "${frameName}_$frame";
    }

    /*@override
    void wallImpact(THREE.Vector3 dir, bool left, bool right, bool top, bool bot, [WallObject object = null]) {
        bounce(dir, left, right, top, bot);
    }*/

    @override
    double getElasticity() => 1.0;

    @override
    void update(num dt) {
        this.updateLifetime(dt);
        super.update(dt);
        if (this.model != null) {
            this.model.position.z = 6.0;
        }
    }

    void randomMotion(double minspeed, double maxspeed) {
        double speed = ArenaParticle.rand.nextDouble() * ArenaParticle.rand.nextDouble() * (maxspeed - minspeed) + minspeed;
        this.angle = ArenaParticle.rand.nextDouble() * 2 * PI;
        THREE.Vector2 push = this.getHeading().multiplyScalar(speed);
        this.setVel(new THREE.Vector3(push.x, push.y, 0.0));
    }
}

class ProjectileSheetParticle extends ArenaParticle {
    ProjectileSheetParticle(num x, num y, int width, int height, double lifetime, double lifevariance, int frameCount, String frameName) : super(x, y, width, height, lifetime, lifevariance, frameCount, frameName, "projectiles", "assets/sprites/projectiles.png");
}

class ObjectSheetParticle extends ArenaParticle {
    ObjectSheetParticle(num x, num y, int width, int height, double lifetime, double lifevariance, int frameCount, String frameName) : super(x, y, width, height, lifetime, lifevariance, frameCount, frameName, "objects", "assets/sprites/objects.png");
}

class SmokeParticle extends ProjectileSheetParticle {
    SmokeParticle(num x, num y, double lifetime, double lifevariance) : super(x, y, 32, 32, lifetime, lifevariance, 4, "smoke"){
        randomMotion(0.0, 50.0);
    }
}

class SmokeTrailer extends ProjectileSheetParticle with Trail {
    SmokeTrailer(num x, num y, double lifetime, double lifevariance) : super(x, y, 16, 16, lifetime, lifevariance, 1, "ball_small");

    @override
    double getTrailDelay() => 0.04;

    @override
    void update(num dt) {
        super.update(dt);
        this.updateTrail(dt);
    }

    @override
    void spawnTrail(THREE.Vector3 offset) {
        new SmokeParticle(this.pos.x + offset.x, this.pos.y + offset.y, 0.2, 0.1)..register(game);
    }
}

class FireParticle extends ProjectileSheetParticle {
    FireParticle(num x, num y, double lifetime, double lifevariance) : super(x, y, 16, 16, lifetime, lifevariance, 1, "fire"){
        randomMotion(0.0, 20.0);
    }
}