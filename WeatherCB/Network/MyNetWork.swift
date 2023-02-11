//
//  MyNetWork.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/09.
//

import UIKit

let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)
var urlComponents = URLComponents(string:"http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty&returnType=json")!
