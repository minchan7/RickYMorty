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
	
	method elementosDeLaMochila() = mochila
	
	method recolectar(unMaterial) {
		if (! self.puedeRecolectar(unMaterial)) {
			self.error("No posee energia suficiente para recoger el material")
		} 
		
		mochila.add(unMaterial)
		if (unMaterial.esRadioactivo()) {
			self.disminuirEnergia(unMaterial.gramosMetal())
		}
	}
	
	method puedeRecolectar(unMaterial) = self.elementosDeLaMochila().size() < 3 and unMaterial.requisitoParaSerColectado(self)
	
	method darObjetosA(unCompanero){
		unCompanero.recibir(self.elementosDeLaMochila())
		mochila.removeAll(self.elementosDeLaMochila())
	}
}

object rick{
	
	var mochila = #{}
	var experimentos =#{}
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	
	method  experimentosQuePuedeRealizar(){
		return experimentos.filter({experimento => experimento.requerimiento(self)})
	}
	
	
	method realizar(unExperimento){
		
	}
	
	method mochila() = mochila
	

}


//-------Materiales-------//

class Material {
	
	method gramosMetal() 
	
	method energiaProducida() = 0
	
	method electricidadConducida() = 0
	
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




//-------Experimentos-------//

class Experimento inherits Material{
	
	method requerimientoParaSerCreado(unPersonaje)
	
}


class Bateria inherits Experimento {
	
	
	 override method requerimientoParaSerCreado(unPersonaje){
		return  unPersonaje.mochila().any({material => material.gramosMetal()>200}) 
				and unPersonaje.mochila().any({material => material.esRadioactivo()})
	}
	

	
	override method gramosMetal() {
		
	}
	
	 
	
}

class Circuito inherits Experimento{
	
}

class ShockElectrico inherits Experimento{
	
}