import "package:GameLib2/three.dart" as THREE;

abstract class Trail {

    THREE.Vector3 getVel();
    double getTrailDelay();
    double trailCounter = 0.0;

    void updateTrail(num dt) {
        trailCounter += dt;
        int count = 0;
        double delay = getTrailDelay();
        while (trailCounter > delay) {
            trailCounter -= delay;
            count++;
        }

        if(count > 0) {
            THREE.Vector3 increment = getVel().clone()..divideScalar(count)..multiplyScalar(-dt);
            for (int i=0; i<count; i++) {
                spawnTrail(increment.clone()..multiplyScalar((count-1)-i));
            }
        }
    }

    void spawnTrail(THREE.Vector3 offset);
}

abstract class Spawner {
    bool spawned = false;

    void updateSpawn() {
        if (!spawned) { spawned = true; } else { return; }
        this.spawn();
    }

    void spawn();
}