extends Node2D

class_name Platform

export(String, "Right", "Left") var position_x = "Left"
var new_transform: Vector2 = Vector2.ZERO;

func _ready():
  new_transform.x = GlobalVariables.PLATFORM_LEFT_X if (position_x == 'Left') else GlobalVariables.PLATFORM_RIGHT_X;
  new_transform.y = self.position.y;

  self.position = new_transform;
