object morty {
	
	var energia = 0
	var mochila = #{}
	
	method aumentarEnergia(unaCantidad) {
		
		energia += unaCantidad
	}
	
	method disminuirEnergia(unaCantidad) {
		
		energia -= unaCantidad
	}
	
	method energia() = energia 
	
	method elementos() = mochila
	
	method recolectar(unMaterial) {
		if (! self.puedeRecolectar(unMaterial)) {
			self.error("No posee energia suficiente para recoger el material")
		} 
		
		mochila.add(unMaterial)
		if (unMaterial.esRadioactivo()) {
			self.disminuirEnergia(unMaterial.gramosMetal())
		}
	}
	
	method puedeRecolectar(unMaterial) = unMaterial.requisitoParaSerColectado(self)
	
	method darObjetosA(unCompanero){
		unCompanero.recibir(self.elementos())
	}
}


//-------Materiales-------//

class Material {
	
	method gramosMetal() 
	
	method energiaProducida() = 0
	
	method electricidadConducida()
	
	method esRadioactivo()= false
	
	method requisitoParaSerColectado(unPersonaje) = unPersonaje.energia() > self.gramosMetal()
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
	
	override method energiaProducida() = materialesConsumidos.max({material => material.energiaProducida()}).energiaProducida()
	
	override method electricidadConducida() = materialesConsumidos.min({material => material.electricidadConducida()}).electricidadConducida()
	
	override method requisitoParaSerColectado(unPersonaje) = unPersonaje.energia() / 2 > self.gramosMetal()
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


object rick{
	
	var mochila = #{}
	var experimentos =#{}
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	
	method  experimentosQuePuedeRealizar(){
		
	}
	
	
	
	method realizar(unExperimento){
		
	}
	
	method mochila() = mochila
	
	/**  Para realizar un experimento se cumplen los siguientes pasos:
○ Se buscan los materiales necesarios de la mochila de Rick
○ Se remueven los materiales de la mochila de Rick.
○ Se aplica el efecto del experimento, por ejemplo si se trata de la construcción de la
batería, se debe agregar una nueva batería a la mochila de Rick, pero si se trata de un
shock eléctrico se debe incrementar la energía del compañero de Rick.*/
}

class Experimento inherits Material{
	
	method requerimientoParaConstruirse(unPersonaje)
}

class Bateria inherits Experimento {
	
	
	 override method requerimientoParaConstruirse(unPersonaje){
		return  unPersonaje.mochila().any({material=> material.gramosMetal()>200}) 
				and unPersonaje.mochila().any({material => material.esRadioactivo()})
	}
	
	method 
	
}

class Circuito inherits Experimento{
	
}

class ShockElectrico inherits Experimento{
	
}