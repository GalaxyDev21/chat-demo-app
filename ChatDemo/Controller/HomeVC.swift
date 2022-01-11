import MobileCoreServices
import UIKit

// MARK: - HomeVC

class HomeVC: UIViewController {

    // MARK: Internal

    @IBOutlet var viewHeight: NSLayoutConstraint!
    var nameArrr = ["What's your COVID silcer lining?", "Favorite sports team?", "Dream celebrity date (alive or dead)?", "Favorite show on Netflix?"]
    @IBOutlet var blackView: UIView!
    @IBOutlet var cameraView: UIViewCustomClass!
    @IBOutlet var cancelVe: UIViewCustomClass!

    @IBOutlet var addImgBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chatView: UIView!
    @IBOutlet var lightningBoltBtn: UIButton!
    @IBOutlet var tvMessage: UITextView!

    var listOfTarget = [[String: Any]]()

    let cellID = "HomeProductListCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        self.chatView.clipsToBounds = true
        chatView.layer.cornerRadius = 20
        chatView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }

    override func viewWillAppear(_ animated: Bool) {
        listOfTarget = CommonFunctions.getTargetList()
        tvMessage.text = "Need an ice-breaker? Tap on the lighting bolt."
    }

    func saveCoverImageCalBack(_ coverPic: UIImage) {
        APIController().uploadImage(image: coverPic) { response in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//            if self.listOfTarget.isEmpty {
//                controller.arr.append(["image": response["filename"].stringValue])
//            } else {
//                controller.arr = self.listOfTarget
//                controller.arr.append(["image": response["filename"].stringValue])
//            }
//            self.navigationController?.pushViewController(controller, animated: true)

            self.listOfTarget.append(["image": response["filename"].stringValue])
            self.pushToChatVC()
        }
    }

    @IBAction func cameraActionBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectImageViewController") as! SelectImageViewController

        vc.coverImageCallback = self.saveCoverImageCalBack(_:)
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func lightningBoltAction(_ sender: Any) {

        if lightningBoltBtn.tag == 0 {
            lightningBoltBtn.tag = 1
            tableView.isHidden = false

            viewHeight.constant = 220
            addImgBtn.isHidden = true
            lightningBoltBtn.setImage(UIImage(named: "Group 1509"), for: .normal)
            tableView.reloadData()
        } else {
            lightningBoltBtn.tag = 0
            tableView.isHidden = true

            viewHeight.constant = 100
            addImgBtn.isHidden = false
            lightningBoltBtn.setImage(UIImage(named: "Group 1507"), for: .normal)
        }
    }

    @IBAction func sendTextAction(_ sender: Any) {
        let messageText = tvMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        listOfTarget.append(["text": messageText])
        pushToChatVC()
    }

    // MARK: Private

    //    private func pushToChatVC(withMessages messages: [[String:Any]]) {
    private func pushToChatVC() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = Storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.arr.append(contentsOf: listOfTarget)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArrr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! HomeProductListCell
        cell.btnName.setTitle(nameArrr[indexPath.row], for: .normal)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        listOfTarget.append(["text": nameArrr[indexPath.row]])
        self.pushToChatVC()
    }
}
