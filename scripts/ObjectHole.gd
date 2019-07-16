extends Node2D

export (NodePath) var npc_path
var npc
func _ready():
	if npc_path:
		print(npc_path)
		npc = get_node(npc_path)
		npc.connect('dimension_changed', self, '_on_NPC_dimension_changed')

func _on_NPC_dimension_changed():
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.get_parent() == npc:
			queue_free()
	
#func _on_Area2D_body_entered(body):
#	var parent = body.get_parent()
#	if parent == npc and npc.is_alive:

