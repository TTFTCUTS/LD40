import "dart:math";

import "package:GameLib2/GameLib2.dart";

class Weapon {
    GameObject2D holder;

    bool trigger = false;

    int maxAmmo = -1;
    int ammo = 1;

    double fireRate = 5.0;
    double cooldown = 0.0;

    double reloadTime = 3.0;
    double reload = 0.0;

    Weapon(GameObject2D this.holder) {}

    void update(num dt) {
        if (cooldown > 0.0) {
            cooldown -= dt;
        }
        if (ammo > 0) {
            if (cooldown <= 0.0 && trigger) {
                cooldown += 1.0 / fireRate;
                shoot();
                if (maxAmmo > 0) {
                    ammo--;
                    if (ammo == 0) {
                        reload += reloadTime;
                        onReload();
                    }
                }
            }
        } else {
            if (reload > 0.0) {
                reload -= dt;
            }
            if (reload <= 0.0) {
                if (maxAmmo > 0) {
                    ammo = maxAmmo;
                }
            }
        }
    }

    void forceReload() {
        if (this.maxAmmo > 0 && this.ammo < this.maxAmmo && this.ammo > 0 && this.reload <= 0.0) {
            this.ammo = 0;
            this.reload += this.reloadTime;
            this.onReload();
        }
    }

    void shoot() {

    }

    void onReload() {

    }
}