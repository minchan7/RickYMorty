class Companero {
	
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
	
	method puedeRecolectar(unMaterial) = self.tieneEspacioEnMochila() and self.tieneEnergiaNecesariaParaRecolectar(unMaterial)
	
	method tieneEspacioEnMochila() = self.elementosDeLaMochila().size() < self.capacidadDeLaMochila()
	
	method tieneEnergiaNecesariaParaRecolectar(unMaterial) = self.energia() > self.energiaNecesariaParaRecolectar(unMaterial)
	
	method capacidadDeLaMochila() = 3
	
	method energiaNecesariaParaRecolectar(unMaterial) = unMaterial.energiaNecesariaParaSerRecolectado()
	
	method recolectar(unMaterial) {
		if (! self.puedeRecolectar(unMaterial)) {
			self.error("No tengo lugar en la mochila o energia suficiente para recolectar el material")
		} 
		self.elementosDeLaMochila().add(unMaterial)
		unMaterial.aplicarEfecto(self)
		
	}
	
	method darObjetosA(unCompanero){
		unCompanero.recibir(self.elementosDeLaMochila())
		self.elementosDeLaMochila().clear()
	}
	
} 

object morty inherits Companero {}

object summer inherits Companero {
	
	override method capacidadDeLaMochila() = 2
	
	override method energiaNecesariaParaRecolectar(unMaterial) = super(unMaterial) * 0.8
	
	override method darObjetosA(unCompanero){
		if(self.energia() < 10) {
			self.error("No tengo energia suficiente para darle mis materiales a mi companero")
		}
		self.disminuirEnergia(10)
		super(unCompanero)	
	}
}

object jerry inherits Companero {
	
	var humor = buenHumor
	
	
	method cambioDeHumor(_humor) {
		humor = _humor
	}
	
	override method elementosDeLaMochila() = humor.elementosDeLaMochila()
	
	override method capacidadDeLaMochila() = humor.capacidadDeLaMochila()
	
	override method recolectar(unMaterial) {
		humor.recolectar(unMaterial)
		if(unMaterial.esUnSerVivo()){
			humor = buenHumor
		}
		if(unMaterial.esRadiactivo()){
			humor = sobreexitado
		}
	}
	
	override method darObjetosA(unCompanero){
		humor.darObjetosA(unCompanero)
		humor = malHumor	
	}
		
}

class Humor inherits Companero {
	
	override method aumentarEnergia(unaCantidad) {
		jerry.aumentarEnergia(unaCantidad) 
	}
	
	override method disminuirEnergia(unaCantidad) {
		jerry.disminuirEnergia(unaCantidad)
	}
	
	override method energia() = jerry.energia()
	
	override method elementosDeLaMochila() = jerry.elementosDeLaMochila()
	
	
}

object buenHumor inherits Humor {}

object malHumor inherits Humor {
	
	override method capacidadDeLaMochila() = 1
	
}

object sobreexitado inherits Humor {
	
	override method capacidadDeLaMochila() = buenHumor*2
	
	override method recolectar(unMaterial) {
		if(1.randomUpTo(4) > 1){
			self.elementosDeLaMochila().clear()
		}
		super(unMaterial)
	}
}

object rick{
	
	var mochila = #{}
	var experimentos = #{construirBateria,construirCircuito,construirShockElectrico}
	var companero = morty
	var estrategia = alAzar
	
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
		unExperimento.materialesParaSerCreado(self.materialesSegunExperimento(unExperimento),self.estrategia())
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
	
	method cambiarEstrategia(_unaEstrategia){
		estrategia = _unaEstrategia
	}
	
	method estrategia() = estrategia
	
	method materialesSegunExperimento(experimento){
		
		return experimento.cumpleConRequisitos(self.mochila())
	}

}


//-------Materiales-------//

class Material {  // clase abstracta
	
	method gramosMetal() 
	
	method energiaProducida() = 0
	
	method electricidadConducida() = 0
	
	method esRadiactivo() = false
	
	method esUnSerVivo() = false
	
	method energiaNecesariaParaSerRecolectado() = self.gramosMetal()
	
