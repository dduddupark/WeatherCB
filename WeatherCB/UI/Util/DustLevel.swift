//
//  DustLevel.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/04/06.
//

import Foundation

enum DustLevel {
    case Bad, Soso, Good
}
enum DustText: String {
    case Bad = "나쁨"
    case Soso = "보통"
    case Good = "좋음"
}

func getDustLevel(value: String?) -> DustLevel {
    
    var result = DustLevel.Soso
    
    switch value {
    case "0", "1" :
        result = DustLevel.Bad
    case "2" :
        result = DustLevel.Soso
    case "3" :
        result = DustLevel.Good
    default:
        result = DustLevel.Soso
    }
    
    print("\(value), \(result)")
    
    return result
}

func getDustText(value: String?) -> DustText {
    
    var result = DustText.Soso
    
    switch value {
    case "0", "1" :
        result = DustText.Bad
    case "2" :
        result = DustText.Soso
    case "3" :
        result = DustText.Good
    default:
        result = DustText.Soso
    }
    
    print("\(value), \(result)")
    
    return result
}
