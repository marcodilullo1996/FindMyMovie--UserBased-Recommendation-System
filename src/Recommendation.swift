import Foundation
import Backendless

class Recommendation{
    
    private var MINSIMILARITY: Float = 0.84
    
    private var utenteAttuale = Utente()
    private var utentiOrdinati: [Utente] = []
    private var filmDisponibili: [film] = []
    private var filmWishListUtenteAttuale: [Desiderio] = []
    private var medieVotoUtenti: [Float] = []
    private var USER_MATRIX: [[Int]] = []
    private var USER_USER_MATRIX: [[Somiglianza]] = []
    private var somiglianzeKUtenteSimili: [Somiglianza] = []
    private var predictionVotesFilmResearch: [Float] = []
    private var averageRatingFilmResearch: [Float] = []
    private var predictionVotesAdvice: [Float] = []
    private var predictionVotesAdviceID_Film: [String] = []
    private var VotesType: [String] = []

    init() {
        
    }
    
    func inizializza(){
        utentiOrdinati.removeAll()
        filmDisponibili.removeAll()
        filmWishListUtenteAttuale.removeAll()
        medieVotoUtenti.removeAll()
        USER_MATRIX.removeAll()
        USER_USER_MATRIX.removeAll()
        somiglianzeKUtenteSimili.removeAll()
        predictionVotesFilmResearch.removeAll()
        averageRatingFilmResearch.removeAll()
        predictionVotesAdvice.removeAll()
        predictionVotesAdviceID_Film.removeAll()
        
        
    }
    
    func recommendationAdvice(utenteAttuale: Utente,filmVistiTotali: [Visione], filmDisponibili: [film], utentiPresenti: [Utente], filmWishListUtenteAttuale: [Desiderio])->([Float],[String],[String]){
        
        self.utenteAttuale = utenteAttuale

        self.utentiOrdinati = utentiPresenti.sorted{ $0.username!.lowercased() < $1.username!.lowercased()}

        self.filmDisponibili = filmDisponibili
        self.filmWishListUtenteAttuale = filmWishListUtenteAttuale
        
        print(filmWishListUtenteAttuale.count)
        
        createUserMatrix(filmVistiTotali: filmVistiTotali)
        
        let contaFilmVisti = checkFilmsSeen()
        
        if (contaFilmVisti > 30){
            calcoloMedieVotoUtenti()
            createUserUserMatrix()
            printUSERUSERMATRIX()
            determinaKUtentiSimili()
            printKSimilarUser()
            predictVoteUserAdvice(filmVistiTotali: filmVistiTotali,contaFilmVisti: contaFilmVisti)
        }
        else{
            calcoloMedieVotoUtenti()
            createUserUserMatrix()
            printUSERUSERMATRIX()
            printKSimilarUser()
            predictVoteUserAdvice(filmVistiTotali: filmVistiTotali,contaFilmVisti: contaFilmVisti)
        }
        
        return (predictionVotesAdvice, predictionVotesAdviceID_Film, VotesType)
        
    }

    func recommendationSearch(utenteAttuale: Utente,filmTrovati: [film],filmVistiTotali: [Visione], filmDisponibili: [film], utentiPresenti: [Utente])->([Float],[Float]){

        self.utenteAttuale = utenteAttuale

        self.utentiOrdinati = utentiPresenti.sorted{ $0.username!.lowercased() < $1.username!.lowercased()}

        self.filmDisponibili = filmDisponibili

        createUserMatrix(filmVistiTotali: filmVistiTotali)

//        printUSERMATRIX()

        calcoloMedieVotoUtenti()

        createUserUserMatrix()

//        printUSERUSERMATRIX()

        determinaKUtentiSimili()

//        printKSimilarUser()

        predictVoteUserSearch(filmTrovati: filmTrovati)

        averageRatingSearch(filmTrovati: filmTrovati, filmVistiTotali: filmVistiTotali, filmDisponibili: filmDisponibili)

        //Una volta che sono stati predetti i voti e sono stati calcolati i voti medi, vengono restituiti
        return (predictionVotesFilmResearch, averageRatingFilmResearch)
    }
    

