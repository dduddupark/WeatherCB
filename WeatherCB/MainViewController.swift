//
//  ViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/09.
//

import UIKit
import CoreLocation

protocol SendData{
    func sendData(data: Location)
}

struct Location {
    var x: Double
    var y: Double
}

class MainViewController: UIViewController {

    var locationManager: CLLocationManager!
    
    var currentLocation: Location?
    
    //protocol 변수 생성
    var delegate: SendData?
    
    var address = ""
    
    private let mapButton: UIButton = {
       let btn = UIButton()
        let image = UIImage(named: "search")!
        btn.setImage(image, for: UIControl.State.normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        getLocationUsagePermission()
        
        view.addSubview(mapButton)
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        mapButton.addTarget(self, action: #selector(moveMain), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(address)
    }
    
    @objc func moveMain(_ sender: Any) {
        self.moveMainVC()
    }
    
    func moveMainVC() {
        let pushVC = AddressViewController()
        pushVC.modalPresentationStyle = .fullScreen
        
        //protocol func
        if let currentLocation {
            self.delegate?.sendData(data: currentLocation)
        }

        self.present(pushVC, animated: true)
    }
    
    private func setView(loation: Location) {
        
        currentLocation = loation
        
        print("latitude" + String(loation.x) + "/ longitude" + String(loation.y))
    }
    
    
}

extension MainViewController: CLLocationManagerDelegate {
    //이곳에서 delegate 메소드나 location manager를 다루면 된다.
    
    func getLocationUsagePermission() {
        //location4
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            //location5
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
                if let coor = manager.location?.coordinate {
                    print("이ㅑ이야")
                    self.setView(loation: Location(x: coor.latitude, y: coor.longitude))
                }
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                getLocationUsagePermission()
            case .denied:
                print("GPS 권한 요청 거부됨")
                getLocationUsagePermission()
            default:
                print("GPS: Default")
            }
        }
}

