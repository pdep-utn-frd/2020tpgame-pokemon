import wollok.game.*


const blastoise = new Pokemon(position = game.at(1, 3), vidas = 8,nombre = "blastoise", imagen = "blastoise.png")

const charizard = new Pokemon(position = game.at(10, 3), vidas = 12,nombre = "charizard", imagen = "charizard2.png")

object juego {

	method inicio() {
		// Movimiento de Pj
		keyboard.a().onPressDo({ movimiento.moveteIzquierda(blastoise)})
		keyboard.d().onPressDo({ movimiento.moveteDerecha(blastoise)})
		keyboard.w().onPressDo({ movimiento.moveteArriba(blastoise)})
		keyboard.s().onPressDo({ movimiento.moveteAbajo(blastoise)})
		keyboard.j().onPressDo({ movimiento.moveteIzquierda(charizard)})
		keyboard.k().onPressDo({ movimiento.moveteAbajo(charizard)})
		keyboard.l().onPressDo({ movimiento.moveteDerecha(charizard)})
		keyboard.i().onPressDo({ movimiento.moveteArriba(charizard)})
			// Poderes
		keyboard.space().onPressDo({ blastoise.ataque()})
		keyboard.enter().onPressDo({ charizard.ataque()})
			// Colisiones
		game.whenCollideDo(blastoise, { objeto => blastoise.colisionarCon(objeto)})
		game.whenCollideDo(charizard, { objeto => charizard.colisionarCon(objeto)})
         // Musica
		const musicaPokemon = game.sound("Musica.mp3")
		game.schedule(100, { musicaPokemon.play()})
		musicaPokemon.volume(0.5)
				
	}

}

class Pokemon {

	var property position
	var property vidas
	var property nombre
	var imagen
	
	//arreglar la definicion de ataque y colision (borre const ataque =  nueva Habilidad ()
	//colisión const =  nuevas Colisiones ()  )
	
	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 100)
	}

	method sosPokemon() {
		return true
	}

	method sosUnAtaque() {
		return false
	}

	method image() = imagen
	
	method miAtaque(){
		if (self.nombre()=="blastoise"){
			const hidrocanion = new Habilidad(nombre = "Hidrocanion", danio = 150, position = blastoise.position(), imagen = "hidrocañon.png")
			return hidrocanion
		}
		else {
			const llamarada = new Habilidad(nombre = "Llamarada", danio = 110, position = charizard.position(), imagen = "llamarada.png")
			return llamarada
		}
	}

 	method colisionarCon(objeto){
 	  const colision = new Colisiones(pokemon = self)
 	  colision.colisionar(objeto)
 }
//	method colisionPokemon(pokemon) {
//		const colision = new Colisiones(pokemon = self)
//		colision.colisionar(self, pokemon)
//	}

//	method colisionAtaque(habilidad) {
//		const colision = new Colisiones()
//		colision.colisionar(habilidad, self)
//	}

	method ataque() {
		const ataque = self.miAtaque()
		game.say(self, ataque.nombre())
		game.addVisual(ataque) 
		ataque.movete12(self)
		game.whenCollideDo(ataque, { ataque2 => ataque.colision(ataque2, ataque)})
		game.onTick(500, "movimientoAtaque", { ataque.moverAtaque(self)})
	}

}

class Colisiones {
    const pokemon = new Pokemon()
    
	method colisionoConAtaque(objeto) {
		if (pokemon.vidas() <= 0) {
			// game.say(charizard, "Murio Blastoise")
			const ganador = game.sound("Winner.mp3")
			ganador.play()
			game.removeVisual(pokemon)
			game.removeVisual(objeto)
		} else {
			pokemon.restarVida(objeto)
			game.say(pokemon, " mi vida actual : " + pokemon.vidas().toString().toString())
			game.removeVisual(objeto)
		}
	}

	method colisionoConPokemon(objeto) {
		if (pokemon.nombre() == "blastoise") {
			game.onCollideDo(pokemon, { obj => obj.position(pokemon.position().x() + 1)})
		} else {
			game.onCollideDo(pokemon, { obj => obj.position(pokemon.position().x() - 1)})
		}
	}

	method colisionar(objeto) {
		if (objeto.sosPokemon()) {
			self.colisionoConPokemon(objeto)
		}
		if (objeto.sosUnAtaque()) {
			self.colisionoConAtaque(objeto)
		} else {
		}
	}

}

class Habilidad {

	var property nombre
	var property danio
	var property position
	var imagen

	method image() = imagen

	method sosPokemon() {
		return false
	}

	method sosUnAtaque() {
		return true
	}

	method colision(habilidad1, habilidad2) {
		const explosion1 = new Explosion()
		explosion1.position(habilidad1.position())
		game.addVisual(explosion1)
		game.removeVisual(habilidad2)
		game.removeVisual(habilidad1)
		game.schedule(300, {=> game.removeVisual(explosion1)})
	}

	method movete12(pokemon){
		if (pokemon.nombre()=="blastoise"){
			self.movete1(pokemon)
		}
		else{
			self.movete2(pokemon)
		}
	}
	method movete1(pokemon) {
		const x = pokemon.position().x() + 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}

	method movete2(pokemon) {
		const x = pokemon.position().x() - 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}

	method moverAtaque(pokemon) {
		var direccion = 0
		if (pokemon.nombre()=="blastoise") {
			direccion = 1
		} else {
			direccion = -1
		}
		const x = self.position().x() + direccion
		const y = self.position().y()
		position = game.at(x, y)
	}

}

class Explosion {

	var property position = game.center()

	method image() = "Explosion.png"

}

object movimiento {

	method moverL(objeto) {
		objeto.position(objeto.position().left(1))
	}

	method moverDown(objeto) {
		objeto.position(objeto.position().down(1))
	}

	method moverR(objeto) {
		objeto.position(objeto.position().right(1))
	}

	method moverUp(objeto) {
		objeto.position(objeto.position().up(1))
	}

	method moveteIzquierda(objeto) {
		if (objeto.position().x() > 0 and objeto.position().x() <= 11) self.moverL(objeto)
	}

	method moveteDerecha(objeto) {
		if (objeto.position().x() >= 0 and objeto.position().x() < 11) self.moverR(objeto)
	}

	method moveteArriba(objeto) {
		if (objeto.position().y() >= 0 and objeto.position().y() < 5) self.moverUp(objeto)
	}

	method moveteAbajo(objeto) {
		if (objeto.position().y() > 0 and objeto.position().y() <= 6) self.moverDown(objeto)
	}

}

