//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 04/03/2022.
//

import UIKit
import SnapKit
import MessageUI
import Localize_Swift

class DetailViewController: UIViewController {
    //MARK: Properties
    private let popView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var btnClose: UIButton = {
        let btn = UIButton()
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.setImage(UIImage(systemName: "clear.fill"), for: .normal)
        btn.addTarget(self, action: #selector(handleEventFromCloseButton(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private let ivItem: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "AppIcon")
        return iv
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "Happy"
        return label
    }()
    
    private let labelAuthor: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "John"
        return label
    }()
    
    private let labelType: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Type"
        return label
    }()
    
    private let labelGenre: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Genre"
        return label
    }()
    
    private let labelTypeDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "E-books"
        return label
    }()
    
    private let labelGenreDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "Romance and sad end"
        return label
    }()
    
    private lazy var buttonPrice: UIButton = {
        let btn = UIButton()
        let color = UIColor(
            red: 20/255,
            green: 160/255,
            blue: 160/255,
            alpha: 1)
        
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = color.cgColor
        btn.setTitleColor(color, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(handleEventFromPriceButton(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromTapGesture(sender:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        return tap
    }()
    
    var height: Constraint?
    
    var result: SearchCellViewModel! {
        didSet {
            updateContent()
        }
    }
    
    enum AnimationStyle {
        case slide, fade
    }
    
    var dismissStyle = AnimationStyle.fade
    var isPopUp = false
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = calculateSubviews(views: popView.subviews)
        self.height?.update(offset: height)
        
    }
    
    //MARK: Actions
    @objc func handleEventFromCloseButton(sender: UIButton) {
        
        closeVC()
        
    }
    
    @objc func handleEventFromPriceButton(sender: UIButton) {
        
        guard let url = URL(string: result.iTuneURL) else {return}
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @objc func handleEventFromTapGesture(sender: UITapGestureRecognizer) {
        
        closeVC()
        
    }
    
    @objc func handleEventFromTapRightNavButton(sender: UIBarButtonItem) {
        
        let targetVC = MenuViewController()
        
        self.addChild(targetVC)
        self.view.addSubview(targetVC.view)
        targetVC.didMove(toParent: self)
        targetVC.delegate = self
        
        targetVC.view.snp.makeConstraints({ (make) in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(230)
            make.height.equalTo(300)
            
        })
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        if isPopUp {
            
            setupUIForIPhone()
            
        } else {
            
            setupUIForIPad()
            
        }
        
    }
    
    private func setupUIForIPhone() {
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = .clear
        view.addGestureRecognizer(gesture)
        
        view.addSubview(popView)
        popView.snp.makeConstraints({ [weak self] (make) in
            
            make.center.equalToSuperview()
            make.width.equalTo(260)
            self?.height = make.height.equalTo(260).constraint
            
        })
        
        let stackViewType = UIStackView(arrangedSubviews: [labelType, labelTypeDescription])
        stackViewType.axis = .horizontal
        stackViewType.spacing = 8
        
        let stackViewGenre = UIStackView(arrangedSubviews: [labelGenre, labelGenreDescription])
        stackViewGenre.axis = .horizontal
        stackViewGenre.spacing = 8
        
        popView.addSubviews(views: [btnClose, ivItem, labelTitle, labelAuthor, stackViewType, stackViewGenre, buttonPrice])
        
        btnClose.snp.makeConstraints({ (make) in
            
            make.top.leading.equalToSuperview().offset(5)
            make.width.height.equalTo(20)
            
        })
        
        ivItem.snp.makeConstraints({ (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(100)
            
        })
        
        labelTitle.snp.makeConstraints({ (make) in
            
            make.top.equalTo(ivItem.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().offset(5)
            
        })
        
        labelAuthor.snp.makeConstraints({ (make) in
            
            make.top.equalTo(labelTitle.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().offset(5)
            
        })
        
        stackViewType.snp.makeConstraints({ (make) in
            
            make.top.equalTo(labelAuthor.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
            
        })
        
        stackViewGenre.snp.makeConstraints({ (make) in
            
            make.top.equalTo(stackViewType.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
            
        })
        
        buttonPrice.snp.makeConstraints({ (make) in
            
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(5)
            make.width.equalTo(80)
            make.height.equalTo(26)
            
        })
        
    }
    
    private func setupUIForIPad() {
        
        if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            
            title = displayName
            
        }
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(handleEventFromTapRightNavButton))
        
        resizeFontIfNeeded(labels: [labelType, labelTypeDescription, labelGenre, labelGenreDescription, labelTitle, labelAuthor])
        
        view.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593990445, alpha: 0.8082574503)
        view.addSubview(popView)
        popView.snp.makeConstraints({ (make) in
            
            make.center.equalToSuperview()
            make.width.height.equalTo(500)
            
        })
        
        let stackViewType = UIStackView(arrangedSubviews: [labelType, labelTypeDescription])
        stackViewType.axis = .horizontal
        stackViewType.spacing = 10
        
        let stackViewGenre = UIStackView(arrangedSubviews: [labelGenre, labelGenreDescription])
        stackViewGenre.axis = .horizontal
        stackViewGenre.spacing = 10
        
        popView.addSubviews(views: [ivItem, labelTitle, labelAuthor, stackViewType, stackViewGenre, buttonPrice])
        
        
        ivItem.snp.makeConstraints({ (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(200)
            
        })
        
        labelTitle.snp.makeConstraints({ (make) in
            
            make.top.equalTo(ivItem.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().offset(10)
            
        })
        
        labelAuthor.snp.makeConstraints({ (make) in
            
            make.top.equalTo(labelTitle.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().offset(10)
            
        })
        
        stackViewType.snp.makeConstraints({ (make) in
            
            make.top.equalTo(labelAuthor.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            
        })
        
        stackViewGenre.snp.makeConstraints({ (make) in
            
            make.top.equalTo(stackViewType.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            
        })
        
        buttonPrice.snp.makeConstraints({ (make) in
            
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(160)
            make.height.equalTo(52)
            
        })
        
    }
    
    private func resizeFontIfNeeded(labels: [UILabel]) {
        
        for label in labels {
            
            let presentSize = label.font.pointSize
            
            label.font = label.font.withSize(presentSize * 1.7)
            
        }
        
    }
    
    private func updateContent() {

        ivItem.loadImage(url: result.largeImageURL)
        labelTitle.text = result.mainTitle
        labelAuthor.text = result.subTitle
        labelTypeDescription.text = result.type
        labelGenreDescription.text = result.genre
        buttonPrice.setTitle(result.price, for: .normal)
        
    }
    
    private func calculateSubviews(views: [UIView]) -> CGFloat {
        
        var height = 50.0
        
        for view in views {
            
            if view is UILabel {
                
                height += view.intrinsicContentSize.height
                
            } else {
                
                height += view.bounds.height
                
            }
            
        }
        
        return height > 260 ? height : 260
        
    }
    
    private func closeVC() {
        
        dismissStyle = .fade
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK: UIViewControllerTransitioningDelegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController( forPresented presented: UIViewController,
                                 presenting: UIViewController?, source: UIViewController) ->
    UIPresentationController? {
        return DimmingPresentationController(
            presentedViewController: presented, presenting: presenting)
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch dismissStyle {
        case .slide:
            
            return SlideOutAnimationController()
            
        case .fade:
            
            return FadeOutAnimationController()
    
            
        }
        
    }
    
}

//MARK: UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch) -> Bool {
            return (touch.view === self.view)
        }
    
}

//MARK: MenuViewControllerDelegate
extension DetailViewController: MenuViewControllerDelegate {
    
    func menuViewControllerSendEmail(_ controller: MenuViewController) {
        
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        
        let recipientEmail = "your@email-address-here.com"
        let subject = "text_title_support_request".localized()
        let body = "text_body_mail".localized()
        
        if MFMailComposeViewController.canSendMail() {
            
            let targetVC = MFMailComposeViewController()

            targetVC.setSubject(subject)
            targetVC.setToRecipients([recipientEmail])
            targetVC.mailComposeDelegate = self

            self.present(targetVC, animated: true, completion: nil)
            
            
        } else if let emailURL = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            
            UIApplication.shared.open(emailURL)
            
        }
        
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            
            return gmailUrl
            
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            
            return outlookUrl
            
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            
            return yahooMail
            
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            
            return sparkUrl
            
        }
        
        return defaultUrl
    }
    
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
