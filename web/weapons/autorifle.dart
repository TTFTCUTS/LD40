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
    double spread = PI / 24.0;

    AutoRifle([GameObject2D holder]) : super(holder) {
        this.fireRate = 20.0;
        this.maxAmmo = 100;
        this.ammo = 100;
        this.reloadTime = 3.0;

        this.sprite = "minigun";
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
        other.hurt(1);
        this.destroy();
    }

    @override
    void impactEnvironment(EnvironmentObject other) {
        other.hurt(1);
        this.destroy();
    }

    @override
    void impactEnemy(Enemy other) {
        other.hurt(1);
        this.destroy();
    }
}