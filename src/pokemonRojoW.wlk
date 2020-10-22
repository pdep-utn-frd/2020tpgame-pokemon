import wollok.game.*

const blastoise = new TipoAgua (position = game.at(1, 3), vida = 100,vidaMax = 100,nombre = "blastoise",lado = "I", imagen = "blastoise.png",tipo = "agua")

const charizard = new TipoFuego (position = game.at(10, 3), vida = 150,vidaMax = 150,nombre = "charizard",lado = "D", imagen = "charizard2.png",tipo = "fuego")

const mega = new PiedraMega(position = game.at(5,3))

object reinicio {
	var property position = game.at(1,5)
	
	method image() = "reinicio.png"
}

object juego {
	
	method restablecer(){
		charizard.Inicial()
		blastoise.Inicial()
	}
	
	method inicio() {
		
		// Objetos
		self.restablecer()
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
		
		// Musica
		const musicaPokemon = game.sound("Musica.mp3")
		game.schedule(100, {musicaPokemon.play()})
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
		game.schedule(500,{game.removeVisual(reinicio)})
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
	var cargaAtqMax = 0
 	var megaEvol = 0
	var imagen
	
	method image() = imagen
	
	method Inicial(){
		
	}
	
	method morir(){
		const ganador = game.sound("Winner.mp3")
			ganador.play()
			game.removeVisual(self)
			// añadir imagen para reinicio de juego
	}
	
	method restarVida(ataque) {
		vida = vida - (ataque.danio() / 10)
		if (self.vida() <= 0) {
			self.morir()
		} else {
			game.say(self, " mi vida actual : " + self.vida().toString().toString())
		}
	}
	
	method restaurarS(ataque){ 
		var auxi
		if (vida < vidaMax){
			auxi = vida + vida*ataque.restaurarS() 
			if (auxi > vidaMax){	
				vida = vidaMax
			}
			else{
				vida = auxi
			}
		}
	}
	
	method miAtaque(){
      var ataque 
 		if ((cargaAtqMax < 2) and (megaEvol == 0)){
			  ataque = self.generarAtaque()
			  cargaAtqMax = cargaAtqMax + 1
			  return ataque
			  }
		else {
			ataque = self.generarAtaqueFuerte()
			cargaAtqMax = 0
			return ataque
		}
	}
	
	method ataque() {
		const ataque = self.miAtaque()
		self.restaurarS(ataque)
		game.say(self, ataque.nombre())
		game.addVisual(ataque) 
		ataque.moveteHaciaAdelante(self)
		game.onTick(500, "movimientoAtaque", { ataque.moverAtaque()})
	}
	
	method generarAtaque(){
		return 0
	}
	
	method generarAtaqueFuerte(){
		return 0
	}

	method rebotarHaciaAtras(){
		
	}
	
	method colisionar(pokemon){
		pokemon.rebotarHaciaAtras()
		self.rebotarHaciaAtras()
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
 
 	override method rebotarHaciaAtras(){
 		movimiento.moveteIzquierda(self)
 	}
 
 	override method Inicial(){
 		position = game.at(1,3)
 		vida = vidaMax
 		cargaAtqMax = 0
 	}
 
 	override method generarAtaque(){
 		const hidrocanion = new AtqTipoAgua(nombre = "Hidrocanion", danio = 70, position = self.position(), imagen = "hidrocañon.png",bonificacionA = 0)
 		return hidrocanion
 	}
 	override method generarAtaqueFuerte(){
 		const hidrocanionMaximo = new AtqTipoAgua(nombre ="Hidrocanion Maximo",danio = 100, position = self.position(),imagen ="BolaDeAgua.png",bonificacionA = 3)
 		return hidrocanionMaximo
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
 
 	override method rebotarHaciaAtras(){
 		movimiento.moveteDerecha(self)
 	}
 	
 	override method Inicial(){
 		position = game.at(10,3)
 		vida = vidaMax
 		cargaAtqMax = 0
 	}
 
 	override method generarAtaque(){
 		const llamarada = new AtqTipoFuego(nombre = "Llamarada", danio = 40, position = self.position(), imagen = "llamarada.png",bonificacionF = 0)
 		return llamarada
 	}
 	override method generarAtaqueFuerte(){
 		const llamaradaMaxima = new AtqTipoFuego(nombre ="Llamarada Maxima",danio = 110, position = self.position(),imagen ="BolaDeFuego.png",bonificacionF = 30)
 		return llamaradaMaxima
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
		return 0.15
	}
	
	method colisionar(pokemon){
		pokemon.restarVida(self)
		game.removeVisual(self)
	}
	
}

class AtqTipoFuego inherits Ataque {
	var bonificacionF
	
	override method restaurarS(){
		return bonificacionF/100
	}
	
	method moverAtaque(){
		position = position.left(1)
	}
	
	method moveteHaciaAdelante(pokemon) {
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
	
	method moverAtaque(){
		position = position.right(1)
	}
	
	method moveteHaciaAdelante(pokemon) {
		const x = pokemon.position().x() + 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}
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