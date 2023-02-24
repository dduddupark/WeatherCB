//
//  CustomAlertView.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/14.
//

import UIKit

class AddressAlertView: UIViewController, DisDelegate {

    //main에서 받을 MyAddress 형 옵셔널 변수
    var receiveAddress: MyAddress?
    
    //delegate required
    func delegateAddress(myAddress: MyAddress) {
            //팝업에서 delegate한 값 textLabel에 뿌려주기
            print(myAddress)
        //main에서 받아온 text Label에 표시
        stateNameLabel.text = myAddress.stateName
        addressLabel.text = myAddress.address
    }
    
    
    private lazy var uiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
        }()
    
    private let stateNameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "Color000000")
        return label
        }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "Color000000")
        return label
        }()
    
    private let cancelButton: UIButton = {
       let btn = UIButton()
        btn.layer.cornerRadius = 16
        btn.titleLabel?.textColor = UIColor(named: "ColorFFFFFF")
        btn.backgroundColor = UIColor(named: "ColorFF7D77")
        return btn
    }()
    
    private let confirmButton: UIButton = {
       let btn = UIButton()
        btn.layer.cornerRadius = 16
        btn.titleLabel?.textColor = UIColor(named: "ColorFFFFFF")
        btn.backgroundColor = UIColor(named: "ColorB1C7FF")
        return btn
    }()
    
    override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
        view.addSubview(uiView)
        uiView.addSubview(stateNameLabel)
        uiView.addSubview(addressLabel)
        uiView.addSubview(cancelButton)
        uiView.addSubview(confirmButton)
        
        //clickListener
        cancelButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        uiView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 50).isActive = true
        uiView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        uiView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
    
        stateNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stateNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        stateNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        stateNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true

        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: self.stateNameLabel.bottomAnchor, constant: 10).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 10).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: self.cancelButton.trailingAnchor, constant: 20).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor, constant: 10).isActive = true
       }
    
    @objc func clickButton(_ sender: Any) {
        print("sender = \(sender)")
        //self.moveMainVC()
    }
    
    func moveMainVC() {
        let pushVC = AddressViewController()
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true)
    }
}
