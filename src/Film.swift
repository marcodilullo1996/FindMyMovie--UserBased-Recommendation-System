import Foundation

class film{
    var ID_Film : String
    var Titolo : String
    var Genere: String
    var Anno: String
    
    
    init(ID: String, Tit: String, Gen: String,Ann: String) {
        self.ID_Film = ID
        self.Titolo = Tit
        self.Genere = Gen
        self.Anno = Ann
    }
    
}
