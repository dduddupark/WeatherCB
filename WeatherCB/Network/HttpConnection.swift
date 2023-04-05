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
