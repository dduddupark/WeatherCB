//
//  AddressItemView.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/03/02.
//

import UIKit

protocol AddressItemProtocol {
    func selectAddress(address: CoreAddress)
    func deleteAddress(address: CoreAddress)
}

class AddressItemView: UITableViewCell {
    
    var address: CoreAddress?
    var delegate : AddressItemProtocol?
    
    private let isSelectedButton: UIButton = {
        return UIButton()
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("삭제", for: .normal)   //highlighted는 버튼 클릭했을때
        btn.backgroundColor = .red
        return btn
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem(address: CoreAddress) {
        self.address = address
        
        stateLabel.text = address.stateName
        addressLabel.text = address.address
        
        var image = UIImage(named: "selected")!
        
        if !address.isSelected {
            image = UIImage(named: "unselected")!
        }
        
        isSelectedButton.setImage(image, for: UIControl.State.normal)
    }
    
    private func setConstraint() {
        
        contentView.addSubview(isSelectedButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(stateLabel)
        contentView.addSubview(addressLabel)
        
        //self.addTarget(self, action: #selector(selectAddress), for: .touchUpInside)
   
        isSelectedButton.translatesAutoresizingMaskIntoConstraints = false
        isSelectedButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        isSelectedButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        isSelectedButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteAddress), for: .touchUpInside)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteAddress), for: .touchUpInside)
        
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        stateLabel.leadingAnchor.constraint(equalTo: self.isSelectedButton.trailingAnchor, constant: 10).isActive = true
     
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: self.stateLabel.bottomAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: self.isSelectedButton.trailingAnchor, constant: 10).isActive = true
    }

    @objc func deleteAddress(_ sender: Any) {
        print("deleteAddress")
        if let address = self.address {
            print("address = \(address), delegate = \(delegate)")
            delegate?.deleteAddress(address: address)
        }
    }
    
    @objc func selectAddress(_ sender: Any) {
        print("deleteAddress")
        if let address = self.address {
            print("address = \(address), delegate = \(delegate)")
            delegate?.selectAddress(address: address)
        }
    }
}
