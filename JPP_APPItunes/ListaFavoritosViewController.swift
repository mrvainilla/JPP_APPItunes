//
//  ListaFavoritosViewController.swift
//  JPP_APPItunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import UIKit
import Kingfisher

class ListaFavoritosViewController: UIViewController {
    
    //MARK: - Variables locales
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    var dataProvider = LocalCoredataService()
    var tapGR : UITapGestureRecognizer!
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    
    //MARK: - UTILS
    func loadData(){
        
        if let movieData = dataProvider.getFavoritesMovies(){
            movies = movieData
            myCollectionView.reloadData()
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


extension ListaFavoritosViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionViewPadding = (anchoPantalla - (3 * 113)) / 4 //los 4 espacios residuales que hay entre las tres peliculas. 113 es el ancho de cada pelicula
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right: collectionViewPadding) //Esto es para que se ajuste
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewPadding //Minimo espaciado por cada seccion
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 //Al menos una seccion
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if movies.count == 0{
            let imageView = UIImageView(image: #imageLiteral(resourceName: "sin-favoritas"))
            imageView.contentMode = .center
            myCollectionView.backgroundView = imageView
        }else{
            myCollectionView.backgroundView = UIView()
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PeliculaCustomCellCollectionViewCell
        
        let movieData = movies[indexPath.row]
        //metodo de creacion de celda
        configureCell(customCell, withMovie: movieData)
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    //MARK : - UTILS - DELEGATE
    
    func configureCell(_ cell : PeliculaCustomCellCollectionViewCell, withMovie movie : MovieModel){
        if let imageData = movie.image{
            //cargamos la imagen con kingfisher
            cell.myImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!),
                                         placeholder: #imageLiteral(resourceName: "img-loading"),
                                         options: nil,
                                         progressBlock: nil,
                                         completionHandler: nil)
        }
    }
}
