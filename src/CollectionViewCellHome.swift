import UIKit

class CollectionViewCellHome: UICollectionViewCell {
    
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmTitolo: UILabel!
    @IBOutlet weak var filmGenere: UILabel!
    @IBOutlet weak var filmAnno: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var imageRating: UIImageView!
    
    var id: String!
    
    func displayContent(image: UIImage,ID: String,title: String,gen: String, anno: String, rating: String){
        filmImage.image = image
        filmTitolo.text = title
        filmGenere.text = gen
        filmAnno.text = anno
        filmRating.text = "Rating:"
        if rating == "1"{
            imageRating.image = UIImage(named: rating+"stella")
        }
        else{
            imageRating.image = UIImage(named: rating+"stelle")
        }
        
        id = ID
    }
    
    
}
