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

class AddressViewController: UIViewController, AddressItemProtocol {
    
    var delegate: DisDelegate?
    
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)

    private let backButton: UIButton = {
        let view = UIButton()
        let image = UIImage(named: "back")!
        view.setImage(image, for: UIControl.State.normal)
        return view
    }()
    
    private let searchAddressButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("내 주소 찾기", for: .normal)   //highlighted는 버튼 클릭했을때
        btn.backgroundColor = .blue
        return btn
    }()
    
    // tableView 생성
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
        setAddressListUI()
    }
    
    private func setView() {
        view.addSubview(backButton)
        view.addSubview(searchAddressButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.addTarget(self, action: #selector(popActivity), for: .touchUpInside)
        
        
        searchAddressButton.translatesAutoresizingMaskIntoConstraints = false
        searchAddressButton.topAnchor.constraint(equalTo: self.backButton.bottomAnchor).isActive = true
        searchAddressButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchAddressButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        searchAddressButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        searchAddressButton.addTarget(self, action: #selector(showKakaoAddress), for: .touchUpInside)
    }
    
    @objc func popActivity(_ sender: Any) {
        self.dismiss(animated: true)
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
    
    func setAddressListUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AddressItemView.self, forCellReuseIdentifier: "AddressItemView")
        
        setConstraint()
        
        // autoHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.searchAddressButton.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    
    private func getAddressList() -> [CoreAddress] {
        return CoreDataManager.shared.getCoreAddress()
    }
    
    func selectAddress(address: CoreAddress) {
        // 메시지창 컨트롤러 인스턴스 생성
        let alert = UIAlertController(title: "지정", message: "해당 위치를 선택 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action) in
            
            CoreDataManager.shared.selectedCoreAddress(address: address) { onSuccess in
                print("onSuccess = \(onSuccess)")
            }
            
            alert.dismiss(animated: false)
            self.reloadTableView()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default){ (action) in
            // 버튼 클릭시 실행되는 코드
            alert.dismiss(animated: false)
        }
        
        //메시지 창 컨트롤러에 버튼 액션을 추가
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        //메시지 창 컨트롤러를 표시
        self.present(alert, animated: false)
    }
    
    func deleteAddress(address: CoreAddress) {
        print("==deleteAddress==")
        CoreDataManager.shared.deleteCoreAddress(address: address) { onSuccess in
            print("onSuccess = \(onSuccess)")
        }
        
        tableView.reloadData()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getAddressList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressItemView", for: indexPath) as? AddressItemView else { return UITableViewCell() }
        
        cell.setItem(address: self.getAddressList()[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectAddress(address: self.getAddressList()[indexPath.row])
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
                                self.showPopUp(myAddress: MyAddress(stateName: roadAddress, address: stationName, isSelected: true))
                            }
                            
                        }
                    case .failure(let error):
                        self.errorPopUp()
                    }
                }
                
            } else {
                self.errorPopUp()
            }
        } else {
            
        }
        //        guard let previousVC = presentingViewController as? MainViewController else { return }
        //        previousVC.address = address
        //        self.dismiss(animated: true, completion: nil)
    }
    
    private func showPopUp(myAddress: MyAddress) {
        // 메시지창 컨트롤러 인스턴스 생성
        let alert = UIAlertController(title: "위치 저장", message: "\(String(describing: myAddress.address))를 저장하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (action) in
            // 버튼 클릭시 실행되는 코드
            
            CoreDataManager.shared.saveCoreAddress(myAddress: myAddress) { onSuccess in
                print("onSuccess = \(onSuccess)")
            }
            
            alert.dismiss(animated: false)
            
            self.reloadTableView()
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
    
    private func errorPopUp() {
        // 메시지창 컨트롤러 인스턴스 생성
        let alert = UIAlertController(title: "실패", message: "위치정보를 가져올 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (action) in
            // 버튼 클릭시 실행되는 코드
            alert.dismiss(animated: false)
        }
        
        //메시지 창 컨트롤러에 버튼 액션을 추가
        alert.addAction(cancelAction)
        
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
