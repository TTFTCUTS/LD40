import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../mixins/health.dart";
import "../mixins/trail.dart";
import "../objects/enemy.dart";
import "../objects/environmentobject.dart";
import "../objects/particles/arenaparticle.dart";
import "../objects/player.dart";
import "../objects/projectile.dart";
import "../objects/wallobject.dart";

import "weapon.dart";

class RocketLauncher extends Weapon {
    Random rand = new Random();

    RocketLauncher([GameObject2D holder]) : super(holder) {
        this.fireRate = 1.0;
        this.maxAmmo = 1;
        this.ammo = 1;
        this.reloadTime = 2.5;

        this.sprite = "launcher";
    }

    @override
    void shoot() {
        THREE.Vector2 offset = holder.getHeading().normalize().multiplyScalar(holder.size * 0.25);

        THREE.Vector2 origin = THREE.v3_xy(holder.pos).add(offset);

        new Rocket(origin.x, origin.y, true)..register(holder.game)
            ..move(holder.getHeading().normalize(), 750.0);

        Audio.play("ROCKETLAUNCH", "effects", pitchVar: 0.075);
    }
}

class Rocket extends Projectile with Trail {
    bool friendly;

    static Random rand = new Random();
    Rocket(num x, num y, bool this.friendly) : super(x, y, 16, 4) {
        this.tilekey = "rocket";
    }

    @override
    void wallImpact(THREE.Vector3 dir, bool left, bool right, bool top, bool bot, [WallObject object = null]) {
        new RocketExplosion(this.pos.x, this.pos.y, this.friendly, 50.0, 75.0)..register(game);
        this.destroy();
    }

    @override
    void impactEnvironment(EnvironmentObject other) {
        new RocketExplosion(this.pos.x, this.pos.y, this.friendly, 50.0, 75.0)..register(game);
        this.destroy();
    }

    @override
    void impactEnemy(Enemy other) {
        if (friendly) {
            new RocketExplosion(this.pos.x, this.pos.y, this.friendly, 50.0, 75.0)..register(game);
            this.destroy();
        }
    }

    @override
    void impactPlayer(Player other) {
        if (!friendly) {
            new RocketExplosion(this.pos.x, this.pos.y, this.friendly, 35.0, 40.0)..register(game);
            this.destroy();
        }
    }

    @override
    void update(num dt) {
        super.update(dt);
        this.updateTrail(dt);
    }

    @override
    void spawnTrail(THREE.Vector3 offset) {
        new SmokeParticle(this.pos.x + offset.x, this.pos.y + offset.y, 0.2, 0.1)..register(game);
    }

    @override
    double getTrailDelay() => 0.01;
}

class RocketExplosion extends ArenaParticle with Spawner {
    static double radius = 110.0;
    static THREE.Vector3 grabbox = new THREE.Vector3.all(radius);
    bool friendly;

    double damage;
    double walldamage;

    RocketExplosion(num x, num y, bool this.friendly, double this.damage, double this.walldamage) : super(x, y, 128, 128, 0.16, 0.0, 4, "explosion", "objects", "assets/sprites/objects.png") {
        this.pos.z = 10.0;
    }

    @override
    void update(num dt) {
        super.update(dt);
        this.updateSpawn();
    }

    @override
    void spawn() {
        Audio.play("EXPLOSION", "loudeffects", pitchVar: 0.01);

        for (int i=0; i<10; i++) {
            new SmokeTrailer(this.pos.x, this.pos.y, 0.1, 0.025)..randomMotion(1000.0, 2000.0)..register(game);
        }

        Set<Collider> area = game.collision.queryAabb(new THREE.Box3.zero()..setFromCenterAndSize(this.pos, grabbox));
        area.remove(this);

        double splash;
        for (Collider c in area) {
            splash = max(0.0, 1.0 - (c.getPos().distanceTo(this.pos) / radius));
            if (splash > 0.0) {
                if (c is WallObject) {
                    c.hurt((walldamage * splash).floor());
                } else if (c is Enemy || c is EnvironmentObject) {
                    if (!friendly) {
                        (c as Health).hurt((damage * 0.5 * splash).floor());
                    } else {
                        (c as Health).hurt((damage * splash).floor());
                    }
                } else if (c is Player) {
                    if (friendly) {
                        c.hurt((damage * 0.5 * splash).floor());
                    } else {
                        c.hurt((damage * splash).floor());
                    }
                }
            }
        }
    }
}