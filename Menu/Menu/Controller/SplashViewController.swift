//
//  SplashViewController.swift
//  Amber
//
//  Created by YoussefRomany on 27/07/2020.
//  Copyright © 2020 HardTask. All rights reserved.
//

import UIKit
import Alamofire

class SplashViewController: UIViewController {

    // IBOutlets
    @IBOutlet var AnimatedImage: UIImageView!
    
    // Variables
    var productPage = 1
    var productUrl = ""
    var categoryPage = 1
    var categoryUrl = ""
    var isFirstCallCategory = true
    var isFirstCallProduct = true
    var categoryList: [DataModel] = []
    var productList: [DataModel] = []
    var dispatchGroup = DispatchGroup()

    // Constant
    let NETWORK = NetworkingHelper()
    let CATEGORIES = "category"
    let PRODUCTS = "Products"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateLogo()
        NETWORK.deleget = self
        if AppSetting.shared.isDownloadData{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of
                pushToView(withId: "homeNavigation")
            }
        }else{
            requestProductsApi()
            requestCategoryApi()
            dispatchGroup.notify(queue: .main) {
                print("enterNotify")
                CoreDataManager.shared.saveCategoriesData(self.categoryList)
                CoreDataManager.shared.saveproductsData(self.productList)
                AppSetting.shared.isDownloadData = true
                AppSetting.shared.storeData()
                pushToView(withId: "homeNavigation")
            }

        }
    }
    
    
    func animateLogo() {
           AnimatedImage.contentMode = .scaleAspectFit
           self.AnimatedImage.alpha = 0.0

           let t1 = CGAffineTransform(scaleX: 0.3, y: 0.3)
           AnimatedImage.transform = t1
           
        UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.AnimatedImage.alpha = 1
               self.AnimatedImage.transform = CGAffineTransform.identity
    
           },  completion: {(finished:Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of
            }

           })
       }
    
}


// MARK: - Networking Helper Deleget
extension SplashViewController: NetworkingHelperDeleget{
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == CATEGORIES {handelCategoryListResponse(forResponse: data)}
        else if id == PRODUCTS {handelProductsListResponse(forResponse: data)}

    }
    
    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayMessage(message: localizedSitringFor(key: "unknownError"),messageError: true)
        // make alert
        hideLoaderForController(self)
        displayAlertConfirmation("Error", "error occured when save data offline do you want re download?", forController: self) {
            self.requestProductsApi()
            self.requestCategoryApi()
        }
    }
    
    /// uses for connecting to server and recive data
    func requestCategoryApi(){
        if isFirstCallCategory{
            dispatchGroup.enter()
            isFirstCallCategory = false
        }
        categoryUrl = ApiNames.CATEGORIES+"?page=\(categoryPage)"
        NETWORK.connectWithHeaderTo(api: categoryUrl, andIdentifier: CATEGORIES, forController: self, methodType: .get)
    }
    
    /// handle response from server
    ///
    /// - Parameter response: server response
    func handelCategoryListResponse(forResponse response: DataResponse<String>){
        mainQueue {hideLoaderForController(self)}
        guard let data = response.data else { return }
        do{
            let respons = try JSONDecoder().decode(HomeRespons.self, from: data)
            categoryList += respons.data ?? []
            if (respons.meta?.current_page ?? 0) < (respons.meta?.last_page ?? 0){
                categoryPage += 1
                requestCategoryApi()
            }else{
                print(categoryPage, "rrruiehiureh")

                dispatchGroup.leave()
            }

        }catch let error{
            print(error)
            displayMessage(message: localizedSitringFor(key: "unknownError"), messageError: true)
        }
    }
    
    /// request products from server
    func requestProductsApi(){
        if isFirstCallProduct{
            dispatchGroup.enter()
            isFirstCallProduct = false
        }
        productUrl = ApiNames.PRODUCTS+"?include=category&page=\(productPage)"
        NETWORK.connectWithHeaderTo(api: productUrl, andIdentifier: PRODUCTS, forController: self, methodType: .get)
    }

      /// handle response from server
      ///
      /// - Parameter response: server response
      func handelProductsListResponse(forResponse response: DataResponse<String>){
          mainQueue {hideLoaderForController(self)}
          
          guard let data = response.data else { return }
          do{
              let respons = try JSONDecoder().decode(HomeRespons.self, from: data)
                productList += respons.data ?? []

            if (respons.meta?.current_page ?? 0) < (respons.meta?.last_page ?? 0){
                productPage += 1
                requestProductsApi()
            }else{
                print(productPage, "requestProductsApi")
                dispatchGroup.leave()

            }

          }catch let error{
              print(error)
              displayMessage(message: localizedSitringFor(key: "unknownError"), messageError: true)
          }
          

      }

}


/*
 "regFont" = "Lato-Regular";
 "boldFont" = "Lato-Bold";
 */


