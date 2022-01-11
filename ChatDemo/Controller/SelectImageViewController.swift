import MobileCoreServices
import UIKit

// MARK: - SelectImageViewController

class SelectImageViewController: UIViewController {

    var coverImageCallback: ((_ coverImage: UIImage) -> Void)?
    var selecetdImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cameraAction(_ sender: Any) {
        openCamera()
    }

    @IBAction func photoActio(_ sender: Any) {
        gallery()
    }

    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.sourceType = .camera
            image.mediaTypes = [kUTTypeImage as String]
            image.delegate = self
            self.present(image, animated: true, completion: nil)
        }
    }

    func gallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.delegate = self
            self.present(image, animated: true, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension SelectImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(info)

        let data = convertUIimageTodict(info)

        if let eeditingImage = data[convertInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            print(eeditingImage)
            selecetdImage = eeditingImage
        }
        picker.dismiss(animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.dismiss(animated: true, completion: nil)
            self.coverImageCallback!(self.selecetdImage)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func convertUIimageTodict(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value)
        })
    }

    func convertInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
