
import "package:GameLib2/three.dart" as THREE;

abstract class Helpers {

    static String printVector2(THREE.Vector2 v) => "Vector2( ${v.x}, ${v.y} )";
    static String printVector3(THREE.Vector3 v) => "Vector3( ${v.x}, ${v.y}, ${v.z} )";
    static String printVector4(THREE.Vector4 v) => "Vector4( ${v.x}, ${v.y}, ${v.z}, ${v.w} )";
    static String printBox2(THREE.Box2 b) => "Box2( min: ${printVector2(b.min)}, max: ${printVector2(b.max)} )";
    static String printBox3(THREE.Box3 b) => "Box3( min: ${printVector3(b.min)}, max: ${printVector3(b.max)} )";
}