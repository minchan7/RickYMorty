import materialCreado.*

class Experimento { // clase abstracta
	
	var componentes = #{}//modificar por correcciones (variable)
	
	method componentes() = componentes
	
	method requerimientoParaSerCreado(materiales)
	
	method efectoDeCreacion(unPersonaje) {
		self.materialesParaSerCreado(unPersonaje.materialesSegunExperimento(self),unPersonaje.estrategia())
		unPersonaje.companero().elementosDeLaMochila().removeAll(self.componentes())
	}
		
	method materialesParaSerCreado(materiales,estrategia)
	
	method cumpleConRequisitos(materiales)
	
}



class CreacionDeMaterial inherits Experimento { // clase abstracta
	
	
	override method efectoDeCreacion(unPersonaje){
		super(unPersonaje)
		unPersonaje.agregarMaterial(self.materialConstruido())
		componentes.removeAll(self.componentes())
	}
	
	method materialConstruido()
}

object construirBateria inherits CreacionDeMaterial {
	
	
	 override method requerimientoParaSerCreado(materiales){
		return  materiales.any({material => material.gramosMetal() >= 200}) 
				and materiales.any({material => material.esRadiactivo()})
	}
	
	override method materialesParaSerCreado(materiales,estrategia){
	
		componentes.add(estrategia.seleccionarMaterial(self.primerRequisito(materiales)))                 
 		componentes.add(estrategia.seleccionarMaterial(self.segundoRequisito(materiales)))              
	}
	
	override method efectoDeCreacion(unPersonaje) {
		super(unPersonaje)
		unPersonaje.companero().disminuirEnergia(5)
	}
	
	override method materialConstruido() = new Bateria(self.componentes())
	
	override method cumpleConRequisitos(materiales){
		
		return self.primerRequisito(materiales) + self.segundoRequisito(materiales)
	}
	
	method primerRequisito(materiales){
		
		return materiales.filter({elemento => elemento.gramosMetal()>= 200})
	}
	
		method segundoRequisito(materiales){
		
		return materiales.filter({elemento => elemento.esRadiactivo()})
	}
	
	
}



object construirCircuito inherits CreacionDeMaterial{
	
	
	override method requerimientoParaSerCreado(materiales) {
		return materiales.any({material => material.electricidadConducida() >= 5})
	}
	
	override method materialesParaSerCreado(materiales, estrategia) {
		componentes.addAll(self.cumpleConRequisitos(materiales))
		
	}

	override method materialConstruido() = new Circuito(self.componentes())
	
	override method cumpleConRequisitos(materiales){
		return materiales.filter({material => material.electricidadConducida() >= 5})
	}

}

object construirShockElectrico inherits Experimento {
	
	var generador
	var conductor

	override method requerimientoParaSerCreado(materiales) {
		return materiales.any({ material => material.energiaProducida() > 0 }) 
			and materiales.any({ material => material.electricidadConducida() > 0 })
	}
	
	override method materialesParaSerCreado(materiales, estrategia){
		generador = estrategia.seleccionarMaterial(self.requisitoGenerador(materiales))
 	 	conductor = estrategia.seleccionarMaterial(self.requisitoConductor(materiales))	
	}
	
	override method efectoDeCreacion(unPersonaje) {
		super(unPersonaje)
		unPersonaje.companero().aumentarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
	method requisitoGenerador(materiales){
		
		return materiales.filter({material => material.energiaProducida() > 0})
	}
	
		method requisitoConductor(materiales){
		
		return materiales.filter({material => material.electricidadConducida() > 0})
	}
	
	override method cumpleConRequisitos(materiales){
		
		return self.requisitoGenerador(materiales) + self.requisitoConductor(materiales)
	
	}
	
	override method componentes() = #{generador, conductor}
	
	}

