//
//  CategoryCollectionViewCell.swift
//  Menu
//
//  Created by YoussefRomany on 21/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    // IBOutlets
    @IBOutlet var categoryNameLAbel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


//MARK:- Helpers
extension CategoryCollectionViewCell{
    
    /// init cell
    func initCell(withData data: DataModel){
        setupFonts()
        categoryNameLAbel.text = data.name ?? ""
        setImageView(forImageView: categoryImageView, andURL: data.image ?? "", andPlaceHolderImage: "home_noimg")
    }
    
    // set up cell fonts
    func setupFonts(){
        mainQueue {
            self.categoryNameLAbel.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*18)
        }
    }
    
}
