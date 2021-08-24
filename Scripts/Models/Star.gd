class_name Star

var starName = "Star name"
var fraction = null
var currentPopulation = 0
onready var maxPopulation = 60000000 + randi() % 6000000000

var buildings = []
var ships = []
var richness = 1.0

var priority = [0.2,0.2,0.2,0.2]
var multipliers = [1.0, 1.0, 1.0]


func initRandom():
	starName = Utils.getRandom(Global.starNames)
	fraction = Utils.getRandomExact(Global.fractionPossibility, Global.fractions)
	if fraction != null:
		currentPopulation = 20 + randi() % 100


func getInfo():
	var info = starName + "\n"
	info = (
		info
		+ "Fraction: "
		+ ("Unpopulated" if fraction == null else fraction.fractionName)
		+ "\n"
	)
	info += "Population: " + renderCount(currentPopulation) + " beings" + "\n"
	info += "Richness: " + String(richness)
	return info


func onYearPass():
	currentPopulation = int(float(currentPopulation) * priority[0] * 4.0)
	#currentPopulation = wrapi(currentPopulation, 0, maxPopulation)


static func renderCount(count):
	if count > 1000 and count < 1000000:
		return String(count / 1000) + " K"
	elif count > 1000000:
		return String(count / 1000000) + " M"
	return String(count)
