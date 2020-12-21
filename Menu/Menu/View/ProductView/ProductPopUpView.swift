//
//  ProductPopUpView.swift
//  Menu
//
//  Created by YoussefRomany on 19/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit
import IBAnimatable

class ProductPopUpView: UIView {

    //MARK: - IBOutlets
    @IBOutlet var productImageView: AnimatableImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var containerView: AnimatableView!

    // constant
    fileprivate let animationDuration: TimeInterval = 1.5

    
    /// init the pop up view
    ///
    /// - Parameter
    ///   - controller: the parent UIViewController for this instance
    ///   - product: product object
    public static func initView(fromController controller: UIViewController) -> ProductPopUpView {
        let popup = Bundle.main.loadNibNamed("ProductPopUpView", owner: controller, options: nil)?.last as! ProductPopUpView
        popup.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        popup.isHidden = true
        popup.setupFonts()

        controller.view.addSubview(popup)
        
        return popup
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !containerView.frame.contains(touch.location(in: self)) {
                self.hideAnimation()
            }
        }
    }
    
    // set up view fonts
    func setupFonts(){
        mainQueue {
            self.productNameLabel.font = UIFont(name: "Lato-Regular", size: iphoneXFactor*20)
            self.productPriceLabel.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*20)
        }
    }
    
}


//MARK: - Animation
extension ProductPopUpView {

    /// display the popup view with animation
    func showAnimation(withProduct product: DataModel) {
        containerView.center.y += screenHeight
        productNameLabel.text = product.name ?? ""
        productPriceLabel.text = "Price: \(product.price ?? 0) $"
        setImageView(forImageView: productImageView, andURL: product.image ?? "", andPlaceHolderImage: "popup_noimg")
        UIView.transition(with: self, duration: animationDuration * 0.5 , options: [.showHideTransitionViews], animations: {
            self.isHidden = false
        }, completion: nil)
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.center.y -= screenHeight
        }, completion: nil)
    }
    
    /// hide the container view with animation
    func hideContainer() {
        
        UIView.transition(with: self, duration: animationDuration * 0.5 , options: [.showHideTransitionViews], animations: {
            self.isHidden = false
        }, completion: nil)
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.center.y -= screenHeight
        }, completion: nil)
        
        hideAnimation()
    }
    
    /// hide the popup view with animation
    fileprivate func hideAnimation(){
        UIView.animate(withDuration: animationDuration * 0.3, animations: {
            self.alpha = 0
        }) { (_) in
            self.isHidden = true
            self.alpha = 1.0
        }
    }
}
