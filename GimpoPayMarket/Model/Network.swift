//
//  Network.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/20.
//
import Foundation

let DidReceiveDataNotification = Notification.Name("DidReceiveData")

struct Network {
    static func requestAPI(address: String) {
        let session = URLSession(configuration: .default)
        
        guard let url = URL(string: address) else {
            print("URL is nil")
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let dataModel: DataModel = try JSONDecoder().decode(DataModel.self, from: data)
                
                // DidReceiveDataNotification 에 해당하면 처리 바란다.
                NotificationCenter.default.post(name: DidReceiveDataNotification, object: nil, userInfo: ["data":dataModel.regionMnyFacltStus])
                
            } catch DecodingError.keyNotFound(let key, let context) {
                Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.typeMismatch(let type, let context) {
                Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(let context) {
                Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
            } catch let error as NSError {
                NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
}
