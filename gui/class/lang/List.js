/*
 * Esta clase simula una lista doblemente enlazada
 * El primer y ultimo elemento son comodines que se enlazan entre si
 *
 */

qx.OO.defineClass("lang.List", qx.core.Object,
function () {
	qx.core.Object.call(this);
	
	this.begin = this.new_node(null, null, null);
	this.end = this.new_node(null, null, null);
	
	this.begin.next = this.end;
	this.begin.prev = this.begin;
	
	this.end.prev = this.begin;
	this.end.next = this.end;
	
});

// El principio y el fin de la lista
qx.Proto.begin = null;
qx.Proto.end = null;

/*
 * Crea un node modificando adecuadamente el nodo siguiente
 * y el nodo anterior
 *
 */
qx.Proto.new_node = function(value, prev, next){
	var node = { prev: prev, next: next, value: value };
	
	if (next){
		next.prev = node;
	}
	if (prev){
		prev.next = node;
	}
	
	return node;
};

/*
 * Agrega un valor en la posicion position
 * si position es negativo se agregara en orden inverso
 *
 */
qx.Proto.add = function(value, position){
	if ( ! position ){ position = -1; }
	
	if (position < 0){
		var node = this.end;
		while(position < 0){
			position++;
			node = node.prev;
		}
		return this.new_node(value, node, node.next);
	}
	else{
		var node = this.begin;
		while(position > 1){
			position--;
			node = node.next;
		}
		return this.new_node(value, node, node.next);
	}
};

/*
 * Elimina un valor de la lista
 * solo sirve para valores positivos
 *
 */
qx.Proto.remove = function (position){
	if (position >= 0){
		var node = this.begin;
		while(position >= 0){
			position--;
			node = node.next;
		}
		
		node.next.prev = node.prev;
		node.prev.next = node.next;
		
		if (node.next.value){
			return node.next.value;
		}
		return node.prev.value;
	}
};

/*
 * Obtiene un elemento de la lista en la posicion
 * position
 *
 */
qx.Proto.get = function (position){
	if (position >= 0){
		var node = this.begin;
		while(position >= 0){
			position--;
			node = node.next;
		}
		return node.value;
	}
};

qx.Proto.length = function (){
	var count = 0;
	var node = this.begin.next;
	while(node != this.end){
		node = node.next;
		count++;
	}
	return count;
};


