extends Node2D


onready var A = get_node("A")
onready var B = get_node("B")
onready var Gtx = get_node("Gt")
onready var lent = get_node("Jj")
onready var focSld = get_node("focal sld")
onready var focTxt = get_node("focal sld/foc")

var W = OS.get_real_window_size().x
var H = OS.get_real_window_size().y+150
export var focal = 50
var Gt = 0

func _process(delta):
	focal = focSld.value
	if focal > 0:
		lent.get_child(0).visible = true 
		lent.get_child(1).visible = false
		focTxt.text = "f' = " + str(focal) + "  ->  L. Convergente"
	else:
		lent.get_child(0).visible = false 
		lent.get_child(1).visible = true
		focTxt.text = "f' = " + str(focal) + "  ->  L.Divergente"
	
	
	A.position.y = H/2
	if(Input.is_mouse_button_pressed(2)):
		A.position.x = get_viewport().get_mouse_position().x
		B.position = get_viewport().get_mouse_position()
		
	lent.position = Vector2(W/2, H/2)
	

	
	if Gt <= 999999970 and Gt >= 10000030 :
		Gtx.text = "Grandissement Transversale INFINIE "
	else: 
		Gtx.text = "Grandissement Transversale: " + str(Gt)
		
	update()

func ray(aa, bb, b = false, e = false):
	var ta = null
	if not bb.x-aa.x == 0:
		ta = (bb.y-aa.y) / (bb.x-aa.x)
	else:
		ta = 1000000
		
	var vA = Vector2(-W, W*(-ta)) + aa
	var vB = Vector2(+W, W*(ta)) + aa 
	
	if b:
		if e:
			return [aa,bb]
		return [aa,vB]
	else:
		if e:
			return [vA,bb]
		else:
			return [vA, vB]
	
func _draw():
	#REPERE
	draw_line(Vector2(W/2, -H*5), Vector2(W/2, H*5), Color(0,0,0), 1)
	draw_line(Vector2(-W*5, H/2), Vector2(W*5, H/2), Color(0,0,0), 1)
	# iF, F, F'
	for i in range(50):
		var grad = 3
		var Fcolor = Color(0,0,0)
		if i != 1:
			grad = 3
			Fcolor = Color(0,0,0)
		else:
			grad = 5
			Fcolor = Color(0,.4,1)
			
		draw_line(Vector2(W/2-focal*i, H/2-10), Vector2(W/2-focal*i, H/2+10), Fcolor, grad)
		draw_line(Vector2(W/2+focal*i, H/2-10), Vector2(W/2+focal*i, H/2+10), Fcolor, grad)
	
	#PASSANT PAR LE CENTRE
	var x = ray(B.position, Vector2(W/2, H/2))
	draw_line(x[0], x[1], Color(0,0,0), 1)
	
	#OBJET AB
	draw_line(A.position, B.position, Color(0,0,0), 5)
	
	# RAYON PARALLELE ENTRANT
	var xx = ray(Vector2(0, B.position.y), Vector2(W, B.position.y))
	draw_line(xx[0], xx[1], Color(0,0,0) ,1)
	#va SORTIR EN PASSANT PAR F' ou F selon Cv Dv
	
	var xxx = ray(Vector2(W/2, B.position.y), Vector2(W/2+focal, H/2))
	draw_line(xxx[0], xxx[1], Color(0,0,0) ,1)
	
	#INTERSECTION ET A'B'
	var Bp = Geometry.line_intersects_line_2d(B.position, (B.position -Vector2(W/2, H/2)), Vector2(W/2, B.position.y), Vector2(W/2, B.position.y)-Vector2(W/2+focal, H/2))
	if Bp != null:
		var Ap = Vector2(Bp.x, H/2)
		draw_line(Ap, Bp, Color(0.9, 0, 0), 4)
		if A.position.distance_to(B.position) != 0: 
			Gt = (Ap.y-Bp.y) / (A.position.y- B.position.y)
	else:
		Gt = 100000000
		
	
