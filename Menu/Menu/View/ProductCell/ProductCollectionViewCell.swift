//
//  ProductCollectionViewCell.swift
//  Menu
//
//  Created by YoussefRomany on 18/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
        productNameLabel.text = "joe romany"

    }

}


//MARK:- Helpers
extension ProductCollectionViewCell{
    
    /// init cell
    func initCell(withData data: DataModel){
        setupFonts()
//        productNameLabel.text = data.name ?? ""
//        setImageView(forImageView: productImageView, andURL: data.image ?? "", andPlaceHolderImage: "list_noimg")
    }
    
    // set up cell fonts
    func setupFonts(){
        mainQueue {
            self.productNameLabel.font = UIFont(name: "Lato-Regular", size: iphoneXFactor*16)
        }
    }
    
    func initCell(withCat cat: DataModel){
        setupFonts()
        productNameLabel.text = cat.name ?? ""
        setImageView(forImageView: productImageView, andURL: cat.image ?? "", andPlaceHolderImage: "list_noimg")
    }
    
}
