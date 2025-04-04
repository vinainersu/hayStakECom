//
//  ProductModel.swift
//  HayStekTask
//
//  Created by Geethansh  on 04/04/25.
//

struct ProductsModel: Codable {
    var title: String?
    var price: Double?
    var description: String?
    var category: String?
    var image: String?
    var rating: RatingModel?
    var isAddedToCart: Bool? = false
}
struct RatingModel: Codable {
    var rate: Double?
    var count: Int?
}
