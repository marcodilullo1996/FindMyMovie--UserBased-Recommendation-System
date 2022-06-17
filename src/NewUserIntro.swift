import Foundation
import Backendless
import UIKit
import CSVImporter

class NewUserIntro: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let fileFilmPath = Bundle.main.path(forResource: "movieDataset", ofType: "csv")
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var utenteLogin: UILabel!
    //Variabile in cui memorizzo l'utente che ha effettuato la registrazione, ricevuto da SIGNIN
    var utenteAttuale = Utente()
    
    //Array in cui memorizzo tutti gli utenti presenti
    var utentiPresenti: [Utente] = []

    //Array in cui memorizziamo tutti i film presenti
    var filmDisponibili: [film] = []
    
    var indexFilm: [Int] = []
    
    var filmScelti: [Visione] = []
    var filmVistiTotali: [Visione] = []
    
    var filmWishList: [Desiderio] = []

    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        if utenteAttuale.nome == nil{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Signin") as! Signin
            self.present(newViewController, animated: true, completion: nil)
        }
        else{
            let iconsSize = CGRect(x: 0, y: -5, width: 33, height: 33)
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "persona")
            attachement.bounds = iconsSize
            let attributeString = NSMutableAttributedString(string: "")
            attributeString.append(NSAttributedString(attachment: attachement))
            attributeString.append(NSAttributedString(string: "  "+utenteAttuale.nome!+" "+utenteAttuale.cognome!))
            
            utenteLogin.attributedText = attributeString
            
            readFilms()
            
            print(filmDisponibili.count)
            
            //Determino in modo casuale gli indici dei film da mostrare all'utente in modo casuale
            for _ in 0..<15{
                var index = Int.random(in: 0 ..< filmDisponibili.count - 1)
                while indexFilm.contains(index){
                    index = Int.random(in: 0 ..< filmDisponibili.count - 1)
                }
                indexFilm.append(index)
            }
            
            readFromDB()
        }
    }
    
    //Funzione a cui indico quante collectionView voglio avere
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexFilm.count
    }
    
    //Funzione per visualizzare la cella
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 20.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.02647465653717518, green: 0.17750251293182373, blue: 0.43236303329467773, alpha: 0.8179192342))
        
        cell.displayContent(image: UIImage(named: filmDisponibili[indexFilm[indexPath.row]].ID_Film)!, ID: filmDisponibili[indexFilm[indexPath.row]].ID_Film, title: filmDisponibili[indexFilm[indexPath.row]].Titolo, gen: filmDisponibili[indexFilm[indexPath.row]].Genere, anno: filmDisponibili[indexFilm[indexPath.row]].Anno)
        
        var trovato = false
        var stelle = "1234"
        for i in 0..<filmScelti.count{
            if filmScelti[i].ID_Film == filmDisponibili[indexFilm[indexPath.row]].ID_Film{
                trovato = true
                stelle = filmScelti[i].Valutazione!
            }
        }
        
        cell.drawStar(trovato: trovato, stelle: stelle)
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let HomePage = segue.destination as! HomePage
        HomePage.utenteAttuale = utenteAttuale
        HomePage.filmVistiTotali = filmVistiTotali
        HomePage.utentiPresenti = utentiPresenti
        HomePage.filmWishList = filmWishList
        
    }
    
    @IBAction func next(_ sender: Any) {
        for i in 0..<filmScelti.count{
            filmVistiTotali.append(filmScelti[i])
            let dataStore = Backendless.shared.data.of(Visione.self)
            dataStore.save(entity: filmScelti[i], responseHandler: { (savedVisione) in
                print("Visioni salvate")
            }, errorHandler: {fault in
                    print("Error: \(fault.message ?? "")")
            })
        }
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
            filmDisponibili.append(film(ID: rec[0], Tit: newTitolo, Gen: genereFixed, Ann: String(annoFilm)))
        }
        
    }
    
    func readFromDB(){
        
        for i in 0..<utentiPresenti.count{
            
            let queryBuilder = DataQueryBuilder()
            let whereClause = "Username = "+"'"+utentiPresenti[i].username!+"'"
            queryBuilder.setWhereClause(whereClause: whereClause)
            queryBuilder.setPageSize(pageSize: 100)
            let dataStore = Backendless.shared.data.of(Visione.self)
            
            dataStore.find(queryBuilder: queryBuilder, responseHandler:{ foundObjects in
                
                for f in 0..<foundObjects.count{
                    self.filmVistiTotali.append((foundObjects as! [Visione])[f])
                }
            
            }, errorHandler: { fault in
                print("Error: \(fault.message ?? "")")
            })
        }
    }
    
    func readFromDBWishList(){
        
        for i in 0..<utentiPresenti.count{
            
            //leggiamo dal DB tutte le visioni effettuate dagli utenti
            let queryBuilder = DataQueryBuilder()
            let whereClause = "Username = "+"'"+utentiPresenti[i].username!+"'"
            queryBuilder.setWhereClause(whereClause: whereClause)
            queryBuilder.setPageSize(pageSize: 100)
                        
            let dataStore = Backendless.shared.data.of(Desiderio.self)
        
            dataStore.find(queryBuilder: queryBuilder, responseHandler:{ foundObjects in
                
                for f in 0..<foundObjects.count{
                    self.filmWishList.append((foundObjects as! [Desiderio])[f])
                }
            
            }, errorHandler: { fault in
                print("Error: \(fault.message ?? "")")
            })
            
        }
    }
}

