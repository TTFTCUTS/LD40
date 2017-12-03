import "dart:math";

import 'package:GameLib2/GameLib2.dart';
import 'package:GameLib2/three.dart' as THREE;

class SpriteObject extends MoverObject2D {
	int width;
	int height;
	
	int spriteOffsetX = 0;
	int spriteOffsetY = 0;

	THREE.Texture texture = null;
	TileSet tileset = null;

	THREE.Vector3 tint = new THREE.Vector3.all(1.0);
	
	Map<String, THREE.ShaderUniform<dynamic>> uniforms;
	
	SpriteObject(num x, num y, int this.width, int this.height) : super(x,y) {
		this.resistance = 1.0;

		THREE.makeShaderMaterial("assets/shader/basic.vert", "assets/shader/sprite.frag").then((THREE.ShaderMaterial mat) {
			mat.transparent = true;
			this.model = new THREE.Mesh(new THREE.PlaneGeometry(width.toDouble(), height.toDouble()), mat);
			if (game != null) {
				game.render.scene.add(this.model);
			}

			this.uniforms = <String, THREE.ShaderUniform<dynamic>>{
				"fLight": new THREE.ShaderUniform<double>(value: 1.0),
				"tDiffuse": new THREE.ShaderUniform<THREE.TextureBase>(value: this.texture),
				"vSprite": new THREE.ShaderUniform<THREE.Vector4>(value: new THREE.Vector4(0.0, 0.0, 1.0, 1.0)),
				"vTint": new THREE.ShaderUniform<THREE.Vector3>(value: this.tint.clone()),
				"opacity": new THREE.ShaderUniform<double>(value: 0.6),
			};

			//mat.side = THREE.DoubleSide;

			for (String name in this.uniforms.keys) {
				THREE.setUniform(mat, name, this.uniforms[name]);
			}
		});
	}

	@override
	void updateGraphics(num dt) {
		if (this.model != null) {
			double x = this.pos.x.floor().toDouble() + spriteOffsetX;
			double y = this.pos.y.floor().toDouble() + spriteOffsetY;
			
			this.model.position.set(x, y, this.pos.z);
			this.model.setRotationFromQuaternion(this.rot.clone()..multiply(new THREE.Quaternion.identity()..setFromEuler(new THREE.Euler(PI, 0.0, PI))));
			this.model.scale.copy(this.scale);

			if (this.model.material != null && this.model.material is THREE.ShaderMaterial) {
				this.updateShader(dt);
			}
		}
	}

	@override
	void updateShader(num dt) {
		THREE.ShaderMaterial m = this.model.material as THREE.ShaderMaterial;
		
		double x = 0.0, y = 0.0, z = 1.0, w = 1.0;
		if (this.tileset != null) {
			String frame = this.getFrame();
			if (frame != null && this.tileset.tiles.containsKey(frame)) {
				THREE.Box2 uv = this.tileset.tiles[frame];
				x = uv.max.x.toDouble();
				y = uv.min.y.toDouble();
				z = uv.min.x.toDouble();
				w = uv.max.y.toDouble();
			}
		}

		this.uniforms["fLight"].value = 1.0;
		this.uniforms["tDiffuse"].value = this.texture;
		(this.uniforms["vSprite"].value as THREE.Vector4).set(x, y, z, w);
		(this.uniforms["vTint"].value as THREE.Vector3).set(this.tint.x, this.tint.y, this.tint.z);

		for (String name in this.uniforms.keys) {
			THREE.setUniform(m, name, this.uniforms[name]);
		}

		m.needsUpdate = true;
	}
	
	String getFrame() {
		return null;
	}
}