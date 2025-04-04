//
//  HomeController.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit

var cartCount: Int? = 0
var cartItems = [ProductsModel]()
var isCheckout: Bool = false

class HomeController: UIViewController {
    @IBOutlet weak var catCollectionView:UICollectionView!
    @IBOutlet weak var prodCollectionView:UICollectionView!
    @IBOutlet weak var prodCollectionViewHeight:NSLayoutConstraint!
    @IBOutlet var btnBgView: [UIView]!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var twoSideCornerView: [UIView]!
    
    var productdataArray = [ProductsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        setupCollectionView()
        for i in btnBgView {
            i.layer.cornerRadius = i.frame.height/2
        }
        
        for i in twoSideCornerView {
            i.layer.cornerRadius = 25
            if i.tag == 0 {
                i.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                i.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            i.clipsToBounds = true
        }
        bgView.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCheckout {
            isCheckout = false
            for i in 0..<productdataArray.count {
                productdataArray[i].isAddedToCart = false
            }
            prodCollectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        catCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        catCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        prodCollectionView.register(UINib(nibName: "ProductHomCell", bundle: nil), forCellWithReuseIdentifier: "ProductHomCell")
        
        prodCollectionView.delegate = self
        prodCollectionView.dataSource = self
        
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        
    }
    
    private func updateCollectionViewHeight() {
        self.prodCollectionView.layoutIfNeeded()
        self.prodCollectionViewHeight.constant = self.prodCollectionView.contentSize.height + 50
        self.view.layoutIfNeeded()
        return
    }
    
    private func getData() {
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Unknown error" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                print("Network Error:", error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let response = try JSONDecoder().decode([ProductsModel].self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    if !response.isEmpty {
                        self.productdataArray = response
                        self.catCollectionView.reloadData()
                        self.prodCollectionView.reloadData()
                        self.updateCollectionViewHeight()
                    }
                }
            } catch {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                print("JSON Decoding Failed:", error.localizedDescription)
            }
        }.resume()
    }
}

extension HomeController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productdataArray.isEmpty == false ? productdataArray.count : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == catCollectionView {
            let cell = catCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.categoryImg.sd_setImage(with: URL(string: productdataArray[indexPath.row].image ?? ""))
            return cell
        } else {
            let cell = prodCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomCell", for: indexPath) as! ProductHomCell
            cell.setData(model: productdataArray[indexPath.row])
            cell.heratBtn.tag = indexPath.row
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != catCollectionView {
            let detailsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
            detailsVc.delegate = self
            detailsVc.selectedProductdata = productdataArray[indexPath.row]
            detailsVc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailsVc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == catCollectionView {
            return CGSize(width: 70  , height: catCollectionView.frame.height)
        } else {
            return CGSize(width: ((prodCollectionView.frame.width - 10) / 2) , height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == catCollectionView {
            return 20
        }
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension HomeController: AddToCart {
    func updateCartCount() {
        if let tabBarController = self.tabBarController as? TabBarController {
            if let thirdTabBarItemView = tabBarController.tabBar.items?[3].value(forKey: "view") as? UIControl,
               let imageView = thirdTabBarItemView.subviews.compactMap({ $0 as? UIImageView }).first {
                cartItems.removeAll()
                let cartItemCount = productdataArray.filter { $0.isAddedToCart == true }.count
                cartItems = productdataArray.filter { $0.isAddedToCart == true }
                cartCount = cartItemCount
                if cartItemCount > 0 {
                    imageView.addBadge(value: "\(cartItemCount)")
                } else {
                    imageView.removeBadge()
                }
            }
        }
    }
    
    func onTapHeart(index: Int) {
        productdataArray[index].isAddedToCart = !(productdataArray[index].isAddedToCart ?? false)
        prodCollectionView.reloadData()
        updateCartCount()
    }
}

extension HomeController: UpdateCartDelegate {
    func onTapHeart(model: ProductsModel) {
        
        for i in 0...productdataArray.count - 1 {
            if productdataArray[i].title == model.title {
                productdataArray[i] = model
                prodCollectionView.reloadData()
                updateCartCount()
            }
        }
    }
}
