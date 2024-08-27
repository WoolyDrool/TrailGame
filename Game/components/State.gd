extends Node
class_name State

signal transitioned

func enter():
	print("entered ", self.name)
	pass

func exit():
	print("exited ", self.name)
	pass

func update(_delta : float):
	pass

func phys_update(_delta : float):
	pass

