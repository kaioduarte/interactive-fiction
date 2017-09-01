//  Created by Kaio Duarte on 8/11/17.
//  Copyright © 2017 Kaio Duarte. All rights reserved.
//

import Foundation
import TelegramBot

let token = readToken(from: "BOT_TOKEN")
let bot = TelegramBot(token: token)
let router = Router(bot: bot)
let game = Game()


func genButtons(scene: Scene) -> ReplyKeyboardMarkup {
	var buttons: [KeyboardButton] = []
	var markup = ReplyKeyboardMarkup()

	for cmd in scene.commands {
		var btn = KeyboardButton()
		btn.text = cmd.text
		buttons.append(btn)
	}

	markup.keyboard = [buttons]
	return markup
}


func UI(context: Context, message: String?) -> Bool {
	if message == nil {
		context.respondSync(game.current_scene!.description, 
			reply_markup: genButtons(scene: game.current_scene!))
		return true
	}

	game.current_scene = game.validateCommand(text: message!)

	if game.current_scene == nil { 
		context.respondSync("Opção inválida, tente novamente!")
		return false;
	}

	context.respondSync(game.current_scene!.description, 
		reply_markup: genButtons(scene: game.current_scene!))
    return true
}


router["start", .slashRequired] = { context in
	guard let from = context.message?.from else { return false }
	return UI(context: context, message: nil)
}


router["Reiniciar", "Jogar novamente"] = { context in
	guard let from = context.message?.from else { return false }
	game.restart()
	return UI(context: context, message: nil)
}


router.unmatched = { context in
	guard let msg = context.message?.text else { return false }
	return UI(context: context, message: msg)
}


while let update = bot.nextUpdateSync() {
    try router.process(update: update)
}