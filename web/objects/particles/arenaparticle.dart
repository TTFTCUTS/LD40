import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../arenacollider.dart";
import "../spriteobject.dart";

class ArenaParticle extends SpriteObject with ArenaCollider, Lifetime {
    @override
    int colwidth;
    @override
    int colheight;

    ArenaParticle(num x, num y, int width, int height) : super(x, y, width, height) {
        this.colwidth = width ~/2;
        this.colheight = height ~/2;
        this.size = ((height + width) * 0.25);
    }

    @override
    THREE.Box3 getBounds() {
        return new THREE.Box3.zero()..setFromCenterAndSize(this.pos, new THREE.Vector3(this.colwidth, this.colheight, 1.0));
    }

    @override
    void updateMovement(num dt) {
        this.updateWallMovement(dt);
    }
}