extends Node2D

onready var tween = $Tween
export var delay = 0.5
export var bullet: PackedScene
var player
var health = 100


func start(player = true):
	self.player = player
	startIdleAnimation()
	startAttacking()
	$Collider.connect("body_entered", self, "bulletEntered")


func startAttacking():
	while true:
		yield(get_tree().create_timer(delay), "timeout")
		var target = get_parent().getNearestFor(self, player)
		if target != null:
			look_at(target.position)
			createBullet()


func createBullet():
	var temp = bullet.instance()
	temp.global_position = global_position
	temp.rotation = global_rotation + PI / 2.0
	temp.player = player
	get_parent().add_child(temp)


func startIdleAnimation():
	while true:
		tween.interpolate_property(
			self,
			"global_position:y",
			global_position.y,
			global_position.y - 10,
			2.0,
			Tween.TRANS_CUBIC
		)
		tween.interpolate_property(self, "scale:x", 1.0, 0.95, 2.0, Tween.TRANS_LINEAR)
		tween.start()

		yield(tween, "tween_all_completed")

		tween.interpolate_property(
			self,
			"global_position:y",
			global_position.y,
			global_position.y + 10,
			2.0,
			Tween.TRANS_CUBIC
		)
		tween.interpolate_property(self, "scale:x", 0.95, 1.0, 2.0, Tween.TRANS_LINEAR)
		tween.start()

		yield(tween, "tween_all_completed")


func bulletEntered(bulletArea):
	if bulletArea.get_parent().player == player:
		return
	get_parent().explodeAt(bulletArea.global_position)
	bulletArea.get_parent().queue_free()
	health -= 20
	if health <= 0:
		onDestroy()


func onDestroy():
	if(player): get_parent().playerShips.erase(self)
	else: get_parent().enemyShips.erase(self)

	get_parent().onDestroy()
	for i in range(0,2):
		get_parent().explodeAt(global_position + Vector2(rand_range(-40,40),rand_range(-40,40)), 4.0)
	queue_free()

