import UIKit
import CSVImporter
import Backendless

class Search: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var utenteLogin: UILabel!
    @IBOutlet weak var filmDaCercare: UITextField!
    @IBOutlet weak var cerca: UIButton!
    
    private let fileFilmPath = Bundle.main.path(forResource: "movieDataset", ofType: "csv")
    
    var utentiPresenti: [Utente] = []
    var utenteAttuale = Utente()
    
    var filmDisponibiliPiccolo: [film] = []
    var filmDisponibili: [film] = []
    
    var filmVistiTotali: [Visione] = []
    var filmVistiUtenteAttuale: [Visione] = []
    var filmVistiUtenteAttualeF: [film] = []
    
    var filmWishList: [Desiderio] = []
    var filmWishListUtenteAttuale: [Desiderio] = []

    var filmTrovati: [film] = []
    
    var filmDaCerc: String = ""
    
    var votiPredettiFilmTrovati: [Float] = []
    var votiMediFilmTrovati: [Float] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let tabbar = tabBarController as! HomePage
        
        utenteAttuale = tabbar.utenteAttuale
        filmVistiTotali = tabbar.filmVistiTotali
        utentiPresenti = tabbar.utentiPresenti
        filmVistiUtenteAttuale = tabbar.filmVistiUtenteAttuale
        filmVistiUtenteAttualeF = tabbar.filmVistiUtenteAttualeF
        filmWishList = tabbar.filmWishList
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale

        let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
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
        utentiPresenti = tabbar.utentiPresenti
        filmVistiUtenteAttuale = tabbar.filmVistiUtenteAttuale
        filmVistiUtenteAttualeF = tabbar.filmVistiUtenteAttualeF
        filmWishList = tabbar.filmWishList
        filmWishListUtenteAttuale = tabbar.filmWishListUtenteAttuale

        let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "persona")
        attachement.bounds = iconsSize
        let attributeString = NSMutableAttributedString(string: "")
        attributeString.append(NSAttributedString(attachment: attachement))
        attributeString.append(NSAttributedString(string: "  "+utenteAttuale.nome!+" "+utenteAttuale.cognome!))
        
        utenteLogin.attributedText = attributeString
        
        readFilms()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmTrovati.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellSearch", for: indexPath) as! CollectionViewCellSearch

        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 20.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.02647465653717518, green: 0.17750251293182373, blue: 0.43236303329467773, alpha: 0.8179192342))
        
        if votiPredettiFilmTrovati[indexPath.row] == 6 && votiMediFilmTrovati[indexPath.row] == 0.0{
            cell.displayContent(image: UIImage(named: filmTrovati[indexPath.row].ID_Film)!, ID: filmTrovati[indexPath.row].ID_Film, title: filmTrovati[indexPath.row].Titolo, gen: filmTrovati[indexPath.row].Genere, anno: filmTrovati[indexPath.row].Anno, rat: String(votiPredettiFilmTrovati[indexPath.row]),ratAver: String(votiMediFilmTrovati[indexPath.row]))
        
        }
        else if votiPredettiFilmTrovati[indexPath.row] == 6 && votiMediFilmTrovati[indexPath.row] > 0.0{
            cell.displayContent(image: UIImage(named: filmTrovati[indexPath.row].ID_Film)!, ID: filmTrovati[indexPath.row].ID_Film, title: filmTrovati[indexPath.row].Titolo, gen: filmTrovati[indexPath.row].Genere, anno: filmTrovati[indexPath.row].Anno, rat: String(votiPredettiFilmTrovati[indexPath.row]),ratAver: String(votiMediFilmTrovati[indexPath.row]))
        }
        else{
            cell.displayContent(image: UIImage(named: filmTrovati[indexPath.row].ID_Film)!, ID: filmTrovati[indexPath.row].ID_Film, title: filmTrovati[indexPath.row].Titolo, gen: filmTrovati[indexPath.row].Genere, anno: filmTrovati[indexPath.row].Anno, rat: String(votiPredettiFilmTrovati[indexPath.row]), ratAver: String(votiMediFilmTrovati[indexPath.row]))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alertControllerDoveSalvare = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        //Visualizzo l'immagine
        let image = UIImage(named: "\(filmTrovati[indexPath.row].ID_Film).png")
        alertControllerDoveSalvare.addImage(image: image!)
        
        //Premendo su YES spermetto di votare all'utente
        let saveWishList = UIAlertAction(title: "Salva nella WishList", style: .default)
        { _ in
            
            let filmDaVedere = Desiderio()
            filmDaVedere.ID_Film = self.filmTrovati[indexPath.row].ID_Film
            filmDaVedere.Username = self.utenteAttuale.username
            
            let tabbar = self.tabBarController as! HomePage
            
            self.filmTrovati.remove(at: indexPath.row)
            self.filmWishList.append(filmDaVedere)
            self.filmWishListUtenteAttuale.append(filmDaVedere)
            
            tabbar.filmWishList = self.filmWishList
            tabbar.filmWishListUtenteAttuale = self.filmWishListUtenteAttuale
            
            collectionView.performBatchUpdates({
                print("DELETE")
                collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
                
            }, completion: nil)
            
            
            let dataStore = Backendless.shared.data.of(Desiderio.self)
            dataStore.save(entity: filmDaVedere, responseHandler: { (savedFilmDaVedere) in
                print("Film aggiunto alla wishlist")
            }, errorHandler: {fault in
                    print("Error: \(fault.message ?? "")")
            })
            
        }
        
        //Premendo su cancel non eseguo il salvataggio
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
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Continua", comment: "No"), style: .destructive, handler: { _ in
                         NSLog("SI")
                    }))
                    print("Voto inserito non valido")
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    
                    let filmVisto = Visione()
                    filmVisto.ID_Film = self.filmTrovati[indexPath.row].ID_Film
                    filmVisto.Username = self.utenteAttuale.username
                    filmVisto.Valutazione = voto
                    
                    self.filmVistiTotali.append(filmVisto)
                    self.filmVistiUtenteAttuale.append(filmVisto)
                    self.filmVistiUtenteAttualeF.append(film(ID: filmVisto.ID_Film!, Tit: self.filmTrovati[indexPath.row].Titolo, Gen: self.filmTrovati[indexPath.row].Genere, Ann: self.filmTrovati[indexPath.row].Anno))
                    
                    print(self.filmVistiUtenteAttuale.count)
                    print(self.filmVistiUtenteAttualeF.count)
                    
                    let tabbar = self.tabBarController as! HomePage

                    tabbar.filmVistiTotali = self.filmVistiTotali
                    tabbar.filmVistiUtenteAttuale = self.filmVistiUtenteAttuale
                    tabbar.filmVistiUtenteAttualeF = self.filmVistiUtenteAttualeF
                    
                    
                    self.filmTrovati.remove(at: indexPath.row)

                    collectionView.performBatchUpdates({
                        print("DELETE")
                        collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
                        
                    }, completion: nil)
                    
                    let dataStore = Backendless.shared.data.of(Visione.self)
                    dataStore.save(entity: filmVisto, responseHandler: { (saveFilmVisto) in
                        print("Film visto aggiunto")
                    }, errorHandler: {fault in
                            print("Error: \(fault.message ?? "")")
                    })
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            { _ in
                
            }
            
            alertControllerSegnaComeVisto.addAction(voteAction)
            alertControllerSegnaComeVisto.addAction(cancelAction)
            self.present(alertControllerSegnaComeVisto, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        { _ in
            print("Cancel: dati non salvati")
        }
        
        
        alertControllerDoveSalvare.addAction(saveWishList)//Attivo il bottone Vote
        alertControllerDoveSalvare.addAction(saveAsSeen)//Attivo il bottone Cancel
        alertControllerDoveSalvare.addAction(cancel)
        
        self.present(alertControllerDoveSalvare, animated: true, completion: nil)


    }
    
    func searchFilm(){
        
        for i in 0..<filmDisponibiliPiccolo.count{
            if filmDisponibiliPiccolo[i].Titolo.contains(filmDaCerc){
                //Verifico se il film in questione è gia stato visto o è stato inserito nella WishLIst
                var trovato = false
                for j in 0..<filmVistiUtenteAttuale.count{
                    if filmVistiUtenteAttuale[j].ID_Film == filmDisponibiliPiccolo[i].ID_Film{
                        trovato = true
                    }
                }
                for j in 0..<filmWishListUtenteAttuale.count{
                    if filmWishListUtenteAttuale[j].ID_Film == filmDisponibiliPiccolo[i].ID_Film{
                        trovato = true
                    }
                }
                
                if trovato == false{
                    filmTrovati.append(film(ID: filmDisponibili[i].ID_Film, Tit: filmDisponibili[i].Titolo, Gen: filmDisponibili[i].Genere, Ann: filmDisponibili[i].Anno))
                }
            }
        }
        
        let recommendation = Recommendation()
        
        (votiPredettiFilmTrovati, votiMediFilmTrovati) = recommendation.recommendationSearch(utenteAttuale: utenteAttuale, filmTrovati: filmTrovati, filmVistiTotali: filmVistiTotali, filmDisponibili: filmDisponibili, utentiPresenti: utentiPresenti)
        
        
        print("I voti medi dei film cercati sono:  ",votiMediFilmTrovati)
        
        print("I voti predetti dei film cercati sono:  ",votiPredettiFilmTrovati)
        print("\n\n")
        
    }
    
    func readFilms(){
        
        let importer = CSVImporter<[String]>(path: fileFilmPath!)
        let record = importer.importRecords{$0}
        for rec in record{
            //Salvo SOLO l'anno del film
            var annoFilm = rec[1].suffix(5)
            annoFilm = annoFilm.prefix(4)
                           
            //Salvo SOLO il titolo del film
            var newTitolo = rec[1]
            newTitolo.removeLast(6)
            let newTitoloPiccolo = newTitolo.lowercased()
                       
            let genereRicevuto = Array(rec[2])
            var genereFixed = ""
                
            for i in 0..<genereRicevuto.count{
                if genereRicevuto[i] != "|"{
                    genereFixed.append(genereRicevuto[i])
                }
                else{
                    genereFixed.append(" ")
                    genereFixed.append("--")
                    genereFixed.append(" ")
                    }
            }
            //Salvo nell' affay Film i film nel formato ID, Titolo, Genere, Anno
            filmDisponibiliPiccolo.append(film(ID: rec[0], Tit: newTitoloPiccolo, Gen: genereFixed, Ann: String(annoFilm)))
            filmDisponibili.append(film(ID: rec[0], Tit: newTitolo, Gen: genereFixed, Ann: String(annoFilm)))
            
        }
    }
    
    @IBAction func search(_ sender: Any) {
                
        filmTrovati.removeAll()
        votiPredettiFilmTrovati.removeAll()
        
        filmDaCerc = filmDaCercare.text!
        filmDaCerc = filmDaCerc.lowercased()
        
        searchFilm()
                
        collectionView.performBatchUpdates({
            for i in 0..<filmTrovati.count{
                
                collectionView.insertItems(at: [IndexPath(row: i, section: 0)])
            }
        }, completion: nil)
    }
}
