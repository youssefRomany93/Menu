//
//  LoaderView.swift
//  4SaleQ8
//
//  Created by YoussefRomany on 1/8/20.
//  Copyright © 2020 hardTask. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {

    func showLoader()  {
        
        let color = UIColor(hexString: "000000")
            
        
        let size:CGFloat =  UIScreen.main.traitCollection.horizontalSizeClass == .regular ? 100.0 : 50.0
        
        let loader = NVActivityIndicatorView(frame: CGRect(x:center.x - (size / 2) ,y:center.y - (size / 2),width:size,height:size), type: .ballSpinFadeLoader, color: color, padding: nil)
        

        self.addSubview(loader)
        
        loader.startAnimating()
        
    }
    

}