extension NewUserIntro: CollectionViewCellDelegate{
    
    func didPressedVoto1(id: String) {
        
        if filmScelti.count == 0{
            for i in 0..<filmDisponibili.count{
                if filmDisponibili[i].ID_Film == id{
                    let oggetto = Visione()
                    oggetto.ID_Film = filmDisponibili[i].ID_Film
                    oggetto.Username = utenteAttuale.username!
                    oggetto.Valutazione = "1"
                    filmScelti.append(oggetto)
                }
            }
        }
        else{
            var filmTrovato = false
            for i in 0..<filmScelti.count{
                if filmScelti[i].ID_Film == id{
                    filmTrovato = true
                    filmScelti[i].Valutazione = "1"
                }
            }
            
            if filmTrovato == false{
                for i in 0..<filmDisponibili.count{
                    if filmDisponibili[i].ID_Film == id{
                        let oggetto = Visione()
                        oggetto.ID_Film = filmDisponibili[i].ID_Film
                        oggetto.Username = utenteAttuale.username!
                        oggetto.Valutazione = "1"
                        filmScelti.append(oggetto)
                    }
                }
            }
        }
        
        print("film")
        for i in 0..<filmScelti.count{
            print(filmScelti[i].ID_Film!," ",filmScelti[i].Valutazione!)
        }
        
        print("\n")
    }
    
    func didPressedVoto2(id: String) {
        if filmScelti.count == 0{
            for i in 0..<filmDisponibili.count{
                if filmDisponibili[i].ID_Film == id{
                    let oggetto = Visione()
                    oggetto.ID_Film = filmDisponibili[i].ID_Film
                    oggetto.Username = utenteAttuale.username!
                    oggetto.Valutazione = "2"
                    filmScelti.append(oggetto)
                }
            }
        }
        else{
            var filmTrovato = false
            for i in 0..<filmScelti.count{
                if filmScelti[i].ID_Film == id{
                    filmTrovato = true
                    filmScelti[i].Valutazione = "2"
                }
            }
            
            if filmTrovato == false{
                for i in 0..<filmDisponibili.count{
                    if filmDisponibili[i].ID_Film == id{
                        let oggetto = Visione()
                        oggetto.ID_Film = filmDisponibili[i].ID_Film
                        oggetto.Username = utenteAttuale.username!
                        oggetto.Valutazione = "2"
                        filmScelti.append(oggetto)
                    }
                }
            }
        }
        
        for i in 0..<filmScelti.count{
            print(filmScelti[i].ID_Film!," ",filmScelti[i].Valutazione!)
        }
        print("\n")
    
    }
    
