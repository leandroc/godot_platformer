extends Node2D

class_name CommonPlatform

signal body_entered(body, this);
signal thorn_visibility(body, is_visible);

export(bool) var thorn_visible: bool = false;

func _physics_process(_delta: float) -> void:
  $PlatformThorns.visible = thorn_visible;

func _on_Area2D_body_entered(body):
  emit_signal('body_entered', body, self)

func _on_PlatformThorns_thorn_visibility(body, is_visible):
  emit_signal('thorn_visibility', body, is_visible)
