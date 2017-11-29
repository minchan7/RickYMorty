
import summer.*
import jerry.*
import humor.*
import rick.*
import material.*
import experimento.*
import estrategia.*

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





