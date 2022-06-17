import UIKit
import Backendless

class Signin: UIViewController, UITextFieldDelegate {
    
    var utentiPresenti: [Utente] = []
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var cognome: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confermaPassword: UITextField!
    @IBOutlet weak var eta: UITextField!
    @IBOutlet weak var sesso: UISegmentedControl!
    
    //Variabile in cui memorizzo l'utente che ha effettuato il login
    private var utenteAttuale = Utente()
    
    @IBAction func registrati(_ sender: Any) {
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.nome.delegate = self //Serve per richiamare la func textField per far inserire solo caratteri
        self.cognome.delegate = self //Serve per richiamare la func textField per far inserire solo caratteri
    
    }
    
    //Tramite questa funzione l'utente nel campo nome e cognome può inserire solo caratteri
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        let typedCharactersSet = CharacterSet(charactersIn: string)
        return set.isSuperset(of: typedCharactersSet)
    }
    
    //Scelta sesso utente
    @IBAction func indexChanged(_ sender: Any) {
         
         switch sesso.selectedSegmentIndex
         {
            case 0:
                utenteAttuale.sesso = "M"
            case 1:
                utenteAttuale.sesso = "F"
            default:
                break
            }
        }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == UIPress.PressType.menu{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseUserType") as! ChooseUserType
            self.present(newViewController, animated: true, completion: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        // Se sono presenti campi vuoti
                if nome.text == "" || cognome.text == "" || username.text == "" || password.text == "" || confermaPassword.text == "" || eta.text == ""{
                    
                    let alert = UIAlertController(title: "", message: "Sono presenti alcuni campi vuoti", preferredStyle: .alert)
                    
                                  alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "NO"), style: .default, handler: { _ in
                                      NSLog("SI")
                                    
                                  }))
                    
                                  self.present(alert, animated: true, completion: nil)
                    
                }
                    
                // Altrimenti verifico se le password inserite sono diverse
                else if confermaPassword.text != password.text{
                        
                        let alert = UIAlertController(title: "", message: "Le password non corrispondono", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "NO"), style: .default, handler: { _ in
                            NSLog("SI")
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                //Verifico se l'età inserita è diversa da null
                else{
                    
                    let age : Int = Int(eta.text!)!//Salvo l'età
                
                    //Se l'età non è consentita stampo l'alert
                    if age <= 14 || age >= 99 {
                        let alert = UIAlertController(title: "", message: "L'età inserita deve essere compresa tra 14 e 99", preferredStyle: .alert)
                    
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "NO"), style: .default, handler: { _ in
                        NSLog("SI")
                        }))
                    
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    //Se l'età è consentita verifico se l'utente inserito non è già presente
                    else{
                
                        var usTrovato = false
                        for index in 0..<self.utentiPresenti.count{
                            if self.username.text == self.utentiPresenti[index].username{
                                usTrovato = true
                            }
                        }
                        
                        //Se anche l'username è corretta continuo con la registrazione
                        if usTrovato == false{
                            
                            self.utenteAttuale.nome = self.nome.text
                            self.utenteAttuale.cognome = self.cognome.text
                            self.utenteAttuale.username = self.username.text
                            self.utenteAttuale.password = self.password.text
                            self.utenteAttuale.eta =  self.eta.text
                            self.utentiPresenti.append(utenteAttuale)
                                                                                         
                            let dataStore = Backendless.shared.data.of(Utente.self)
                            dataStore.save(entity: self.utenteAttuale, responseHandler: { (savedutente) in
                                print("Utente salvato")
                            }, errorHandler: {fault in
                                    print("Error: \(fault.message ?? "")")
                            })
                    
                        }

                        //Altrimenti se l'username è già presente stampo un alert
                        else{
                            let alert = UIAlertController(title: "", message: "Username inserito già esistente", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "NO"), style: .default, handler: { _ in
                                NSLog("SI")
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
            }
        
        //Invio i dati alla classe NewUserIntro
        let NewUserIntro = segue.destination as! NewUserIntro
        NewUserIntro.utenteAttuale = utenteAttuale
        NewUserIntro.utentiPresenti = utentiPresenti
    }
}
