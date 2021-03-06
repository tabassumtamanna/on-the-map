//
//  OnTheMapUser.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/25/21.
//

import Foundation

// MARK: - On The Map User
class OnTheMapUser {
    
    struct Auth {
        static var uniqueKey = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case signup
        case logout
        case getStudentLocations
        case getPublicUserData
        case postingStudentLocation
        
        var stringValue: String {
            switch self {
           
            case .login:
                return Endpoints.base + "/session"
            
            case .signup:
                return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com"
            
            case .logout:
                return Endpoints.base + "/session"
                
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
                
            case .getPublicUserData:
                return Endpoints.base + "/users/\(Auth.uniqueKey)"
            
            case .postingStudentLocation:
                return Endpoints.base + "/StudentLocation"
            
            }
        }
        
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Task For Get Request
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, skipFirstCharacters: Bool, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var newData = data
            
            if skipFirstCharacters {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
           
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do{
                    let errorResponse = try decoder.decode(OnTheMapErrorResponse.self, from: newData) as Error
                    
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
    
    // MARK: - Task For Post Request
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, skipFirstCharacters: Bool,  completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request)  {(data, response, error) in
           
            guard let data = data else {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var newData = data
            
            if skipFirstCharacters {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
            
            let docoder = JSONDecoder()
            
            do {
                let requestObject = try docoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(requestObject, nil)
                }
                
            } catch {
                do{
                    let errorResponse = try docoder.decode(OnTheMapErrorResponse.self, from: newData) as Error
                    
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
        
    }

    // MARK: - Login
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        
        let body = LoginRequest(username: username, password: password)
        
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body, skipFirstCharacters: true) { (response, error) in
            
            if let response = response {
                Auth.uniqueKey = response.account.key
                
                completion(response.account.registered, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: - Logout
    class func logout(completion: @escaping () -> Void){
        
        var request = URLRequest(url: Endpoints.logout.url)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.uniqueKey = ""
            completion()
        }
            
        task.resume()
        
    }
    
    // MARK: - Get Student Locations
    class func getStudentLocations(completion: @escaping ([StudentInfo], Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentInfoResults.self, skipFirstCharacters: false) { response, error in
            if let response = response {
                
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // MARK: - Get Public User Data
    class func getPublicUserData(completion: @escaping(String?, String?, Error?) -> Void){
        
        taskForGETRequest(url: Endpoints.getPublicUserData.url, responseType: User.self, skipFirstCharacters: true) { (response, error) in
            
            if let response = response{
                
                completion(response.firstName, response.lastName, nil)
            } else {
                completion(nil, nil, error)
            }
        }
    }
    
    // MARK: -  Posting Student Location
    class func postingStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion: @escaping (Bool, Error?) -> Void){
        
       
        let body = PostingLocationRequest(uniqueKey: Auth.uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPOSTRequest(url: Endpoints.postingStudentLocation.url, responseType: PostingLocationResponse.self, body: body, skipFirstCharacters: false){( response, error) in
            
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
        
    }
    
    
}
