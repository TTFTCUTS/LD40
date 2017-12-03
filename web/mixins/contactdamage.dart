import "package:GameLib2/three.dart" as THREE;

abstract class ContactDamage {
	int damage = 1;
	
	THREE.Vector3 getPos();
	THREE.Box3 getBounds();
}