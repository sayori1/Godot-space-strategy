class_name Ship

var shipName = ""
var icon = null

var instance = null

func _init(shipName, icon = null, instance = null):
	self.shipName = shipName
	self.icon = icon
	self.instance = instance
