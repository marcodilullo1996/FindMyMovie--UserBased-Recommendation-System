import UIKit

extension UIAlertController{
    
    func addImage(image: UIImage){
//        let maxSize = CGSize(width: 200, height: 250)
        let imgSize = image.size
        
//        var ratio: CGFloat!
//        
//        if imgSize.width > imgSize.height{
//            ratio = maxSize.width / imgSize.width
//        } else{
//            ratio = maxSize.height / maxSize.height
//        }
        
        let scaleSize = CGSize(width: imgSize.width * 4.68, height: imgSize.height * 1.42)
        
        let resizeImage = image.imageWithSize(scaleSize)

        let imageAction = UIAlertAction(title:"", style: .default, handler: nil)
        imageAction.isEnabled = false
        imageAction.setValue(resizeImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imageAction)
    }
}
