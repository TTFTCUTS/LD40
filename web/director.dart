import "dart:async";
import "dart:html";
import "dart:math";
import 'dart:web_audio';

import 'objects/refuse.dart';
import "package:GameLib2/GameLib2.dart";

import 'mainlogic.dart';
import 'objects/wallobject.dart';
import 'room.dart';
import 'weapons/weapon.dart';

class Director {
    Random rand = new Random();
    MainLogic game;

    Room room1;
    Room room2;
    Room room3;
    Room room4;
    Room room5;
    List<Room> phaserooms;
    List<List<Blockerwall>> phasedoors;
    List<Blockerwall> janitordoor;
    List<int> phasescores;

    List<List<Blockerwall>> advancementdoors = <List<Blockerwall>>[];

    Room janitorRoom ;

    int score = 0;
    double totalfilth = 0.0;
    double filthfraction = 0.0;

    int phase = 0;

    double timer = 180.0;
    bool called60 = false;
    bool called30 = false;

    AudioBufferSourceNode music;

    Announcer announcer = new Announcer();

    Director(MainLogic this.game) {
        room1 = new Room(0, 4);
        room2 = new Room(0, 3);
        room3 = new Room(0, 2);
        room4 = new Room(0, 1);
        room5 = new Room(0, 0);
        phaserooms = <Room>[room1, room2, room3, room4, room5];

        janitorRoom = new Room(1, 4);

        activateRoom(room1);
    }

    void activateRoom(Room room) {
        for (Room r in Room.rooms) {
            if (r == room) {
                r.activate();
            } else {
                r.deactivate();
            }
        }
        game.moveCameraToRoom(room.roomx, room.roomy);
    }

    void update(num dt) {
        checkRoomAdvancement();

        if (phase < 5) {
            timer = max(0.0, timer - dt);

            if (timer <= 0) {
                phase = 5;
                endOfShooty();
            }
        } else if (phase == 6) {
            timer = max(0.0, timer - dt);

            if (this.totalfilth <= 0.0) {
                this.filthfraction = 0.0;
            } else {
                double filth = this.tallyFilth();
                this.filthfraction = filth / totalfilth;
            }

            if (timer <= 0 || this.filthfraction == 0.0) {
                phase = 7;
                endOfJanitor();
            }
        }

        if (phase < 5 || phase == 6) {
            if (timer <= 60.0 && !called60) {
                called60 = true;
                announcer.play("oneminuteremains", "HOST: Only a minute to go!");
            }
            if (timer <= 30.0 && !called30) {
                called30 = true;
                announcer.play("30secondsremain", "HOST: 'Alf a minute to go!");
            }
        }
    }

    double tallyFilth() {
        double filth = 0.0;
        for (Room r in Room.rooms) {
            for (Refuse ref in r.refuse) {
                filth += ref.filth;
            }
        }
        return filth;
    }

    Future<Null> startOfShooty() async {
        this.music = await Audio.play("combattheme", "music")..loop=true;
    }

    Future<Null> deathInShooty() async {
        game.allowControl = false;
        game.paused = true;

        this.music.stop(0);

        announcer.play("whatamess", "HOST: Ey by... what a mess!");
        querySelector("#death").style.display = "block";
        querySelector("#deathscore").text = this.score.toString();

        this.music = await Audio.play("45secSynthSax", "music")..loop = true;
    }

    Future<Null> endOfShooty() async {
        game.allowControl = false;
        game.paused = true;

        querySelector("#round2").style.display = "block";
        querySelector("#round2score").text = this.score.toString();

        for(Room r in Room.rooms) {
            r.removeEnemies();
        }

        announcer.play("skegness", "HOST: You've won a luxury weekend away - to Skegness!");

        new Future<Null>.delayed(new Duration(seconds: 6), () {
            announcer.play("whatamess", "HOST: Ey by... what a mess...");
        });
        this.totalfilth = this.tallyFilth();

        new Future<Null>.delayed(new Duration(seconds: 9), () {
            Element cont = querySelector("#continue");
            cont..style.display = "inline-block";
            announcer.play("goandcleanup", "HOST: Now... get out there and clean it up!");

            cont.onClick.listen((MouseEvent e){
                startOfJanitor();
            });
        });

        game.player.destroy();
        game.player = game.janitor;
    }

    Future<Null> startOfJanitor() async {
        timer = 180.0;
        called30 = false;
        game.allowControl = true;
        game.paused = false;
        this.phase = 6;

        this.music.stop(0);
        this.music = await Audio.play("Janitor", "music")..loop=true;

        this.janitorRoom.activate();


        querySelector("#filthbox").style.display = "block";
        querySelector("#round2").style.display = "none";

        /*for (List<Blockerwall> door in this.phasedoors) {
            if (door == null) { continue; }
            for (Blockerwall b in door) {
                b.destroy();
            }
        }
        for (Blockerwall b in this.janitordoor) {
            b.destroy();
        }*/
        for (GameObject o in game.objects) {
            if (o is Blockerwall) {
                o.destroy();
            }
        }
        makeMainDoor(12, 125);
    }

