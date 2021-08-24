extends TextureRect

func _ready():
	$Button.connect("button_down", self, "buttonDown")

func popup(text):
	visible = true
	$Info.text = text

func buttonDown():
	visible = false