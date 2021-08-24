class_name Utils

static func getRandom(choice: Array):
	var id = randi() % len(choice)
	return choice[id]

static func getRandomExact(possibility: Array, choice: Array):
	var a = rand_range(0, 1.0)
	var acc = 0.0
	for i in range(0, len(choice)):
		if a >= acc and a <= acc + possibility[i]:
			return choice[i]
		acc += possibility[i]
