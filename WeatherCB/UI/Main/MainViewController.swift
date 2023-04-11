//
//  ViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/09.
//

import UIKit
import CoreLocation
import Lottie

class MainViewController: UIViewController {
    
    private let dustStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 10
        return view
    }()
    
    var delegate: DisDelegate?
    
    var coreAddress: CoreAddress?
    
    private let mapButton: UIButton = {
        var filled = UIButton.Configuration.plain()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        filled.image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfiguration)
        filled.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10)
        
        let btn = UIButton(configuration: filled, primaryAction: nil)
        
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
        let pointAddress = UserDefaults.standard.string(forKey: key_address)
        
        CoreDataManager.shared.findCoreAddress(address: pointAddress ?? "") { data in
            if data == nil {
                self.showEmptyView()
            } else {
                self.coreAddress = data
                
                if let stateName = data?.stateName {
                    fetchServer(type: .DustInfo,
                                query: ["stationName" : stateName,
                                        "dataTerm" : "DAILY",
                                        "ver" : "1.0"]) {
                        (result: Result<DustData, APIError>) in
                        switch result {
                        case .success(let model):
                            if  model.response?.body?.items?.count ?? 0 > 0 {
                                if let data = model.response?.body?.items?[0] {
                                    print("success \(data)")
                                    DispatchQueue.main.async {
                                        self.showDustView(dustData: data)
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            print("failure \(error)")
                        }
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
        
        print("showDustView 진입")
        
        //주소
        let tvAddress = UILabel()
        tvAddress.text = "현재 주소\n\(coreAddress?.address ?? "")"
        tvAddress.font = .systemFont(ofSize: 18)
        tvAddress.textColor = .black
        tvAddress.numberOfLines = 0
        tvAddress.textAlignment = .center
        
        view.addSubview(tvAddress)
        
        tvAddress.translatesAutoresizingMaskIntoConstraints = false
        tvAddress.topAnchor.constraint(equalTo: self.mapButton.bottomAnchor, constant: 20).isActive = true
        let centerX = tvAddress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerX.isActive = true
        
        //메인 미세먼지
        let dustInfoViewMain = DustInfoView()
        view.addSubview(dustInfoViewMain)
        
        dustInfoViewMain.backgroundColor = .blue
       
        switch dustData.pm10Grade {
        case "0", "1" :
            view.backgroundColor = .red
        case "2" :
            view.backgroundColor = .yellow
        case "3" :
            view.backgroundColor = .blue
        default:
            view.backgroundColor = .yellow
        }
        
        dustInfoViewMain.translatesAutoresizingMaskIntoConstraints = false
        dustInfoViewMain.topAnchor.constraint(equalTo: tvAddress.bottomAnchor, constant: 20).isActive = true
        let centerXdustInfoViewMain = dustInfoViewMain.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerXdustInfoViewMain.isActive = true
        
        dustInfoViewMain.loadView(grade: dustData.pm10Grade ?? "", text: getDustText(value: dustData.pm10Grade).rawValue, emojiSize: 200, fontSize: 30)
        
        //먼지 정보 리스트
        view.addSubview(dustStackView)

        dustStackView.translatesAutoresizingMaskIntoConstraints = false
        dustStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200).isActive = true
        dustStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        dustStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        
        let dustInfoView10 = DustInfoView()
        dustStackView.addArrangedSubview(dustInfoView10)
        dustInfoView10.topAnchor.constraint(equalTo: dustStackView.topAnchor).isActive = true
        dustInfoView10.bottomAnchor.constraint(equalTo: dustStackView.bottomAnchor).isActive = true
        dustInfoView10.loadView(grade: dustData.pm10Grade ?? "", text: "미세먼지 농도\n\(String(describing: dustData.pm10Value ?? ""))", emojiSize: 70, fontSize: 12)

        let dustInfoView25 = DustInfoView()
        dustStackView.addArrangedSubview(dustInfoView25)
        dustInfoView25.topAnchor.constraint(equalTo: dustStackView.topAnchor).isActive = true
        dustInfoView25.bottomAnchor.constraint(equalTo: dustStackView.bottomAnchor).isActive = true
        dustInfoView25.loadView(grade: dustData.pm25Grade ?? "", text: "초미세먼지 농도\n\(String(describing: dustData.pm25Value ?? ""))", emojiSize: 70, fontSize: 12)
        
        let dustInfoViewNo2 = DustInfoView()
        dustStackView.addArrangedSubview(dustInfoViewNo2)
        dustInfoViewNo2.topAnchor.constraint(equalTo: dustStackView.topAnchor).isActive = true
        dustInfoViewNo2.bottomAnchor.constraint(equalTo: dustStackView.bottomAnchor).isActive = true
        dustInfoViewNo2.loadView(grade: dustData.no2Grade ?? "", text: "이산화질소\n\(String(describing: dustData.no2Value ?? ""))", emojiSize: 70, fontSize: 12)
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

class DustInfoView: UIView {
    
    //미세먼지
    private let animationView: LottieAnimationView? = nil
    
   private let label : UILabel = {
        let label = UILabel()
       label.textColor = UIColor(named: "Color000000")
       label.textAlignment = .center
       label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadView(grade: String, text: String, emojiSize: Int, fontSize: Int) {
        
        label.text = text
        label.font = .boldSystemFont(ofSize: CGFloat(fontSize))
    
        var animation: LottieAnimation? = nil
        
        switch getDustLevel(value: grade) {
        case DustLevel.Bad :
            animation = LottieAnimation.named("emoji_sad")
        case DustLevel.Good :
            animation = LottieAnimation.named("emoji_happy")
        case .Soso:
            animation = LottieAnimation.named("emoji_soso")
        }
        
       let animationView = LottieAnimationView(animation: animation)
        animationView.center = self.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        
        addSubview(label)
        addSubview(animationView)
        
        animationView.play()
        
        animationView.backgroundColor = .orange
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: CGFloat(emojiSize)).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: CGFloat(emojiSize)).isActive = true
        let centerXanimationView = animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        centerXanimationView.isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 6).isActive = true
        let centerXtopAnchor = label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        centerXtopAnchor.isActive = true
    }
}
