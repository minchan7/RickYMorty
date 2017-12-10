import materialCreado.*

class Experimento { // clase abstracta
	
		
		
	method efectoDeCreacion(unPersonaje) {}
		
	method materialesUsadosParaCreacion(unosMateriales,estrategia)
	
	method cumpleRequisitoParaSerCreado(unosMateriales)
	
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
	
	override method efectoDeCreacion(unPersonaje) {
		unPersonaje.companero().modificarEnergia(-5)
		
	}
	
	method materialConstruido(unosMateriales,estrategia) = new Bateria(self.materialesUsadosParaCreacion(unosMateriales,estrategia))
	


	method primerRequisitoParaCreacion(unosMateriales){
		
		return unosMateriales.filter({elemento => elemento.gramosMetal()>= 200})
	}
	
	method segundoRequisitoParaCreacion(unosMateriales){
		
		return unosMateriales.filter({elemento => elemento.esRadiactivo()})
	}
	
	
}



object construirCircuito inherits Experimento{
	
	var press = 2
	
	override method cumpleRequisitoParaSerCreado(unosMateriales) {
		return unosMateriales.any({material => material.electricidadConducida() >= 5})
	}
	
	override method materialesUsadosParaCreacion(unosMateriales, estrategia) {
		return #{estrategia.seleccionarMaterial(unosMateriales.filter({material => material.electricidadConducida() >= 5}))}
		
	}

	method materialConstruido(unosMateriales,estrategia) = new Circuito(self.materialesUsadosParaCreacion(unosMateriales, estrategia))
	
	
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
	
	override method efectoDeCreacion(unPersonaje) {
		unPersonaje.companero().aumentarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
	method materialesRequeridosPorGenerador(unosMateriales){
		
		return unosMateriales.filter({material => material.energiaProducida() > 0})
	}
	
		method materialesRequeridosPorConductor(unosMateriales){
		
		return unosMateriales.filter({material => material.electricidadConducida() > 0})
	}
	
	
}

