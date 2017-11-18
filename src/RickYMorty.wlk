// TODO Dividan este archivo en partes más pequeñas porque si no es muy difícil de manejar. 
object morty {
	
	var energia = 0
	var mochila = #{}
	
	method aumentarEnergia(unaCantidad) {
		
		energia += unaCantidad
	}
	
	method disminuirEnergia(unaCantidad) {
		
		energia -= unaCantidad
	}
	
	method energiaInicial(_energia) {
		energia = _energia
	}
	
	method energia() = energia 
	
	// TODO Este método no hace básicamente nada y tampoco se usa en otros objetos, sólo
	// Internamente y en un test, me pregunto si no sería mejor sacarlo y acceder a la mochila
	// directamente.
	method elementosDeLaMochila() = mochila
	
	method puedeRecolectar(unMaterial) = self.elementosDeLaMochila().size() < 3 and unMaterial.puedeSerRecolectado(self)
	
	method recolectar(unMaterial) {
		if (! self.puedeRecolectar(unMaterial)) {
			self.error("No tengo lugar en la mochila o energia suficiente para recolectar el material")
		} 
		mochila.add(unMaterial)
		
		// TODO Estas dos responsabilidades están muy relacionadas, sería mejor unirlas en un solo método, 
		// y delegar la responsabilidad en el material.
		// También sería mejor que el material sólo me diga la energía que quita/otorga en lugar de modificar 
		// directamente la energía del personaje.
		self.disminuirEnergia(unMaterial.energiaNecesariaParaSerRecolectada())
		unMaterial.cambioDeEnergia(self)
	}
	
	method darObjetosA(unCompanero){
		unCompanero.recibir(self.elementosDeLaMochila())
		mochila.removeAll(self.elementosDeLaMochila())
	}
}

object rick{
	
	var mochila = #{}
	var experimentos = #{construirBateria,construirCircuito,construirShockElectrico}
	var companero = morty
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	method agregarMaterial(unMaterial){
		mochila.add(unMaterial)
	}
	
	method  experimentosQuePuedeRealizar() = experimentos.filter({experimento => experimento.requerimientoParaSerCreado(self.mochila())})
	
	
	method realizar(unExperimento){
		
		if(!self.experimentosQuePuedeRealizar().contains(unExperimento)){
			self.error("No puedo construir el experimento")
		}
		// TODO sería mejor que las dos lineas siguientes no existieran y todo ocurriera
		// dentro de "efectoDeCreación".
		unExperimento.materialesParaSerCreado(self.mochila())
		self.mochila().removeAll(unExperimento.componentes())
		unExperimento.efectoDeCreacion(self)
	}
	
	method cambiarCompanero(unCompanero){
		companero = unCompanero
	}
	
	method agregarExperimento(unExperimento){
		experimentos.add(unExperimento)
	}
	
	method companero() = companero
	
	method mochila() = mochila
	

}


//-------Materiales-------//

class Material {  // clase abstracta
	
	method gramosMetal() 
	
	method energiaProducida() = 0
	
	method electricidadConducida() = 0
	
	method esRadiactivo() = false
	
	method puedeSerRecolectado(unPersonaje) = unPersonaje.energia() >= self.energiaNecesariaParaSerRecolectada()

	method energiaNecesariaParaSerRecolectada() = self.gramosMetal()

	// TODO este nombre de método se podría mejorar, no es muy descriptivo
	method cambioDeEnergia(unPersonaje) {}
}

class Lata inherits Material {	
	
	var gramosMetal
	
	constructor(_gramosMetal) {
		
		gramosMetal = _gramosMetal

	}
	
	override method gramosMetal() = gramosMetal
	
	override method electricidadConducida() = 0.1 * gramosMetal
		
}

class Cable inherits Material {
	
	const longitud
	const seccion
	
	 constructor(_longitud,_seccion) {
	 	
	 	longitud = _longitud
	 	seccion = _seccion
		
	}
	
	// TODO En realidad está mal el enunciado, pero si la longitud es en metros y 
	// la sección es en centímetros, entonces hay que dividir por 100 y no por 1000.
	override method gramosMetal() = 1 * ((longitud / 1000) * seccion)
	
	override method electricidadConducida() =  3 * seccion
	
}


class Fleeb inherits Material {
	
	const edad
	
	const materialesConsumidos
	
	constructor(_edad,_materialesConsumidos) { // Fleeb debe haber consumido al menos un material	
		
		edad = _edad
		materialesConsumidos = _materialesConsumidos
	}
	
	method comerMaterial(unMaterial) {
		
		materialesConsumidos.add(unMaterial)
	}
	
	override method gramosMetal() = materialesConsumidos.sum({material => material.gramosMetal()})
	
	override method esRadiactivo() = edad > 15
	
	override method energiaProducida() = self.materialQueMasEnergiaProduzca().energiaProducida()
	
