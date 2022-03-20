//
//  SearchTableCell.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import UIKit
import SnapKit
import Localize_Swift

class SearchTableCell: UITableViewCell {
    //MARK: Properties
    private let searchCellImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let mainTitleLbl: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleTxt: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private let nothingFoundLbl: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        label.text = "text_nothing_found".localized()
        return label
    }()
    
    var viewModel: SearchCellViewModel? {
        didSet {
            self.updateUI()
        }
    }

    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CellID_Of_SearchCell)
        
        addObservers()
        
        addSubview(searchCellImg)
        searchCellImg.snp.makeConstraints({ (make) in
            
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.width.equalTo(60)
            
        })
        
        let stackView = UIStackView(arrangedSubviews: [mainTitleLbl,subtitleTxt])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        
        addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            
            make.top.equalTo(searchCellImg.snp.top)
            make.leading.equalTo(searchCellImg.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            
        })

        addSubview(nothingFoundLbl)
        nothingFoundLbl.snp.makeConstraints({ (make) in
            
            make.center.equalToSuperview()
            
        })

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let selectedView = UIView(frame: CGRect.zero)
          selectedView.backgroundColor = UIColor(
            red: 20/255, green: 160/255,
            blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    //MARK: Actions
    @objc func switchLanguages() {
        
        nothingFoundLbl.text = "text_nothing_found".localized()
        
    }
    
    //MARK: Helpers
    func updateUI() {
        guard let viewModel = viewModel else {return}
        
        searchCellImg.loadImage(url: viewModel.smallImageURL)
        mainTitleLbl.text = viewModel.mainTitle
        subtitleTxt.text = viewModel.subTitle
        nothingFoundLbl.text = viewModel.notFound
        
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(switchLanguages),
            name: NSNotification.Name(LCLLanguageChangeNotification),
            object: nil)
        
    }
    
}

