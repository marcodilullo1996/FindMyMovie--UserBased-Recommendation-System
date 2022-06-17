import UIKit
import Backendless

class Wishlist: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
  

    @IBOutlet weak var utenteLogin: UILabel!
    
    var utenteAttuale = Utente()
    var utentiPresenti: [Utente] = []
    var filmDisponibili: [film] = []
    
    var filmVistiTotali: [Visione] = []
    var filmVistiUtenteAttuale: [Visione] = []
    var filmVistiUtenteAttualeF: [film] = []
    
    var filmWishList: [Desiderio] = []
    var filmWishListUtenteAttuale: [Desiderio] = []
    var filmWishListUtenteAttualeF: [film] = []
    
    var votiPredettiFilmTrovati: [Float] = []
    var votiMediFilmTrovati: [Float] = []
    
    var contaFilm: [film] = []


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                
        filmWishListUtenteAttualeF.removeAll()
        
        let tabbar = tabBarController as! HomePage

        utenteAttuale = tabbar.utenteAttuale
        filmDisponibili = tabbar.filmDisponibili
        filmWishList = tabbar.filmWishList
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        filmVistiUtenteAttuale = tabbar.filmVistiUtenteAttuale
        filmVistiUtenteAttualeF = tabbar.filmVistiUtenteAttualeF
        utentiPresenti = tabbar.utentiPresenti
        
        for i in 0..<filmWishListUtenteAttuale.count{
            for j in 0..<filmDisponibili.count{
                if filmWishListUtenteAttuale[i].ID_Film == filmDisponibili[j].ID_Film{
                    filmWishListUtenteAttualeF.append(film(ID: filmWishListUtenteAttuale[i].ID_Film!, Tit: filmDisponibili[j].Titolo, Gen: filmDisponibili[j].Genere, Ann: filmDisponibili[j].Anno))
                }
            }
        }
        
        print(contaFilm.count)
        print(filmWishListUtenteAttualeF.count)
        
        let contaFilmOrdinati = contaFilm.sorted{ $0.ID_Film < $1.ID_Film }

        let filmWishListUtenteAttualeFOrdinati = filmWishListUtenteAttualeF.sorted{ $0.ID_Film < $1.ID_Film }
        
        let uguali = contaFilmOrdinati.elementsEqual(filmWishListUtenteAttualeFOrdinati, by: { $0.ID_Film == $1.ID_Film })

        print(uguali)
        
        if uguali == false{

            let recommender = Recommendation()

            (votiPredettiFilmTrovati, votiMediFilmTrovati) = recommender.recommendationSearch(utenteAttuale: utenteAttuale, filmTrovati: filmWishListUtenteAttualeF, filmVistiTotali: filmVistiTotali, filmDisponibili: filmDisponibili, utentiPresenti: utentiPresenti)

            
            collectionView.performBatchUpdates({
                for i in stride(from: contaFilm.count-1, to: 0, by: -1){
                    collectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
                }
                
            }, completion: nil)
            
            collectionView.performBatchUpdates({
                for i in 0..<filmWishListUtenteAttualeF.count{
                    collectionView.insertItems(at: [IndexPath(row: i, section: 0)])
                }
            }, completion: nil)
            
//            let newFilm = filmWishListUtenteAttualeF.count - contaFilm
//            print(newFilm)
//            collectionView.performBatchUpdates({
//
//                for i in stride(from: newFilm, to: 1, by: -1){
//                    collectionView.insertItems(at: [IndexPath(row: (filmWishListUtenteAttualeF.count - i), section: 0)])
//                }
//            }, completion: nil)
        }
        
        contaFilm = filmWishListUtenteAttualeF
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = tabBarController as! HomePage
        
        utenteAttuale = tabbar.utenteAttuale
        filmDisponibili = tabbar.filmDisponibili
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        filmVistiUtenteAttuale = tabbar.filmVistiUtenteAttuale
        filmVistiUtenteAttualeF = tabbar.filmVistiUtenteAttualeF
        utentiPresenti = tabbar.utentiPresenti
        
        let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "persona")
        attachement.bounds = iconsSize
        let attributeString = NSMutableAttributedString(string: "")
        attributeString.append(NSAttributedString(attachment: attachement))
        attributeString.append(NSAttributedString(string: "  "+utenteAttuale.nome!+" "+utenteAttuale.cognome!))
               
        utenteLogin.attributedText = attributeString
        
        for i in 0..<filmWishListUtenteAttuale.count{
            for j in 0..<filmDisponibili.count{
                if filmWishListUtenteAttuale[i].ID_Film == filmDisponibili[j].ID_Film{
                    filmWishListUtenteAttualeF.append(film(ID: filmWishListUtenteAttuale[i].ID_Film!, Tit: filmDisponibili[j].Titolo, Gen: filmDisponibili[j].Genere, Ann: filmDisponibili[j].Anno))
                }
            }
        }
        
        let recommender = Recommendation()

        (votiPredettiFilmTrovati, votiMediFilmTrovati) = recommender.recommendationSearch(utenteAttuale: utenteAttuale, filmTrovati: filmWishListUtenteAttualeF, filmVistiTotali: filmVistiTotali, filmDisponibili: filmDisponibili, utentiPresenti: utentiPresenti)

       contaFilm = filmWishListUtenteAttualeF

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmWishListUtenteAttualeF.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellWishList", for: indexPath) as! CollectionViewCellWishList
        
        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 20.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.02647465653717518, green: 0.17750251293182373, blue: 0.43236303329467773, alpha: 0.8179192342))
        
        cell.displayContent(image: UIImage(named: filmWishListUtenteAttualeF[indexPath.row].ID_Film)!, ID: filmWishListUtenteAttualeF[indexPath.row].ID_Film, title: filmWishListUtenteAttualeF[indexPath.row].Titolo, gen: filmWishListUtenteAttualeF[indexPath.row].Genere, anno: filmWishListUtenteAttualeF[indexPath.row].Anno, rat: String(votiPredettiFilmTrovati[indexPath.row]), ratAver: String(votiMediFilmTrovati[indexPath.row]))
        
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alertControllerDoveSalvare = UIAlertController(title: "", message: "", preferredStyle: .alert)

        //Visualizzo l'immagine
        let image = UIImage(named: "\(filmWishListUtenteAttuale[indexPath.row].ID_Film!).png")!
        alertControllerDoveSalvare.addImage(image: image)
        
        let saveAsSeen = UIAlertAction(title: "Segna come visto", style: .default)
        { _ in
            
            let alertControllerSegnaComeVisto = UIAlertController(title: "Inserisci un voto da 1 a 5", message: "", preferredStyle: .alert)

            alertControllerSegnaComeVisto.addTextField(configurationHandler: {(
                _ textField: UITextField) -> Void in
                
                textField.keyboardType = .asciiCapableNumberPad
                textField.textAlignment = .center
                textField.textColor = UIColor.red
            })
            
            let voteAction = UIAlertAction(title: "Vote", style: .default)
            { _ in
                
                //Salvo il voto inserito dall'utente
                let voto = alertControllerSegnaComeVisto.textFields?.first?.text ?? ""
                               
                //Se il voto non è valido non continuo
                if voto == "" || Int(voto)! < 1 || Int(voto)! > 5{
                                   
                    let alert = UIAlertController(title: "Voto inserito non corretto", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Continua", comment: "NO"), style: .destructive, handler: { _ in
                        NSLog("SI")
                    }))
                    print("Voto inserito non valido")
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    
                    let filmVisto = Visione()
                    filmVisto.ID_Film = self.filmWishListUtenteAttualeF[indexPath.row].ID_Film
                    filmVisto.Username = self.utenteAttuale.username
                    filmVisto.Valutazione = voto
                    
                    self.filmVistiTotali.append(filmVisto)
                    self.filmVistiUtenteAttuale.append(filmVisto)
                    self.filmVistiUtenteAttualeF.append(film(ID: filmVisto.ID_Film!, Tit: self.filmWishListUtenteAttualeF[indexPath.row].Titolo, Gen: self.filmWishListUtenteAttualeF[indexPath.row].Genere, Ann: self.filmWishListUtenteAttualeF[indexPath.row].Anno))
                    
                    //Rimuovo il film dalla wishList
                    let dataStore = Backendless.shared.data.of(Desiderio.self)
                    dataStore.removeBulk(whereClause: "ID_Film = '\(self.filmWishListUtenteAttuale[indexPath.row].ID_Film!)'", responseHandler: { (filmWishListRemoved) in
                        print("Film della WishList rimosso")
                    }, errorHandler: { fault in
                        print("Error: \(fault.message ?? "")")
                    })
                    
                    //Memorizzo il film come visto dall'utente attuale
                    let dataStoreSave = Backendless.shared.data.of(Visione.self)
                    dataStoreSave.save(entity: filmVisto, responseHandler: { (saveFilmVisto) in
                        print("Film visto aggiunto")
                    }, errorHandler: {fault in
                        print("Error: \(fault.message ?? "")")
                    })
                    
                    self.filmWishList.remove(at: self.filmWishList.firstIndex(of: self.filmWishListUtenteAttuale[indexPath.row])!)

                    self.filmWishListUtenteAttuale.remove(at: indexPath.row)
                    self.filmWishListUtenteAttualeF.remove(at: indexPath.row)
                    
                    let tabbar = self.tabBarController as! HomePage

                    tabbar.filmVistiTotali = self.filmVistiTotali
                    tabbar.filmVistiUtenteAttuale = self.filmVistiUtenteAttuale
                    tabbar.filmVistiUtenteAttualeF = self.filmVistiUtenteAttualeF
                    tabbar.filmWishList = self.filmWishList
                    tabbar.filmWishListUtenteAttuale = self.filmWishListUtenteAttuale
                    
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
                        
                    }, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            { _ in
                
    
            }
            
            alertControllerSegnaComeVisto.addAction(voteAction)
            alertControllerSegnaComeVisto.addAction(cancelAction)
            self.present(alertControllerSegnaComeVisto, animated: true, completion: nil)
        }
        
        let RemoveFromWishList = UIAlertAction(title: "Rimuovi dalla WishList", style: .default)
        { _ in
            
            //Rimuovo il film dalla wishList
            let dataStore = Backendless.shared.data.of(Desiderio.self)
            dataStore.removeBulk(whereClause: "ID_Film = '\(self.filmWishListUtenteAttuale[indexPath.row].ID_Film!)'", responseHandler: { (filmWishListRemoved) in
                print("Film della WishList rimosso")
            }, errorHandler: { fault in
                print("Error: \(fault.message ?? "")")
            })
            
            self.filmWishList.remove(at: self.filmWishList.firstIndex(of: self.filmWishListUtenteAttuale[indexPath.row])!)
            self.filmWishListUtenteAttuale.remove(at: indexPath.row)
            self.filmWishListUtenteAttualeF.remove(at: indexPath.row)
            
            let tabbar = self.tabBarController as! HomePage

            tabbar.filmWishList = self.filmWishList
            tabbar.filmWishListUtenteAttuale = self.filmWishListUtenteAttuale
            
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
                
            }, completion: nil)
            
                
            self.contaFilm.remove(at: indexPath.row)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        { _ in
            print("Cancel: dati non salvati")
        }
        
        alertControllerDoveSalvare.addAction(saveAsSeen)
        alertControllerDoveSalvare.addAction(RemoveFromWishList)
        alertControllerDoveSalvare.addAction(cancel)
        
        self.present(alertControllerDoveSalvare, animated: true, completion: nil)
    }
}
