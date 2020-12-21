//
//  CategoryViewController.swift
//  Menu
//
//  Created by YoussefRomany on 16/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit
import Alamofire
import IBAnimatable


class CategoryViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet var titleLAbel: UILabel!
    @IBOutlet var previousButton: AnimatableButton!
    @IBOutlet var nextButton: AnimatableButton!
    @IBOutlet var collectionView: UICollectionView!
    

    // Variables
    var page = 1
    var dataList: [DataModel] = []
    var AllData: [DataModel] = []
    var popUp: ProductPopUpView?
    var startIndex = 0
    var canLoadeMore = true
    
    // Constant
    let NETWORK = NetworkingHelper()
    let CATEGORIES = "category"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    //MARK:- IBActions
    @IBAction func previousAction(_ sender: Any) {
        makePrevAction()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        makeNextAction()
    }

}


//MARK:- Helpers
extension CategoryViewController{
    
    /// init view for first time
    func initView(){
        setupFonts()
        let cats = CoreDataManager.shared.getCategories()
        AllData = cats.map({DataModel(id: $0.id, name: $0.name, name_localized: $0.name_localized, reference: $0.reference, image: $0.image, created_at: $0.created_at, updated_at: $0.updated_at, deleted_at: $0.deleted_at, price: nil, category: nil)})
        for i in 0..<AllData.count{
            if i < 20{
                dataList.append(AllData[i])
            }
        }
        if dataList.count < 20{
            canLoadeMore = false
        }
        
        if dataList.count == 0{
            displayMessage(message: "There is no categories", messageError: false)
        }
        initCommonCollectionView()
        popUp = ProductPopUpView.initView( fromController: self)

    }
    
    // setup screen fonts
    func setupFonts(){
        mainQueue {
            self.titleLAbel.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*20)
            self.previousButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*15)
            self.nextButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: iphoneXFactor*15)
        }
    }
    /// init tcommon table view
    func initCommonCollectionView() {
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    // used when press prev button
    func makePrevAction(){
        collectionView.setContentOffset(CGPoint.zero, animated: true)

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
        collectionView.setContentOffset(CGPoint.zero, animated: true)
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
extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        Cell.initCell(withData: dataList[indexPath.row])
        return Cell
        
     }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            vc.delegate = self
        vc.currentCategory = dataList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
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


//MARK:- Helpers
extension CategoryViewController: ShowProductDelegation{
    
    func showProduct(product: DataModel) {
        popUp?.showAnimation(withProduct: product)
    }
    
}
