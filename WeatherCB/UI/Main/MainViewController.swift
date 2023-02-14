//
//  ViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/09.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

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
        
        view.addSubview(mapButton)
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        mapButton.addTarget(self, action: #selector(moveMain), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(address)
        if address != "" {
            print("getWeatherData")
            getWeatherData()
        }
    }
    
    @objc func moveMain(_ sender: Any) {
        self.moveMainVC()
    }
    
    func moveMainVC() {
        let pushVC = AddressViewController()
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true)
    }
    
    private func getWeatherData() {
        
        let addressList = address.components(separatedBy: " ")
        
        if(addressList.count > 2) {
            //측정소명 가져오기
            fetchServer(type: .ArpltnInfo,
                        query: ["addr" : addressList[0] + " " + addressList[1]]) {
                (result: Result<AddressData, APIError>) in
                switch result {
                case .success(let model):
                    print("success \(model)")

                    let address = model.response?.body?.items?.first?.stationName
                    if let address {
                        //미세먼지 데이터 가져오기
                        fetchServer(type: .DustInfo,
                                    query: ["stationName" : address, "dataTerm" : "DAILY", "ver" : "1.0"]) {
                            (result: Result<DustData, APIError>) in
                            switch result {
                            case .success(let model):
                                print("success \(model)")

                            case .failure(let error):
                                print("error \(error)")
                            }
                        }
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
           
        } else {
            print("없는 주소 입니다.")
        }
    }
}
