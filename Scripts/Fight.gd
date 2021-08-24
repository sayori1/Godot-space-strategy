extends Control

signal fightEnded(result)

var currentShip = null  #ghost ship for placing actual ship

var playerShipsModels = []
var enemyShipsModels = []

var enemyFraction

#Actual playerShips
var playerShips = []

var enemyShips = []
var enemyCount = 10

export var explosion: PackedScene


func _ready():
	""" start(
		Global.fractions[5],
		[Global.ships[0], Global.ships[1], Global.ships[2]],
		Global.fractions[1],
		Global.ships
	) """


#calls when we star fighting
func start(enemyFraction, enemyCount = 10, enemyShipsModels = [], playerShipsModels = []):
	visible = true


	#creating buttons on the bottom with ship icons for selecting them
	for ship in playerShipsModels:
		var temp = $Ships/Template.duplicate()
		temp.get_node("Icon").texture_normal = ship.icon
		temp.get_node("Label").text = ship.shipName
		temp.visible = true
		temp.get_node("Icon").connect("button_down", self, "shipSelected", [ship, temp])
		$Ships.add_child(temp)

	self.playerShipsModels = playerShipsModels
	self.enemyShipsModels = enemyShipsModels
	self.enemyFraction = enemyFraction
	self.enemyCount = enemyCount

	AI()


#calls when we select a ship on the panel
func shipSelected(ship, button):
	var ghost = ship.instance.instance()
	ghost.modulate.a = 0.5
	add_child(ghost)
	currentShip = ghost
	playerShips.append(ghost)

	button.queue_free()


func _process(delta):
	#if we selected ship on the bottom
	if currentShip != null:
		currentShip.global_position = get_global_mouse_position()
		if Input.is_action_just_released("ui_click") and currentShip != null:
			currentShip.modulate.a = 1.0
			if currentShip.has_method("start"):
				currentShip.start()
			currentShip = null


func getNearestFor(ship, player = true):
	var minD = 1000.0
	var node = null
	if player:
		for i in enemyShips:
			if i == null or ship == null:
				return
			if i.position.distance_to(ship.position) < minD:
				minD = i.position.distance_to(ship.position)
				node = i
	else:
		for i in playerShips:
			if i.position.distance_to(ship.position) < minD:
				minD = i.position.distance_to(ship.position)
				node = i

	return node


func AI():
	while enemyCount > 0:
		enemyCount -= 1

		var temp = enemyShipsModels[randi() % 4].instance.instance()
		add_child(temp)

		temp.global_position.x = randi() % int(get_viewport_rect().size.x)
		temp.global_position.y = randi() % int(get_viewport_rect().size.y / 2)
		temp.rotation += PI

		temp.start(false)
		enemyShips.push_back(temp)

		yield(get_tree().create_timer(4.0), "timeout")


func explodeAt(pos, scale = 1.0):
	var temp = explosion.instance()

	temp.scale = Vector2(scale, scale)

	temp.position = pos
	add_child(temp)


func onDestroy():
	var info = {}

	if len(playerShips) == 0 and enemyCount == 0:
		Global.alert.popup("Draw!")
		info["whoWon"] = "draw"
	elif len(playerShips) == 0:
		Global.alert.popup("Enemy won!")
		info["whoWon"] = "enemy"
	elif enemyCount == 0:
		Global.alert.popup("Player won!")
		info["whoWon"] = "player"

	yield(get_tree().create_timer(2.0), "timeout")

	if info != {}:
		info["playerShips"] = playerShipsModels
		emit_signal("fightEnded", info)
