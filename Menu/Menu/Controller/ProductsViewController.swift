//
//  ProductsViewController.swift
//  Menu
//
//  Created by YoussefRomany on 18/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit
import Alamofire
import IBAnimatable

protocol ShowProductDelegation: NSObjectProtocol {
    func showProduct(product: DataModel)
}

class ProductsViewController: UIViewController {

    // IBOutlets
    @IBOutlet var titleLAbel: UILabel!
    @IBOutlet var previousButton: AnimatableButton!
    @IBOutlet var nextButton: AnimatableButton!
    @IBOutlet var collectionView: UICollectionView!
    
    // Variables
    var page = 1
    var startIndex = 0
    var canLoadeMore = true
    var currentCategory: DataModel?
    weak var delegate: ShowProductDelegation?
    var dataList: [DataModel] = []
    var AllData: [DataModel] = []
    var productsCategory: [DataModel] = []

    // Constant
    let NETWORK = NetworkingHelper()
    let PRODUCTS = "Products"

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    
    //MARK:- IBActions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func previousAction(_ sender: Any) {
        makePrevAction()
    }
    @IBAction func nextAction(_ sender: Any) {
        makeNextAction()
    }
    
}


//MARK:- Helpers
extension ProductsViewController{
    
    /// init view for first time
    func initView(){
        setupFonts()
        titleLAbel.text = currentCategory?.name ?? ""
        let product = CoreDataManager.shared.getProducts()
        
        AllData = product.map({DataModel(id: $0.id, name: $0.name, name_localized: $0.name_localized, reference: nil, image: $0.image, created_at: nil, updated_at: nil, deleted_at: nil, price: $0.price, category: CategoryModel(id: "", name: $0.category ?? ""))})
        for product in AllData{
                if product.category?.name == currentCategory?.name {
                    self.productsCategory.append(product)
                }
            }
        if productsCategory.count == 0{
            displayMessage(message: "There is no products in this category", messageError: false)
        }
        AllData = productsCategory
        for i in 0..<AllData.count{
            if i < 20{
                dataList.append(AllData[i])
            }
        }
        if dataList.count < 20{
            canLoadeMore = false
        }
        initCommonCollectionView()

    }
    
    /// init tcommon table view
    func initCommonCollectionView() {
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    func setupFonts(){
        mainQueue {
            self.titleLAbel.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*20)
            self.previousButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*15)
            self.nextButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*15)
        }
    }
    
    
    // used when press prev button
    func makePrevAction(){
        if page > 1{
            canLoadeMore = true
            var list: [DataModel] = []
            startIndex -= 1
            page -= 1
            for i in (20*startIndex)..<AllData.count{
                if i < (page*20){
                    list.append(AllData[i])
                }
            }
            dataList = list
            mainQueue {
                self.collectionView.reloadData()
            }
        }
    }
    
    // used when press next button
    func makeNextAction(){
        if canLoadeMore{
            var list: [DataModel] = []
            dataList.removeAll()
            startIndex += 1
            page += 1
            for i in (20*startIndex)..<AllData.count{
                if i < (page*20){
                    list.append(AllData[i])
                }
            }
            if list.count == 20{
                canLoadeMore = true
            }else{
                canLoadeMore = false
            }
            if list.count > 0{
                dataList = list
            }
            print(dataList.count, "nextAction")
            mainQueue {
                self.collectionView.reloadData()
            }
        }
    }
}


//MARK:- UICollection View Delegate,DataSource
extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        Cell.initCell(withCat: dataList[indexPath.row])
        return Cell
        
     }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        delegate?.showProduct(product: dataList[indexPath.row])

    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
            let width:CGFloat = ((collectionView.frame.width - ((20*iphoneXFactor)*3)) / 2)
            let height:CGFloat = ((width * 195) / 166)
            return CGSize(width:width ,height: height)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets.init(top: (0), left: (20*iphoneXFactor), bottom: 0, right: (20*iphoneXFactor))
     }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return (20*iphoneXFactor)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }

}

//
// MARK: - Networking Helper Deleget
//extension ProductsViewController: NetworkingHelperDeleget{
//    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
//        if id == PRODUCTS {handelProductsListResponse(forResponse: data)}
//
//    }
//
//    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
//        displayMessage(message: localizedSitringFor(key: "unknownError"),messageError: true)
//        hideLoaderForController(self)
//    }
//
//
//
//    /// request products from server
//    func requestProductsApi(withLoader loader : Bool = true){
//        mainQueue {showLoaderForController(self)}
//        url = ApiNames.PRODUCTS+"?include=category&page=\(page)"
//        NETWORK.connectWithHeaderTo(api: url, andIdentifier: PRODUCTS, forController: self, methodType: .get)
//    }
//
//    /// handle response from server
//    ///
//    /// - Parameter response: server response
//    func handelProductsListResponse(forResponse response: DataResponse<String>){
//        mainQueue {hideLoaderForController(self)}
//
//        guard let data = response.data else { return }
//        do{
//            let respons = try JSONDecoder().decode(HomeRespons.self, from: data)
//            if respons.data?.count == 0{
//                isPaging = false
//                return
//            }
//            if let data = respons.data{
//                for product in data{
//                    if product.category?.name == currentCategory?.name {
//                        self.dataList.append(product)
//                    }
//                }
//            }
//            if self.dataList.count < 50{
//                page += 1
//                if (respons.meta?.current_page ?? 0) < (respons.meta?.last_page ?? 0){
//                    requestProductsApi(withLoader: false)
//                }
//
//            }else{
//
//            }
//
//            if self.dataList.isEmpty{
//                  displayMessage(message: "there is no products in this category", messageError: false)
//              }
//
//            mainQueue {
//                self.collectionView.reloadData()
//            }
//        }catch let error{
//            print(error)
//            displayMessage(message: localizedSitringFor(key: "unknownError"), messageError: true)
//        }
//
//
//    }
//
//}
