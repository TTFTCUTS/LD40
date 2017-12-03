import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../objects/enemy.dart";
import "../objects/environmentobject.dart";
import "../objects/projectile.dart";
import "../objects/wallobject.dart";

import "weapon.dart";

class AutoRifle extends Weapon {
    Random rand = new Random();
    double spread = PI / 32.0;

    AutoRifle(GameObject2D holder) : super(holder) {
        this.fireRate = 10.0;
        this.maxAmmo = 24;
        this.ammo = 24;
        this.reloadTime = 2.0;
    }

    @override
    void shoot() {
        THREE.Vector2 offset = holder.getHeading().normalize().multiplyScalar(holder.size * 0.25);

        THREE.Vector2 origin = THREE.v3_xy(holder.pos).add(offset);

        new AutoRifleBullet(origin.x, origin.y)..register(holder.game)
            ..move(holder.getHeading().normalize().rotateAround(new THREE.Vector2.zero(), (rand.nextDouble() - 0.5) * spread), 750.0);

        Audio.play("boydhurt1", "effects", pitchVar: 0.075);
    }
}

class AutoRifleBullet extends Projectile {
    static Random rand = new Random();
    AutoRifleBullet(num x, num y) : super(x, y, 16, 4);

    @override
    void impactWall(WallObject other) {
        other.hurt(rand.nextInt(2) + 1);
        this.destroy();
    }

    @override
    void impactEnvironment(EnvironmentObject other) {
        other.hurt(rand.nextInt(2) + 1);
        this.destroy();
    }

    @override
    void impactEnemy(Enemy other) {
        this.destroy();
    }
}