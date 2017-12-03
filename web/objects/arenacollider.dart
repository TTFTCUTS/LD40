import "dart:math";

import "package:GameLib2/GameLib2.dart";
import "package:GameLib2/three.dart" as THREE;

import "../mainlogic.dart";
import "wallobject.dart";

abstract class ArenaCollider {
    THREE.Quaternion get rot;
    THREE.Vector3 get angvel;
    double get angresist;
    THREE.Vector3 get vel;
    THREE.Vector3 get pos;
    double get resistance;

    int get colwidth;
    int get colheight;

    GameLogic get game;

    THREE.Box3 getBounds();
    void setPos(THREE.Vector3 v);
    void wallImpact(THREE.Vector3 dir, bool left, bool right, bool top, bool bot, [WallObject object = null]) {

    }

    void updateWallMovement(num dt) {
        this.rot.multiply(new THREE.Quaternion.fromEuler(new THREE.Euler(this.angvel.x*dt, this.angvel.y*dt, this.angvel.z*dt)));
        this.angvel.multiplyScalar(this.angresist);

        this.vel.multiplyScalar(this.resistance);

        THREE.Vector3 movedir = this.vel.clone();

        double dx = this.pos.x + this.vel.x*dt;
        double dy = this.pos.y + this.vel.y*dt;

        double pdx = dx;
        double pdy = dy;

        double left = (this.pos.x - this.colwidth * 0.5).floorToDouble();
        double right = (this.pos.x + this.colwidth * 0.5).floorToDouble()-1;
        double top = (this.pos.y - this.colheight * 0.5).floorToDouble();
        double bottom = (this.pos.y + this.colheight * 0.5).floorToDouble()-1;

        double dleft = (pdx - this.colwidth * 0.5).floorToDouble();
        double dright = (pdx + this.colwidth * 0.5).floorToDouble()-1;
        double dtop = (pdy - this.colheight * 0.5).floorToDouble();
        double dbottom = (pdy + this.colheight * 0.5).floorToDouble()-1;

        WorldGrid grid = (this.game as MainLogic).grid;

        int lefttile = (left/grid.tilesize).floor();
        int righttile = (right/grid.tilesize).floor();
        int toptile = (top/grid.tilesize).floor();
        int bottomtile = (bottom/grid.tilesize).floor();

        int dlefttile = (dleft/grid.tilesize).floor();
        int drighttile = (dright/grid.tilesize).floor();
        int dtoptile = (dtop/grid.tilesize).floor();
        int dbottomtile = (dbottom/grid.tilesize).floor();

        bool solidleft = false;
        bool solidright = false;
        bool solidtop = false;
        bool solidbot = false;

        int solidleftpos = 0;
        int solidrightpos = 0;
        int solidtoppos = 0;
        int solidbotpos = 0;

        if(dlefttile <= lefttile) {
            for (int i = toptile; i<= bottomtile; i++) {
                TileType tile = grid.getTile(dlefttile, i);
                if(tile != null && tile.solid) {
                    solidleft = true;
                    solidleftpos = (dlefttile+1)*grid.tilesize;
                    break;
                }
            }
        }
        if (drighttile >= righttile) {
            for (int i = toptile; i<= bottomtile; i++) {
                TileType tile = grid.getTile(drighttile, i);
                if(tile != null && tile.solid) {
                    solidright = true;
                    solidrightpos = (drighttile)*grid.tilesize;
                    break;
                }
            }
        }
        if (dtoptile <= toptile) {
            for (int i = lefttile; i<= righttile; i++) {
                TileType tile = grid.getTile(i, dtoptile);
                if(tile != null && tile.solid) {
                    solidtop = true;
                    solidtoppos = (dtoptile+1)*grid.tilesize;
                    break;
                }
            }
        }
        if (dbottomtile >= bottomtile) {
            for (int i = lefttile; i<= righttile; i++) {
                TileType tile = grid.getTile(i, dbottomtile);
                if(tile != null && tile.solid) {
                    solidbot = true;
                    solidbotpos = (dbottomtile)*grid.tilesize;
                    break;
                }
            }
        }

        // collision with solid objects

        THREE.Box3 box = this.getBounds().expandByScalar(32);

        Set<Collider> inbounds = this.game.collision.queryAabb(box);
        inbounds.remove(this);

        THREE.Box3 pbounds;
        WallObject wall;
        int pxmin,pxmax,pymin,pymax;
        WallObject wallobject = null;

        for(Collider c in inbounds) {
            if (c is WallObject) {
                if (c.getDestroyed()) { continue; }
                wall = c;
                pbounds = wall.getBounds();

                pxmin = pbounds.min.x.round();
                pxmax = pbounds.max.x.round();
                pymin = pbounds.min.y.round();
                pymax = pbounds.max.y.round();

                if (pymax > top && pymin < bottom && dleft <= pxmax && dx > c.pos.x) {// && left >= pxmax) {
                    solidleft = true;
                    solidleftpos = pxmax;
                    wallobject = c;
                }

                if (pymax > top && pymin < bottom && dright >= pxmin && dx < c.pos.x) { //&& right <= pxmin) {
                    solidright = true;
                    solidrightpos = pxmin;
                    wallobject = c;
                }

                if (pxmax > left && pxmin < right && dbottom >= pymin && dy < c.pos.y) { //&& bottom <= pymin) {
                    solidbot = true;
                    solidbotpos = pymin;
                    wallobject = c;
                }

                if (pxmax > left && pxmin < right && dtop <= pymax && dy > c.pos.y) { //&& top >= pymax) {
                    solidtop = true;
                    solidtoppos = pymax;
                    wallobject = c;
                }
            }
        }

        // new position

        double newx = dx;
        double newy = dy;

        if (solidleft) {
            this.vel.x = max(0.0, this.vel.x);
            newx = max(dx, solidleftpos.toDouble() + this.colwidth*0.5);
        }
        if (solidright) {
            this.vel.x = min(0.0, this.vel.x);
            newx = min(dx, solidrightpos.toDouble() - this.colwidth*0.5);
        }

        if (solidtop) {
            this.vel.y = max(0.0, this.vel.y);
            newy = max(dy, solidtoppos.toDouble() + this.colheight*0.5);
        }

        if (solidbot) {
            this.vel.y = min(0.0, this.vel.y);
            newy = min(dy, solidbotpos.toDouble() - this.colheight*0.5);
        }

        this.setPos(new THREE.Vector3(newx,newy, this.pos.z));

        if (solidleft || solidright || solidtop || solidbot) {
            this.wallImpact(movedir, solidleft, solidright, solidtop, solidbot, wallobject);
        }
    }
}