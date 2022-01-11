import UIKit

class HomeProductListCell: UITableViewCell {

    @IBOutlet var btnName: UIButton!
    @IBOutlet var viewChat: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        viewChat.clipsToBounds = true
        viewChat.layer.cornerRadius = 20
        viewChat.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}
