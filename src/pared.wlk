
class Pared {
	var posicion
	
	constructor(_posicion) {
		_posicion.drawElement(self)
		game.whenCollideDo(self, { personaje => self.empuja(personaje) })
	}

	method imagen() = "pared.jpg"
	method getPosicion() = posicion
	method setPosicion(_posicion) { posicion = _posicion }
	method empuja(personaje)
}

class ParedArriba inherits Pared {
	constructor(_posicion) = super(_posicion)
	
	override method empuja(personaje) {
		personaje.posicion().moveDown(1)
	}
}

class ParedAbajo inherits Pared {
	constructor(_posicion) = super(_posicion)
	
	override method empuja(personaje) {
		personaje.posicion().moveUp(1)
	}
}

class ParedIzquierda inherits Pared {
	constructor(_posicion) = super(_posicion)
	
	override method empuja(personaje) {
		personaje.posicion().moveRight(1)
	}
}

class ParedDerecha inherits Pared {
	constructor(_posicion) = super(_posicion)
	
	override method empuja(personaje) {
		personaje.posicion().moveLeft(1)
	}
}