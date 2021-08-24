extends Node

onready var journal = get_node("/root/Scene/UI/Journal") 
onready var text = journal.get_node("Info")

var toShow = ""

func _ready():
	journal.connect("gui_input", self, "guiInput")

func show():
	journal.visible = true
	text.text = "Year: " + String(Global.year) + "\n"
	text.text += toShow
	toShow = ""

	var tween = journal.get_node("Tween")
	tween.interpolate_property(journal, "rect_position:x", -journal.rect_size.x, 0.0, 0.5,Tween.TRANS_CUBIC)
	tween.start()

func guiInput(event):
	if(event is InputEventMouseButton):
		var tween = journal.get_node("Tween")
		if(tween.is_active()):
			return
		
		tween.interpolate_property(journal, "rect_position:x", 0.0, -journal.rect_size.x, 0.5,Tween.TRANS_CUBIC)
		tween.start()
		
		yield(tween, "tween_all_completed")
		journal.visible = false
