import "dart:math";

abstract class Health {
	int maxhealth = 10;
	int health = 10;
	
	void addHealth(int amount) {
		this.health = (health + amount).clamp(0, maxhealth);
		if (this.health == 0) {
			this.kill();
		}
	}
	
	void heal(int amount) {
		this.addHealth(max(0,amount));
	}
	
	void hurt(int amount) {
		this.addHealth(min(0, -amount));
	}
	
	void kill() {
		this.onDeath();
		this.destroy();
	}
	
	void onDeath() {}
	void destroy();
	
	void setMaxHealth(int amount) {
		this.maxhealth = amount;
		this.health = amount;
	}
}