    private func createUserMatrix(filmVistiTotali: [Visione]){

        for u in 0..<utentiOrdinati.count{

            //Array utilizzato per memorizzare tutti i vogli dell'utente u
            var array: [Int] = []

            //Ottengo gli identificativi dei film visti dall'utente U, con le informazioni riguardanti quei film
            let (idFilmU, fVU) = determinaFilmVistiUtenteU(utente: utentiOrdinati[u], filmVistiTotale: filmVistiTotali)

            //Ordino gli identificiativi
            let identificativiFilmVistiU = idFilmU.sorted()

            //Creo un vettore in cui inserisco le informazioni dei film visti, ma con i campi ID_Film e Valutazioni di tipo INT, in modo da poterli gestire nei calcoli successivi
            var filmVU: [VisioneInt] = []

            for f in 0..<fVU.count{
                filmVU.append(VisioneInt(us: fVU[f].Username!, ID: Int(fVU[f].ID_Film!)!, Val: Int(fVU[f].Valutazione!)!))
            }

            //Ordino le informazioni sui film visti in base all'ID del film
            let filmVistiU = filmVU.sorted{ $0.ID_Film! < $1.ID_Film!}

            //Richiamiamo la function per stampare tutti i film visti dall'utente U
//            printFilmVisti(utenteU: utentiOrdinati[u],filmVistiU: filmVistiU,identificativiFilmVistiU: identificativiFilmVistiU)

            //Per ogni film f disponibile verifichiamo il voto assegnato dall'utente U ad esso, inserendolo poi in un array che, quando completo, sarà inserito nella USER_MATRIX
            for f in 0..<filmDisponibili.count{
                let voto = verificaVoto(filmDaCercare: filmDisponibili[f], identificativiFilmVistiU: identificativiFilmVistiU, filmVistiU: filmVistiU)

                array.append(voto)
            }
            USER_MATRIX.append(array)
        }
    }

    private func createUserUserMatrix(){

        for u in 0..<USER_MATRIX.count{

            var numeratore: Float = 0.0
            var denominatore: [Float] = [0.0,0.0]
            var somiglianze: [Somiglianza] = []

            for ut in 0..<USER_MATRIX.count{
                numeratore = 0.0
                denominatore[0] = 0.0
                denominatore[1] = 0.0

                for v in 0..<filmDisponibili.count{
                    if USER_MATRIX[u][v] != 0 && USER_MATRIX[ut][v] != 0{
                        numeratore = numeratore + Float((USER_MATRIX[u][v] * USER_MATRIX[ut][v]))
                        
                    }
                    
                    denominatore[0] = denominatore[0] + Float((USER_MATRIX[u][v] * USER_MATRIX[u][v]))
                    denominatore[1] = denominatore[1] + Float((USER_MATRIX[ut][v] * USER_MATRIX[ut][v]))
                }

                denominatore[0] = sqrtf(denominatore[0])
                denominatore[1] = sqrtf(denominatore[1])

                if numeratore == 0 && denominatore[0] == 0 && denominatore[1] == 0{
                    somiglianze.append(Somiglianza(us: utentiOrdinati[ut].username!, sim: 0))
                }
                else if numeratore == 0 && (denominatore[0] == 0 || denominatore[1] == 0) {
                    somiglianze.append(Somiglianza(us: utentiOrdinati[ut].username!, sim: 0))
                }
                else{
                    let x = numeratore / (denominatore[0] * denominatore[1])
                    let y = Float(round(x * 1000000) / 1000000)
                    somiglianze.append(Somiglianza(us: utentiOrdinati[ut].username!, sim: y))
                }
            }
            USER_USER_MATRIX.append(somiglianze)
        }
    }

    private func calcoloMedieVotoUtenti(){

        for u in 0..<utentiOrdinati.count{
            var media: Float = 0.0
            var contaFilm = 0
            for f in 0..<USER_MATRIX[u].count{
                if USER_MATRIX[u][f] != 0{
                    media = media + Float(USER_MATRIX[u][f]);
                    contaFilm+=1
                }
            }
            medieVotoUtenti.append(media / Float(contaFilm))
        }

        print("LE MEDIE VOTO SONO: ",terminator:"")
        for u in 0..<medieVotoUtenti.count{
            print(medieVotoUtenti[u],terminator:" ")
        }
        print("\n")

    }

