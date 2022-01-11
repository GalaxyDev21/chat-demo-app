import Alamofire
import UIKit

class APIController: NSObject {

    func getImage(filename: String, width: Int, height: Int, successHandler: @escaping (_ success: JSON) -> Void) {
        let parameters: [String: Any] = ["width": width, "height": height]
        ServiceManager.requestWithGet(methodName: "https://api-stage.somethingmoreapp.com/photo/test/\(filename)", parameter: parameters, isHUD: true, timeout: 60, encoding: URLEncoding.queryString, success: { jsonResponse in
            if jsonResponse["status"].stringValue == "1" {
                successHandler(jsonResponse)
            } else {
                ServiceManager.alert(message: jsonResponse["message"].stringValue)
            }
        }, Error: { _ in

        })
    }

    func uploadImage(image: UIImage, successHandler: @escaping (_ success: JSON) -> Void) {
        let parameters: [String: Any] = ["DeviceType": "iOS"]
        let imgData = fixOrientation(img: image)
        ServiceManager.requestWithPostMultipart(methodName: "https://api-stage.somethingmoreapp.com/photo/test", data: imgData.pngData()!, extention: ".png", mimeType: "image/png", parameter: parameters, isHUD: true, timeOut: 60, encoding: URLEncoding.default) { jsonResponse in
            if jsonResponse["filename"].stringValue != "" {
                successHandler(jsonResponse)
            } else {
                ServiceManager.alert(message: jsonResponse["message"].stringValue)
            }
        }
    }

    // MARK: - to fix orientation in Image upload

    func fixOrientation(img: UIImage) -> UIImage {
        if img.imageOrientation == .up {
            return img
        }

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }
}
