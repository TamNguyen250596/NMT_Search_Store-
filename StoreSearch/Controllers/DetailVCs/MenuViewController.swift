//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 19/03/2022.
//

import UIKit
import SnapKit
import Localize_Swift

protocol MenuViewControllerDelegate: AnyObject {
    
    func menuViewControllerSendEmail(_ controller: MenuViewController)
    
}

class MenuViewController: UIViewController {
    //MARK: Properties
    weak var delegate: MenuViewControllerDelegate?
    
    private let titles = [
        "text_send_support_email".localized(),
        "text_rate_this_app".localized(),
        "text_about".localized()]
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    //MARK: Actions
    @objc func handleEventFromTap(sender: UITapGestureRecognizer) {

        if sender.view?.accessibilityLabel == titles[0] {
            
            delegate?.menuViewControllerSendEmail(self)
            
        }
        
    }
    
    
    //MARK: Helpers
    private func setupUI() {
        
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593990445, alpha: 1)
        
        let views = createVStack(titles: titles)
        
        let vStack = UIStackView(arrangedSubviews: views)
        
        view.addSubview(vStack)
        vStack.snp.makeConstraints({ (make) in
            
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            
        })
        
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        
    }
    
    private func createVStack(titles: [String]) -> [UIView] {
        
        var views = [UIView]()
        
        for title in titles {
            
            let containView = UIView()
            containView.accessibilityLabel = title
            containView.backgroundColor = .white
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .darkGray
            label.text = title
            
            let line = UIView()
            line.backgroundColor = .lightGray
            
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(handleEventFromTap))
            
            containView.addSubviews(views: [label, line])
            containView.addGestureRecognizer(tap)
            
            label.snp.makeConstraints({ (make) in
                
                make.top.equalToSuperview().offset(10)
                make.leading.trailing.equalToSuperview().offset(10)
                
            })
            
            line.snp.makeConstraints({ (make) in
                
                make.top.equalTo(label.snp.bottom).offset(10)
                make.leading.equalTo(label.snp.leading)
                make.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
                
            })
            
            views.append(containView)

        
        }
        
        return views
    }

}