    private func determinaKUtentiSimili(){

        //Ottengo l'indice nel vettore degli utenti ordinati dell'utente per il quale voglio raccomandare
        //Con questo indice, mi posizione nella USER_USER_MATRIX e prendo il vettore delle similarità per l'utente in questione
        let similarityArrayUser = USER_USER_MATRIX[utentiOrdinati.firstIndex(of: utenteAttuale)!]

        //Ordino il vettore delle similarità
        var sorted = similarityArrayUser.sorted{ $0.similarity < $1.similarity}

        //Flag che mi identifica se iniziare la ricerca o meno
        var needToFind = true

        //Se è presente un solo utente, non ci saranno altri utenti simili, quindi non inizio la ricerca
        if utentiOrdinati.count == 1{
            needToFind = false
        }

        //Nel caso in cui è necessario iniziare la ricerca
        if needToFind == true{

            //Continuo fino a quando non trovo un indice di similarità minore della soglia.
            var endResearch = false
            while endResearch == false{
                //Nel caso in cui l'ultimo elemento sia la similarità con se stesso, rimuovo semplicemente l'ultimo elemento
                if sorted.last!.similarity == 1 && sorted.last!.usernameOtherUser == utenteAttuale.username{
                    sorted.removeLast()
                }
                //Nel caso in cui invece l'indice non fa riferimento alla similarità con se stesso, verifico se è maggiore di una certa soglia.
                //In questo caso aggiungo l'indice all'array e lo rimuovo
                else if sorted.last!.similarity > MINSIMILARITY && somiglianzeKUtenteSimili.count < 4{
                    somiglianzeKUtenteSimili.append(sorted.last!)
                    sorted.removeLast()
                    if sorted.count == 0{
                        endResearch = true
                    }
                }
                //Nel momento in cui trovo un elemento minore della soglia, significa che non ci sono altri utenti che possono essere simili, quindi
                //interrompo la ricerca
                else{
                    endResearch = true
                }
            }
        }
    }

    private func predictVoteUserSearch(filmTrovati: [film]){

        //Se non ho trovato utenti simili, assegno ai film trovati una votazione suggerita pari a 6, per indicare alla classe Search che non è presente il voto per il film I
        if somiglianzeKUtenteSimili.count < 1{
            for _ in 0..<filmTrovati.count{
                predictionVotesFilmResearch.append(6)
            }
        }

            //nel caso in cui ho trovato utenti simili, inizio la predizione dei voti dei film
            //in questo caso, ovvero della ricerca di un film, verrà effettuata la predizione di ogni film e verrò mostrata sempre, anche se è molto bassa
        else{
            let indiceUtenteAttuale = utentiOrdinati.firstIndex(of: utenteAttuale)

            //Per ogni film F effettuo la predizione del voto per l'utenteAttuale
            for f in 0..<filmTrovati.count{

                var predizione: Float
                var numeratore: Float = 0.0
                var denominatore: Float = 0.0

                //Per ogni film F verifico se l'utente U ha visto e giudicato il film F, in questo caso partecipa al calcolo
                for u in 0..<somiglianzeKUtenteSimili.count{

                    //Determino l'indice dell'utente simile da utilizzare nella USER_MATRIX
                    var indice = utentiOrdinati.count + 1
                    for ut in 0..<utentiOrdinati.count{
                        if somiglianzeKUtenteSimili[u].usernameOtherUser == utentiOrdinati[ut].username{
                            indice = ut
                        }
                    }

                    //Se l'indice è stato effettivamente trovato, verifico se l'utente U in question ha votato o meno il film f
                    if indice != utentiOrdinati.count + 1
                    {
                        if USER_MATRIX[indice][(Int(filmTrovati[f].ID_Film)!)-1] != 0{
//                            print("L'utente",utentiOrdinati[indice].username!,"ha votato il film",filmTrovati[f].ID_Film,"con votazione",USER_MATRIX[indice][(Int(filmTrovati[f].ID_Film)!)-1])
                            let voto = USER_MATRIX[indice][(Int(filmTrovati[f].ID_Film)!)-1]

                            numeratore = numeratore + ((Float(voto) - medieVotoUtenti[indice]) * somiglianzeKUtenteSimili[u].similarity)
                            denominatore = denominatore + somiglianzeKUtenteSimili[u].similarity
                        }
                        else{
                            numeratore = numeratore + 0
                            denominatore = denominatore + 0
//                            print("L'utente",utentiOrdinati[indice].username!,"non ha votato il film",filmTrovati[f].ID_Film,"con votazione",USER_MATRIX[indice][(Int(filmTrovati[f].ID_Film)!)-1])
                        }
                    }
                    else{
                        break
                    }
                }
//                print(numeratore)
//                print(denominatore)

                //Calcolo la predizione
                predizione = (numeratore / denominatore) + medieVotoUtenti[indiceUtenteAttuale!]
//                print(predizione)

                if predizione.isNaN{
                    predictionVotesFilmResearch.append(6.0)
                }
                else{
                    //Inserisco la predizione nel vettore apposito
                    predictionVotesFilmResearch.append(predizione)
                }
            }
        }
    }
    
