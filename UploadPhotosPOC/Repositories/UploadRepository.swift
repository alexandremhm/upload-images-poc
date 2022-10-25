//
//  UploadRepository.swift
//  UploadPhotosPOC
//
//  Created by Matheus Henrique Mendes Alexandre on 24/10/22.
//

import Foundation

protocol UploadRepositoryProtocol {
    func uploadImage(data: Data, boundary: String, breweryId: String)
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void)
}

class UploadRepository: UploadRepositoryProtocol {
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String) {
        service.uploadImage(data: data, boundary: boundary, breweryId: breweryId)
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) {
        service.fetchBreweryImages(breweryId: breweryId) { response in
            completion(response)
        }
    }

}
