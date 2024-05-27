//
//  HomeModel.swift
//  EterationCaseUIKit
//
//  Created by arge-macbook-air on 25.05.2024.
//

struct HomeModel : Codable {
    
    let createdAt : String?
    let name : String?
    let image : String?
    let price : String?
    let description : String?
    let model : String?
    let brand : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case createdAt = "createdAt"
        case name = "name"
        case image = "image"
        case price = "price"
        case description = "description"
        case model = "model"
        case brand = "brand"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        model = try values.decodeIfPresent(String.self, forKey: .model)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}
