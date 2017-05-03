//
//  DetallePeliculaViewController.swift
//  JPP_APPItunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import UIKit
import Kingfisher


class DetallePeliculaViewController: UIViewController {

    
    //MARK: - Variables locales
    var movie : MovieModel?
    let dataProvider = LocalCoredataService()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var myImagePelicula: UIImageView!
    @IBOutlet weak var myTituloPelicula: UILabel!
    @IBOutlet weak var myDirectorPelicula: UILabel!
    @IBOutlet weak var myCategoriaPelicula: UILabel!
    @IBOutlet weak var myButtonInteresaBtn: UIButton!
    @IBOutlet weak var mySinopsisBtn: UITextView!
    
    
    
    //MARK: - IBActions
    @IBAction func peliculaFavoritaAction(_ sender: Any) {
        
        configuredFavoriteBTN()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configuredFavoriteBTN(){
        if let movieData = movie{
            if dataProvider.isFavorite(movieData){
                myButtonInteresaBtn.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                myButtonInteresaBtn.setTitle("Quiero verla", for: .normal)
            }else{
                myButtonInteresaBtn.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                myButtonInteresaBtn.setTitle("No me interesa", for: .normal)

            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