	method materialQueMasEnergiaProduzca() = materialesConsumidos.max({material => material.energiaProducida()})
	
	override method electricidadConducida() = self.materialQueMenosElectricidadConduzca().electricidadConducida()
	
	method materialQueMenosElectricidadConduzca() = materialesConsumidos.min({material => material.electricidadConducida()})

	override method energiaNecesariaParaSerRecolectada() = super() * 2
	
	override method cambioDeEnergia(unPersonaje){
		if(!self.esRadiactivo()){
			unPersonaje.aumentarEnergia(10)
		}
	}
}

class MateriaOscura inherits Material {
	
	const materialBase
	
	constructor(_materialBase) {
		
		materialBase = _materialBase
	}
	
	override method gramosMetal() = materialBase.gramosMetal()
	
	override method electricidadConducida() = materialBase.electricidadConducida() / 2
	
	override method energiaProducida() = materialBase.energiaProducida() * 2

	override method cambioDeEnergia(unPersonaje){
		materialBase.cambioDeEnergia(unPersonaje)
	}

}

//----- Materiales creados a partir de experimento-----//


// TODO Sería mejor MaterialCreado, todas las demás clases están en singular.
class MaterialesCreados inherits Material {  // clase abstracta
	var componentes = #{}
	
	constructor (_componentes) {
		
		componentes.addAll(_componentes)
	}
	
	method componentes() = componentes
	
	override method gramosMetal() = self.componentes().sum({componente => componente.gramosMetal()})

}

class Bateria inherits MaterialesCreados {
	
	
	override method energiaProducida() = self.gramosMetal() * 2
	
	override method esRadiactivo() = true
}

class Circuito inherits MaterialesCreados {

		
	override method electricidadConducida() = self.electricidadConducidaComponentes() * 3
	
	method electricidadConducidaComponentes() = self.componentes().sum({material => material.electricidadConducida()})
		
	override method esRadiactivo() = self.componentes().any({material => material.esRadiactivo()})	
}



//-------Experimentos-------//

class Experimento { // clase abstracta
	
	
	method requerimientoParaSerCreado(materiales)
	
	method efectoDeCreacion(unPersonaje)
		
	method materialesParaSerCreado(materiales)
	
}



class CreacionDeMaterial inherits Experimento { // clase abstracta	
	// Si bien entiendo las motivaciones para poner esta variable, creo que finalmente termina
	// no siendo una buena idea, complica varias cosas.
	// Por un lado los experimentos ahora tienen estado y eso obliga a "resetearlos"
	// luego de usarlos (ver #1)
	// Por otro lado, hay un manejo de esta variable distribuido en varias clases (ver #2).
	// Y finalmente obliga a que rick tenga mucho conocimiento 
	// sobre la ejecución del experimento (ver #3).
	var componentes = #{}
	
	method componentes() = componentes
	
	override method efectoDeCreacion(unPersonaje){
		unPersonaje.agregarMaterial(self.materialConstruido())
		// TODO Referencia #1
		componentes.removeAll(self.componentes())
	}
	
	method materialConstruido()
}


object construirBateria inherits CreacionDeMaterial {
	
	
	 override method requerimientoParaSerCreado(materiales){
		return  materiales.any({material => material.gramosMetal() >= 200}) 
				and materiales.any({material => material.esRadiactivo()})
	}
	
	override method materialesParaSerCreado(materiales){
		// TODO Referencia #2
		componentes.add(materiales.find({material => material.gramosMetal() >= 200})) 
		componentes.add(materiales.find({material => material.esRadiactivo()}))
	}
	
	override method efectoDeCreacion(unPersonaje) {
		super(unPersonaje)
		unPersonaje.companero().disminuirEnergia(5)
	}
	
	override method materialConstruido() = new Bateria(self.componentes())
	
}



object construirCircuito inherits CreacionDeMaterial{
	
	
	override method requerimientoParaSerCreado(materiales) {
		return materiales.any({material => material.electricidadConducida() >= 5})
	}
	
	override method materialesParaSerCreado(materiales) {
		componentes.addAll(materiales.filter({material => material.electricidadConducida() >= 5}))
	}

	override method materialConstruido() = new Circuito(self.componentes())

}

object construirShockElectrico inherits Experimento {	
	var generador
	var conductor

	override method requerimientoParaSerCreado(materiales) {
		return materiales.any({ material => material.energiaProducida() > 0 }) 
			and materiales.any({ material => material.electricidadConducida() > 0 })
	}
	
	override method materialesParaSerCreado(materiales){
		
		generador = materiales.find({material => material.energiaProducida() > 0})
	 	conductor = materiales.find({material => material.electricidadConducida() > 0})
	 	
	}
	
	
	override method efectoDeCreacion(unPersonaje) {
		
		unPersonaje.companero().aumentarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
}
