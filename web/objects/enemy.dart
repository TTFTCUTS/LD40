import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../main.dart';
import '../mainlogic.dart';
import '../mixins/bleeder.dart';
import '../mixins/contactdamage.dart';
import '../mixins/delegateparts.dart';
import '../room.dart';
import '../weapons/weapon.dart';
import "arenamover.dart";

class Enemy extends ArenaMover with DelegateParts, ContactDamage, Bleeder, RoomObject {
    static double LOS_STEP = 28.0;
    static Random rand = new Random();

    Weapon weapon;

    double hatr;
    double hatg;
    double hatb;

    double viewrange = 10.0;
    double engagementRange = 0.6;

    double turnspeed = 1.0;
    double wakeuptime = 1.0;
    double hesitation = 1.0;

    double wakedness = 0.0;
    double shootwindup = 0.0;

    double wandertimer = 0.0;
    double wandertime = 1.0;

    double accuracy = 0.2;

    int score = 100;

    bool mobile = true;

    Enemy(num x, num y, int size, int health, double r, double g, double b, double this.hatr, double this.hatg, double this.hatb, Weapon this.weapon) : super(x, y, size, size, (size*0.75).floor(), (size*0.75).floor()) {

        this.setMaxHealth(health);
        this.tint..x=r..y=g..z=b;

        this.weapon.holder = this;

        this.tileset = TileSet.tilesets["dude"];
        getTexture("assets/sprites/dude.png").then((THREE.Texture t) { this.texture = t; });

        this.damage = 1;

        this.angle = rand.nextDouble() * PI * 2;
        this.wandertimer = rand.nextDouble() * wandertime;
    }

    @override
    void createDelegates() {
        double scale = (this.colwidth / 16) * (2/3);
        new PartDelegate(this, 6 * scale, -10 * scale, 0.0, (24 * scale).round(), (24 * scale).round(), "dude", this.weapon.sprite, "assets/sprites/dude.png")..register(game);
        new PartDelegate(this, 0, -7.5 * scale, 0.0, (16 * scale).round(), (16 * scale).round(), "dude", "head", "assets/sprites/dude.png")..register(game)
        ..baseTint.x=hatr..baseTint.y=hatg..baseTint.z=hatb;
    }

    @override
    void register(GameLogic game) {
        super.register(game);
        this.createDelegates();
        this.addToRoom();
    }

    @override
    void destroy() {
        this.destroyDelegates();
        super.destroy();
    }

    @override
    String getFrame() {
        return "body";
    }

    @override
    void update(num dt) {
        if(this.paused) { return; }
        super.update(dt);
        this.weapon.update(dt);
        this.updateBlood(dt);

        if (checkForPlayer()) {
            fight(dt);
        } else {
            wander(dt);
        }
    }

    @override
    void hurt(int amount) {
        this.wakedness = wakeuptime * 2.0;
        super.hurt(amount);

        //splatter blood based on damage
        this.bloodbank += amount;
    }

    @override
    void onDeath() {
        //splatter big blood, splat explosion?
        this.deathBlood();
        game.director.score += this.score;
        super.onDeath();
    }

    bool checkForPlayer() {
        if (this.game == null) { return false; }
        MainLogic game = this.game as MainLogic;
        if (game.player == null) { return false; }
        double dist = this.pos.distanceTo(game.player.pos);
        if (dist > this.viewrange * 32.0) { return false; }

        int steps = (dist / LOS_STEP).floor();
        THREE.Vector2 step = THREE.v3_xy(game.player.pos.clone().sub(this.pos)).normalize().multiplyScalar(LOS_STEP);

        WorldGrid grid = game.grid;
        for (int i=0; i<steps; i++) {
            if (grid.solidAt(((this.pos.x + step.x * i) / grid.tilesize).floor(), ((this.pos.y + step.y * i) / grid.tilesize).floor())) {
                return false;
            }
        }

        return true;
    }

