//
//  CartController.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

import UIKit

class CartController: UIViewController {
    @IBOutlet weak var btnBgView: UIView! {
        didSet {
            btnBgView.layer.cornerRadius = btnBgView.frame.height/2
        }
    }
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func onTapCheckout() {
        if cartItems.count  > 0 {
            let alert = UIAlertController(title: "Success", message: "Thank You", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                isCheckout = true
                cartItems.removeAll()
                if let tabBarController = self.tabBarController as? TabBarController {
                    if let thirdTabBarItemView = tabBarController.tabBar.items?[3].value(forKey: "view") as? UIControl,
                       let imageView = thirdTabBarItemView.subviews.compactMap({ $0 as? UIImageView }).first {
                       
                            imageView.removeBadge()
                        
                    }
                }
                self.tableView.reloadData()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return cartItems.isEmpty == false ? cartItems.count : .zero
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.setData(model: cartItems[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return 100
    }
}
