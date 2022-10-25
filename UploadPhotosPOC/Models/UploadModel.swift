//
//  UploadModel.swift
//  UploadPhotosPOC
//
//  Created by Matheus Henrique Mendes Alexandre on 24/10/22.
//

import Foundation

struct UploadModel: Decodable {

    let id: String
    let breweryId: String
    let url: String
  
    enum CodingKeys: String, CodingKey {
        case id
        case breweryId = "brewery_id"
        case url
    }
}
