import wollok.game.*

const blastoise = new TipoAgua (position = game.at(1, 3), vida = 100,vidaMax = 100,nombre = "blastoise",lado = "I", imagen = "blastoise.png",tipo = "agua")

const charizard = new TipoFuego (position = game.at(10, 3), vida = 150,vidaMax = 150,nombre = "charizard",lado = "D", imagen = "charizard2.png",tipo = "fuego")

const mega = new PiedraMega(position = game.at(5,3))

object reinicio {
	var property position = game.at(1,5)
		
	method image() = "reinicio.png"
}

object juego {
	
	method inicio() {
		
		// Objetos
		game.addVisual(blastoise)
		game.addVisual(charizard)
		game.addVisual(mega)
		
		// Movimiento
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
		game.whenCollideDo(blastoise, { objeto => objeto.colisionar(blastoise)})
		game.whenCollideDo(charizard, { objeto => objeto.colisionar(charizard)})
		game.whenCollideDo(mega, {objeto => objeto.colisionarConPiedraMega(mega)})
		
		// Musica
		const musicaPokemon = game.sound("Musica.mp3")
		game.schedule(100, { musicaPokemon.play()})
		musicaPokemon.volume(0.5)
		
		// REINICIO DEL JUEGO
		keyboard.r().onPressDo({self.reiniciar()})
		
		// FINALIZAR JUEGO
		keyboard.t().onPressDo({self.terminar()})
	
	}
	
	method reiniciar(){  
		game.clear()
		self.inicio()
		game.addVisual(reinicio)
		game.onTick(500, "quitar imagen",{=> game.removeVisual(reinicio)})
	}
	
	method terminar(){ 
		game.stop()
	}
}

class Pokemon {
	var property vida
	var property position
	var property nombre
	var property vidaMax
	var property lado
	var imagen
	
	method image() = imagen
	
	method restarVida(ataque) {
		vida = vida - (ataque.danio() / 10)
	}
	
	method restaurarS(ataque){
		if (vida < vidaMax){
			vida = vida + vida*ataque.restaurarS() 
			}
		else {}
	}
	
	method colisionar(pokemon){
		if (pokemon.lado() == "I"){
			movimiento.moveteIzquierda(pokemon)
       		movimiento.moveteDerecha(self)
		}
		if (pokemon.lado() == "D"){
			movimiento.moveteIzquierda(self)
       		movimiento.moveteDerecha(pokemon)
		}
		
	}
	
	method colisionarConPiedraMega(){
		self.megaEvolucion()
	}
	
	method megaEvolucion(){
		game.schedule(15000, {=> self.quitarMega()})
	}
	
