extends RigidBody

#Remember the state so we can return it when the player drops the object
onready var original_parent = get_parent()
var original_collision_mask
var original_collision_layer

#Who picked us up?
var picked_up_by = null

#Being picked up
func pick_up(by):
	if picked_up_by == by:
		return
	
	if picked_up_by:
		let_go()
	
	#Remembering who picked us up
	picked_up_by = by
	
	#Turn off the physics of our pickable object
	mode = RigidBody.MODE_STATIC
	collision_layer = 0
	collision_mask = 0
	
	#Reparent
	original_parent.remove_child(self)
	picked_up_by.add_child(self)
	
	#Reset our transform
	transform = Transform()

#Letting go
func let_go(impulse = Vector3(0.0, 0.0, 0.0)):
	if picked_up_by:
		#Get current global transform
		var t = global_transform
		
		#Reparent
		picked_up_by.remove_child(self)
		original_parent.add_child(self)
		
		#Reposition and apply impulse
		global_transform = t
		mode = RigidBody.MODE_RIGID
		collision_mask = original_collision_mask
		collision_layer = original_collision_layer
		apply_impulse(Vector3(0.0, 0.0, 0.0), impulse)
		
		#No longer picked up
		picked_up_by = null

func _ready():
	original_collision_mask = collision_mask
	original_collision_layer = collision_layer












