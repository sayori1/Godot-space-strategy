extends Control

signal popupDone(info)
var chosed = []  #stores only IDs


func _ready():
	$Button.connect("button_down", self, "buttonDown")
	$Close.connect("button_down", self, "close")


func clear():
	chosed = []
	for button in $Ships.get_children():
		if button.name == "Template":
			continue
		button.queue_free()


func init(ships):
	clear()

	visible = true
	var id = 0
	for ship in ships:
		var template = $Ships/Template.duplicate()
		template.visible = true
		template.text = ship.shipName
		template.icon = ship.icon
		template.connect("toggled", self, "chosed", [id])
		$Ships.add_child(template)
		id += 1


func buttonDown():
	emit_signal("popupDone", chosed)
	visible = false


func chosed(state, id):
	if state:
		chosed.push_back(id)
	else:
		chosed.erase(id)


func close():
	emit_signal("popupDone", [])
	visible = false
