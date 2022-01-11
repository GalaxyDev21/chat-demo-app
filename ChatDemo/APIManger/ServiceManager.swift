import Alamofire
import MBProgressHUD
import UIKit

// MARK: - ServiceManager

class ServiceManager: NSObject {
    static var sessionManager: SessionManager?
    static var showHUD: Bool = true

    static let indicator: MBProgressHUD = {
        () -> MBProgressHUD in

        let frame = CGRect(x: screenCenterX - ((screenHeight / 6) / 2), y: screenCenterY - ((screenHeight / 6) / 2), width: screenHeight / 6, height: screenHeight / 6)
        let topVC = ServiceManager.topMostController()
        let HUD = MBProgressHUD(view: topVC.view)
        UIApplication.shared.keyWindow?.addSubview(HUD)
        HUD.label.text = "Loading"

        return HUD
    }()

    @objc class func update() {
        Alamofire.SessionManager.default.session.getAllTasks(completionHandler: { tasks in
            if !tasks.isEmpty {
                DispatchQueue.main.async {
                    if showHUD {
                        indicator.show(animated: true)
                    } else {
                        DispatchQueue.main.async {
                            indicator.hide(animated: true)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    indicator.hide(animated: true)
                }
            }
        })
    }

    class func requestWithGet(methodName: String, parameter: [String: Any]?, isHUD: Bool, timeout: Double, encoding: ParameterEncoding, success successHandler: @escaping (_ success: JSON) -> Void, Error errorHandler: @escaping (_ success: JSON) -> Void) {
        let errorDict: [String: Any] = [:]
        var errorJson = JSON(errorDict)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        if ReachabilityCheck.sharedInstance.isInternetAvailable() {
            indicator.mode = .indeterminate
            indicator.label.text = "Loading"
            if isHUD {
                DispatchQueue.main.async {
                    showHUD = isHUD
                }
            }
            var jsonResponse: JSON!
            let urlString = "\(methodName)?"
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = timeout
            sessionManager = Alamofire.SessionManager(configuration: configuration)

            Alamofire.request(urlString, method: .get, parameters: parameter, encoding: encoding).debugLog().responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                    case .failure:

                        successHandler(errorJson)
                    case let .success(value):
                        print(value)
                        let json = JSON(data: response.data!)
                        jsonResponse = json
                        successHandler(jsonResponse)
                }
            }
        } else {
            errorJson = ["status": "0", "message": "Network is Unreachable"]
            successHandler(errorJson)
        }
    }

    class func requestWithPostMultipart(methodName: String, data: Data, extention: String, mimeType: String, parameter: [String: Any]?, isHUD: Bool, timeOut: Int, encoding: ParameterEncoding, success successHandler: @escaping (_ success: JSON) -> Void) {
        if ReachabilityCheck.sharedInstance.isInternetAvailable() {

            indicator.mode = .determinate
            indicator.label.text = "Uploading"
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval(timeOut)
            sessionManager = Alamofire.SessionManager(configuration: configuration)

            showHUD = isHUD

            let parameters: Parameters = parameter ?? Dictionary()
            var jsonResponse: JSON!
            let urlString = "\(methodName)"

            Alamofire.upload(multipartFormData: { multipartFormData in

                multipartFormData.append(data, withName: "photo", fileName: "file.\(extention)", mimeType: mimeType)
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: urlString, method: .put, headers: ["Connection": "keep-alive", "Content-Length": "1060139", "Content-Type": "multipart/form-data; boundary=--------------------------973857972943020641401104", "Accept": "*/*"], encodingCompletion: { result in
                switch result {
                    case let .success(upload, _, _):

                        upload.uploadProgress(closure: { progress in
                            print(progress.fractionCompleted * 100)
                            indicator.progress = Float(progress.fractionCompleted)
                        })

                        upload.responseJSON(completionHandler: { response in
                            if response.error != nil {
                                if response.error!.localizedDescription == "" {}
                            }
                            var json = JSON(data: response.data!)
                            if response.response != nil {
                                print(response.request!) // original URL request
                                print(response.response!) // HTTP URL response
                            }
                            print(String(data: response.data!, encoding: .utf8)!) // server data
                            print(response.result)
                            if response.request?.url?.query?.components(separatedBy: "=")[1] != nil {
                                json["imageid"] = JSON(response.request!.url!.query!.components(separatedBy: "=")[1])
                            }
                            if json == JSON.null {
                                print(response)
                            }
                            print("\(json)")
                            jsonResponse = json
                            successHandler(jsonResponse)
                        })
                    case let .failure(error):
                        print(error)
                        successHandler(JSON(["message": error.localizedDescription]))
                }
            })
        } else {}
    }

    class func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while (topController?.presentedViewController) != nil {
            topController = topController?.presentedViewController
        }
        return topController!
    }

    class func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
        }
        alert.addAction(cancelAction)
        ServiceManager.topMostController().present(alert, animated: true, completion: nil)
    }

    class func imageUploadRequest(image: UIImage, uploadUrl: URL, param: [String: String]?, successHandler: @escaping (_ success: JSON) -> Void) {

        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = image.jpegData(compressionQuality: 1)
        if imageData == nil {
            successHandler(JSON(""))
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error -> Void in
            if let data = data {

                // You can print out response object
                print("******* response = \(String(describing: response))")

                print(data.count)
                // you can use data here

                // Print out reponse body
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")

                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary

                print("json value \(String(describing: json))")

                // var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                successHandler(JSON(json!))
            } else if let error = error {
                print(error)
                successHandler(JSON(error))
            }
        })
        task.resume()
    }

    class func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData()

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        let filename = "user-profile.jpg"

        let mimetype = "image/jpg"

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")

        body.appendString(string: "--\(boundary)--\r\n")

        return body as Data
    }

    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension NSMutableData {

    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
