import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../objects/environmentobject.dart';
import '../objects/player.dart';
import '../objects/projectile.dart';
import '../objects/wallobject.dart';
import "weapon.dart";

class EnemyGun extends Weapon {
    static Random rand = new Random();
    double spread = PI / 24.0;

    int damage = 2;
    double velocity = 450.0;
    String sound = "boydhurt1";

    EnemyGun() : super(){
        this.sprite = "handgun";
    }

    Projectile spawnProjectile(double x, double y) {
        return new EnemyBullet(x, y, (10.0 * sqrt(damage)).floor(), damage);
    }

    @override
    void shoot() {
        THREE.Vector2 offset = holder.getHeading().normalize().multiplyScalar(holder.size * 0.25);

        THREE.Vector2 origin = THREE.v3_xy(holder.pos).add(offset);

        this.spawnProjectile(origin.x, origin.y)..register(holder.game)..angle = holder.angle
            ..move(holder.getHeading().normalize().rotateAround(new THREE.Vector2.zero(), (rand.nextDouble() - 0.5) * spread), velocity);

        Audio.play(sound, "effects", pitchVar: 0.075);
    }
}

class EnemyBullet extends Projectile {
    int damage;

    EnemyBullet(num x, num y, int size, int this.damage) : super(x, y, size, size~/2) {
        this.tilekey = "ball_med_enemy";
    }

    @override
    void impactWall(WallObject other) {
        other.hurt((damage * 0.25).round());
        this.destroy();
    }

    @override
    void impactEnvironment(EnvironmentObject other) {
        other.hurt(damage);
        this.destroy();
    }

    @override
    void impactPlayer(Player other) {
        other.hurt(damage);
        this.destroy();
    }
}

class GruntGun extends EnemyGun {
    GruntGun() {
        this.fireRate = 1.0;
        this.damage = 5;
        this.velocity = 175.0;
        this.ammo = 6;
        this.maxAmmo = 6;
        this.reloadTime = 3.0;
        this.spread = PI / 8;
    }
}

class SargeGun extends EnemyGun {
    SargeGun() {
        this.fireRate = 1.2;
        this.damage = 10;
        this.velocity = 175.0;
        this.ammo = 8;
        this.maxAmmo = 8;
        this.reloadTime = 2.0;
        this.spread = PI / 16;
    }
}

class FattyGun extends EnemyGun {
    FattyGun() {
        this.fireRate = 3.5;
        this.damage = 5;
        this.velocity = 175.0;
        this.ammo = 50;
        this.maxAmmo = 50;
        this.reloadTime = 4.0;
        this.spread = PI / 6;

        this.sprite = "minigun";
    }
}