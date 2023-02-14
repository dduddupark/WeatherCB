//
//  DustData.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/13.
//

import Foundation

struct DustData: Codable {
    let response: DustResponse?
}

struct DustResponse: Codable {
    let header: Header?
    let body: DustBody?
}

struct DustBody: Codable {
    let totalCount: Int?
    let items: [Dust]?
}

struct Dust: Codable {
    let so2Grade: String?   //아황산가스 지수
    let khaiValue: String?  //통합대기환경수치
    let so2Value: String?   //아황산가스 농도
    let coValue: String?    //일산화탄소 농도
    let pm10Value: String?  //미세먼지(PM10) 농도
    let o3Grade: String?    //오존 지수
    let khaiGrade: String?  //통합대기환경지수
    let pm25Value: String?  //미세먼지(PM2.5) 농도
    let no2Grade: String?   //이산화질소 지수
    let pm25Grade: String?  //미세먼지(PM2.5) 24시간 등급자료
    let dataTime: String?   //발표 시간
    let coGrade: String?    //일산화탄소 지수
    let no2Value: String?   //이산화질소 농도
    let pm10Grade: String?  //미세먼지(PM10) 24시간 등급
    let o3Value: String?    //오존 농도
}
