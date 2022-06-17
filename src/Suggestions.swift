import UIKit
import CSVImporter
import Backendless

class Suggestions: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var utenteLogin: UILabel!
    
    private let fileFilmPath = Bundle.main.path(forResource: "movieDataset", ofType: "csv")

    var utenteAttuale = Utente()
    
    var utentiPresenti: [Utente] = []
    var filmVistiTotali: [Visione] = []
    var filmDisponibili: [film] = []
    
    var filmWishListUtenteAttuale: [Desiderio] = []

    var votiPredettiFilmConsigliati: [Float] = []
    var votiPredettiFilmConsigliatiID_Film: [String] = []
    var VotesType: [String] = []
    
    var IDFilms: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
//        IDFilms = votiPredettiFilmConsigliatiID_Film

        let tabbar = tabBarController as! HomePage
               
        utenteAttuale = tabbar.utenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        utentiPresenti = tabbar.utentiPresenti
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale
        
        print(votiPredettiFilmConsigliati.count)
        print(votiPredettiFilmConsigliatiID_Film.count)
        print(filmWishListUtenteAttuale.count)
        print("FilmVistiTotale",filmVistiTotali.count)
        
        let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "persona")
        attachement.bounds = iconsSize
        let attributeString = NSMutableAttributedString(string: "")
        attributeString.append(NSAttributedString(attachment: attachement))
        attributeString.append(NSAttributedString(string: "  "+utenteAttuale.nome!+" "+utenteAttuale.cognome!))
            
        utenteLogin.attributedText = attributeString
        
        let recommender = Recommendation()
//        recommender.inizializza()
        
        (votiPredettiFilmConsigliati, votiPredettiFilmConsigliatiID_Film, VotesType) = recommender.recommendationAdvice(utenteAttuale: utenteAttuale, filmVistiTotali: filmVistiTotali, filmDisponibili: filmDisponibili, utentiPresenti: utentiPresenti, filmWishListUtenteAttuale: filmWishListUtenteAttuale)
        
        let combined = zip(votiPredettiFilmConsigliati, votiPredettiFilmConsigliatiID_Film).sorted{ $0.0 > $1.0}

        votiPredettiFilmConsigliati = combined.map {$0.0}
        votiPredettiFilmConsigliatiID_Film = combined.map {$0.1}
        
        print("I voti predetti dei film consigliati sono:  ")
        print("          FILM:",votiPredettiFilmConsigliatiID_Film)
        print("          VOTI:",votiPredettiFilmConsigliati)
        print("          TIPO:",VotesType)

        var modifica = false
        if IDFilms != votiPredettiFilmConsigliatiID_Film{
            modifica = true
        }
        
        if modifica == true{
            collectionView.performBatchUpdates({
                for i in stride(from: IDFilms.count-1, to: 0, by: -1){
                    collectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
                }
                
            }, completion: nil)
            collectionView.performBatchUpdates({
                for i in 0..<votiPredettiFilmConsigliatiID_Film.count{
                    collectionView.insertItems(at: [IndexPath(row: i, section: 0)])
                }
                
            }, completion: nil)
        }
        
        IDFilms = votiPredettiFilmConsigliatiID_Film
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = tabBarController as! HomePage
               
        utenteAttuale = tabbar.utenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        utentiPresenti = tabbar.utentiPresenti
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale
        filmDisponibili = tabbar.filmDisponibili
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return votiPredettiFilmConsigliatiID_Film.count
    }
       
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellConsigli", for: indexPath) as! CollectionViewCellConsigli
        
        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 20.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.02647465653717518, green: 0.17750251293182373, blue: 0.43236303329467773, alpha: 0.8179192342))
        
        let indice = Int(votiPredettiFilmConsigliatiID_Film[indexPath.row])! - 1
        
        cell.displayContent(image: UIImage(named: filmDisponibili[indice].ID_Film)!, ID: filmDisponibili[indice].ID_Film, title: filmDisponibili[indice].Titolo, gen: filmDisponibili[indice].Genere, anno: filmDisponibili[indice].Anno, rating: String(votiPredettiFilmConsigliati[indexPath.row]), type: VotesType[indexPath.row])

           return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        let alertController = UIAlertController(title: "Vuoi inserire il film nella tua WishList?", message: "", preferredStyle: .alert)
        
        //Visualizzo l'immagine
        let image = UIImage(named: "\(votiPredettiFilmConsigliatiID_Film[indexPath.row]).png")
        alertController.addImage(image: image!)
        
        //Premendo su YES spermetto di votare all'utente
        let salveAction = UIAlertAction(title: "Yes", style: .default)
        { _ in
            
            let filmDaVedere = Desiderio()
            filmDaVedere.ID_Film = self.votiPredettiFilmConsigliatiID_Film[indexPath.row]
            filmDaVedere.Username = self.utenteAttuale.username
            
            let dataStore = Backendless.shared.data.of(Desiderio.self)
            dataStore.save(entity: filmDaVedere, responseHandler: { (savedFilmDaVedere) in
                print("Film aggiunto alla wishlist")
            }, errorHandler: {fault in
                    print("Error: \(fault.message ?? "")")
            })
            
        }
        
        //Premendo su cancel non eseguo il salvataggio
        let cancelAction = UIAlertAction(title: "No", style: .destructive)
        { _ in
            print("Cancel: dati non salvati")
        }
        
        alertController.addAction(salveAction)//Attivo il bottone Vote
        alertController.addAction(cancelAction)//Attivo il bottone Cancel
        
        self.present(alertController, animated: true, completion: nil)


    }
}
