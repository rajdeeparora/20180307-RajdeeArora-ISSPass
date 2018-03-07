//
//  ServicesCall.swift
//  JPMCCode
//
//  Created by Rajdeep Arora on 3/6/18.
//  Copyright © 2018 Rajdeep Arora. All rights reserved.
//

import UIKit
import  CoreLocation

class ServicesCall: NSObject {
    
    static let sharedInstance = ServicesCall()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        config.timeoutIntervalForRequest = TimeInterval(90)
        config.timeoutIntervalForResource = TimeInterval(90)
        return URLSession(configuration: config)
    }()
    
    class func GetDataFromServer(latitude: CLLocationDegrees, longitude: CLLocationDegrees , handler: @escaping (_ inner: () throws -> [String: Any]?) -> Void)     {
        // Set up the URL request
        let todoEndpoint: String = "http://api.open-notify.org/iss-pass.json?lat=\(latitude)&lon=\(longitude)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                 handler({todo})
                
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
               
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func executeService(urlPath: String, httpMethodType: String, body: String?, completionHandler: @escaping (NSDictionary?, NSError?) -> Void) {
       
            URLCache.shared.removeAllCachedResponses()
            let storage = HTTPCookieStorage.shared
            if let cookies = storage.cookies {
                for cookie in cookies {
                    storage.deleteCookie(cookie)
                }
            }
            
            if let url = NSURL(string: urlPath) {
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = httpMethodType
                
                if let bodyString = body {
                    let jsonData = bodyString.data(using: .utf8, allowLossyConversion: false)
                    request.httpBody = jsonData
                }
                
                let task = session.dataTask(with: request as URLRequest) {data, response, error in
                    do {
                        if let data = data {
                            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                var statuscode :NSInteger?
                                if let httpResponse = response as? HTTPURLResponse {
                                    statuscode = httpResponse.statusCode
                                    if statuscode == 200 {
                                        completionHandler(jsonResult, nil)
                                    } else {
                                        if let status = jsonResult.object(forKey: "status") as? Int {
                                            let error = NSError(domain: "", code: status, userInfo: nil)
                                            completionHandler(nil, error)
                                        }
                                    }
                                }
                            }
                        } else {
                            if let error = error {
                                completionHandler(nil, error as NSError)
                            }
                        }
                    }
                    catch let error as NSError {
                        completionHandler(nil, error)
                    }
                }
                
                task.resume()
            }
         else {
            let error = NSError(domain: "", code: -1009, userInfo: nil)
            completionHandler(nil, error)
        }
    }
    
    
}
