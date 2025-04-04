//
//  DetailsViewController.swift
//  HayStekTask
//
//  Created by Geethansh  on 03/04/25.
//

import UIKit
import SDWebImage

protocol UpdateCartDelegate: AnyObject {
    func onTapHeart(model: ProductsModel)
}

class DetailsViewController: UIViewController {
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 25
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var addCartBtn: UIButton!  {
        didSet {
            addCartBtn.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet var btnBgView: [UIView]! {
        didSet {
            for i in btnBgView {
                let tap = UITapGestureRecognizer(target: self, action: #selector(onTapView))
                if i.tag == 0 || i.tag == 1 {
                    i.isUserInteractionEnabled = true
                    i.addGestureRecognizer(tap)
                }
            }
            
        }
    }
    @IBOutlet var bgCornerView: [UIView]! {
        didSet {
            for i in bgCornerView {
                i.layer.cornerRadius = 8
            }
        }
    }
    var selectedProductdata = ProductsModel()
    var delegate: UpdateCartDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        navigationController?.setNavigationBarHidden(true, animated: true)
        pageController.numberOfPages  = 5
        pageController.currentPage = 0
        
        for i in btnBgView {
            i.layer.cornerRadius = i.frame.height/2
        }
        for i in bgCornerView {
            i.layer.cornerRadius = 8
            i.layer.borderWidth = 1
            i.layer.borderColor = UIColor.systemGray3.cgColor
        }
        setData()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    func setData() {
        titleLbl.text = selectedProductdata.title
        descriptionLbl.text = selectedProductdata.description
        rateLbl.text = "\(selectedProductdata.rating?.rate ?? 0)"
        
        if selectedProductdata.isAddedToCart == true {
            heartImg.image = UIImage(systemName: "heart.fill")
            heartImg.tintColor = .red
        } else {
            heartImg.image = UIImage(systemName: "heart")
            heartImg.tintColor = .black
        }
    }
    
    @objc func onTapView(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        if tappedView.tag == 0 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            delegate?.onTapHeart(model: selectedProductdata)
            navigationController?.popViewController(animated: true)
        } else if tappedView.tag == 1 {
            if selectedProductdata.isAddedToCart == true {
                selectedProductdata.isAddedToCart = false
                //cartCount = (cartCount ?? 0) - 1
                heartImg.image = UIImage(systemName: "heart")
                heartImg.tintColor = .black
            } else {
                selectedProductdata.isAddedToCart = true
                //cartCount = (cartCount ?? 0) + 1
                heartImg.image = UIImage(systemName: "heart.fill")
                heartImg.tintColor = .red
            }
        }
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.img.sd_setImage(with: URL(string: selectedProductdata.image ?? ""))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageController.currentPage = Int(pageIndex)
        }

        @IBAction func pageControlChanged(_ sender: UIPageControl) {
            let x = CGFloat(sender.currentPage) * collectionView.frame.width
            collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }
}
