import companero.*//borrar archivo
import humor.*

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