import UIKit

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
            self.clipsToBounds = false  // add this to maintain corner radius
            UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
            if let context = UIGraphicsGetCurrentContext() {
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
                let colorImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.setBackgroundImage(colorImage, for: forState)
            }
        }
    
    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if (context.nextFocusedView == self) {
            // handle focus appearance changes
        }
        else {
            // handle unfocused appearance changes
        }
    
    }
    }
