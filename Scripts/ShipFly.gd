extends Sprite

class_name ShipFly

var target = null
var from = null

var ships = []
var time = 0

onready var startTime = Global.year


func _init(target, from, ships = [], time = 0):
	self.target = target
	self.from = from
	self.ships = ships
	self.time = time


func _ready():
	Global.connect('yearPass', self, "yearPass")

	var line = Line2D.new()
	line.add_point(from.global_position)
	line.add_point(target.global_position)

	add_child(line)


func yearPass():
	if (Global.year - startTime) >= time:
		target.onShipsArrived(self)
		queue_free()
