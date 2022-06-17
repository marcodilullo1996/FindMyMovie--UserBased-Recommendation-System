import UIKit
import Backendless
import CSVImporter

class ChooseUserType: UIViewController {
    
    //Variabile per memorizzare tutti gli utenti presenti nel DB
    public var utentiPresenti: [Utente] = []

    //Variabile utilizzata per memorizzare se l'utente ha scelto di loggarsi o di registrarsi
    private var sceltaUtente: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Controllo sulla connessione(Controllo obbligatorio)
        if connectionDatabase() == true{
            print("Connessione effettuata")
        }
        else{
            print("Connessione non effettuata")

            return
        }
        
        readFromDB()
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Se l'utente ha scelto di loggarsi
        if sceltaUtente == 1{
            let Login = segue.destination as! Login
            Login.utentiPresenti = utentiPresenti
        }
        
        //Se l'utente ha scelto di registrarsi
        else if sceltaUtente == 2{
            let Signin = segue.destination as! Signin
            Signin.utentiPresenti = utentiPresenti
        }
    }
    
    @IBAction func Login(_ sender: Any) {
        sceltaUtente = 1
    }
    
    @IBAction func Signin(_ sender: Any) {
        sceltaUtente = 2
    }
        
    
    //Funzione per connettersi al database
    func connectionDatabase() -> Bool{
        
        let API_HOST = "https://api.backendless.com"
        let APP_ID = "25646D25-87C2-524F-FFF2-AFFECC7DCD00"
        let API_KEY = "816D84DA-F62C-6E60-FF55-6B4DAEEA7F00"
        
        Backendless.shared.hostUrl = API_HOST
        Backendless.shared.initApp(applicationId: APP_ID, apiKey: API_KEY)
        
        if (Backendless.shared.getApiKey() == "816D84DA-F62C-6E60-FF55-6B4DAEEA7F00"){
            return true
        }
        else{
            return false
            }
    }
    
    func readFromDB(){
        //Ricevo dal DB tutti gli utenti presenti
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 100)
        let dataStore = Backendless.shared.data.of(Utente.self)
        dataStore.find(queryBuilder: queryBuilder, responseHandler:{ foundObjects in
            
            print("CHOOSEUSERTYPE----Oggetti totali->" , foundObjects.count)

            for f in 0..<foundObjects.count{
                self.utentiPresenti.append((foundObjects as! [Utente])[f])
            }
        
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
    }
}