	method quitarMega(){
		game.addVisual(mega)
	}
	
}
 class TipoAgua inherits Pokemon {
 	var property tipo
 	var cargaAtqMax = 0
 	var megaEvol = 0
 	
 	method miAtaque(){
 		if ((cargaAtqMax <= 2) and (mega == 0)){
			  const hidrocanion = new AtqTipoAgua(nombre = "Hidrocanion", danio = 70, position = self.position(), imagen = "hidrocañon.png",bonificacionA = 0)
			  cargaAtqMax = cargaAtqMax + 1
			  return hidrocanion
			  }
		else {
			const hidrocanionMaximo = new AtqTipoAgua(nombre ="Hidrocanion Maximo",danio = 100, position = self.position(),imagen ="BolaDeAgua.png",bonificacionA = 3)
			cargaAtqMax = 0
			return hidrocanionMaximo
		}
 	}
 	
 	method ataque() {
		const ataqueAgua = self.miAtaque()
		self.restaurarS(ataqueAgua)
		game.say(self, ataqueAgua.nombre())
		game.addVisual(ataqueAgua) 
		ataqueAgua.movete(self)
		game.whenCollideDo(ataqueAgua, { ataque2 => ataqueAgua.colision(ataque2, ataqueAgua)})
		game.onTick(500, "movimientoAtaque", { ataqueAgua.moverAtaque(self)})
	}
	
	override method megaEvolucion(){
		imagen = "MegaBlastoise.png"
		vida = 300
		vidaMax = 300
		megaEvol = 1
		game.say(self,"Mega Evolucion")
		game.schedule(15000, {=> self.quitarMega()})
	}
	override method quitarMega(){
		imagen = "blastoise.png"
		vida = 100
		vidaMax = 100
		megaEvol = 0
		game.addVisual(mega)
	}
 		
 }
 class TipoFuego inherits Pokemon{
 	var property tipo
 	var cargaAtqMax = 0
 	var megaEvol = 0
  	
  	method miAtaque(){
 		if ((cargaAtqMax <= 3) and (mega == 0)){
			  const llamarada = new AtqTipoFuego(nombre = "Llamarada", danio = 40, position = self.position(), imagen = "llamarada.png",bonificacionF = 0)
			  cargaAtqMax = cargaAtqMax + 1
			  return llamarada
			  }
		else {
			const llamaradaMaxima = new AtqTipoFuego(nombre ="Llamarada Maxima",danio = 110, position = self.position(),imagen ="BolaDeFuego.png",bonificacionF = 10)
			cargaAtqMax = 0
			return llamaradaMaxima
		}
 	}
 	
 	method ataque() {
		const ataqueFuego = self.miAtaque()
		self.restaurarS(ataqueFuego)
		game.say(self, ataqueFuego.nombre())
		game.addVisual(ataqueFuego) 
		ataqueFuego.movete(self)
		game.whenCollideDo(ataqueFuego, { ataque2 => ataqueFuego.colisionAtaque(ataque2,ataqueFuego)})
		game.onTick(500, "movimientoAtaque", { ataqueFuego.moverAtaque(self)})
	}
 
 	override method megaEvolucion(){
		imagen = "MegaCharizard.png"
		vida = 400
		vidaMax = 400
		megaEvol = 1
		game.say(self,"Mega Evolucion")
		game.schedule(15000, {=> self.quitarMega()})
	}
	
	override method quitarMega(){
		imagen = "charizard2.png"
		vida = 150
		vidaMax = 150
		megaEvol = 0
		game.addVisual(mega)
	}
 }
 
class Ataque {
	var property nombre
	var property danio
	var property position
	var imagen
	
	method image() = imagen
	
	method restaurarS(){
		return 0.05
	}
	
	method colisionar(pokemon){
		pokemon.restarVida(self)
		if (pokemon.vida() <= 0) {
			const ganador = game.sound("Winner.mp3")
			ganador.play()
			game.removeVisual(self)
			game.removeVisual(pokemon)
		} else {
			game.say(pokemon, " mi vida actual : " + pokemon.vida().toString().toString())
			game.removeVisual(self)
		}
	}
	
	method colisionarConPiedraMega(){
		
	}
	
	method moverAtaque(pokemon) {
		var direccion = 0
		if (pokemon.tipo() == "agua") {
			direccion = 1
		} else {
			direccion = -1
		}
		const x = self.position().x() + direccion
		const y = self.position().y()
		position = game.at(x, y)
	}
	
	method colisionAtaque(otroAtaque,miAtaque){
		const explosion = new Explosion ()
		explosion.position(miAtaque.position())
		game.addVisual(explosion)
		game.removeVisual(otroAtaque)
		game.removeVisual(miAtaque)
		game.schedule(300,  {=> game.removeVisual(explosion)})
	}
	
}

class AtqTipoFuego inherits Ataque {
	var bonificacionF
	
	override method restaurarS(){
		return bonificacionF/100
	}
	
	method movete(pokemon) {
		const x = pokemon.position().x() - 1
		const y = pokemon.position().y()
		position = game.at(x,y)
	}
}

class AtqTipoAgua inherits Ataque{
	var bonificacionA
	
	override method danio(){
		return danio + ((bonificacionA*danio)/6)
	}
	
	method movete(pokemon) {
		const x = pokemon.position().x() + 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}
}

class Explosion {

	var property position = game.center()

	method image() = "Explosion.png"

}

class PiedraMega {
	
	var property position = game.center()
	
	method image()= "PiedraMega.png"
	
	method colisionar(pokemon){
		pokemon.megaEvolucion()
		game.removeVisual(self)
	}
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