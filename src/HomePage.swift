import UIKit
import CSVImporter
import Backendless

class HomePage: UITabBarController {
    
    
    private let fileFilmPath = Bundle.main.path(forResource: "movieDataset", ofType: "csv")

    var utentiPresenti: [Utente] = []
    
    //Array in cui memorizziamo tutti i film presenti
    var filmDisponibili: [film] = []
    
    //Array in cui memorizziamo tutte le visioni effettuate dagli utenti, ricevuto da LOGIN o da NEWUSERINTRO
    var filmVistiTotali: [Visione] = []
    //Array in cui memorizzo tutte le visioni effettuate dall'utente connesso
    var filmVistiUtenteAttuale: [Visione] = []
    var filmVistiUtenteAttualeF: [film] = []
    
    var filmWishList: [Desiderio] = []
    var filmWishListUtenteAttuale: [Desiderio] = []
    
    //Variabile in cui memorizziamo l'utente che ha effettuato il login, ricevuto da LOGIN o da NEWUSERINTRO
    var utenteAttuale = Utente()
        
    //Oggetto che rappresenta l'item della TabBar
    var item = UITabBarItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        readFilms()
        
        //Controlliamo quali sono i film visti dall'utente che ha effettuato il login
        for i in 0..<filmVistiTotali.count{
            if filmVistiTotali[i].Username == utenteAttuale.username{
                for j in 0..<filmDisponibili.count{
                    if filmDisponibili[j].ID_Film == filmVistiTotali[i].ID_Film{
                        filmVistiUtenteAttuale.append(filmVistiTotali[i])
                        filmVistiUtenteAttualeF.append(film(ID: filmDisponibili[j].ID_Film, Tit: filmDisponibili[j].Titolo, Gen: filmDisponibili[j].Genere, Ann: filmDisponibili[j].Anno))
                    }
                }
            }
        }
        
        for i in 0..<filmWishList.count{
            if filmWishList[i].Username == utenteAttuale.username{
                filmWishListUtenteAttuale.append(filmWishList[i])
            }
        }
       
        if utenteAttuale.nome == nil{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
            self.present(newViewController, animated: true, completion: nil)
        }
        else{
            
            let deSelectedImage1 = UIImage(named: "home")
            item = self.tabBar.items![0]
            item.title = "Home"
            item.image = deSelectedImage1
            
            let deSelectedImage2 = UIImage(named: "suggestions")
            item = self.tabBar.items![1]
            item.title = "Suggestions"
            item.image = deSelectedImage2
            
            let deSelectedImage3 = UIImage(named: "search")
            item = self.tabBar.items![2]
            item.title = "Search"
            item.image = deSelectedImage3
            
            let deSelectedImage4 = UIImage(named: "wishlist")
            item = self.tabBar.items![3]
            item.title = "Wishlist"
            item.image = deSelectedImage4

            self.selectedIndex = 0
            
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
}
