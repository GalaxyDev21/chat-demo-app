import Alamofire
import Foundation
import UIKit

var screenHeight = UIScreen.main.bounds.height
var screenWidth = UIScreen.main.bounds.width
var screenCenterX = UIScreen.main.bounds.width / 2
var screenCenterY = UIScreen.main.bounds.height / 2

public extension Request {
    func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}
