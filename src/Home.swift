import Foundation
import UIKit


class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var utenteLogin: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var filmDisponibili: [film] = []
    
    //Array in cui memorizzo tutte le visioni effettuate dall'utente connesso
    var filmVistiUtenteAttuale: [Visione] = []
    var filmVistiUtenteAttualeF: [film] = []
    
    //Array in cui memorizzo tutte le visioni effettuate dagli utenti
    var filmVistiTotali: [Visione] = []
    
    var filmWishList: [Desiderio] = []
    var filmWishListUtenteAttuale: [Desiderio] = []

    
    //Variabile in cui memorizzo l'utente che ha effettuato il login, ricevuto da LOGIN
    var utenteAttuale = Utente()
    
    var contaFilm: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let tabbar = tabBarController as! HomePage
        
        utenteAttuale = tabbar.utenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        filmVistiUtenteAttuale = tabbar.filmVistiUtenteAttuale
        filmVistiUtenteAttualeF = tabbar.filmVistiUtenteAttualeF
        filmWishList = tabbar.filmWishList
        
        let combined = zip(filmVistiUtenteAttuale, filmVistiUtenteAttualeF).sorted{ $0.0.Valutazione! > $1.0.Valutazione!}
        
        filmVistiUtenteAttuale = combined.map{$0.0}
        filmVistiUtenteAttualeF = combined.map{$0.1}

        if contaFilm < filmVistiUtenteAttuale.count{
            let differenza = filmVistiUtenteAttuale.count - contaFilm
            collectionView.performBatchUpdates({
                for i in stride(from: differenza, to: 1, by: -1){
                    collectionView.insertItems(at: [IndexPath(row: (filmVistiUtenteAttuale.count - i), section: 0)])
                }
            }, completion: nil)
        }
        
        contaFilm = filmVistiUtenteAttuale.count
        
        let iconsSize = CGRect(x: 0, y: -5, width: 35, height: 35)
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "persona")
        attachement.bounds = iconsSize
        let attributeString = NSMutableAttributedString(string: "")
        attributeString.append(NSAttributedString(attachment: attachement))
        attributeString.append(NSAttributedString(string: "  "+utenteAttuale.nome!+" "+utenteAttuale.cognome!))
        utenteLogin.attributedText = attributeString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = tabBarController as! HomePage
               
        utenteAttuale = tabbar.utenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        filmWishList = tabbar.filmWishList
        filmDisponibili = tabbar.filmDisponibili
        filmVistiUtenteAttuale = tabbar.filmVistiUtenteAttuale
        filmVistiUtenteAttualeF = tabbar.filmVistiUtenteAttualeF
        filmWishList = tabbar.filmWishList
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale
        
        let combined = zip(filmVistiUtenteAttuale, filmVistiUtenteAttualeF).sorted{ $0.0.Valutazione! > $1.0.Valutazione!}
        
        filmVistiUtenteAttuale = combined.map{$0.0}
        filmVistiUtenteAttualeF = combined.map{$0.1}
        
        contaFilm = filmVistiUtenteAttuale.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmVistiUtenteAttualeF.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellHome", for: indexPath) as! CollectionViewCellHome

        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 20.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
                
        cell.displayContent(image: UIImage(named: filmVistiUtenteAttualeF[indexPath.row].ID_Film)!, ID: filmVistiUtenteAttualeF[indexPath.row].ID_Film, title: filmVistiUtenteAttualeF[indexPath.row].Titolo, gen: filmVistiUtenteAttualeF[indexPath.row].Genere, anno: filmVistiUtenteAttualeF[indexPath.row].Anno, rating: filmVistiUtenteAttuale[indexPath.row].Valutazione!)

        return cell
    }
}
