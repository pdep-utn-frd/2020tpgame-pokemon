import wollok.game.*

object juego {

	method inicio() {
//		// Movimiento de Pj
		keyboard.a().onPressDo({ blastoise.moveteIzquierda()})
		keyboard.d().onPressDo({ blastoise.moveteDerecha()})
		keyboard.w().onPressDo({ blastoise.moveteArriba()})
		keyboard.s().onPressDo({ blastoise.moveteAbajo()})
		
		keyboard.j().onPressDo({ charizard.moveteIzquierda()})
		keyboard.k().onPressDo({ charizard.moveteAbajo()})
		keyboard.l().onPressDo({ charizard.moveteDerecha()})
    	keyboard.i().onPressDo({ charizard.moveteArriba()})
    	
			// Poderes
		keyboard.space().onPressDo({ blastoise.ataque()})
		keyboard.enter().onPressDo({ charizard.ataque()})

			// Colisiones
		game.whenCollideDo(blastoise,{habilidad => blastoise.colisionoCon(habilidad)})
		
		game.whenCollideDo(charizard,{habilidad => charizard.restarVida(habilidad) 
						   game.say(self,"mi vida actual")
						   game.say(self,charizard.vidas())
						  
		})
	}

}

object blastoise {

	var property position = game.at(1, 3)
	var property vidas = 8

	method muerto() {
		return vidas == 0
	}
	
	method restarVida(habilidad) {
	vidas = vidas - (habilidad.cuantoDanio()/10)
	}

	method image() = "blastoise.png"

	method moverL() {
		position = position.left(1)
	}

	method moverDown() {
		position = position.down(1)
	}

	method moverR() {
		position = position.right(1)
	}

	method moverUp() {
		position = position.up(1)
	}

	method moveteIzquierda() {
		if (self.position().x() > 0 and self.position().x() <= 11) 
			self.moverL()
	}

	method moveteDerecha() {
		if (self.position().x() >= 0 and self.position().x() < 11) 
			self.moverR()
	}

	method moveteArriba() {
		if (self.position().y() >= 0 and self.position().y() < 5) 
			self.moverUp()
	}

	method moveteAbajo() {
		if (self.position().y() > 0 and self.position().y() <= 6) 
			self.moverDown()
	}

	method ataque() {
		const hidrocanion = new Habilidad(nombre = "Hidro Cañon",
										  danio = 150, 
										  position = self.position(), 
										  imagen = "hidrocañon.png")
		var nombreHabilidad = hidrocanion.nombre()
		game.say(self, nombreHabilidad)
		game.addVisual(hidrocanion)
	}
	
	method colisionoCon(habilidad){
		game.say(self," mi vida actual : " + self.vidas())
		game.removeVisual(habilidad)
	}

}

object charizard {

	var property position = game.at(10, 3)
	var property vidas = 12

    method restarVida(habilidad) {
	vidas = vidas - (habilidad.cuantoDanio()/10)
	}
	method muerto() {
		return vidas == 0
	}

	method image() = "charizard2.png"

	method moverL() {
		position = position.left(1)
	}

	method moverDown() {
		position = position.down(1)
	}

	method moverR() {
		position = position.right(1)
	}

	method moverUp() {
		position = position.up(1)
	}

	method moveteIzquierda() {
		if (self.position().x() > 0 and self.position().x() <= 11) 
			self.moverL()
	}

	method moveteDerecha() {
		if (self.position().x() >= 0 and self.position().x() < 11) 
			self.moverR()
	}

	method moveteArriba() {
		if (self.position().y() >= 0 and self.position().y() < 5) 
			self.moverUp()
	}

	method moveteAbajo() {
		if (self.position().y() > 0 and self.position().y() <= 6) 
			self.moverDown()
	}

	method ataque() {
		const llamarada = new Habilidad(nombre = "Llamarada",
										danio = 110, 
										position = self.position(), 
										imagen = "llamarada.png")
		var nombreHabilidad = llamarada.nombre()
		game.say(self, nombreHabilidad)
		game.addVisual(llamarada)
	}

}

class Habilidad {

	var property nombre
	var property danio
	var property position
	var imagen

	method image() = imagen

	method cuantoDanio() {
		return danio
	}

}

//class ActualizarVista {
//
//	method quitarPokemonMuerto() {
//		if (pokemon.muerto()) {
//			game.removeVisual(pokemon)
//		}
//	}
//
//}
//class Movimiento{
//	
//	method mover(){
//	
//	}
//	
//}


// pokemon tiene variable vidas 10, un method restarvida(ataque)
// vida = vida - habilidad.daño()
// un method actualizar vista quita al pokemon muerto
//para el ataque paso posicion y pokemon que lo usa
// limitar movimiento de posiciones hasta limite de pantalla
//calcular el limite y donde estoy para, que la hablilidad sepa hasta
//donde se puede mover el ataque
