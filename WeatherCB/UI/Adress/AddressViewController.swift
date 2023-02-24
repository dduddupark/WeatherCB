//
//  AddressViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/11.
//

import UIKit
import WebKit


// delegate protocol
protocol DisDelegate{
    func delegateAddress(myAddress: MyAddress)
}


class AddressViewController: UIViewController {
    
    var delegate: DisDelegate?
    
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    
    private let searchAddressButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("내 주소 찾기", for: .highlighted)
        btn.backgroundColor = .blue
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
    }
    
    private func setView() {
        view.addSubview(searchAddressButton)
        
        searchAddressButton.translatesAutoresizingMaskIntoConstraints = false
        searchAddressButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchAddressButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchAddressButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        searchAddressButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        searchAddressButton.addTarget(self, action: #selector(showKakaoAddress), for: .touchUpInside)
    }
    
    @objc func showKakaoAddress(_ sender: Any) {
        self.configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setWebView()
    }
    
    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        self.webView?.navigationDelegate = self
        
        guard let url = URL(string: "https://dduddupark.github.io/Kakao-Postcode/"),
              let webView = webView
        else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }
    
    private func setWebView() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
        ])
    }
}


extension AddressViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let data = message.body as? [String: Any] {
            print(data)
            let roadAddress = data["roadAddress"] as? String ?? ""
            
            let addressList = roadAddress.components(separatedBy: " ")
            if(addressList.count > 2) {
                //측정소명 가져오기
                fetchServer(type: .ArpltnInfo,
                            query: ["addr" : addressList[0] + " " + addressList[1]]) {
                    (result: Result<AddressData, APIError>) in
                    switch result {
                    case .success(let model):
                        print("success \(model)")
                        
                        let stationName = model.response?.body?.items?.first?.stationName
                        if let stationName {
                            
                            DispatchQueue.main.async {
                                
                                self.webView?.isHidden = true
                                self.showPopUp(myAddress: MyAddress(stateName: roadAddress, address: stationName))
                            }
                            
                        }
                    case .failure(let error):
                        print("error \(error)")
                    }
                }
                
            } else {
                print("측정소 정보를 가져올수없습니다.")
            }
        }
//        guard let previousVC = presentingViewController as? MainViewController else { return }
//        previousVC.address = address
//        self.dismiss(animated: true, completion: nil)
    }
    
    private func showPopUp(myAddress: MyAddress) {
        // 메시지창 컨트롤러 인스턴스 생성
        let alert = UIAlertController(title: "위치 저장", message: "\(myAddress.address)를 저장하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (action) in
            // 버튼 클릭시 실행되는 코드
            
            let dicionaryKeyData = UserDefaults.standard.dictionaryWithValues(forKeys: ["keyForAddress"]) // 다수의 Dictionary 데이터를 Array로 호출
            
            let addressDictionary = 
            
            UserDefaults.standard.set(["key3":"value3", "key4":"value4"], forKey: "keyForAddress") // Dictionary
            
            alert.dismiss(animated: false)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default){ (action) in
            // 버튼 클릭시 실행되는 코드
            alert.dismiss(animated: false)
        }

        //메시지 창 컨트롤러에 버튼 액션을 추가
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        //메시지 창 컨트롤러를 표시
        self.present(alert, animated: false)
    }
}

extension AddressViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
