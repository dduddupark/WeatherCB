//
//  ViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/09.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {
    
    var delegate: DisDelegate?
    
    private let mapButton: UIButton = {
       let btn = UIButton()
        let image = UIImage(named: "search")!
        btn.setImage(image, for: UIControl.State.normal)
        return btn
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 위치가 없어요.\n우측 상단에서 우리집 주소를 검색해보세요!"
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "Color000000")
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        checkData()
        showDefaultView()
    }
    
    private func checkData() {
        let pointStateName = UserDefaults.standard.string(forKey: key_stateName)
        
        print("pointStateName = \(pointStateName)")
        
        if pointStateName == nil {
            showEmptyView()
        } else {
            if let stateName = pointStateName {
                fetchServer(type: .DustInfo,
                            query: ["stationName" : stateName,
                                    "dataTerm" : "DAILY",
                                    "ver" : "1.0"]) {
                    (result: Result<DustData, APIError>) in
                    switch result {
                    case .success(let model):
                       if let data = model.response?.body?.items?[0] {
                           print("success \(data)")
                           self.showDustView(dustData: data)
                        }
                    case .failure(let error):
                        print("failure \(error)")
                    }
                }
            }
        }
    }
    
    private func showEmptyView() {
        view.addSubview(emptyLabel)
     
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        emptyLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func showDefaultView() {
        view.addSubview(mapButton)
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        mapButton.addTarget(self, action: #selector(moveMain), for: .touchUpInside)
    }
    
    private func showDustView(dustData: Dust) {
        view.addSubview(mapButton)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkData()
    }
    
    @objc func moveMain(_ sender: Any) {
        self.moveMainVC()
    }
    
    func moveMainVC() {
        let pushVC = AddressViewController()
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true)
    }
}
