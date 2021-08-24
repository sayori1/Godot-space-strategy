class_name Building

var name = "Building name"
var description = "Description"
var cost = 100
var star = null
var workCost = 100

var extra = [0.0, 0.0, 0.0]

func applyExtra():
	star.multipliers[0] += extra[0]
	star.multipliers[1] += extra[1]
	star.multipliers[2] += extra[2]

func _init(name, description, cost, workCost, extra):
	self.name = name
	self.description = description
	self.cost = cost
	self.workCost = workCost
	self.extra = extra
