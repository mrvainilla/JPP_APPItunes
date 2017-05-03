//
//  ListaPeliculasViewController.swift
//  JPP_APPItunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import UIKit
import Kingfisher

class ListaPeliculasViewController: UIViewController {

    //MARK: - Variables locales
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    var customRefreshControl = UIRefreshControl()
    var dataProvider = LocalCoredataService()
    var tapGR : UITapGestureRecognizer!
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customRefreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = CONSTANTES.COLORES_BASE.COLOR_ROJO_GENERAL
        myCollectionView.refreshControl = customRefreshControl
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        
        loadData()
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: - Utils
    func loadData(){
        //codigo de coreData
        dataProvider.topMovie({ (localResult) in
            
            if let moviesData = localResult{
                self.movies = moviesData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }else{
                print("No hay registros en CoreData")
            }
            
            
        }) { (remoteResult) in
            
            if let moviesData = remoteResult{
                self.movies = moviesData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customRefreshControl.endRefreshing()
                }
            }else{
                print("No se han encontrado registros")
            }
            
        }
    }
    
    func hideKeyBoard(){
        mySearchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(tapGR)
    }
    
    
}//TODO : Fin de la clase

extension ListaPeliculasViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
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
        return movies.count //Numero de elementos
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
    
    //SEARCHBAR
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(tapGR)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            //ejecutamos la busqueda
            loadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text{
            //invocamos coredata
            dataProvider.searchMovies(term, remoteHandler: { (resultMovies) in
                if let moviesData = resultMovies{
                    self.movies = moviesData
                    //cola principal
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                    
                }
            })
        }
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
