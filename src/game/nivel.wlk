import wollok.game.*
import pared.*
import companero.*
import rick.*
import materialesBasicos.*
import experimento.*

object nivel {

	method configurate(_largo,_ancho){
	//	CONFIGURACION	
		game.title("RickYMorty")
		game.height(_largo)
		game.width(_ancho)
		game.ground("suelo.jpg")
		morty.energiaInicial(2000)
		
	//	VISUALES
	 	const materialesBasicos = [lata,fleeb,cable,materiaOscura,parasitoAlienigena]//ConjuntoDeMaterialesBasicos
	 	
	 	materialesBasicos.forEach{materiales => self.random(_largo-2,_ancho-2).drawElement(materiales)} 
	 	new Position(1,1).drawElement(rick)
		game.addVisualCharacter(morty)
	
	// ACCIONES
		
		materialesBasicos.forEach({material => game.whenCollideDo(material,{personaje =>
												if(rick.companero() == personaje) personaje.recolectar(material)})})	
		
		game.whenCollideDo(rick, { companero => if(rick.companero() == companero ) companero.darObjetosA(rick) })
		E.onPressDo{game.say(rick, "" + rick.experimentosQuePuedeRealizar()) }
		M.onPressDo{game.say(rick,"" + rick.mochila())
					game.say(morty,"" + morty.elementosDeLaMochila())}
		
		NUM_1.onPressDo{rick.realizar(construirBateria)}
		NUM_2.onPressDo{rick.realizar(construirCircuito)}
		NUM_3.onPressDo{rick.realizar(construirShockElectrico)}
		
		
		//	PARED
		const ancho = game.width() - 1
		const largo = game.height() - 1
	
		(1 .. ancho-1).forEach { n => new ParedAbajo(new Position(n, 0)) } // BordeAbajo
		(1 .. ancho-1).forEach { n => new ParedArriba(new Position(n, largo)) } // BordeArriba 
		(0 .. largo).forEach { n => new ParedIzquierda(new Position(0, n)) } // BordeIzq 
		(0 .. largo).forEach { n => new ParedDerecha(new Position(ancho, n)) } // BordeDer
	}
	
	/*method experimentosARealizar(unNumero){
		rick.realizar(rick.experimentosQuePuedeRealizar().get(unNumero))
	}*/
	
	method random(largo,ancho) = new Position(1.randomUpTo(largo),1.randomUpTo(ancho)) 

}