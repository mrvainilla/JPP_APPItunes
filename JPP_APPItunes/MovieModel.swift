//
//  MovieModel.swift
//  JPP_APPItunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 empresa. All rights reserved.
//

import Foundation


class MovieModel{
    
    var id : String?
    var title : String?
    var order : Int?
    var symmary : String?
    var image : String?
    var category : String?
    var director : String?
    
    
    init(pId : String?, pTitle : String?, pOrder : Int?, pSummary : String?, pImage : String?, pCategory : String?, pDirector : String?){
        
        self.id = pId
        self.title = pTitle
        self.order = pOrder
        self.symmary = pSummary
        self.image = pImage
        self.category = pCategory
        self.director = pDirector
    }
    
}
