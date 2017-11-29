import material.*

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