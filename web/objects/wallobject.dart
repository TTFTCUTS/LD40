import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../main.dart';
import "actor.dart";
import "refuse.dart";

class WallObject extends Actor {
    static Random rand = new Random();
    static THREE.Vector3 _hurtTint = new THREE.Vector3(-0.2, -0.2, -0.2);

    final int cellx;
    final int celly;

    String tilekey;

    WallObject(int this.cellx, int this.celly, TileType tileType, WorldGrid grid, [int hp = 100, String tilekey]) : super(cellx * 32 + 16, celly * 32 + 16, 32, 32, 32,32) {
        this.tileset = TileSet.tilesets["arena"];

        if (tileType == null && tilekey != null) {
            this.tilekey = tilekey;
        } else {
            this.tilekey = tileType.getTileNameForLocation(grid, cellx, celly, rand, false);
        }

        getTexture("assets/tiles/arena.png").then((THREE.Texture t) { this.texture = t; });
        this.size = 32.0;

        this.setMaxHealth(hp);

        this.hurtTint = _hurtTint;
        this.takesContactDamage = false;
    }

    @override
    String getFrame() {
        if (this.health > this.maxhealth * 0.75) {
            return tilekey;
        } else if (this.health > this.maxhealth * 0.50) {
            return "${tilekey}_damage25";
        } else if (this.health > this.maxhealth * 0.25) {
            return "${tilekey}_damage50";
        }
        return "${tilekey}_damage75";
    }

    @override
    void updateGraphics(num dt) {
        super.updateGraphics(dt);
        if (this.model != null) {
            this.model.position.z = 5.0;
        }
    }

    @override
    bool testCollision(Collider other) {
        if (other is WallObject) { return false; }
        return super.testCollision(other);
    }

    @override
    void onDeath() {
        super.onDeath();
        new WallRubble(this)..register(game);
        game.director.score += 500;
    }
}

class WallRubble extends Refuse {
    int cellx;
    int celly;
    int hp;

    WallRubble(WallObject wall) : super(wall.pos.x, wall.pos.y, 32, 32, 32.0, 0.0) {
        this.tileset = wall.tileset;
        this.texture = wall.texture;

        this.tilekey = wall.tilekey;
        this.hp = wall.maxhealth;
        this.cellx = wall.cellx;
        this.celly = wall.celly;

        this.filth = 20.0;
        this.setMaxHealth(30);
    }

    @override
    String getFrame() {
        return "${tilekey}_damage100";
    }

    @override
    void cleanUp() {
        super.cleanUp();
        //new WallObject(cellx, celly, null, null, hp, tilekey);
    }
}

class Blockerwall extends WallObject {
    static THREE.Vector3 _nohurtTint = new THREE.Vector3(0.0, 0.0, 0.0);

    Blockerwall(int cellx, int celly, WorldGrid grid) : super(cellx, celly, TileType.typesByName["blocker"], grid) {
        this.setMaxHealth(1000000);
        this.hurtTint = _nohurtTint;
    }

    @override
    void update(num dt) {
        super.update(dt);
        if (!this.destroyed) {
            this.setMaxHealth(1000000);
        }
    }

    @override
    void onDeath() {
        this.destroy();
    }
}