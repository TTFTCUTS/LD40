import '../mainlogic.dart';
import '../objects/refuse.dart';
import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import '../objects/player.dart';
import 'weapon.dart';

class Mop extends Weapon {
    static THREE.Box3 aoe = new THREE.Box3.zero();
    static THREE.Vector3 aoescale = new THREE.Vector3.all(128);

    static THREE.Vector3 scale1 = new THREE.Vector3(2.0,2.0,2.0);
    static THREE.Vector3 scale2 = new THREE.Vector3(-2.0,2.0,2.0);

    Mop([GameObject2D holder]):super(holder) {
        this.sprite = "mop";

        this.fireRate = 20.0;
    }

    @override
    void shoot() {
        Player p = this.holder as Player;

        if (p.weapondelegate.offset.x == 3.0) {
            p.weapondelegate.offset.x = -3.0;
            p.weapondelegate.setScale(scale1);
        } else {
            p.weapondelegate.offset.x = 3.0;
            p.weapondelegate.setScale(scale2);
        }

        THREE.Vector2 dir = p.getHeading().normalize().multiplyScalar(40);
        THREE.Vector3 sweepspot = new THREE.Vector3(p.pos.x + dir.x, p.pos.y + dir.y, 0.0);

        Set<Collider> filth = (p.game as MainLogic).collision.queryAabb(aoe.setFromCenterAndSize(sweepspot, aoescale));
        filth.retainWhere((Collider c) => c is Refuse);

        for (Collider c in filth) {
            if (c is Refuse && c.getPos().distanceTo(sweepspot) < 40) {
                c.hurt(1);
            }
        }
    }
}