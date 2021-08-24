extends Node


func _ready():
	randomize()
	turnButton.connect("button_down", self, "yearPass")


##STAR
var starNames = ["Aldebaran", "Mira", "Vea"]
var playerStarChosed = false

##Fraction
var fractionPossibility = [0.5, 0.5, 0.05, 0.05, 0.05, 0.0]
var fractions = [
	null,
	Fraction.new("LOD"),
	Fraction.new("LOW"),
	Fraction.new("LOB"),
	Fraction.new("Marsians"),
	Fraction.new("People")
]

##Ships
var ships = [Ship.new("Scout", preload("res://Images/Ships/Scout.png"), preload("res://Prefabs/Ships/Scout.tscn")),
Ship.new("Pegas", preload("res://Images/Ships/Pegas.png"), preload("res://Prefabs/Ships/Pegas.tscn")),
Ship.new("Linkor", preload("res://Images/Ships/Linkor.png"), preload("res://Prefabs/Ships/Linkor.tscn")),
Ship.new("Kreiser", preload("res://Images/Ships/Kreiser.png"), preload("res://Prefabs/Ships/Kreiser.tscn"))
]


##References
onready var panel = get_node("/root/Scene/UI/StarInfo")
onready var actions = get_node("/root/Scene/UI/Actions")
onready var turnButton = get_node("/root/Scene/UI/Actions/TurnButton")
onready var infoLabel = get_node("/root/Scene/UI/Info")
onready var popup = get_node("/root/Scene/UI/Popup")
onready var alert = get_node("/root/Scene/UI/Popup/Alert")
onready var fight = get_node("/root/Scene/UI/Fight")
onready var colony = get_node("/root/Scene/UI/Colony")

##State
signal yearPass
signal starChosed(star)

var year = 1000


func yearPass():
	year += 1
	emit_signal("yearPass")
	Journal.show()