    private func predictVoteUserAdvice(filmVistiTotali: [Visione],contaFilmVisti: Int){
        
        //Analizzo la USER_MATRIX per individuare i film non visti dall'utente attuale
        let indiceUtenteAttuale = utentiOrdinati.firstIndex(of: utenteAttuale)!

        if somiglianzeKUtenteSimili.count < 1{
                    
            for f in 0..<filmDisponibili.count{
                if USER_MATRIX[indiceUtenteAttuale][(Int(filmDisponibili[f].ID_Film)!)-1] == 0 && filmWishListUtenteAttuale.contains(where: {$0.ID_Film == filmDisponibili[f].ID_Film}) == false{
                    let mediaVoto = searchRating(filmTrovato: filmDisponibili[f], filmVistiTotali: filmVistiTotali)
                    
                    predictionVotesAdvice.append(mediaVoto)
                    predictionVotesAdviceID_Film.append(filmDisponibili[f].ID_Film)
                    VotesType.append("Top rated")
                }
            }
            
            let combined = zip(predictionVotesAdvice, predictionVotesAdviceID_Film).sorted{ $0.0 > $1.0}
            
            predictionVotesAdvice = combined.map {$0.0}
            predictionVotesAdviceID_Film = combined.map {$0.1}
            
            print(predictionVotesAdvice)
            print(predictionVotesAdviceID_Film)
            print(VotesType)
            
            if contaFilmVisti >= 0 && contaFilmVisti <= 20{
                
                while predictionVotesAdvice.count > 10{
                    predictionVotesAdvice.removeLast()
                    predictionVotesAdviceID_Film.removeLast()
                    VotesType.removeLast()
                }
            }
            else if contaFilmVisti > 20 && contaFilmVisti < 30{
                while predictionVotesAdvice.count > 5{
                    predictionVotesAdvice.removeLast()
                    predictionVotesAdviceID_Film.removeLast()
                    VotesType.removeLast()

                }
            }
            
            print(predictionVotesAdvice)
            print(predictionVotesAdviceID_Film)
            print(VotesType)
        }
        else{
            
            for f in 0..<USER_MATRIX[indiceUtenteAttuale].count{
            
                //Per ogni film non visto dall'utente attuale e non presente nella wishList devo individuare quali utenti simili l'hanno visto ed effettuare la predizioni
                if USER_MATRIX[indiceUtenteAttuale][f] == 0 && filmWishListUtenteAttuale.contains(where: {$0.ID_Film == filmDisponibili[f].ID_Film}) == false{
    //                print(f,"---",USER_MATRIX[indiceUtenteAttuale][f])
                    
                    var predizione: Float
                    var numeratore: Float = 0.0
                    var denominatore: Float = 0.0
                    
                    for u in 0..<somiglianzeKUtenteSimili.count{
                        
                        //Determino l'indice dell'utente simile da utilizzare nella USER_MATRIX
                        var indice = utentiOrdinati.count + 1
                        for ut in 0..<utentiOrdinati.count{
                            if somiglianzeKUtenteSimili[u].usernameOtherUser == utentiOrdinati[ut].username{
                                indice = ut
                            }
                        }
                        
                        //Se l'indice rappresenta effettivamente un utente della USER MATRIX, verifico se ha visto o meno il film
                        if indice != utentiOrdinati.count + 1{
                            if USER_MATRIX[indice][f] != 0{
                                print("L'utente",utentiOrdinati[indice].username!,"ha votato il film",filmDisponibili[f].ID_Film,"con votazione",USER_MATRIX[indice][f])
                                let voto = USER_MATRIX[indice][f]

                                numeratore = numeratore + ((Float(voto) - medieVotoUtenti[indice]) * somiglianzeKUtenteSimili[u].similarity)
                                denominatore = denominatore + somiglianzeKUtenteSimili[u].similarity
                            }
                            else{
                                numeratore = numeratore + 0
                                denominatore = denominatore + 0
    //                            print("L'utente",utentiOrdinati[indice].username!,"non ha votato il film",filmDisponibili[f].ID_Film)
                            }
                        }
                    }
                    
                    print(numeratore)
                    print(denominatore)
                    
                    //Memorizzo la predizione per il film F
                    predizione = (numeratore / denominatore) + medieVotoUtenti[indiceUtenteAttuale]

                    print(predizione)

                    //Verifico se la predizione è diversa da NaN e nel caso verifico se sia maggiore di 3.
                    //In questo caso memorizzo il voto predetto per il film F e memorizzo il suo indice
                    if predizione.isNaN == false{
                        if predizione >= 2.85{
                            //Inserisco la predizione nel vettore apposito
                            predictionVotesAdvice.append(predizione)
                            predictionVotesAdviceID_Film.append(filmDisponibili[f].ID_Film)
                            VotesType.append("Recommended for you")
                        }
                    }
                }
            }
        }
    }

    
    private func checkFilmsSeen()->Int{
        
        var contaFilm = 0
        
        for f in 0..<USER_MATRIX[utentiOrdinati.firstIndex(of: utenteAttuale)!].count{
            if USER_MATRIX[utentiOrdinati.firstIndex(of: utenteAttuale)!][f] != 0{
                contaFilm+=1
            }
        }
        
        return contaFilm
    }
    

