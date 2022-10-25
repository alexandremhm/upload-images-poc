//
//  UploadViewModel.swift
//  UploadPhotosPOC
//
//  Created by Matheus Henrique Mendes Alexandre on 24/10/22.
//

import Foundation

class UploadViewModel {
    
    private let uploadRepository: UploadRepositoryProtocol
    
    init(uploadRepository: UploadRepositoryProtocol = UploadRepository()) {
        self.uploadRepository = uploadRepository
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String) {
        uploadRepository.uploadImage(data: data, boundary: boundary, breweryId: breweryId)
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) {
        uploadRepository.fetchBreweryImages(breweryId: breweryId) { response in
            completion(response)
        }
    }
}
