import "dart:math";

import 'package:GameLib2/GameLib2.dart';
import "package:GameLib2/three.dart" as THREE;

import "../mixins/contactdamage.dart";
import "../mixins/health.dart";
import "spriteobject.dart";

class Actor extends SpriteObject with Collider, Health {
	bool paused = false;

	int colwidth;
	int colheight;
	
	double age = 0.0;
	
	double maxhurttime = 0.75;
	double hurttime = 0.0;
	double invulntime = 0.5;
	
	bool takesContactDamage = true;

	THREE.Vector3 hurtTint = new THREE.Vector3(2.0,-0.5,-0.5);
	
	Actor(num x, num y, int width, int height, int this.colwidth, int this.colheight) : super(x,y, width, height) {
		//this.uniforms["fHurt"] = new Uniform.float(1.0);
	}

	@override
	void enterRegister(GameLogic game) {
		super.enterRegister(game);
		this.registerCollider(game);
	}

	@override
	void update(num dt) {
		if (this.paused) { return; }
		this.age += dt;
		super.update(dt);
		this.hurttime = max(0.0, this.hurttime - dt);
		this.updateCollider(dt);
	}

	@override
	THREE.Box3 getBounds() {
		return new THREE.Box3.zero()..setFromCenterAndSize(this.getPos().clone()..z = 0.0, new THREE.Vector3(this.colwidth, this.colheight, 0.02));
	}
	
	double getHurtPortion() {
		return this.hurttime / this.maxhurttime;
	}

	@override
	void hurt(int amount) {
		super.hurt(amount);
		this.hurttime = this.maxhurttime;
	}

	@override
	void updateShader(num dt) {
		super.updateShader(dt.toDouble());
		
		double add = this.getHurtPortion();
		
		(this.uniforms["vTint"].value as THREE.Vector3).set(this.tint.x + this.hurtTint.x * add, this.tint.y + this.hurtTint.y * add, this.tint.z + this.hurtTint.z * add);
		this.model.material.needsUpdate = true;
	}

	@override
	void collide(Collider other) {
		if (this.takesContactDamage && other is ContactDamage) {
			if (this.hurttime <= this.maxhurttime - this.invulntime) {
				this.hurt((other as ContactDamage).damage);
			}
			THREE.Vector2 diff = THREE.v3_xy(other.getPos())..sub(THREE.v3_xy(this.pos));
			double dot = THREE.v3_xy(this.vel).dot(diff) / diff.dot(diff);
			THREE.Vector2 proj = diff.clone()..multiplyScalar(dot);
			this.vel.x -= proj.x;
			this.vel.y -= proj.y;
			THREE.Vector2 rebound = (diff.clone()..normalize())..multiplyScalar(-400.0);
			this.vel.x += rebound.x;
            this.vel.y += rebound.y;
		}
	}
}