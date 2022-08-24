//
//  TFLClient.swift
//  BikeBay
//
//  Created by Aleksandrs Trubacs on 24/08/2022.
//

import Foundation

class TFLClient {

    enum Endpoints {
        
        static let base = "https://api.tfl.gov.uk/BikePoint"
        
        case bikePoints
        
        var stringValue: String {
            switch self {
            case .bikePoints:
                return Endpoints.base
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    //MARK: Networking Methods
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
          let task = URLSession.shared.dataTask(with: url) { data, response, error in
              guard let data = data else {
                  DispatchQueue.main.async {
                      completion(nil, error)
                  }
                  return
              }
              let decoder = JSONDecoder()
              do {
                  let responseObject = try decoder.decode(responseType, from: data)
                  print("responseObject: \(responseObject)")
                  DispatchQueue.main.async {
                      completion(responseObject, nil)
                  }
              } catch {
                  do {
                      let errorResponse = try decoder.decode(responseType.self, from: data) as! Error
                      DispatchQueue.main.async {
                          completion(nil, errorResponse)
                      }
                  } catch {
                      DispatchQueue.main.async {
                          completion(nil, error)
                      }
                  }
              }
          }
          task.resume()
          
          return task
      }
    
    class func downloadingBikeBay(completion: @escaping (TFLResponseElement?,Error?) -> Void) {
        taskForGETRequest(url: Endpoints.bikePoints.url, responseType: TFLResponseElement.self) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}