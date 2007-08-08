/*
 * Esta clase simula una lista doblemente enlazada
 * El primer y ultimo elemento son comodines que se enlazan entre si
 *
 */
qx.Class.define("lib.lang.List",
{
	extend: qx.core.Object,
	
	construct: function () {
		this.base(arguments);
		
		// Crea el primer y el ultimo elemento
		this.begin = this.new_node(null, null, null);
		this.end = this.new_node(null, null, null);
		
		/*
		 * Crea un doble enlace desde el primer elemento
		 * hacia el ultimo
		 *
		 */
		this.begin.next = this.end;
		this.begin.prev = this.begin;
		
		/*
		 * Crea un doble enlace desde el ultimo elemento
		 * hacia el primero
		 *
		 */
		this.end.prev = this.begin;
		this.end.next = this.end;
	},
	
	members:
	{
		// El principio y el fin de la lista
		begin: null,
		end: null,
		
		/*
		 * Crea un node modificando adecuadamente el nodo siguiente
		 * y el nodo anterior
		 *
		 */
		new_node: function(value, prev, next){
			var node = { prev: prev, next: next, value: value };
			
			if (next){
				next.prev = node;
			}
			if (prev){
				prev.next = node;
			}
			
			return node;
		},
		
		/*
		 * Agrega un valor a la lista
		 *
		 * value: el valor a agregar a la lista
		 * position: la posicion en donde agregar el valor, si es negativo se
		 * agregara en orden inverso
		 *
		 */
		add: function(value, position){
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
		},
		
		/*
		 * Elimina un valor de la lista
		 *
		 * position: la posicion del valor a eliminar solo sirve para
		 * posiciones positivas
		 *
		 */
		remove: function (position){
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
		},
		
		/*
		 * Obtiene un elemento de la lista
		 *
		 * position: la posicion del elemento a obtener
		 *
		 */
		get_at: function (position){
			if (position >= 0){
				var node = this.begin;
				while(position >= 0){
					position--;
					node = node.next;
				}
				return node.value;
			}
		},
		
		/*
		 * Calcula el tamaño de la lista excluyendo los
		 * comodines
		 *
		 */
		size: function (){
			var count = 0;
			var node = this.begin.next;
			while(node != this.end){
				node = node.next;
				count++;
			}
			return count;
		}
	}
});
