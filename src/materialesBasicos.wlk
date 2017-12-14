import material.*
import accionesForzadas.*
import nivel.*

object lata inherits Lata(5) {
	 
	 method imagen() = "lata.png"
	 
}

object cable inherits Cable(50,50){
	 method imagen() = "cable.png"
}

object fleeb inherits Fleeb(20,#{otroCable}){
	 method imagen() = "fleeb.png"
}

object materiaOscura inherits MateriaOscura(otraLata){
	 method imagen() = "materiaOscura.png"
}

object parasitoAlienigena inherits ParasitoAlienigena(#{new IncrementoDeEnergia(20)}) {
	 method imagen() = "parasitoAlienigena.jpeg"
}

object otroCable inherits Cable(50,50){
	 method imagen() = "cable.png"
}


object otraLata inherits Lata(400) {
	 method imagen() = "lata.png"
}
