extends Control

func _on_shop_pressed() -> void:
	$"../ScrollContainer".visible=false
	%InventoryGrid.visible=false
	%ShopGrid.visible=true

func _on_inventory_pressed() -> void:
	$"../ScrollContainer".visible=true
	%InventoryGrid.visible=true
	%ShopGrid.visible=false
