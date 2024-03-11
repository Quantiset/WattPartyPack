extends ControllableShip

var is_in_polygon := true

var is_raycasting := true
var raycast: RayCast2D

var trail_mod : Color

var raycasts := []


func _ready():
	super._ready()
	
	$Polygon2D2.material.set_shader_parameter("background", $SubViewport.get_texture())
	
	$FollowingLine.modulate.h += (randi() % 50) / 100.0
	
	$Polygon2D.polygon = PackedVector2Array([
		Vector2(-20,20)+position,Vector2(20,20)+position,Vector2(20,-20)+position,Vector2(-20,-20)+position
	])

func _physics_process(delta):
	super._physics_process(delta)
	var is_in_polygon_cached = Geometry2D.is_point_in_polygon(position, $Polygon2D.polygon)
	
	if is_in_polygon_cached != is_in_polygon:
		if is_in_polygon_cached and $FollowingLine.get_point_count() > 0:
			var ship_polygons = Geometry2D.offset_polygon($FollowingLine.points,5)
			if ship_polygons.size() > 0:
				var merged = Geometry2D.merge_polygons(ship_polygons[0],$Polygon2D.polygon)[0]
				
				$Polygon2D.polygon = merged
				$Polygon2D2.polygon = merged
				$FollowingLine.clear_points()
		is_in_polygon = is_in_polygon_cached
		
		if not is_in_polygon:
			$FollowingLine.add_point(position - velocity.normalized() * 4)
	
	if not is_in_polygon:
		$FollowingLine.add_point(position)
