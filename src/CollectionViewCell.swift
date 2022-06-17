import UIKit

protocol CollectionViewCellDelegate {
    
    func didPressedVoto1(id: String)
    func didPressedVoto2(id: String)
    func didPressedVoto3(id: String)
    func didPressedVoto4(id: String)
    func didPressedVoto5(id: String)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmTitolo: UILabel!
    @IBOutlet weak var filmGenere: UILabel!
    @IBOutlet weak var filmAnno: UILabel!
    @IBOutlet weak var voto1: UIButton!
    @IBOutlet weak var voto2: UIButton!
    @IBOutlet weak var voto3: UIButton!
    @IBOutlet weak var voto4: UIButton!
    @IBOutlet weak var voto5: UIButton!
    
    var id: String!
    
    var delegate: CollectionViewCellDelegate?
    
    func displayContent(image: UIImage,ID: String,title: String,gen: String, anno: String){
        filmImage.image = image
        filmTitolo.text = title
        filmGenere.text = gen
        filmAnno.text = anno
        
        id = ID
    }
    
    func drawStar(trovato: Bool, stelle: String){

        if trovato == false{
            
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto1.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto1.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            

            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto2.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto2.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto5.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto5.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto5.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto5.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
 
        }
        else{
            if stelle == "1"{
                voto1.backgroundColor = UIColor.yellow
                voto1.layer.cornerRadius = 5
                voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            }
            else if stelle == "2"{
                voto1.backgroundColor = UIColor.yellow
                voto1.layer.cornerRadius = 5
                voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto2.backgroundColor = UIColor.yellow
                voto2.layer.cornerRadius = 5
                voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            }
            else if stelle == "3"{
                voto1.backgroundColor = UIColor.yellow
                voto1.layer.cornerRadius = 5
                voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto2.backgroundColor = UIColor.yellow
                voto2.layer.cornerRadius = 5
                voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
    
                voto3.backgroundColor = UIColor.yellow
                voto3.layer.cornerRadius = 5
                voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            }
            else if stelle == "4"{
                voto1.backgroundColor = UIColor.yellow
                voto1.layer.cornerRadius = 5
                voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                            
                voto2.backgroundColor = UIColor.yellow
                voto2.layer.cornerRadius = 5
                voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto3.backgroundColor = UIColor.yellow
                voto3.layer.cornerRadius = 5
                voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto4.backgroundColor = UIColor.yellow
                voto4.layer.cornerRadius = 5
                voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            }
            else if stelle == "5"{
                voto1.backgroundColor = UIColor.yellow
                voto1.layer.cornerRadius = 5
                voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                            
                voto2.backgroundColor = UIColor.yellow
                voto2.layer.cornerRadius = 5
                voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto3.backgroundColor = UIColor.yellow
                voto3.layer.cornerRadius = 5
                voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto4.backgroundColor = UIColor.yellow
                voto4.layer.cornerRadius = 5
                voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
                voto5.backgroundColor = UIColor.yellow
                voto5.layer.cornerRadius = 5
                voto5.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
                voto5.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            }
        }
        
    }
    

    @IBAction func pressedVoto1(_ sender: UIButton) {
       
        if(voto5.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto5.backgroundColor = UIColor.yellow
            voto5.layer.cornerRadius = 5
            voto5.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto5.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto5.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto5.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto4.backgroundColor = UIColor.yellow
            voto4.layer.cornerRadius = 5
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto2.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto2.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
    
            delegate?.didPressedVoto1(id: id)
        }
        else if(voto4.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto4.backgroundColor = UIColor.yellow
            voto4.layer.cornerRadius = 5
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto2.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto2.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            delegate?.didPressedVoto1(id: id)
        }
        else if(voto3.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto2.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto2.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            delegate?.didPressedVoto1(id: id)
        }
        else if(voto2.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto2.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto2.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            delegate?.didPressedVoto1(id: id)
        }
        else{
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            delegate?.didPressedVoto1(id: id)
        }
        
    }
    
    
    @IBAction func pressedVoto2(_ sender: UIButton) {
        
        if(voto5.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto5.backgroundColor = UIColor.yellow
            voto5.layer.cornerRadius = 5
            voto5.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto5.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto5.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto5.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
                
            voto4.backgroundColor = UIColor.yellow
            voto4.layer.cornerRadius = 5
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
                
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
                
            delegate?.didPressedVoto2(id: id)
        }
        else if(voto4.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
            voto4.backgroundColor = UIColor.yellow
            voto4.layer.cornerRadius = 5
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
                
            delegate?.didPressedVoto2(id: id)

                
        }
        else if(voto3.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto3.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto3.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            delegate?.didPressedVoto2(id: id)


        }
        else{
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
        
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            delegate?.didPressedVoto2(id: id)
        }
    }
    
    
    @IBAction func pressedVoto3(_ sender: UIButton) {
        
        if(voto5.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto5.backgroundColor = UIColor.yellow
            voto5.layer.cornerRadius = 5
            voto5.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto5.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto5.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto5.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
                
            voto4.backgroundColor = UIColor.yellow
            voto4.layer.cornerRadius = 5
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
                

                
            delegate?.didPressedVoto3(id: id)
        }
        else if(voto4.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
            voto4.backgroundColor = UIColor.yellow
            voto4.layer.cornerRadius = 5
            voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto4.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto4.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)

            delegate?.didPressedVoto3(id: id)
        }
        else{
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5

            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            delegate?.didPressedVoto3(id: id)
        }
    }
    
    
    @IBAction func pressedVoto4(_ sender: UIButton) {
        if(voto5.backgroundColor == UIColor.yellow){
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto5.backgroundColor = UIColor.yellow
            voto5.layer.cornerRadius = 5
            voto5.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            voto5.setImage(UIImage(named: "starFill.png"), for: UIControl.State.focused)
            voto5.setBackgroundColor(color: UIColor.gray, forState: UIControl.State.normal)
            voto5.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.focused)
            
            delegate?.didPressedVoto4(id: id)
        }
        else{
            sender.backgroundColor = UIColor.yellow
            sender.layer.cornerRadius = 5
            sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto1.backgroundColor = UIColor.yellow
            voto1.layer.cornerRadius = 5
            voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto2.backgroundColor = UIColor.yellow
            voto2.layer.cornerRadius = 5
            voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
            
            voto3.backgroundColor = UIColor.yellow
            voto3.layer.cornerRadius = 5
            voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
            voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
                
            delegate?.didPressedVoto4(id: id)
        }
    }
    
    
    @IBAction func pressedVoto5(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.yellow
        sender.layer.cornerRadius = 5
        sender.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
        sender.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
        
        voto1.backgroundColor = UIColor.yellow
        voto1.layer.cornerRadius = 5
        voto1.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
        voto1.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
        
        voto2.backgroundColor = UIColor.yellow
        voto2.layer.cornerRadius = 5
        voto2.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
        voto2.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
        
        voto3.backgroundColor = UIColor.yellow
        voto3.layer.cornerRadius = 5
        voto3.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
        voto3.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
        
        voto4.backgroundColor = UIColor.yellow
        voto4.layer.cornerRadius = 5
        voto4.setBackgroundColor(color: UIColor.yellow, forState: UIControl.State.normal)
        voto4.setImage(UIImage(named: "star.png"), for: UIControl.State.normal)
        
        delegate?.didPressedVoto5(id: id)
    }
}


