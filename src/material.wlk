import companero.*
import summer.*
import jerry.*
import humor.*
import rick.*
import experimento.*
import estrategia.*

class Material {  // clase abstracta
	
	method gramosMetal() 
	
	method energiaProducida() = 0
	
	method electricidadConducida() = 0
	
	method esRadiactivo() = false
	
	method esUnSerVivo() = false
	
	method energiaNecesariaParaSerRecolectado() = self.gramosMetal()
	
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
	
	override method gramosMetal() = (longitud / 100) * seccion //Modificacion por enunciado(metros a centimetros es dividido por 100)
	
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

	override method energiaNecesariaParaSerRecolectado() = super()*2
	
	override method esUnSerVivo() = true
	
}

class MateriaOscura inherits Material {
	
	const materialBase
	
	constructor(_materialBase) {
		
		materialBase = _materialBase
	}
	
	override method gramosMetal() = materialBase.gramosMetal()
	
	override method electricidadConducida() = materialBase.electricidadConducida() / 2
	
	override method energiaProducida() = materialBase.energiaProducida() * 2

	override method esUnSerVivo() = materialBase.esUnSerVivo()

}


class ParasitoAlienigena inherits Material {
	
	const accionesForzadas
	
	constructor(conjuntoAcciones) {
		accionesForzadas = conjuntoAcciones
	}
	
	override method gramosMetal() = 10
	
	override method energiaProducida() = 5
	
	override method aplicarEfecto(unPersonaje) {//Modificar por correccion
		
		super(unPersonaje)
		accionesForzadas.forEach({accion => accion.ejecutar(unPersonaje)})
	}
	
	override method esUnSerVivo() = true
}

//--------- Acciones de los parasitos ---------//

object entregaObjetos {
	
  		method ejecutar(unPersonaje) {
		unPersonaje.darObjetosA(rick)
	}
	
}

object descartaObjeto {
	
		method ejecutar(unPersonaje) {
			
			if(!unPersonaje.elementosDeLaMochila().isEmpty()) {
				
				unPersonaje.elementosDeLaMochila().remove(unPersonaje.elementosDeLaMochila().anyOne())
			}		
		}
	
}

class EfectoEnergia {
	
	const porcentajeEnergia 
	
	constructor(_porcentajeEnergia) {
		
		porcentajeEnergia = _porcentajeEnergia
	}
	
	method ejecutar(unPersonaje) 
	
	method porcentajeDeEnergia(unPersonaje) = unPersonaje.energia() * porcentajeEnergia / 100 
}

class IncrementoDeEnergia inherits EfectoEnergia {
	
	override method ejecutar(unPersonaje) {
		
		unPersonaje.aumentarEnergia(self.porcentajeDeEnergia(unPersonaje))
	}
}

class DecrementoDeEnergia inherits EfectoEnergia {
	
	override method ejecutar(unPersonaje) {
		
		unPersonaje.disminuirEnergia(self.porcentajeDeEnergia(unPersonaje))
	}
}

class ElementoOculto {
	
	const elementoOculto
	
	constructor(_elementoOculto) {
		elementoOculto = _elementoOculto
	}
	
	method ejecutar(unPersonaje) {
		if(unPersonaje.puedeRecolectar(elementoOculto)) {
			
			unPersonaje.recolectar(elementoOculto)
		}
		
	}
}

//----- Materiales creados a partir de experimento-----//



class MaterialCreado inherits Material {  // clase abstracta
	
	var componentes = #{}
	
	constructor (_componentes) {
		
		componentes.addAll(_componentes)
	}
	
	method componentes() = componentes
	
	override method gramosMetal() = componentes.sum({componente => componente.gramosMetal()})

}

class Bateria inherits MaterialCreado {
	
	
	override method energiaProducida() = self.gramosMetal() * 2
	
	override method esRadiactivo() = true
}

class Circuito inherits MaterialCreado {

		
	override method electricidadConducida() = self.electricidadConducidaComponentes() * 3
	
	method electricidadConducidaComponentes() = componentes.sum({material => material.electricidadConducida()})
		
	override method esRadiactivo() = componentes.any({material => material.esRadiactivo()})	
}