    func averageRatingSearch(filmTrovati: [film],filmVistiTotali: [Visione], filmDisponibili: [film]){

           self.filmDisponibili = filmDisponibili

           for f in 0..<filmTrovati.count{
               averageRatingFilmResearch.append(searchRating(filmTrovato: filmTrovati[f], filmVistiTotali: filmVistiTotali))
           }

       }

    func searchRating(filmTrovato: film, filmVistiTotali: [Visione])->Float{

        var mediaVoto: Float = 0.0
        var contaFilm: Float = 0

        for f in 0..<filmVistiTotali.count{
            if filmVistiTotali[f].ID_Film == filmTrovato.ID_Film{
                mediaVoto = mediaVoto + Float(filmVistiTotali[f].Valutazione!)!
                contaFilm+=1
            }
        }
        
        if mediaVoto == 0.0{
            return 6.0
        }

        return mediaVoto/contaFilm

    }

    
    private func determinaFilmVistiUtenteU(utente: Utente, filmVistiTotale: [Visione])-> ([Int],[Visione]){

        var identificativi: [Int] = []
        var filmVistiU: [Visione] = []

        for f in 0..<filmVistiTotale.count{
            if filmVistiTotale[f].Username == utente.username{
                let visione = Visione()
                visione.ID_Film = filmVistiTotale[f].ID_Film
                visione.Username = filmVistiTotale[f].Username
                visione.Valutazione = filmVistiTotale[f].Valutazione
                filmVistiU.append(visione)
                identificativi.append(Int(filmVistiTotale[f].ID_Film!)!)
            }
        }
        return (identificativi,filmVistiU)
    }
    private func verificaVoto(filmDaCercare: film,identificativiFilmVistiU: [Int], filmVistiU: [VisioneInt])-> Int{

        var voto: Int = 0

        if let index = identificativiFilmVistiU.firstIndex(of: Int(filmDaCercare.ID_Film)!){
            voto = filmVistiU[index].Valutazione!
        }
        else{
            voto = 0
        }
        return voto

    }
    

    func printFilmVisti(utenteU: Utente, filmVistiU: [VisioneInt], identificativiFilmVistiU: [Int]){

        print("Film visti da",utenteU.username!,"->",identificativiFilmVistiU)
        print("          con voti ->","[", terminator: "")

        for f in 0..<filmVistiU.count{
            if f != filmVistiU.count - 1{
                print(filmVistiU[f].Valutazione!,",", terminator: "")
            }
            else{
                print(filmVistiU[f].Valutazione!,"]")
            }
        }

        if filmVistiU.count == 0{
            print("]")
        }
    }

    func printUSERMATRIX(){
        print("\n\nUSERMATRIX!!!!!!!!")
        for u in 0..<USER_MATRIX.count{
            for f in 0..<USER_MATRIX[u].count{
                if f != USER_MATRIX[u].count - 1{
                    print(USER_MATRIX[u][f],terminator:" ")
                }
                else{
                    print(USER_MATRIX[u][f],terminator:" ----- ")
                }
            }
            print(utentiOrdinati[u].username!)
        }
        print("\n")

    }

    func printUSERUSERMATRIX(){

        print("USERUSERMATRIX!!!!!!!!")
        for u in 0..<utentiOrdinati.count{
            print(utentiOrdinati[u].username!,"-->", terminator:"   ")
            for ut in 0..<utentiOrdinati.count{
                print(USER_USER_MATRIX[u][ut].usernameOtherUser,USER_USER_MATRIX[u][ut].similarity,terminator:"  ")
            }
            print("\n")
        }
    }

    func printKSimilarUser(){

        print("Gli utenti simili individuati sono--->",terminator:" ")

        for u in 0..<somiglianzeKUtenteSimili.count{
            print("[",somiglianzeKUtenteSimili[u].usernameOtherUser,";",somiglianzeKUtenteSimili[u].similarity,"]",terminator:"")
        }
        print("\n\n")
    }
}
