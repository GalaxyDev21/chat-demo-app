import SDWebImage
import UIKit

// MARK: - ChatViewController

class ChatViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var arr = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
    }

    override func viewWillDisappear(_ animated: Bool) {
        CommonFunctions.archive(customObject: arr, keyName: "SavedTargetList")
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        print(arr[indexPath.row])
        let data = arr[indexPath.row]
        if data.containsKey("text") {
            cell.lblMessage.text = data["text"] as? String
            cell.cellHeight.constant = 60
        } else {
            cell.cellHeight.constant = 200
            let fileName = data["image"] as! String
            cell.img.sd_setImage(with: URL(string: "https://api-stage.somethingmoreapp.com/photo/test/\(fileName)?&height=200&width=150")) { _, _, _, _ in
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

extension Dictionary {

    func containsKey(_ key: Key) -> Bool {
        index(forKey: key) != nil
    }
}
