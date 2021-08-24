extends Node2D

export var speed = 2.0
var player = true

func _process(delta):
	position += Vector2.UP.rotated(rotation)
