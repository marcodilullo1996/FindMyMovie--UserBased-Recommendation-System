import UIKit

class CollectionViewCellSearch: UICollectionViewCell {
    
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmTitolo: UILabel!
    @IBOutlet weak var filmGenere: UILabel!
    @IBOutlet weak var filmAnno: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var filmRatingAverage: UILabel!
    @IBOutlet weak var filmImageSuggesterRating: UIImageView!
    @IBOutlet weak var filmImageAverageRating: UIImageView!
    var id: String!
    
    func displayContent(image: UIImage,ID: String,title: String,gen: String, anno: String, rat: String, ratAver: String){
        
        filmImage.image = image
        filmTitolo.text = title
        filmGenere.text = gen
        filmAnno.text = anno
        filmRating.text = "Suggested rating:  "
        
        let vote: Float = (rat as NSString).floatValue
        let voteAverage = (ratAver as NSString).floatValue
        
        if (vote > 0 && vote < 0.8){
            filmImageSuggesterRating.image = UIImage(named: "0.5stella")
        }
        
        if (vote > 0.8 && vote < 1.25){
            filmImageSuggesterRating.image = UIImage(named: "1stella")
        }
        
        if(vote > 1.25 && vote < 1.75){
            filmImageSuggesterRating.image = UIImage(named: "1.5stelle")
        }
        
        if(vote > 1.75 && vote < 2.25){
            filmImageSuggesterRating.image = UIImage(named: "2stelle")
        }
        
        if(vote > 2.25 && vote < 2.85){
            filmImageSuggesterRating.image = UIImage(named: "2.5stelle")
        }
        
        if(vote > 2.8 && vote < 3.25){
            filmImageSuggesterRating.image = UIImage(named: "3stelle")
        }
        
        if(vote > 3.25 && vote < 3.75){
            filmImageSuggesterRating.image = UIImage(named: "3.5stelle")
        }
        
        if(vote > 3.75 && vote < 4.25){
            filmImageSuggesterRating.image = UIImage(named: "4stelle")
        }
        if(vote > 4.25 && vote < 4.75){
            filmImageSuggesterRating.image = UIImage(named: "4.5stelle")
        }
        if(vote > 4.75){
            filmImageSuggesterRating.image = UIImage(named: "5stelle")
        }
        
        if rat == "6.0"{
            filmRating.text = "Suggester rating:  Non disponibile"
        }
        
        filmRatingAverage.text = "Average rating:  "

        if (voteAverage > 0 && voteAverage < 0.8){
            filmImageAverageRating.image = UIImage(named: "0.5stella")
        }
        
        if (voteAverage > 0.8 && voteAverage < 1.25){
            filmImageAverageRating.image = UIImage(named: "1stella")
        }
        
        if(voteAverage > 1.25 && voteAverage < 1.75){
            filmImageAverageRating.image = UIImage(named: "1.5stelle")
        }
        
        if(voteAverage > 1.75 && voteAverage < 2.25){
            filmImageAverageRating.image = UIImage(named: "2stelle")
        }
        
        if(voteAverage > 2.25 && voteAverage < 2.85){
            filmImageAverageRating.image = UIImage(named: "2.5stelle")
        }
        
        if(voteAverage > 2.8 && voteAverage < 3.25){
            filmImageAverageRating.image = UIImage(named: "3stelle")
        }
        
        if(voteAverage > 3.25 && voteAverage < 3.75){
            filmImageAverageRating.image = UIImage(named: "3.5stelle")
        }
        
        if(voteAverage > 3.75 && voteAverage < 4.25){
            filmImageAverageRating.image = UIImage(named: "4stelle")
        }
        if(voteAverage > 4.25 && voteAverage < 4.75){
            filmImageAverageRating.image = UIImage(named: "4.5stelle")
        }
        if(voteAverage > 4.75){
            filmImageAverageRating.image = UIImage(named: "5stelle")
        }
        
        if ratAver == "6.0"{
            filmRating.text = "Average rating:  Non disponibile"
        }
        
        id = ID
    }
    
}
