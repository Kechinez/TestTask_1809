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


private enum ApiRequests {
    case GetAllHotels
    case GetImage(hotelId: String)
    case GetHotelInfo(hotelId: String)
    
    private var baseURL: URL {
        switch self {
        case .GetAllHotels, .GetHotelInfo(hotelId: _):
            return URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/")!

        case .GetImage(hotelId: _):
            return URL(string: "https://github.com/iMofas/ios-android-test/raw/master/")!
        }
    }
    
    private var path: String {
        switch self {
        case .GetAllHotels:
            return String("0777.json")
        case .GetImage(hotelId: let id):
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



protocol HotelDecoding {
    init?(json: JSON)
}

private protocol Parsing {
    static func fetchHotelArray(from json: [JSON], completionHandler: @escaping ((APIResult<[Hotel]>) -> ())) -> ()
    static func fetchHotel(from json: JSON, completionHandler: @escaping ((APIResult<Hotel>) -> ()))
}


extension NetworkManager: Parsing {
   
    static func fetchHotel(from json: JSON, completionHandler: @escaping ((APIResult<Hotel>) -> ())) {
        
        guard !json.isEmpty else {
            DispatchQueue.main.async {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("No results. Please, try again!", comment: "")]
                let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
                completionHandler(APIResult.Failure(error))
            }
            return
        }
        
        guard let hotel = Hotel(json: json) else {
            DispatchQueue.main.async {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("No results. Please, try again!", comment: "")]
                let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
                completionHandler(APIResult.Failure(error))
            }
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(APIResult.Success(hotel))
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
            DispatchQueue.main.async {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("No results. Please, try again!", comment: "")]
                let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
                completionHandler(APIResult.Failure(error))
            }
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(APIResult.Success(hotelList))
        }
    }




}


private protocol GettingHotelImages {
    static func getImageOfHotel(with id: String, completionHandler: @escaping ((APIResult<Data>) -> ()))
}


private protocol GettingHotelData {
    static func getHotels(completionHandler: @escaping ((APIResult<[Hotel]>) -> ()))
    static func getHotel(with id: String, completionHandler: @escaping ((APIResult<Hotel>) -> ()))
}



extension NetworkManager: GettingHotelImages {
    
    static func getImageOfHotel(with id: String, completionHandler: @escaping ((APIResult<Data>) -> ())) {
        let urlRequest = ApiRequests.GetImage(hotelId: id).request
        
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
                
                
            case .Failure(let error): print(error)
            }
        }
    }
    
    
    static func getHotel(with id: String, completionHandler: @escaping ((APIResult<Hotel>) -> ())) {
        let urlRequest = ApiRequests.GetHotelInfo(hotelId: id).request
        
        requestData(with: urlRequest) { (data) in
            switch data {
            case .Success(let data):
                jsonHandlingQueue.async {
                    guard let jsonData = serializeJSON(from: data) as? JSON else { return }
                    fetchHotel(from: jsonData, completionHandler: completionHandler)
                }
                
                
            case .Failure(let error): print(error)
            }
        }
    }
    

}


final class NetworkManager {
    
    static let jsonHandlingQueue = DispatchQueue(label: "jsonHandling", qos: .background, attributes: .concurrent)
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    
    private static func serializeJSON(from data: Data) -> Any? {
        if !Thread.isMainThread {
            print("JSON serialization runs on background")
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            print("can't convert to JSON object!")
            return nil
        }
    }
    
    
    private static func requestData(with request: URLRequest,  completionHandler: @escaping ((APIResult<Data>) -> ())) {
        
        let session = URLSession(configuration: .default)
        let urlRequest = ApiRequests.GetAllHotels.request
        
        let dataTask = session.dataTask(with: urlRequest) {  (data, response, error) in
            
            if !Thread.isMainThread {
                print("callback of dataTask runs on background")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completionHandler(APIResult.Failure(error!))
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(APIResult.Failure(error!))
                }
                return
            }
            
            switch httpResponse.statusCode {
            case 200: completionHandler(.Success(data!))
            default: break
            }
        }
        dataTask.resume()
    }



}




