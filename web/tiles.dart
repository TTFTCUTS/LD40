import "package:GameLib2/GameLib2.dart";

abstract class Tiles {
    static void init() {

        new TileSet("arena", 512, 512)

            // base floor
            ..fixedTile("base_0", 0, 0, 32)
            ..fixedTile("base_1", 1, 0, 32)
            ..fixedTile("base_2", 2, 0, 32)
            ..fixedTile("base_3", 3, 0, 32)
            ..fixedTile("base_4", 0, 1, 32)
            ..fixedTile("base_5", 1, 1, 32)
            ..fixedTile("base_6", 2, 1, 32)
            ..fixedTile("base_7", 3, 1, 32)

            // wall
            ..fixedTile("wall_t_1", 2, 6, 32)
            ..fixedTile("wall_t_2", 3, 6, 32)
            ..fixedTile("wall_t_3", 2, 7, 32)
            ..fixedTile("wall_t_4", 3, 7, 32)

            ..fixedTile("wall_b_1", 4, 6, 32)
            ..fixedTile("wall_b_2", 5, 6, 32)
            ..fixedTile("wall_b_3", 4, 7, 32)
            ..fixedTile("wall_b_4", 5, 7, 32)

            ..fixedTile("wall_l_1", 2, 8, 32)
            ..fixedTile("wall_l_2", 3, 8, 32)
            ..fixedTile("wall_l_3", 2, 9, 32)
            ..fixedTile("wall_l_4", 3, 9, 32)

            ..fixedTile("wall_r_1", 4, 8, 32)
            ..fixedTile("wall_r_2", 5, 8, 32)
            ..fixedTile("wall_r_3", 4, 9, 32)
            ..fixedTile("wall_r_4", 5, 9, 32)
        
            ..fixedTileNumRange("wall_tl_", 1, 4, 0, 6, 32)
            ..fixedTileNumRange("wall_tr_", 1, 4, 1, 6, 32)
            ..fixedTileNumRange("wall_bl_", 1, 4, 0, 7, 32)
            ..fixedTileNumRange("wall_br_", 1, 4, 1, 7, 32)

            ..fixedTileNumRange("wall_tli_", 1, 4, 0, 8, 32)
            ..fixedTileNumRange("wall_tri_", 1, 4, 1, 8, 32)
            ..fixedTileNumRange("wall_bli_", 1, 4, 0, 9, 32)
            ..fixedTileNumRange("wall_bri_", 1, 4, 1, 9, 32)
        
            // inner wall
            ..fixedTileNumRange("innerwall_b_", 1, 3, 6, 6, 32)
            ..fixedTileNumRange("innerwall_l_", 1, 3, 7, 6, 32)
            ..fixedTileNumRange("innerwall_r_", 1, 3, 6, 7, 32)
            ..fixedTileNumRange("innerwall_t_", 1, 3, 7, 7, 32)

            ..fixedTileNumRange("innerwall_br_", 1, 3, 8, 6, 32)
            ..fixedTileNumRange("innerwall_bl_", 1, 3, 9, 6, 32)
            ..fixedTileNumRange("innerwall_tr_", 1, 3, 8, 7, 32)
            ..fixedTileNumRange("innerwall_tl_", 1, 3, 9, 7, 32)

            ..fixedTileNumRange("innerwall_tbl_", 1, 3, 9, 8, 32)
            ..fixedTileNumRange("innerwall_tlr_", 1, 3, 10, 8, 32)
            ..fixedTileNumRange("innerwall_blr_", 1, 3, 9, 9, 32)
            ..fixedTileNumRange("innerwall_tbr_", 1, 3, 10, 9, 32)

            ..fixedTileNumRange("innerwall_", 1, 3, 10, 6, 32)
            ..fixedTileNumRange("innerwall_tblr_", 1, 3, 10, 7, 32)

            ..fixedTile("innerwall_tb_1", 6, 8, 32)
            ..fixedTile("innerwall_tb_2", 6, 9, 32)
            ..fixedTile("innerwall_tb_3", 8, 8, 32)

            ..fixedTile("innerwall_lr_1", 7, 8, 32)
            ..fixedTile("innerwall_lr_2", 7, 9, 32)
            ..fixedTile("innerwall_lr_3", 8, 9, 32)

            // breakable walls
            ..fixedTile("breakwall_1", 0, 2, 32)
            ..fixedTile("breakwall_1_damage25", 1, 2, 32)
            ..fixedTile("breakwall_1_damage50", 2, 2, 32)
            ..fixedTile("breakwall_1_damage75", 3, 2, 32)
            ..fixedTile("breakwall_1_damage100", 4, 2, 32)

            ..fixedTile("breakwall_2", 0, 3, 32)
            ..fixedTile("breakwall_2_damage25", 1, 3, 32)
            ..fixedTile("breakwall_2_damage50", 2, 3, 32)
            ..fixedTile("breakwall_2_damage75", 3, 3, 32)
            ..fixedTile("breakwall_2_damage100", 4, 3, 32)

            ..fixedTile("breakwall_3", 0, 4, 32)
            ..fixedTile("breakwall_3_damage25", 1, 4, 32)
            ..fixedTile("breakwall_3_damage50", 2, 4, 32)
            ..fixedTile("breakwall_3_damage75", 3, 4, 32)
            ..fixedTile("breakwall_3_damage100", 4, 4, 32)

            ..fixedTile("breakwall_4", 0, 5, 32)
            ..fixedTile("breakwall_4_damage25", 1, 5, 32)
            ..fixedTile("breakwall_4_damage50", 2, 5, 32)
            ..fixedTile("breakwall_4_damage75", 3, 5, 32)
            ..fixedTile("breakwall_4_damage100", 4, 5, 32)

            // grates
            ..fixedTile("grate_1", 4, 0, 32)
            ..fixedTile("grate_2", 4, 1, 32)
            ..fixedTile("grate_3", 5, 0, 32)
            ..fixedTile("grate_4", 5, 1, 32)

            // stripes
            ..fixedTile("stripes_free", 4, 11, 32)
            ..fixedTile("stripes_solo", 1, 11, 32)

            ..fixedTile("stripes", 4, 11, 32)

            ..fixedTile("stripes_l", 3, 11, 32)
            ..fixedTile("stripes_r", 5, 11, 32)
            ..fixedTile("stripes_t", 4, 10, 32)
            ..fixedTile("stripes_b", 4, 12, 32)

            ..fixedTile("stripes_tl", 3, 10, 32)
            ..fixedTile("stripes_tr", 5, 10, 32)
            ..fixedTile("stripes_bl", 3, 12, 32)
            ..fixedTile("stripes_br", 5, 12, 32)

            ..fixedTile("stripes_tli", 2, 12, 32)
            ..fixedTile("stripes_tri", 0, 12, 32)
            ..fixedTile("stripes_bli", 2, 10, 32)
            ..fixedTile("stripes_bri", 0, 10, 32)
        ;

        new TileType(20, "void")..solid=true;
        new TileType(40, "base", <String>["0", "1", "2", "3", "4", "5", "6", "7"])..solid=false;
        new TileType(60, "stripes_free")..solid=false;
        new TileType(65, "stripes_solo")..solid=false;
        new TileTypeConnected(70, "stripes", connectTo: <String>["stripes_free", "void"])..solid=false;
        new TileType(90, "grate_1")..solid=false;
        new TileType(95, "grate_2")..solid=false;
        new TileType(100, "grate_3")..solid=false;
        new TileType(105, "grate_4")..solid=false;

        new TileTypeConnected(255, "wall", variants: <String>["1", "2", "3", "4"], connectTo: <String>["void"])..solid=true;
        new TileTypeConnected(200, "innerwall", variants: <String>["1", "2", "3"], track: true)..solid=true;
        new TileType(180, "breakwall", <String>["1", "2", "3", "4"])..solid=true;


        new TileSet("projectiles", 256,256)
            ..fixedTile("bullet", 0, 0, 16)
            ..fixedTile("ball_med", 1, 0, 16)
            ..fixedTile("ball_small", 0, 1, 16)
            ..fixedTile("ball_tiny", 1, 1, 16)
            ..fixedTile("bullet_enemy", 4, 0, 16)
            ..fixedTile("ball_med_enemy", 5, 0, 16)
            ..fixedTile("ball_small_enemy", 4, 1, 16)
            ..fixedTile("ball_tiny_enemy", 5, 1, 16)
            ..addTile("rocket", 32, 0, 32, 32)

            //smoke?
            ..fixedTile("smoke_1", 0, 1, 32)
            ..fixedTile("smoke_2", 1, 1, 32)
            ..fixedTile("smoke_3", 2, 1, 32)
            ..fixedTile("smoke_4", 3, 1, 32)

            ..addTile("fire", 0, 64, 32,32)
        ;

        new TileSet("objects", 512,512)
            ..addTile("car", 0, 0, 256, 128)
            ..addTile("car_refuse", 0, 128, 256, 128)
            ..addTile("car", 0, 0, 256, 128)
            ..addTile("car_refuse", 0, 128, 256, 128)
            ..addTile("barrel", 192, 256, 64, 64)
            ..addTile("barrel_refuse", 128, 256, 64, 64)
            ..addTile("explosion", 0, 384, 128,128)
        ;

        new TileSet("dude", 256,256)
            ..addTile("body", 0, 0, 128, 128)
            ..addTile("head", 128, 0, 64, 64)
            ..fixedTile("shotgun", 0, 2, 64)
            ..fixedTile("handgun", 1, 2, 64)
            ..fixedTile("mop", 2, 2, 64)
            ..fixedTile("launcher", 0, 3, 64)
            ..fixedTile("flamer", 1, 3, 64)
            ..fixedTile("minigun", 2, 3, 64)
        ;

        new TileSet("blood", 512,512)
            ..fixedTile("blood_big_1", 0, 0, 128)
            ..fixedTile("blood_big_2", 1, 0, 128)
            ..fixedTile("blood_big_3", 2, 0, 128)
            ..fixedTile("blood_big_4", 3, 0, 128)
            ..fixedTile("blood_big_5", 0, 1, 128)
            ..fixedTile("blood_big_6", 1, 1, 128)
            ..fixedTile("blood_big_7", 2, 1, 128)
            ..fixedTile("blood_small_1", 0, 8, 32)
            ..fixedTile("blood_small_2", 1, 8, 32)
            ..fixedTile("blood_small_3", 2, 8, 32)
            ..fixedTile("blood_small_4", 3, 8, 32)
        ;

    }
}