    Future<Null> endOfJanitor() async {
        game.allowControl = false;
        game.paused = true;

        //this.music.stop(0);

        querySelector("#round3score").text = this.score.toString();
        querySelector("#round3filth").text = "${(this.filthfraction * 100.0).floor()}%";
        querySelector("#round3final").text = "x${(1.0 - this.filthfraction).toStringAsFixed(2)} = ${(this.score * (1.0-this.filthfraction)).round()}";
        querySelector("#finalscore").style.display = "block";

        if (this.filthfraction > 0.5) {
            announcer.play("elbowgrease", "HOST: Come on... put some elbow grease into it!");
        } else {
            announcer.play("fantastic", "HOST: Fantastic!");
        }
    }

    void checkRoomAdvancement() {
        if (game.player == null) { return; }
        Room room = Room.getRoomForCoords(game.player.pos.x, game.player.pos.y);
        if (phase < 5) {
            int roomphase = phaserooms.indexOf(room);
            if (roomphase > phase) {
                phase = roomphase;
                for (int i=0; i<phase; i++) {
                    phaserooms[i].removeEnemies();
                }
                game.player.pos.y -= 64;
                activateRoom(room);

                advancementdoors.add(makeMainDoor(12, (5 - phase) * 25));
            }

            //if (score > phasescores[phase] && (phase >= 4 || phasedoors[phase] != null)) {
            if (phase < 4 && phaserooms[phase].enemies.isEmpty && phasedoors[phase] != null) {
                List<Blockerwall> door = phasedoors[phase];
                phasedoors[phase] = null;
                
                for (Blockerwall wall in door) {
                    wall.kill();
                }
                
                int y = (4-phase) * 25*32;
                new RocketExplosion(400, y, true, 5.0, 0.0)..register(game);
            }
        } else {
            if (room != null) {
                activateRoom(room);
            }
        }
        
        
    }

    void levelsetup() {
        this.phasedoors = <List<Blockerwall>>[];
        this.phasescores = <int>[];

        makeMainDoor(12, 125);

        this.phasedoors.add(makeMainDoor(12, 100));
        this.phasedoors.add(makeMainDoor(12, 75));
        this.phasedoors.add(makeMainDoor(12, 50));
        this.phasedoors.add(makeMainDoor(12, 25));

        this.janitordoor = makeJanitorDoor(24, 108);

        for (int i=0; i<phaserooms.length; i++) {
            Room r = phaserooms[i];
            int total = r.getTotalScore();
            if (i > 0) {
                total += phasescores[i-1];
            }
            phasescores.add(total);
        }
    }

    List<Blockerwall> makeMainDoor(int x, int y) {
        List<Blockerwall> door = <Blockerwall>[];

        door.add(new Blockerwall(x-1, y, game.grid)..register(game));
        door.add(new Blockerwall(x, y, game.grid)..register(game));
        door.add(new Blockerwall(x+1, y, game.grid)..register(game));
        door.add(new Blockerwall(x-1, y-1, game.grid)..register(game));
        door.add(new Blockerwall(x, y-1, game.grid)..register(game));
        door.add(new Blockerwall(x+1, y-1, game.grid)..register(game));

        return door;
    }

    List<Blockerwall> makeJanitorDoor(int x, int y) {
        List<Blockerwall> door = <Blockerwall>[];

        door.add(new Blockerwall(x, y, game.grid)..register(game));
        door.add(new Blockerwall(x, y+1, game.grid)..register(game));
        door.add(new Blockerwall(x+1, y+1, game.grid)..register(game));
        door.add(new Blockerwall(x+1, y, game.grid)..register(game));
        
        return door;
    }
}

class Announcer {
    double talking = 0.0;

    List<String> queue = <String>[];
    List<String> subs = <String>[];

    Future<Null> update(num dt) async {
        if (talking > 0.0) {
            talking = max(0.0, talking - dt);
        } else {
            if (!queue.isEmpty) {
                String todo = queue.removeAt(0);
                String sub = subs.removeAt(0);
                AudioBufferSourceNode node = await Audio.play(todo, "voice", subtitle: sub);
                this.talking += node.buffer.duration + 0.5;
            }
        }
    }

    void play(String sound, String subtitle) {
        this.queue.add(sound);
        this.subs.add(subtitle);
    }
}