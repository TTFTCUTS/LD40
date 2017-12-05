
import 'package:GameLib2/GameLib2.dart';
import "package:GameLib2/three.dart" as THREE;

import 'objects/enemy.dart';
import 'objects/environmentobject.dart';
import 'objects/refuse.dart';


class Room {
    static List<Room> rooms = <Room>[];

    final int roomx;
    final int roomy;

    int minx;
    int maxx;
    int miny;
    int maxy;

    List<Enemy> enemies = <Enemy>[];
    List<Refuse> refuse = <Refuse>[];
    List<EnvironmentObject> envobjects = <EnvironmentObject>[];

    bool active = false;

    Room(int this.roomx, int this.roomy) {
        rooms.add(this);

        int roomsize = 32 * 25;

        this.minx = roomx * roomsize;
        this.maxx = (roomx+1) * roomsize;
        this.miny = roomy * roomsize;
        this.maxy = (roomy+1) * roomsize;
    }

    void activate() {
        this.active = true;
        switchObjects();
    }

    void deactivate() {
        this.active = false;
        switchObjects();
    }

    void switchObjects() {
        for (Enemy e in enemies) {
            e.paused = !this.active;
        }
        for (Refuse r in refuse) {
            r.paused = !this.active;
        }
        for (EnvironmentObject e in envobjects) {
            e.paused = !this.active;
        }
    }

    static Room getRoomForCoords(double x, double y) {
        for (Room r in rooms) {
            if (x >= r.minx && x <= r.maxx && y >= r.miny && y <= r.maxy) {
                return r;
            }
        }
        return null;
    }

    static Room getRoomForObject(RoomObject o) {
        return getRoomForCoords(o.pos.x, o.pos.y);
    }

    static void addToRoom(RoomObject o) {
        Room r = getRoomForObject(o);
        if (r == null) { return; }

        List<dynamic> list = r.getListForObject(o);
        if (list != null) {
            list.add(o);
            o.room = r;
            o.paused = !r.active;
        }
    }

    void removeFromRoom(RoomObject o) {
        List<dynamic> list = this.getListForObject(o);
        if (list != null) {
            list.remove(o);
            o.paused = false;
        }
    }

    List<dynamic> getListForObject(RoomObject o) {
        if (o is Refuse) {
            return this.refuse;
        } else if (o is EnvironmentObject) {
            return this.envobjects;
        } else if (o is Enemy) {
            return this.enemies;
        }
        return null;
    }

    int getTotalScore() {
        int total = 0;
        for (Enemy e in enemies) {
            total += e.score;
        }
        for(EnvironmentObject e in envobjects) {
            total += e.score;
        }
        return total;
    }

    void removeEnemies() {
        for (Enemy e in enemies) {
            e.destroy();
        }
    }
}

abstract class RoomObject {
    Room room;

    THREE.Vector3 get pos;

    bool get paused;
    void set paused(bool val);

    void addToRoom() {
        if (this.room == null) {
            Room.addToRoom(this);
        }
    }

    void removeFromRoom() {
        if (this.room != null) {
            room.removeFromRoom(this);
        }
    }
}