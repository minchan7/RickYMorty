import companero.*
import summer.*
import jerry.*
import rick.*
import material.*
import experimento.*
import estrategia.*

class Humor {//clase abstracta
	
	method capacidadMaximaDeMochila() = 3
	
	method recolectar(unMaterial,unaPersona){}
}

object buenHumor inherits Humor {}

object malHumor inherits Humor {
	
	override method capacidadMaximaDeMochila() = 1
	
}

object sobreexitado inherits Humor {
	
	override method capacidadMaximaDeMochila() = super() * 2
	
	override method recolectar(unMaterial,unaPersona) {
		if(1.randomUpTo(4) == 1){
			unaPersona.elementosDeLaMochila().clear()
		}
	}
}