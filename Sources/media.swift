import Foundation
import SwiftyJSON

class Media {
    var audio: String?
    var gif: String?
    var sticker: String?

    init(audio: String?, gif: String?, sticker: String?) {
        self.audio = audio
        self.gif = gif
        self.sticker = sticker
    }
}
