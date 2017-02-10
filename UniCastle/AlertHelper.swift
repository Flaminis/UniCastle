import UIKit
import SCLAlertView

class AlertHelper: NSObject {
    
    class func loginSearchAppearance() -> SCLAlertView.SCLAppearance {
        
        return SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "AvenirNext-Regular", size: 20)!,
            kTextFont: UIFont(name: "AvenirNext-Regular", size: 14)!,
            kButtonFont: UIFont(name: "AvenirNext-Bold", size: 14)!,
            showCloseButton: true)
        
    }
    
}
