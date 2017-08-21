//  Created by Kaio Duarte on 8/11/17.
//  Copyright © 2017 Kaio Duarte. All rights reserved.
//

import Foundation
import TelegramBot

let token = readToken(from: "BOT_TOKEN")
let bot = TelegramBot(token: token)
let router = Router(bot: bot)
let game = Game()


func genButtons(scene: Scene) -> [KeyboardButton] {
	var buttons: [KeyboardButton] = []

	for cmd in scene.commands {
		var btn = KeyboardButton()
		btn.text = cmd.text
		buttons.append(btn)
	}

	return buttons
}


router["start", .slashRequired] = { context in
	guard let from = context.message?.from else { return false }
	
	var markup = ReplyKeyboardMarkup()

	markup.keyboard = [genButtons(scene: game.current_scene!)]
	context.respondAsync(game.current_scene!.description, reply_markup: markup)

	return true
}

router.unmatched = { context in
	guard let msg = context.message?.text else { return false }
	
	game.current_scene = game.validateCommand(text: msg)

	if game.current_scene == nil { 
		context.respondAsync("Opção inválida, tente novamente!")
		return false;
	}

	var markup = ReplyKeyboardMarkup()

	markup.keyboard = [genButtons(scene: game.current_scene!)]
	context.respondAsync(game.current_scene!.description, reply_markup: markup)

    return true
}

while let update = bot.nextUpdateSync() {
    try router.process(update: update)
}