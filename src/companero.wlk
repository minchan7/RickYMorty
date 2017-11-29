import humor.*

class Companero {
	
	var energia = 100
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
	
	method tieneEspacioEnMochila() = mochila.size() < self.capacidadMaximaDeMochila()
	
	method tieneEnergiaNecesariaParaRecolectar(unMaterial) = self.energia() > self.energiaNecesariaParaRecolectar(unMaterial)
	
	method capacidadMaximaDeMochila() = 3
	
	method energiaNecesariaParaRecolectar(unMaterial) = unMaterial.energiaNecesariaParaSerRecolectado()
	
	method recolectar(unMaterial) {
		self.verificarSiPuedeRecolectar(unMaterial) 
		mochila.add(unMaterial)
		self.disminuirEnergia(self.energiaNecesariaParaRecolectar(unMaterial))
		unMaterial.aplicarEfecto(self)
	}
	
	method verificarSiPuedeRecolectar(unMaterial){//mensaje para especificar que error lanza
		self.verificarSiTengoEspacioEnMochila()
		self.verificarSiTengoEnergiaParaRecolectar(unMaterial)
	}
	
	method verificarSiTengoEspacioEnMochila(){
		if(!self.tieneEspacioEnMochila()){
			self.error("No tengo lugar en la mochila")
		}
	}
	
	method verificarSiTengoEnergiaParaRecolectar(unMaterial){
		if(!self.tieneEnergiaNecesariaParaRecolectar(unMaterial)){
			self.error("No tengo energia suficiente para recolectar el material")
		}
	}
	
	method darObjetosA(unCompanero){
		unCompanero.recibir(mochila)
		mochila.clear()
	}
	
	
	
} 

object morty inherits Companero {}


object summer inherits Companero {
	
	override method capacidadMaximaDeMochila() = 2
	
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
	
	method humor() = humor
	
	method cambioDeHumor(_humor) {
		humor = _humor
	}
	
	override method capacidadMaximaDeMochila() = humor.capacidadMaximaDeMochila()
	
	override method recolectar(unMaterial) {
		humor.recolectar(unMaterial,self)
		super(unMaterial)
		self.reaccionarAMaterial(unMaterial)
	}
	
	method reaccionarAMaterial(unMaterial){
		if(unMaterial.esUnSerVivo()){
			self.cambioDeHumor(buenHumor)
		}
		if(unMaterial.esRadiactivo()){
			self.cambioDeHumor(sobreexitado)
		}
	}
	
	override method darObjetosA(unCompanero){
		super(unCompanero)
		self.cambioDeHumor(malHumor)	
	}
		
}

