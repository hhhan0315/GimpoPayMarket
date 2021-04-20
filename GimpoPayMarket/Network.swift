//
//  Network.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/20.
//

import Foundation

//let DidReceiveMarketsNotification = Notification.Name("DidReceiveMarkets")

//struct Network {
//    static func requestAPI(address: String) {
//        guard let url = URL(string: address) else { return }
//        
//        let session = URLSession(configuration: .default)
//        let dataTask = session.dataTask(with: url, completionHandler: {
//            (data: Data?, response: URLResponse?, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                let apiResponse = try JSONDecoder().decode(RegionMnyFacltStus.self, from: data)
//                DispatchQueue.main.async {
//                    print(apiResponse)
//                }
//                NotificationCenter.default.post(name: DidReceiveMarketsNotification, object: nil, userInfo: ["markets":apiResponse.markets])
//            } catch(let err) {
//                print(err.localizedDescription)
//                return
//            }
//        })
//        
//        dataTask.resume()
//    }
//}
