import UIKit

extension UIImage{
    
    func imageWithSize(_ size: CGSize) -> UIImage  {
        
        var scaleImageRect = CGRect.zero
        
        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight: CGFloat = size.height / self.size.height
        let aspectRatio: CGFloat = min(aspectWidth, aspectHeight)
        
        scaleImageRect.size.width = self.size.width * aspectRatio
        scaleImageRect.size.height = self.size.height * aspectRatio
        scaleImageRect.origin.x = (size.width - scaleImageRect.size.width) / 2.0
        scaleImageRect.origin.y = (size.height - scaleImageRect.size.height) / 2.0

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaleImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