    func didPressedVoto3(id: String) {
        
        if filmScelti.count == 0{
            for i in 0..<filmDisponibili.count{
                if filmDisponibili[i].ID_Film == id{
                    let oggetto = Visione()
                    oggetto.ID_Film = filmDisponibili[i].ID_Film
                    oggetto.Username = utenteAttuale.username!
                    oggetto.Valutazione = "3"
                    filmScelti.append(oggetto)
                }
            }
        }
        else{
            var filmTrovato = false
            for i in 0..<filmScelti.count{
                if filmScelti[i].ID_Film == id{
                    filmTrovato = true
                    filmScelti[i].Valutazione = "3"
                }
            }
            
            if filmTrovato == false{
                for i in 0..<filmDisponibili.count{
                    if filmDisponibili[i].ID_Film == id{
                        let oggetto = Visione()
                        oggetto.ID_Film = filmDisponibili[i].ID_Film
                        oggetto.Username = utenteAttuale.username!
                        oggetto.Valutazione = "3"
                        filmScelti.append(oggetto)
                    }
                }
            }
        }
        
        for i in 0..<filmScelti.count{
            print(filmScelti[i].ID_Film!," ",filmScelti[i].Valutazione!)
        }
        print("\n")

    }
    
    func didPressedVoto4(id: String) {
        
        if filmScelti.count == 0{
            for i in 0..<filmDisponibili.count{
                if filmDisponibili[i].ID_Film == id{
                    let oggetto = Visione()
                    oggetto.ID_Film = filmDisponibili[i].ID_Film
                    oggetto.Username = utenteAttuale.username!
                    oggetto.Valutazione = "4"
                    filmScelti.append(oggetto)
                }
            }
        }
        else{
            var filmTrovato = false
            for i in 0..<filmScelti.count{
                if filmScelti[i].ID_Film == id{
                    filmTrovato = true
                    filmScelti[i].Valutazione = "4"
                }
            }
            
            if filmTrovato == false{
                for i in 0..<filmDisponibili.count{
                    if filmDisponibili[i].ID_Film == id{
                        let oggetto = Visione()
                        oggetto.ID_Film = filmDisponibili[i].ID_Film
                        oggetto.Username = utenteAttuale.username!
                        oggetto.Valutazione = "4"
                        filmScelti.append(oggetto)
                    }
                }
            }
        }
        
        for i in 0..<filmScelti.count{
            print(filmScelti[i].ID_Film!," ",filmScelti[i].Valutazione!)
        }
        print("\n")

    }
    
    func didPressedVoto5(id: String) {
        
        if filmScelti.count == 0{
            for i in 0..<filmDisponibili.count{
                if filmDisponibili[i].ID_Film == id{
                    let oggetto = Visione()
                    oggetto.ID_Film = filmDisponibili[i].ID_Film
                    oggetto.Username = utenteAttuale.username!
                    oggetto.Valutazione = "5"
                    filmScelti.append(oggetto)
                }
            }
        }
        else{
            var filmTrovato = false
            for i in 0..<filmScelti.count{
                if filmScelti[i].ID_Film == id{
                    filmTrovato = true
                    filmScelti[i].Valutazione = "5"
                }
            }
            
            if filmTrovato == false{
                for i in 0..<filmDisponibili.count{
                    if filmDisponibili[i].ID_Film == id{
                        let oggetto = Visione()
                        oggetto.ID_Film = filmDisponibili[i].ID_Film
                        oggetto.Username = utenteAttuale.username!
                        oggetto.Valutazione = "5"
                        filmScelti.append(oggetto)
                    }
                }
            }
        }
    }
}
