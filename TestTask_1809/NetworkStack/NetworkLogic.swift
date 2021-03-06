//
//  NetworkingProtocol.swift
//  TestTask_1809
//
//  Created by Nikita Kechinov on 18.09.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


typealias JSON = [String: AnyObject]


public enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}



//MARK: - Building API requests

private enum ApiRequests {
    case GetAllHotels
    case GetImage(imageId: String)
    case GetHotelInfo(hotelId: String)
    
    private var baseURL: URL {
        switch self {
        case .GetAllHotels, .GetHotelInfo(hotelId: _):
            return URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/")!
            
        case .GetImage(imageId: _):
            return URL(string: "https://github.com/iMofas/ios-android-test/raw/master/")!
        }
    }
    
    private var path: String {
        switch self {
        case .GetAllHotels:
            return String("0777.json")
        case .GetImage(imageId: let id):
            return String(id)
        case .GetHotelInfo(hotelId: let id):
            return String(id) + ".json"
        }
    }
    
    var request: URLRequest {
        
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}




//MARK: - Network stack functionality protocols

protocol HotelMetadataDecoding {
    init?(json: JSON)
}

protocol HotelDecoding {
    init?(json: JSON)
}

private protocol Parsing {
    static func fetchHotelArray(from json: [JSON], completionHandler: @escaping ((APIResult<[Hotel]>) -> ())) -> ()
    static func fetchHotelMetadata(from json: JSON, completionHandler: @escaping ((APIResult<HotelMetadata>) -> ()))
}

private protocol GettingHotelImages {
    static func getImageOfHotel(with id: String, completionHandler: @escaping ((APIResult<Data>) -> ()))
}


private protocol GettingHotelData {
    static func getHotels(completionHandler: @escaping ((APIResult<[Hotel]>) -> ()))
    static func getHotelMetadata(with id: String, completionHandler: @escaping ((APIResult<HotelMetadata>) -> ()))
}




//MARK: - Implementation of protocols

extension NetworkManager: Parsing {
    
    static func fetchHotelMetadata(from json: JSON, completionHandler: @escaping ((APIResult<HotelMetadata>) -> ())) {
        
        guard !json.isEmpty else {
            NetworkManager.returnDefaultErrorOnMainThread(with: completionHandler)
            return
        }
        
        guard let hotelMetadata = HotelMetadata(json: json) else {
            NetworkManager.returnDefaultErrorOnMainThread(with: completionHandler)

            return
        }
        
        DispatchQueue.main.async {
            completionHandler(APIResult.Success(hotelMetadata))
        }
    }
    
    
    
    static func fetchHotelArray(from json: [JSON], completionHandler: @escaping ((APIResult<[Hotel]>) -> ())) -> () {
        
        guard json.count > 0 else {
            DispatchQueue.main.async {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("No results. Please, try again!", comment: "")]
                let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
                completionHandler(APIResult.Failure(error))
            }
            return
        }
        var hotelList: [Hotel] = []
        for jsonHotel in json {
            guard let hotel = Hotel(json: jsonHotel) else { continue }
            hotelList.append(hotel)
        }
        
        guard hotelList.count > 0 else {
            NetworkManager.returnDefaultErrorOnMainThread(with: completionHandler)

            return
        }
        
        DispatchQueue.main.async {
            completionHandler(APIResult.Success(hotelList))
        }
    }
    
}




extension NetworkManager: GettingHotelImages {
    
    static func getImageOfHotel(with id: String, completionHandler: @escaping ((APIResult<Data>) -> ())) {
        let urlRequest = ApiRequests.GetImage(imageId: id).request
        
        requestData(with: urlRequest) { (data) in
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }
    }
    
}




extension NetworkManager: GettingHotelData {
    
    static func getHotels(completionHandler: @escaping ((APIResult<[Hotel]>) -> ())) {
        let urlRequest = ApiRequests.GetAllHotels.request
        
        requestData(with: urlRequest) { (data) in
            
            switch data {
            case .Success(let data):
                jsonHandlingQueue.async {
                    guard let jsonData = serializeJSON(from: data) as? [JSON] else { return }
                    fetchHotelArray(from: jsonData, completionHandler: completionHandler)
                }
            case .Failure(let error):
                DispatchQueue.main.async {
                    completionHandler(APIResult.Failure(error))
                }
            }
        }
    }
    
    
    
    static func getHotelMetadata(with id: String, completionHandler: @escaping ((APIResult<HotelMetadata>) -> ())) {
        let urlRequest = ApiRequests.GetHotelInfo(hotelId: id).request
        
        requestData(with: urlRequest) { (data) in
            switch data {
            case .Success(let data):
                jsonHandlingQueue.async {
                    guard let jsonData = serializeJSON(from: data) as? JSON else { return }
                    fetchHotelMetadata(from: jsonData, completionHandler: completionHandler)
                }
            case .Failure(let error):
                DispatchQueue.main.async {
                    completionHandler(APIResult.Failure(error))
                }
            }
        }
    }
    
}




// MARK: - NetworkManager class

final class NetworkManager {
    
    static let jsonHandlingQueue = DispatchQueue(label: "jsonHandling", qos: .background, attributes: .concurrent)
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    //MARK: - base functionality methods
    
    private static func serializeJSON(from data: Data) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            print("can't convert to JSON object!")
            return nil
        }
    }
    
    
    private static func returnDefaultErrorOnMainThread<T>(with completionHandler: @escaping ((APIResult<T>) -> ())) {
        DispatchQueue.main.async {
            let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("No results. Please, try again!", comment: "")]
            let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
            completionHandler(APIResult.Failure(error))
        }
    }
    
    
    private static func requestData(with request: URLRequest,  completionHandler: @escaping ((APIResult<Data>) -> ())) {
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) {  (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Server replied with invalid protocol!", comment: "")]
                let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
                completionHandler(APIResult.Failure(error))
                return
            }
            
            guard error == nil else {
                completionHandler(APIResult.Failure(error!))
                return
            }
            
            switch httpResponse.statusCode {
            case 200: completionHandler(.Success(data!))
            default:
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Requested resource could not be found !", comment: "")]
                let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
                completionHandler(APIResult.Failure(error))
            }
        }
        dataTask.resume()
    }
    
}




