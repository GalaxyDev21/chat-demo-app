
import UIKit

class UIViewCustomClass: UIView {
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor:UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var shadowColor:UIColor? {
        get { return UIColor(cgColor: layer.shadowColor!) }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowOpacity:Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable var shadowRadius:CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var masksToBounds:Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable var shadowOffset:CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
}
