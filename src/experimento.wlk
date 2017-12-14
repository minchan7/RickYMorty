import materialCreado.*

class Experimento { // clase abstracta
	
	var posicion = new Position(1,0)
		
	method efectoDeCreacion(unPersonaje,unosMateriales) {}
		
	method materialesUsadosParaCreacion(unosMateriales,estrategia)
	
	method cumpleRequisitoParaSerCreado(unosMateriales)
	
	method posicion() = posicion
	 
	method cambiarPosicion(_posicion){posicion = _posicion}
	
	method imagen()
}


object construirBateria inherits Experimento {
	
	var press = 1
		
	 override method cumpleRequisitoParaSerCreado(unosMateriales){
		return  unosMateriales.any({elemento => elemento.gramosMetal()>= 200}) 
				and unosMateriales.any({elemento => elemento.esRadiactivo()})
	}
	
	
	override method materialesUsadosParaCreacion(unosMateriales,estrategia){
	
		return #{estrategia.seleccionarMaterial(self.primerRequisitoParaCreacion(unosMateriales))} +
			  #{ estrategia.seleccionarMaterial(self.segundoRequisitoParaCreacion(unosMateriales))}        
 		              
	}
	
	override method efectoDeCreacion(unPersonaje,unosMateriales) {
		unPersonaje.agregarMaterial(self.materialConstruido(unosMateriales))
		unPersonaje.companero().modificarEnergia(-5)
		
	}
	
	method materialConstruido(unosMateriales) = new Bateria(unosMateriales)
	


	method primerRequisitoParaCreacion(unosMateriales){
		
		return unosMateriales.filter({elemento => elemento.gramosMetal()>= 200})
	}
	
	method segundoRequisitoParaCreacion(unosMateriales){
		
		return unosMateriales.filter({elemento => elemento.esRadiactivo()})
	}
	
	override method imagen() ="bateria.png"
	
}



object construirCircuito inherits Experimento{
	
	var press = 2
	
	override method cumpleRequisitoParaSerCreado(unosMateriales) {
		return unosMateriales.any({material => material.electricidadConducida() >= 5})
	}
	
	override method materialesUsadosParaCreacion(unosMateriales, estrategia) {
		return #{estrategia.seleccionarMaterial(unosMateriales.filter({material => material.electricidadConducida() >= 5}))}
		
	}

	method materialConstruido(unosMateriales) = new Circuito(unosMateriales)
	
	override method efectoDeCreacion(unPersonaje,unosMateriales) {
		unPersonaje.agregarMaterial(self.materialConstruido(unosMateriales))
	}
	
	override method imagen() ="circuito.png"
}

object construirShockElectrico inherits Experimento {
	
	var press = 3
	var generador
	var conductor

	override method cumpleRequisitoParaSerCreado(unosMateriales) {
		return unosMateriales.any({ material => material.energiaProducida() > 0 }) 
			and unosMateriales.any({ material => material.electricidadConducida() > 0 })
	}
	
	override method materialesUsadosParaCreacion(unosMateriales, estrategia){
		generador = estrategia.seleccionarMaterial(self.materialesRequeridosPorGenerador(unosMateriales))
 	 	conductor = estrategia.seleccionarMaterial(self.materialesRequeridosPorGenerador(unosMateriales))
 	 	return #{generador,conductor}	
	}
	
	override method efectoDeCreacion(unPersonaje,unosMateriales) {
		unPersonaje.companero().modificarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
	method materialesRequeridosPorGenerador(unosMateriales){
		
		return unosMateriales.filter({material => material.energiaProducida() > 0})
	}
	
		method materialesRequeridosPorConductor(unosMateriales){
		
		return unosMateriales.filter({material => material.electricidadConducida() > 0})
	}
	
	override method imagen() = "shockElectrico.png"
	
}

