//
//  ServiceError.swift
//  UploadPhotosPOC
//
//  Created by Matheus Henrique Mendes Alexandre on 24/10/22.
//

enum HttpMethod: String {
    case post = "POST"
}

enum ServiceError: String, Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unableToParseJson
    case emptySearch
    case failedToGetCity
    case badRequest
}
