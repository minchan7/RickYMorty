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
	
	method elementosDeLaMochila() = mochila
	
	method puedeRecolectar(unMaterial) = self.elementosDeLaMochila().size() < 3 and unMaterial.requisitoParaSerColectado(self)
	
	method recolectar(unMaterial) {
		if (! self.puedeRecolectar(unMaterial)) {
			self.error("No tengo lugar en la mochila o energia suficiente para recolectar el material")
		} 
		
		mochila.add(unMaterial)
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
	var experimentos = #{}
	var companero = morty
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	method agregarMaterial(unMaterial){
		mochila.add(unMaterial)
	}
	
	
	method  experimentosQuePuedeRealizar(){
		return experimentos.filter({experimento => experimento.requerimientoParaSerCreado(self)})
	}
	
	
	method realizar(unExperimento){
		if(!self.experimentosQuePuedeRealizar().contains(unExperimento)){
			self.error("No puedo construir el experimento")
		}
		
		unExperimento.buscarMaterial(self)
		self.mochila().removeAll(unExperimento.componentes())
		unExperimento.efecto(companero)
	}
	
	method cambiarCompanero(unCompanero){
		companero = unCompanero
	}
	
	method companero() = companero
	
	method mochila() = mochila
	

}


//-------Materiales-------//

class Material {
	
	method gramosMetal() 
	
	method energiaProducida() = 0
	
	method electricidadConducida() = 0
	
	method esRadioactivo()= false
	
	method puedeSerRecolectado(unPersonaje) = unPersonaje.energia() >= self.energiaNecesariaParaSerRecolectada()

	method energiaNecesariaParaSerRecolectada() = self.gramosMetal()
	
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
	
	override method gramosMetal() = 1 * ((longitud / 1000) * seccion)
	
	override method electricidadConducida() =  3 * seccion
	
}

class Fleeb inherits Material {
	
	const edad
	
	var materialesConsumidos = #{}
	
	constructor(_edad) {
		
		edad = _edad
	}
	
	method comerMaterial(unMaterial) {
		
		materialesConsumidos.add(unMaterial)
	}
	
	override method gramosMetal() = materialesConsumidos.sum({material => material.gramosMetal()})
	
	override method esRadioactivo() = edad > 15
	
	override method energiaProducida() = self.materialQueMasEnergiaProduzca().energiaProducida()
	
	method materialQueMasEnergiaProduzca() = materialesConsumidos.max({material => material.energiaProducida()})
	
	override method electricidadConducida() = self.materialQueMenosElectricidadConduzca().electricidadConducida()
	
	method materialQueMenosElectricidadConduzca() = materialesConsumidos.min({material => material.electricidadConducida()})

	override method energiaNecesariaParaSerRecolectada() = super() * 2
	
	override method cambioDeEnergia(unPersonaje){
		if(!self.esRadioactivo()){
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
}




//-------Experimentos-------//

class Experimento inherits Material {
	
	var componentes = #{}
	
	method componentes() = componentes
	
	
	method requerimientoParaSerCreado(unPersonaje)
	
	method efecto(unPersonaje){
		unPersonaje.agregarMaterial(self)
	}
	
	override method gramosMetal() = self.componentes().sum({material => material.gramosMetal()})
	
	method agregarMateriales(unPersonaje) {
		componentes.addAll(self.buscarMaterial(unPersonaje))
	}
	
	method buscarMaterial(unPersonaje)
}


class ConstruirBateria inherits Experimento {
	
	
	 override method requerimientoParaSerCreado(unPersonaje){
		return  unPersonaje.mochila().any({material => material.gramosMetal()>200}) 
				and unPersonaje.mochila().any({material => material.esRadioactivo()})
	}
	
	override method buscarMaterial(unPersonaje){
		return #{unPersonaje.mochila().find({material => material.gramosMetal()>200})} 
				+ #{unPersonaje.mochila().find({material => material.esRadioactivo()})}
	}
	
	override method cambioDeEnergia(unPersonaje) {
		unPersonaje.companero().disminuirEnergia(5)
	}
	
	
	
}

class Bateria inherits Material {
	
	var componentes
	
	constructor(_componentes) {
		componentes = _componentes
	}
	
	override method gramosMetal() = componentes.sum({material => material.gramosMetal()})
	
	override method energiaProducida() = self.gramosMetal() * 2
	
	override method esRadioactivo() = true
	
}

class ConstruirCircuito inherits Experimento{
	
	
	
	override method requerimientoParaSerCreado(unPersonaje) {
		return unPersonaje.mochila().any({material => material.electricidadConducida() >= 5})
	}
	
	override method buscarMaterial(unPersonaje) {
		return unPersonaje.mochila().filter({material => material.electricidadConducida() >= 5})
	}
	
	override method electricidadConducida() = self.electricidadConducidaComponentes() * 3
	
	method electricidadConducidaComponentes() = self.componentes().sum({material => material.electricidadConducida()})
	
	override method esRadioactivo() = self.componentes().any({material => material.esRadioactivo()})
}

class ConstruirShockElectrico inherits Experimento {
	
	var generador
	var conductor
	
	override method buscarMaterial(unPersonaje){
		generador = unPersonaje.mochila().find({material => material.energiaProducida() > 0})
	 	conductor = unPersonaje.mochila().find({material => material.electricidadConducida() > 0})
	}
	
	override method componentes() = #{generador,conductor} 
	
	override method efecto(unPersonaje) {
		unPersonaje.companero().aumentarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
	method()
}