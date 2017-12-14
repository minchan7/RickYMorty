
class Celda {
	var posicion
	
	constructor(_posicion) {
		_posicion.drawElement(self)
	}
	
	method imagen() ="celda.png"
	method getPosicion() = posicion
	method setPosicion(_posicion) { posicion = _posicion }
}

class OtraCelda inherits Celda {
	override method imagen() ="otraCelda.png"
}