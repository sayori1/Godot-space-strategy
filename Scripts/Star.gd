extends Sprite

var selected = false setget setSelected
var star

onready var speed = rand_range(0.0, 0.5)


func _ready():
	for child in get_children():
		if child.name[0] == "P":
			child.rotation = rand_range(-3.14, 3.14)
			child.texture = load("res://Images/Planets/" + String(1 + randi() % 21) + ".png")
	self_modulate = Color(rand_range(0.5, 1.0), rand_range(0.5, 1.0), rand_range(0.5, 1.0), 1.0)
	var k = rand_range(scale.x, scale.x + 2.0)
	scale = Vector2(k,k)

	$TargetArea.connect("input_event", self, "inputEvent")
	Global.connect("yearPass", self, "onYearPass")

	star = Star.new()
	star.initRandom()

	#if player doesn't have a star
	if not Global.playerStarChosed:
		star.fraction = Global.fractions[5]
		Global.playerStarChosed = true
		star.currentPopulation = 20 + randi() % 100

		#for test
		star.ships.push_back(Global.ships[0])
		star.ships.push_back(Global.ships[1])
		star.ships.push_back(Global.ships[2])

		print(star.ships)


func setSelected(newValue):
	selected = newValue
	$Selected.visible = selected
	if selected:
		Global.emit_signal("starChosed", self)


func _process(delta):
	for child in get_children():
		if child.name[0] != "P":
			continue
		child.rotation += speed * delta


func loseFocus():
	self.selected = false
	Global.panel.visible = false
	for child in Global.actions.get_children():
		if "action" in child.get_groups():
			child.queue_free()


func setFocus():
	self.selected = ! self.selected
	Global.panel.visible = self.selected
	if self.selected:
		showInfo()
	addActions()


#calls when we click on the star
func inputEvent(node, event, id):
	if event is InputEventMouseButton and event.pressed:
		setFocus()


func showInfo():
	Global.panel.get_node("Info").text = star.getInfo()


#calls when we click on anything except the star
func _input(event):
	if selected and event is InputEventMouseButton and event.pressed:
		loseFocus()


func onYearPass():
	star.onYearPass()


func addAction(name):
	var template = Global.actions.get_node("Template").duplicate()
	template.connect("button_down", self, "actionDown", [name])
	template.get_node("Label").text = name
	template.visible = true
	template.add_to_group("action")
	Global.actions.add_child(template)
	print('create')


func addActions():
	if star.fraction == null:
		if len(star.ships) != 0:
			addAction("Colonize")
			addAction("Fleet")
	elif star.fraction.fractionName == "People":
		addAction("Get info")
		addAction("Colony")
		addAction("Fleet")
	else:
		pass


func actionDown(action):
	if action == "Fleet":
		Global.popup.get_node("Fleet").init(star.ships)
		var info = yield(Global.popup.get_node("Fleet"), "popupDone")

		print(info, star.ships)

		if len(info) == 0:
			return

		Global.infoLabel.text = "Choose star to go"
		var starChosed

		while true:
			starChosed = yield(Global, "starChosed")

			if starChosed == self:
				Global.infoLabel.text = "Choose another star"
			else:
				break

		var chosedShips = []
		for i in info:
			chosedShips.push_back(star.ships[0])
			star.ships.remove(0)

		var shipFly = ShipFly.new(starChosed, self, chosedShips, 10)
		get_parent().add_child(shipFly)

		Global.infoLabel.text = ""

	elif action == "Colonize":
		star.currentPopulation = 20 + randi() % 200
		star.fraction = Global.fractions[5]
		Global.alert.popup("Wait you are going to colonize this star???")
	elif action == "Colony":
		Global.colony.begin(self)

	
func onShipsArrived(fleet):
	Journal.toShow += "Ships arrived to the star \n"

	if fleet.target.star.fraction == null:
		(star.ships as Array).append_array(fleet.ships)
	elif fleet.target.star.fraction.fractionName == "People":
		(star.ships as Array).append_array(fleet.ships)
	else:
		Global.fight.start(star.fraction, 1, Global.ships, fleet.ships)
		var info = yield(Global.fight, "fightEnded")
		Global.fight.visible = false
		if info.whoWon == "enemy" or info.whoWon == "draw":
			pass
		if info.whoWon == "player":
			star.ships = info.playerShips
			star.fraction = Global.fractions[5]
