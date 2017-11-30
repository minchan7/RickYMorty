import materialCreado.*

class Experimento { // clase abstracta
	
	var materiales = #{}
	
	method requerimientoParaSerCreado(unosMateriales)
	
	method efectoDeCreacion(unPersonaje) {
		self.materialesParaSerCreado(unPersonaje.materialesSegunExperimento(self),unPersonaje.estrategia())
		unPersonaje.mochila().removeAll(materiales)
	}
		
	method materialesParaSerCreado(unosMateriales,estrategia)
	
	method cumpleConRequisitos(unosMateriales)
	
}



class CreacionDeMaterial inherits Experimento { // clase abstracta
	
	
	override method efectoDeCreacion(unPersonaje){
		super(unPersonaje)
		unPersonaje.agregarMaterial(self.materialConstruido())
		
	}
	
	method materialConstruido()
}

object construirBateria inherits CreacionDeMaterial {
	
	
	 override method requerimientoParaSerCreado(unosMateriales){
		return  unosMateriales.any({material => material.gramosMetal() >= 200}) 
				and unosMateriales.any({material => material.esRadiactivo()})
	}
	
	override method materialesParaSerCreado(unosMateriales,estrategia){
	
		materiales = #{(estrategia.seleccionarMaterial(self.primerRequisito(unosMateriales))),
			(estrategia.seleccionarMaterial(self.segundoRequisito(unosMateriales)))}               
 		              
	}
	
	override method efectoDeCreacion(unPersonaje) {
		super(unPersonaje)
		unPersonaje.companero().modificarEnergia(-5)
	}
	
	override method materialConstruido() = new Bateria(materiales)
	
	override method cumpleConRequisitos(unosMateriales){
		
		return self.primerRequisito(unosMateriales) + self.segundoRequisito(unosMateriales)
	}
	
	method primerRequisito(unosMateriales){
		
		return unosMateriales.filter({elemento => elemento.gramosMetal()>= 200})
	}
	
		method segundoRequisito(unosMateriales){
		
		return unosMateriales.filter({elemento => elemento.esRadiactivo()})
	}
	
	
}



object construirCircuito inherits CreacionDeMaterial{
	
	
	override method requerimientoParaSerCreado(unosMateriales) {
		return unosMateriales.any({material => material.electricidadConducida() >= 5})
	}
	
	override method materialesParaSerCreado(unosMateriales, estrategia) {
		materiales = self.cumpleConRequisitos(unosMateriales)
		
	}

	override method materialConstruido() = new Circuito(materiales)
	
	override method cumpleConRequisitos(unosMateriales){
		return unosMateriales.filter({material => material.electricidadConducida() >= 5})
	}

}

object construirShockElectrico inherits Experimento {
	
	var generador
	var conductor

	override method requerimientoParaSerCreado(unosMateriales) {
		return unosMateriales.any({ material => material.energiaProducida() > 0 }) 
			and unosMateriales.any({ material => material.electricidadConducida() > 0 })
	}
	
	override method materialesParaSerCreado(unosMateriales, estrategia){
		generador = estrategia.seleccionarMaterial(self.requisitoGenerador(unosMateriales))
 	 	conductor = estrategia.seleccionarMaterial(self.requisitoConductor(unosMateriales))
 	 	materiales = #{generador,conductor}	
	}
	
	override method efectoDeCreacion(unPersonaje) {
		super(unPersonaje)
		unPersonaje.companero().aumentarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
	method requisitoGenerador(unosMateriales){
		
		return unosMateriales.filter({material => material.energiaProducida() > 0})
	}
	
		method requisitoConductor(unosMateriales){
		
		return unosMateriales.filter({material => material.electricidadConducida() > 0})
	}
	
	override method cumpleConRequisitos(unosMateriales){
		
		return self.requisitoGenerador(unosMateriales) + self.requisitoConductor(unosMateriales)
	
	}
	
	}

