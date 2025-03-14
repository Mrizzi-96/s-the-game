class_name ItemData extends Resource

enum Type {ASS, LEFT_LEG, RIGHT_LEG, WEAPON}

@export var type : Type
@export var name : String
@export_multiline var description : String
@export var texture : Texture2D
@export var price: int
