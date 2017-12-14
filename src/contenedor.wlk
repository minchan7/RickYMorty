import nivel.*
import companero.*
import rick.*




class  MochilaCompanero  {
	
	var posicionInicial =  new Position(game.width()-1, game.height()-1 )
	var posicion = posicionInicial
	
	
	method guardar(material) {
		game.addVisualIn(material,posicion.clone())
		posicion.moveDown(1)
	}
	
	method sacar(material){
		game.removeVisual(material)
	}
	
	method restablecerPosicion(){
		posicion = posicionInicial
	}
}

object mochilaRick{
	
	var posicionInicial = new Position(0, game.height()-1 )
	var posicion = posicionInicial
	
	
	method guardar(material) {
		game.addVisualIn(material,posicion.clone())
		posicion.moveDown(1)
	}
	
	method sacar(material){
		game.removeVisual(material)
	}
	
	method restablecerPosicion(){
		posicion = posicionInicial
	}
	
}

object experimentosRick {
	
	var posicionInicial =  new Position(0,0)
	var posicion = posicionInicial
	
	
	method guardar(experimento) {
		game.addVisualIn(experimento,posicion.clone())
		posicion.moveRight(1)
	}
	
	method sacar(material){
		game.removeVisual(material)
	}
	
	method restablecerPosicion(){
		posicion = posicionInicial
	}
	
}