##State_Machine 1.0.0 

extends Node
class_name StateMachine


# Nodo encargado de administrar la State_Machine
@onready var controlador = self.owner
@onready var state = get_node (initial_state)
##Estado Inicial por defecto.
##Permite seleccionar la ruta del estado
@export_node_path('Node') var initial_state

#Obtiene el nodo para trabajar con èl 
#State que se esta ejecutando 


##DEBUG
@export var DEBUG : bool = true
##Si el valor es true , imprime en consola el historial de Estados
@export var PRINT_HISTORY : bool = false 
var initialized = false
#Historial de Estados seleccioandos
var history : Array [String] 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Espera que los nodos esten listos antes de ejecutar el metodo
	call_deferred("_enter_state")
	pass # Replace with function body.

func _enter_state():
	if DEBUG:
		print (controlador.name, ": Entrando en estado :", state.name)
	
	state.player = controlador
	state.state_machine = self
	state.enter()
	initialized = true 
	
	##Crea la comunicación entre los Nodos de la Maquina
func change_to (new_state):
	
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()
	if PRINT_HISTORY :
		print(history)


func _process(delta: float) -> void:
	if state.has_method("process"):
		state.process(delta)
	

func _physics_process(delta: float) -> void:
	if initialized && state.has_method("physics_process"):
		
		state.physics_process(delta)
		
		
func _input(event:InputEvent) -> void:
	if state.has_method("input"):
		state.input(event)

	
