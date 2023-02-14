//
//  HttpConnection.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/11.
//

import Foundation

enum UrlType {
    case ArpltnInfo
    case DustInfo
}

extension String {
    func decodeURL() -> String? {
        return self.removingPercentEncoding?.replacingOccurrences(of: "%25", with: "%")
    }
    
    func encodeURL() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
}

private func defaultQuery() -> Dictionary<String, String> {
    return [
        "serviceKey":"FL2Lf%2FVBu34lWCZPPSRLuLagD0WRz3x51SIhLjGQIoMAVvoe1aVKhcqa4DKYrMV1y8BhLoL%2BnNsnekMOROXkWQ%3D%3D",
        "pageNo":"1",
        "numOfRows":"10",
        "returnType":"json"
    ]
}

enum APIError: Error {
       case data
       case decodingJSON
   }

func fetchServer<T: Codable>(type: UrlType, query: Dictionary<String, String>, completion: @escaping (Result<T,APIError>) -> Void) {
    
    var urlComponents: URLComponents?
    
    print("type = \(type)")
    
    switch(type) {
    case .ArpltnInfo:
        urlComponents = URLComponents(string: "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getMsrstnList?")
    case .DustInfo:
       urlComponents = URLComponents(string: "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?")
    }
    
    for item in defaultQuery() {
        print("기본 query is \(item)")
        urlComponents?.queryItems?.append(URLQueryItem(name: item.key, value: item.value)) // 파라미터
    }
    
    for item in query {
        print("item is \(item)")
        urlComponents?.queryItems?.append(URLQueryItem(name: item.key, value: item.value)) // 파라미터
    }
    
    let url: String? = urlComponents?.string
    let encodedSpacingStr = url?.replacingOccurrences(of: "%25", with: "%") ?? ""
    guard let myUrl = URL(string: encodedSpacingStr) else {return}
    
    print("myUrl = \(myUrl)")

    // [http 통신 타입 및 헤더 지정 실시]
    var requestURL = URLRequest(url: myUrl)
    requestURL.httpMethod = "GET" // GET
    requestURL.addValue("application/x-www-form-urlencoded; charset=utf-8;", forHTTPHeaderField: "Content-Type") // GET
    
    URLSession.shared.dataTask(with: requestURL) { data, response, error in
    
            guard let data = data else {
                return completion(.failure(.data))
            }

            do {
                
                let resultString = String(data: data, encoding: .utf8) ?? "" // 응답 메시지
                print("resultString = \(resultString)")
                
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                print("catch")
                completion(.failure(.decodingJSON))
            }

        }.resume()
}



let serviceKey = "FL2Lf%2FVBu34lWCZPPSRLuLagD0WRz3x51SIhLjGQIoMAVvoe1aVKhcqa4DKYrMV1y8BhLoL%2BnNsnekMOROXkWQ%3D%3D"

func fetchModel<T: Codable>(type: UrlType, address: String, completion: @escaping (Result<T,APIError>) -> Void) {
    
    let addr: String = "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getMsrstnList?serviceKey=\(serviceKey)&pageNo=1&numOfRows=10&returnType=json&addr=\(address)"
    
    guard let endodeStr = addr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
    let encodedSpacingStr = endodeStr.replacingOccurrences(of: "%25", with: "%")
    
    guard let myUrl = URL(string: encodedSpacingStr) else {return}
    
    print("myUrl = \(myUrl)")
    
    // [http 통신 타입 및 헤더 지정 실시]
    var requestURL = URLRequest(url: myUrl)
    requestURL.httpMethod = "GET" // GET
    requestURL.addValue("application/x-www-form-urlencoded; charset=utf-8;", forHTTPHeaderField: "Content-Type") // GET
    
    URLSession.shared.dataTask(with: requestURL) { data, response, error in
    
            guard let data = data else {
                return completion(.failure(.data))
            }

            do {
                let resultString = String(data: data, encoding: .utf8) ?? "" // 응답 메시지
                print("resultString = \(resultString)")
                
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                print("catch")
                completion(.failure(.decodingJSON))
            }

        }.resume()
}

func requestGet(type: UrlType, query: Dictionary<String, String>) -> Void {
    // [URL 지정 및 파라미터 값 지정 실시]
    var urlComponents: URLComponents?
    
    switch(type) {
    case .ArpltnInfo:
        urlComponents = URLComponents(string: "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getMsrstnList")
    case .DustInfo:
        urlComponents = URLComponents(string: "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc?")
    }
    
    for item in query {
        print("item is \(item)")
        urlComponents?.queryItems?.append(URLQueryItem(name: item.key, value: item.value)) // 파라미터
    }
    
    for item in defaultQuery() {
        print("기본 query is \(item)")
        urlComponents?.queryItems?.append(URLQueryItem(name: item.key, value: item.value)) // 파라미터
    }
    
    // [http 통신 타입 및 헤더 지정 실시]
    var requestURL = URLRequest(url: (urlComponents?.url)!)
    requestURL.httpMethod = "GET" // GET
    requestURL.addValue("application/x-www-form-urlencoded; charset=utf-8;", forHTTPHeaderField: "Content-Type") // GET
    
    
    // [http 요쳥을 위한 URLSessionDataTask 생성]
    print("")
    print("====================================")
    print("[requestGet : http get 요청 실시]")
    print("url : ", requestURL)
    print("====================================")
    print("")
    let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
        
        // [error가 존재하면 종료]
        guard error == nil else {
            print("")
            print("====================================")
            print("[requestGet : http get 요청 실패]")
            print("fail : ", error?.localizedDescription ?? "")
            print("====================================")
            print("")
            return
        }
        
        // [status 코드 체크 실시]
        let successsRange = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
        else {
            print("")
            print("====================================")
            print("[requestGet : http get 요청 에러]")
            let errorCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            let errorMsg = (response as? HTTPURLResponse)?.description ?? ""
            print("error : ", errorCode)
            print("msg : ", errorMsg)
            print("====================================")
            print("")
            return
        }
        
        // [response 데이터 획득, utf8인코딩을 통해 string형태로 변환]
        let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let resultLen = data! // 데이터 길이
        let resultString = String(data: resultLen, encoding: .utf8) ?? "" // 응답 메시지
        print("")
        print("====================================")
        print("[requestGet : http get 요청 성공]")
        print("resultCode : ", resultCode)
        print("resultLen : ", resultLen)
        print("resultString : ", resultString)
        
        print("====================================")
        print("")
    }
    
    // network 통신 실행
    dataTask.resume()
}
