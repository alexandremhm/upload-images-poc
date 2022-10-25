//
//  Service.swift
//  UploadPhotosPOC
//
//  Created by Matheus Henrique Mendes Alexandre on 24/10/22.
//

import Foundation

struct Constants {
    static let baseUrl = "https://bootcamp-mobile-01.eastus.cloudapp.azure.com/breweries"
    static let cityBaseUrl = "?by_city="
    static let topTen = "/breweries/topTen"
    static let evaluationBaseUrl = "/myEvaluations/"
    static let uploadPhoto = "/photos/upload"
    static let breweryPhotos = "/photos"
}

protocol ServiceProtocol {
    func uploadImage(data: Data, boundary: String, breweryId: String)
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void)
}

class Service: ServiceProtocol {
    
    func uploadImage(data: Data, boundary: String, breweryId: String) {
        
        let stringURL = "\(Constants.baseUrl)\(Constants.uploadPhoto)?brewery_id=\(breweryId)"
        let url = URL(string: stringURL)
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) {
        
        let urlString = "\(Constants.baseUrl)\(Constants.breweryPhotos)/\(breweryId)"
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else {
                
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let images = try decoder.decode([UploadModel].self, from: data)
                completion(.success(images))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        task.resume()
    }
    
}
