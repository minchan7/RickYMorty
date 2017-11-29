import companero.*//borrar archivo

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