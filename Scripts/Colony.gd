extends Control

var star = {"priority": [0.25, 0.25, 0.25, 0.25]}

var sliders = []


func _ready():
	#begin(null)
	var j = 0
	for slider in $Panel/Sliders.get_children():
		slider.connect("value_changed", self, "sliderChange", [j])
		j += 1
		sliders.push_back(slider)
	refresh()


func begin(star):
	visible = true
	#self.star = star
	initButtons()
	#$Panel/Info.text = star.getInfo()


func end():
	clear()


func initButtons():
	addButton("Build")
	addButton("Controlling")


func addButton(name):
	var template = $Actions/Template.duplicate()
	template.connect("button_down", self, "buttonDown", [name])
	template.get_node("Label").text = name
	template.add_to_group("button")
	template.visible = true
	$Actions.add_child(template)


func clear():
	for button in $Actions.get_children():
		if "button" in button.get_groups():
			button.queue_free()


func sliderChange(value, j):
	star.priority[j] = float(value) / 10000.0

	var sum = 0.0

	for i in range(0, len(star.priority)):
		sum += star.priority[i]

	var k = sum - 1.0

	if k != 0.0:
		var d = -k / (float(len(star.priority)) - 1.0)
		print(k)
		for i in range(0, len(star.priority)):
			if i == j:
				continue
			star.priority[i] += d

	refresh()


func refresh():
	for i in range(0, len(sliders)):
		sliders[i].value = int(star.priority[i] * 10000.0)


func buttonDown(name):
	if name == "Build":
		pass
	elif name == "Controlling":
		pass
