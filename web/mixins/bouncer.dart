import "package:GameLib2/three.dart" as THREE;

abstract class Bouncer {

    double getElasticity();
    
    void setVel(THREE.Vector3 v);

    void bounce(THREE.Vector3 dir, bool left, bool right, bool top, bool bot) {
        THREE.Vector3 normal = new THREE.Vector3.zero();
        if (left) {
            normal.x += 1.0;
        } else if (right) {
            normal.x -= 1.0;
        }

        if (top) {
            normal.y += 1.0;
        } else if (bot) {
            normal.y -= 1.0;
        }

        if (normal.length() > 0.0) {
            THREE.Vector3 ref = dir.reflect(normal.normalize()).multiplyScalar(getElasticity());

            this.setVel(ref);
        }
    }
}