//
//  MapViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/09.
//

import UIKit




class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    
        let mapView = MTMapView(frame: self.view.frame)
        mapView.baseMapType = .standard
        
        // 현재 위치 트래킹
        mapView.currentLocationTrackingMode = .onWithoutHeading
        mapView.showCurrentLocationMarker = true
        
        self.view.addSubview(mapView)
        
    
    }
    
    
}
