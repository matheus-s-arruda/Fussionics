@tool
extends GraphEdit

const GRAPH_RESOURCE =  preload("res://addons/cognite/cognite_source.gd")

enum PortTypes {
	VARIANT = 99, # 8835ff
	ANALISYS = 0, # d2fff0
	DECISION = 40,# ffe671
	ARRAY = 56,   # d95400
	INT = 87,     # ff3030
}
const GRAPH_NODES := [
	preload("res://addons/cognite/interface/decision.tscn"),
	preload("res://addons/cognite/interface/decompose.tscn"),
	preload("res://addons/cognite/interface/loop.tscn"),
	preload("res://addons/cognite/interface/condition.tscn"),
	preload("res://addons/cognite/interface/best_match.tscn"),
	preload("res://addons/cognite/interface/directive.tscn"),
]
const GRAPH_NAMES := [
	"Decision", "Decompose", "Loop", "Condition", "Best_Match", "Directive"
]

var nodes: Array[GraphNode]
var current_resource
var is_ready: bool

@onready var select_graphnode = $HBoxContainer/select_graphnode
@onready var chipset_selection = $modus/chipset_selection


func _ready():
	add_valid_connection_type(99, 40)
	add_valid_connection_type(99, 56)
	add_valid_connection_type(99, 87)
	add_valid_connection_type(0, 99)
	add_valid_connection_type(40, 99)
	add_valid_connection_type(56, 99)
	add_valid_connection_type(87, 99)
	
	if current_resource:
		apply_resource()
	
	else:
		current_resource = GRAPH_RESOURCE.new()
	
	is_ready = true


func load_resource(resource):
	if is_ready and current_resource and current_resource != resource:
		clear_connections()
		
		for node in nodes:
			if is_instance_valid(node):
				node.queue_free()
		nodes.clear()
	
	current_resource = resource
	
	if is_ready:
		apply_resource()


func apply_resource():
	var links: Array
	
	chipset_selection.selected = current_resource.chipset_selection
	
	for node in current_resource.graph_nodes:
		var pack: Dictionary = current_resource.graph_nodes[node]
		var graph_node: GraphNode = create_graph(pack.type, node)
		
		for prop in pack.properties:
			graph_node.set(prop, pack.properties[prop])
		
		links.append_array(pack.connections)
	
	for connections in links:
		connect_node(connections[0], connections[1], connections[2], connections[3])


func create_graph(type: int, _name: String):
	select_graphnode.selected = 0
	
	var graph_node: GraphNode = GRAPH_NODES[type].instantiate()
	graph_node.position_offset = Vector2(500, 300)
	graph_node.graph_resource = current_resource
	graph_node.name = _name
	
	nodes.append(graph_node)
	add_child(graph_node)
	return graph_node


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	current_resource.graph_nodes[from_node].connections.append([from_node, from_port, to_node, to_port])
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	current_resource.graph_nodes[from_node].connections.erase([from_node, from_port, to_node, to_port])
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_select_graphnode_item_selected(index):
	var _name = GRAPH_NAMES[index - 1] + str(current_resource.get_hash())
	var graph_node: GraphNode = create_graph(index - 1, _name)
	current_resource.append_node(_name, index - 1)
	print(_name)


func _on_chipset_selection_item_selected(index):
	current_resource.chipset_selection = index
