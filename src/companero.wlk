import contenedor.*
import humor.*
import wollok.game.*


class Companero {
	
	var energia = 100
	var mochila = []
	var posicion = new Position(5,5)
	var contenedorVisuales = new MochilaCompanero()
	
	method posicion() = posicion
	 
	method cambiarPosicion(_posicion){posicion = _posicion}
	
	method imagen() 
		
	method modificarEnergia(unaCantidad) {
		
		energia += unaCantidad
	}
	
	method energiaInicial(_energia) {
		energia = _energia
	}
	
	method energia() = energia 
	
	method elementosDeLaMochila() = mochila
	
	method puedeRecolectar(unMaterial) = self.tieneEspacioEnMochila() and self.tieneEnergiaNecesariaParaRecolectar(unMaterial)
	
	method tieneEspacioEnMochila() = mochila.size() < self.capacidadMaximaDeMochila()
	
	method tieneEnergiaNecesariaParaRecolectar(unMaterial) = self.energia() > unMaterial.energiaNecesariaParaSerRecolectado()
	
	method capacidadMaximaDeMochila() = 3
	
	method energiaNecesariaParaRecolectar(unMaterial) = unMaterial.energiaNecesariaParaSerRecolectado()
	
	method recolectar(unMaterial) {
		if(!self.tieneEspacioEnMochila() || !self.tieneEnergiaNecesariaParaRecolectar(unMaterial)){
			self.verificarSiPuedeRecolectar(unMaterial)
		}
			 
		else {
			mochila.add(unMaterial)
			unMaterial.efectoPorRecoleccion(self)
			contenedorVisuales.guardar(unMaterial)
		}
			
			
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
		mochila.forEach{material => contenedorVisuales.sacar(material)}
		contenedorVisuales.restablecerPosicion()
		mochila.clear()
	}
	
	
	
} 

object morty inherits Companero {
	override method imagen() = "morty.jpeg"
}


object summer inherits Companero {
	
	override method imagen() = "summer.jpeg"
	
	override method capacidadMaximaDeMochila() = 2
	
	override method energiaNecesariaParaRecolectar(unMaterial) = super(unMaterial) * 0.8
	
	override method darObjetosA(unCompanero){
		if(self.energia() < 10) {
			self.error("No tengo energia suficiente para darle mis materiales a mi companero")
		}
		else self.modificarEnergia(-10)
		super(unCompanero)	
	}
}

object jerry inherits Companero {
	
	var humor = buenHumor
	
	override method imagen() = "jerry.jpeg"
	
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