    void wander(num dt) {
        this.shootwindup = 0.0;
        this.weapon.trigger = false;
        this.wakedness = max(0.0, this.wakedness - dt * 0.5);
        if (wakedness > 0) {
            this.fight(dt, false);
            return;
        }

        if (this.wandertimer < this.wandertime) {
            this.wandertimer += dt;
            return;
        }
        this.wandertimer -= this.wandertime * (0.7 + 0.8 * rand.nextDouble());

        double spread = 0.25;
        double minimum = 0.0;
        THREE.Vector2 heading = this.getHeading();

        if (this.mobile) {
            THREE.Vector2 probe = heading.normalize().multiplyScalar(this.size * 0.75);
            WorldGrid grid = (this.game as MainLogic).grid;
            for (int i = 1; i <= 3; i++) {
                if (grid.solidAt(((this.pos.x + probe.x * i) / grid.tilesize).floor(), ((this.pos.y + probe.y * i) / grid.tilesize).floor())) {
                    spread += 0.35;
                    minimum += 0.3;
                    break;
                }
            }
        }

        double ang = (rand.nextDouble() * spread - spread * 0.5 + minimum * (rand.nextBool() ? 1.0 : -1.0)) * PI;
        this.angle += ang;
        if (this.mobile) {
            this.move(heading.rotateAround(new THREE.Vector2.zero(), ang));
        }
    }

    void fight(num dt, [bool wakeup = true]) {
        this.wandertimer = 0.0;

        if (wakeup && this.wakedness < this.wakeuptime) {
            this.wakedness += dt;
            wander(dt);
        }

        THREE.Vector2 heading = this.getHeading();
        THREE.Vector2 diff = THREE.v3_xy((this.game as MainLogic).player.pos.clone().sub(this.pos));
        THREE.Vector2 dir = diff.clone().normalize();

        double ang = atan2(heading.y, heading.x) - atan2(dir.y, dir.x);
        if (ang > PI) { ang -= PI * 2; }
        else if (ang < - PI) { ang += PI * 2; }

        if (ang.abs() > PI * 0.02) {
            this.angle -= this.turnspeed * dt * ang.sign;
        }

        if (ang.abs() < PI * this.accuracy){
            this.shootwindup = min(this.hesitation, this.shootwindup + dt);
            if (shootwindup >= this.hesitation) {
                this.weapon.trigger = true;
            } else {
                this.weapon.trigger = false;
            }
        }
    }
}

class Grunt extends Enemy {
    Grunt(num x, num y) : super(x, y, 32, 8, 0.7, 0.4, 0.2, 0.2, 0.8, 0.2, new GruntGun());
}

class Sarge extends Enemy {
    Sarge(num x, num y) : super(x, y, 40, 20, 0.2, 0.5, 0.2, 0.2, 0.8, 0.2, new SargeGun()) {
        this.turnspeed = 2.0;
        this.wandertime = 0.8;
        this.accuracy = 0.1;
        this.hesitation = 0.2;
        this.viewrange = 12.0;

        this.score = 250;
    }
}

class Fatty extends Enemy {
    Fatty(num x, num y) : super(x, y, 64, 100, 0.8, 0.3, 0.2, 0.8, 0.8, 0.2, new FattyGun()) {
        this.turnspeed = 1.2;
        this.mobile = false;
        this.accuracy = 0.1;
        this.hesitation = 0.1;
        this.viewrange = 23.0;

        this.score = 2500;
    }

    @override
    void onDeath() {
        super.onDeath();
        if (Enemy.rand.nextDouble() <= 0.5) {
            (this.game as MainLogic).director.announcer.play("thatshowedim", "HOST: That showed 'im!");
        }
    }
}

class Commando extends Enemy {
    Commando(num x, num y) : super(x, y, 40, 40, 0.1, 0.1, 0.1, 0.4, 0.2, 0.2, new CommandoGun()) {
        this.turnspeed = 4.0;
        this.wandertime = 0.6;
        this.accuracy = 0.1;
        this.hesitation = 0.2;
        this.viewrange = 10.0;

        this.score = 250;
    }
}