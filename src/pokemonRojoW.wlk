import wollok.game.*

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
		game.whenCollideDo(blastoise, { objeto => blastoise.colisionar(objeto)})
		game.whenCollideDo(charizard, { objeto => charizard.colisionar(objeto)})
         // Musica
		const musicaPokemon = game.sound("Musica.mp3")
		game.schedule(100, { musicaPokemon.play()})
		musicaPokemon.volume(0.5)
		
		
	}

}

const blastoise = new Pokemon(position = game.at(1, 3), vidas = 8, imagen = "blastoise.png", ataque = new Habilidad(nombre = "Hidrocanion", danio = 150, position = blastoise.position(), imagen = "hidrocañon.png"))

const charizard = new Pokemon(position = game.at(10, 3), vidas = 12, imagen = "charizard2.png", ataque = new Habilidad(nombre = "Llamarada", danio = 110, position = charizard.position(), imagen = "llamarada.png"))

class Pokemon {

	var property position
	var property vidas
	var imagen
	const ataque = new Habilidad()
	const colision = new Colisiones()

	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 100)
	}

	method esBlastoise() {
		return true
	}

	method sosPokemon() {
		return true
	}

	method sosUnAtaque() {
		return false
	}

	method image() = imagen

	method colisionPokemon(pokemon) {
		colision.colisionar(self, pokemon)
	}

	method colisionAtaque(habilidad) {
		colision.colisionar(habilidad, self)
	}

	method ataque() {
		game.say(self, ataque.nombre())
		game.addVisual(ataque)
		ataque.movete1(self)
		game.whenCollideDo(ataque, { ataque2 => ataque.colision(ataque2, ataque)})
		game.onTick(500, "movimientoAtaque", { ataque.moverAtaque(self)})
	}

}

class Colisiones {

	method colisionoConAtaque(ataque, pokemon) {
		if (pokemon.vidas() <= 0) {
			// game.say(charizard, "Murio Blastoise")
			// const ganador = game.sound("Winner.mp3")
			// ganador.play()
			game.removeVisual(pokemon)
			game.removeVisual(ataque)
		} else {
			pokemon.restarVida(ataque)
			game.say(pokemon, " mi vida actual : " + pokemon.vidas())
			game.removeVisual(ataque)
		}
	}

	method colisionoConPokemon(pokemon) {
		if (pokemon.esBlastoise()) {
			game.onCollideDo(pokemon, { pokemon2 => pokemon2.position(pokemon.position().x() + 1)})
		} else {
			game.onCollideDo(pokemon, { pokemon1 => pokemon1.position(pokemon.position().x() - 1)})
		}
	}

	method colisionar(objeto, objeto2) {
		if (objeto.sosPokemon()) {
			self.colisionoConPokemon(objeto)
		}
		if (objeto.sosUnAtaque()) {
			self.colisionoConAtaque(objeto, objeto2)
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
		if (pokemon.esBlastoise()) {
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

