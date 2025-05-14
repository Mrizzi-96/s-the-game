extends Control



func _on_shop_pressed() -> void:
	%InventoryGrid.visible=false
	%ShopGrid.visible=true

func _on_inventory_pressed() -> void:
	%InventoryGrid.visible=true
	%ShopGrid.visible=false
