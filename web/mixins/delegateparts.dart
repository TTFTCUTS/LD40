import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../main.dart';
import "../objects/actor.dart";
import "../objects/spriteobject.dart";

abstract class DelegateParts {
    List<PartDelegate> delegates = <PartDelegate>[];

    THREE.Vector3 getPos();
    THREE.Vector2 getHeading();
    double getAngle();

    void destroyDelegates() {
        for (PartDelegate part in delegates) {
            part.destroy();
        }
    }

    void createDelegates();
}

class PartDelegate extends SpriteObject {
    DelegateParts parent;
    THREE.Vector2 offset;
    double offsetAngle;

    String tilekey;
    THREE.Vector3 baseTint;

    PartDelegate(DelegateParts this.parent, num offsetx, num offsety, double this.offsetAngle, int width, int height, String tileset, String this.tilekey, String image) : super(parent.getPos().x, parent.getPos().y, width, height) {
        this.offset = new THREE.Vector2(offsetx, offsety);
        this.parent.delegates.add(this);
        this.updatePositionToParent();

        this.tileset = TileSet.tilesets[tileset];
        /*Loader.getResource(image).then((ImageElement img){
            this.texture = new THREE.Texture(img)..flipY=false..needsUpdate=true;
        });*/
        getTexture(image).then((THREE.Texture t) {this.texture = t;});

        this.baseTint = this.tint.clone();
    }

    void updatePositionToParent() {
        THREE.Vector2 up = parent.getHeading();
        THREE.Vector3 ppos = parent.getPos();

        this.setHeadingVec(up);

        this.pos.z = ppos.z + 1.0;

        this.pos.x = ppos.x - up.y * offset.x - up.x * offset.y;
        this.pos.y = ppos.y - up.y * offset.y + up.x * offset.x;

        this.vel.x = 0.0;
        this.vel.y = 0.0;
    }

    @override
    void update(num dt) {
        this.updatePositionToParent();
        super.update(dt);

    }

    @override
    String getFrame() => tilekey;

    @override
    void updateGraphics(num dt) {
        this.rot.setFromEuler(new THREE.Euler(0,0, this.angle + this.offsetAngle + PI * 0.5));

        if (parent is Actor) {
            Actor pa = (parent as Actor);
            double frac = pa.getHurtPortion();
            this.tint.x = this.baseTint.x + pa.hurtTint.x * frac;
            this.tint.y = this.baseTint.y + pa.hurtTint.y * frac;
            this.tint.z = this.baseTint.z + pa.hurtTint.z * frac;
        }

        super.updateGraphics(dt);
    }
}