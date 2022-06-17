import Foundation
import Backendless
import CSVImporter

class Login: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //Array in cui memorizziamo tutti gli utenti presenti nel DB, ricevuti da CHOOSEUSERTYPE
    var utentiPresenti: [Utente] = []
    
    //Array in cui memorizziamo tutte le visioni effettuate dagli utenti
    var filmVistiTotali: [Visione] = []
    
    var filmWishList: [Desiderio] = []
    
    //Variabile in cui memorizziamo l'utente che ha effettuato il login
    var utenteAttuale: Utente = Utente()
    
    override func viewDidLoad() {
        
        readFromDB()
        
        readFromDBWishList()
        
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == UIPress.PressType.menu{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseUserType") as! ChooseUserType
            self.present(newViewController, animated: true, completion: nil)
        }
    }

    @IBAction func login(_ sender: Any) {
        
        if username.text == "" || password.text == ""{
    
            let alert = UIAlertController(title: "", message: "Riempire tutti i campi", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "NO"), style: .default, handler: { _ in
                NSLog("SI")
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            var usTrovato = false
            
            //Verifico se l'username e la password inseriti sono presenti del DB
            for index in 0..<self.utentiPresenti.count{
                if self.username.text == self.utentiPresenti[index].username && self.password.text == self.utentiPresenti[index].password{
                    utenteAttuale = self.utentiPresenti[index]
                    usTrovato = true
                }
            }

            //Altrimenti avverto l'utente che ha inserito dei dati sbagliati
            if usTrovato == false{
                let alert = UIAlertController(title: "", message: "Username o password errati", preferredStyle: .alert)
                               
                               alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "NO"), style: .default, handler: { _ in
                                   NSLog("SI")
                               }))
                               self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Inviamo ad HOMEPAGE2 l'utente che attualmente si è connesso e le visioni effettuate dagli utenti
        let homePage = segue.destination as! HomePage
        homePage.utenteAttuale = utenteAttuale
        homePage.filmVistiTotali = filmVistiTotali
        homePage.utentiPresenti = utentiPresenti
        homePage.filmWishList = filmWishList
    }
    
    func readFromDB(){
        
        for i in 0..<utentiPresenti.count{
            
            //leggiamo dal DB tutte le visioni effettuate dagli utenti
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
