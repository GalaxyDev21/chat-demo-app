import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!

    @IBOutlet var cellHeight: NSLayoutConstraint!
    @IBOutlet var viewMessage: UIView!
    @IBOutlet var lblMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewMessage.clipsToBounds = true
        viewMessage.layer.cornerRadius = 20
        viewMessage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 20
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}
