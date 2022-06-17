import UIKit

class CollectionViewCellConsigli: UICollectionViewCell {
    
    
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmTitolo: UILabel!
    @IBOutlet weak var filmGenere: UILabel!
    @IBOutlet weak var filmAnno: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var imageFilmRating: UIImageView!
    @IBOutlet weak var voteType: UILabel!
    
    var id: String!
       
    func displayContent(image: UIImage,ID: String,title: String,gen: String, anno: String, rating: String, type: String){
        filmImage.image = image
        filmTitolo.text = title
        filmGenere.text = gen
        filmAnno.text = anno
        filmRating.text = "Rating Suggester: "
        
        if type == "Top rated"{
            let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "starFill")
            attachement.bounds = iconsSize
            let attributeString = NSMutableAttributedString(string: "")
            attributeString.append(NSAttributedString(attachment: attachement))
            attributeString.append(NSAttributedString(string: "  "+type))
                       
            voteType.attributedText = attributeString
        }
        else if type == "Recommended for you"{
            let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "recommendedForYou")
            attachement.bounds = iconsSize
            let attributeString = NSMutableAttributedString(string: "")
            attributeString.append(NSAttributedString(attachment: attachement))
            attributeString.append(NSAttributedString(string: "  "+type))
                                  
            voteType.attributedText = attributeString
        }
                   
        id = ID
        
        let vote: Float = (rating as NSString).floatValue
        
        if (vote > 0 && vote < 0.8){
            imageFilmRating.image = UIImage(named: "0.5stella")
        }
        if (vote > 0.8 && vote < 1.25){
            imageFilmRating.image = UIImage(named: "1stella")
        }
               
        if(vote > 1.25 && vote < 1.75){
            imageFilmRating.image = UIImage(named: "1.5stelle")
        }
               
        if(vote > 1.75 && vote < 2.25){
            imageFilmRating.image = UIImage(named: "2stelle")
        }
               
        if(vote > 2.25 && vote < 2.85){
            imageFilmRating.image = UIImage(named: "2.5stelle")
        }
        
        if(vote > 2.8 && vote < 3.25){
            imageFilmRating.image = UIImage(named: "3stelle")
        }
               
        if(vote > 3.25 && vote < 3.75){
            imageFilmRating.image = UIImage(named: "3.5stelle")
        }
               
        if(vote > 3.75 && vote < 4.25){
            imageFilmRating.image = UIImage(named: "4stelle")
        }
        if(vote > 4.25 && vote < 4.75){
            imageFilmRating.image = UIImage(named: "4.5stelle")
        }
        if(vote > 4.75){
            imageFilmRating.image = UIImage(named: "5stelle")
        }
    }
    
}