	method aplicarEfecto(unPersonaje) {
		
		unPersonaje.disminuirEnergia(self.energiaNecesariaParaSerRecolectado())
	}
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

	override method energiaNecesariaParaSerRecolectado() = super() * 2
	
	override method esUnSerVivo() = true
	
	override method aplicarEfecto(unPersonaje){
		super(unPersonaje)
		
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

	override method esUnSerVivo() = materialBase.esUnSerVivo()
	
	override method aplicarEfecto(unPersonaje){
		
		materialBase.aplicarEfecto(unPersonaje)
	}

}


class ParasitoAlienigena inherits Material {
	
	const accionesForzadas
	
	constructor(conjuntoAcciones) {
		accionesForzadas = conjuntoAcciones
	}
	
	override method gramosMetal() = 10
	
	override method energiaProducida() = 5
	
	override method aplicarEfecto(unPersonaje) {
		
		super(unPersonaje)
		accionesForzadas.forEach({accion => accion.ejecutar(unPersonaje)})
	}
}

//--------- Acciones de los parasitos ---------//

object entregaObjetos {
	
  		method ejecutar(unPersonaje) {
		unPersonaje.darObjetosA(unPersonaje.Companero())
	}
	
}

object descartaObjeto {
	
		method ejecutar(unPersonaje) {
			
			if(!unPersonaje.mochila().isEmpty()) {
				
				unPersonaje.mochila().remove(unPersonaje.mochila().anyOne())
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
	
	var componentes = #{}
	
	method componentes() = componentes
	
	method requerimientoParaSerCreado(materiales)
	
	method efectoDeCreacion(unPersonaje)
		
	method materialesParaSerCreado(materiales,estrategia)
	
	method cumpleConRequisitos(mochila)
	
}



class CreacionDeMaterial inherits Experimento { // clase abstracta
	
	
	override method efectoDeCreacion(unPersonaje){
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
 		componentes.add(estrategia.seleccionarMaterial(self.segundoRequisito(materiales))                 
	}
	
	override method efectoDeCreacion(unPersonaje) {
		super(unPersonaje)
		unPersonaje.companero().disminuirEnergia(5)
	}
	
	override method materialConstruido() = new Bateria(self.componentes())
	
	override method cumpleConRequisitos(mochila){
		
		return self.primerRequisito(mochila) + self.segundoRequisito(mochila)
	}
	
	method primerRequisito(mochila){
		
		return mochila.filter({elemento => elemento.gramosMetal()>= 200})
	}
	
		method segundoRequisito(mochila){
		
		return mochila.filter({elemento => elemento.esRadiactivo()})
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
	
	override method cumpleConRequisitos(mochila){
		return mochila.filter({material => material.electricidadConducida() >= 5})
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
		
		unPersonaje.companero().aumentarEnergia(generador.energiaProducida() * conductor.electricidadConducida())
	}
	
	method requisitoGenerador(mochila){
		
		return mochila.filter({material => material.energiaProducida() > 0})
	}
	
		method requisitoConductor(mochila){
		
		return mochila.filter({material => material.electricidadConducida() > 0})
	}
	
	override method cumpleConRequisitos(mochila){
		
		return self.requisitoGenerador(mochila) + self.requisitoConductor(mochila)
	
	}
	
	override componentes() = #{generador, conductor}
	
	}

class Estrategia {
	
	method seleccionarMaterial(mochila)

	}
	
object alAzar inherits Estrategia{
				
	override method seleccionarMaterial(mochila) =  mochila.anyOne()
	
	}
	
object menorCantidadDeMetal inherits Estrategia{
		
	override method seleccionarMaterial(mochila) =  mochila.min({elemento => elemento.gramosMetal()})	

	}
	
object mejorGeneradorElectrico inherits Estrategia{
		
	
		
	override method seleccionarMaterial(mochila) = mochila.max({elemento => elemento.energiaProducida()})
	
	
object ecologico inherits Estrategia{
	
	
	override method seleccionarMaterial(mochila){
	
		return mochila.findOrElse({elemento => elemento.esUnSerVivo()}, {mochila.findOrDefault({elemento => !elemento.esRadiactivo()},mochila.anyOne())})
	}

	