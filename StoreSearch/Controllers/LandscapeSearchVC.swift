//
//  LandscapeSearchVC.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 05/03/2022.
//

import UIKit
import SnapKit

class LandscapeSearchVC: SearchViewController {
    //MARK: Properties
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = CGSize(width: 1000, height: 1000)
        scroll.delegate = self
        return scroll
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 0
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.2262691259, green: 0.6917769313, blue: 0.4410685599, alpha: 1)
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        pc.addTarget(self, action: #selector(pageChanged(_:)), for: .allTouchEvents)
        return pc
    }()
    
    private var firstTime = true
    var results = Search()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupUI()
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        tableView.isHidden = true
        
        categorySegment.snp.updateConstraints({ (update) in
            
            update.width.equalTo(520)
            update.height.equalTo(25)
            
        })
        
    }
    
    //MARK: API
    private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
        
        if let url = URL(string: searchResult.imageSmall) {
            
            let task = URLSession.shared.downloadTask(with: url) { [weak button] url, response, error in
                
                if error == nil, let url = url, let data = try? Data(contentsOf: url) {
                    
                    DispatchQueue.main.async {
                        
                        if let button = button {
                            
                            button.setBackgroundImage(UIImage(data: data), for: .normal)
                            
                        }
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    
    
    //MARK: Actions
    @objc func pageChanged(_ sender: UIPageControl) {
        
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: [.curveEaseInOut], animations: {
            self.scrollView.contentOffset = CGPoint(
                x: self.scrollView.bounds.size.width *
                CGFloat(sender.currentPage), y: 0)
        },
                       completion: nil)
        
    }
    
    @objc func handleTapButton(_ sender: UIButton) {
        
        let targetVC = DetailViewController()
        
        if case .results(let list) = results.state {
            
            var searchResult = list[(sender.tag - 2000)]
            searchResult.isFounded = true
            
            targetVC.result = SearchCellViewModel(search: searchResult)
            self.present(targetVC, animated: true, completion: nil)
            
            
        }
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        
        view.addSubview(scrollView)
        scrollView.frame = CGRect(
            x: safeFrame.origin.x,
            y: categorySegment.frame.maxY - 15,
            width: safeFrame.width,
            height: safeFrame.height)
        
        view.addSubview(pageControl)
        pageControl.frame = CGRect(
            x: safeFrame.origin.x,
            y: safeFrame.size.height,
            width: safeFrame.size.width - pageControl.frame.size.height,
            height: pageControl.frame.size.height)
        
        if firstTime {
            
            switch results.state {
            case .notSearchedYet:
                
                break
                
            case .loading:
                
                showSpinner()
                break
                
            case .noResults:
                
                showNothingFoundLabel()
                break
                
            case .results(let list):
                
                showSpinner()
                tileButtons(list)
                break
                
            }
            
            hideSpinner()
            
        }
        
    }
    
    private func tileButtons(_ searchResults: [SearchResult]) {
        
        var columnsPerPage = 6
        var rowsPerPage = 3
        var itemWidth: CGFloat = 94
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 2
        var marginY: CGFloat = 20
        let viewWidth = view.safeAreaLayoutGuide.layoutFrame.width
        
        switch view.frame.width {
            
        case 568...666:
            
            break
            
        case 667...735:
            
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
            break
            
        case 724...CGFloat.greatestFiniteMagnitude:
            
            columnsPerPage = 7
            rowsPerPage = 3
            itemWidth = 98
            itemHeight = 98
            marginX = 2
            marginY = 10
            break
            
        default:
            
            break
            
        }
        
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeight)/2
        
        var row = 0
        var column = 0
        var x = marginX
        
        for (index, result) in searchResults.enumerated() {
            
            let button = UIButton(type: .system)
            
            downloadImage(for: result, andPlaceOn: button)
            
            
            button.frame = CGRect(
                x: x + paddingHorz,
                y: marginY + CGFloat(row)*itemHeight + paddingVert,
                width: buttonWidth,
                height: buttonHeight)
            button.tag = 2000 + index
            button.addTarget(self, action: #selector(handleTapButton(_:)), for: .touchUpInside)
            
            scrollView.addSubview(button)
            
            row += 1
            if row == rowsPerPage {
                
                row = 0; x += itemWidth; column += 1
                
                if column == columnsPerPage {
                    
                    column = 0; x += marginX * 2
                    
                }
            }
        }
        
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        
        scrollView.contentSize = CGSize(
            width: CGFloat(numPages) * viewWidth,
            height: scrollView.bounds.size.height)
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        
    }
    
    private func showSpinner() {
        
        print("DEBUG: showSpinner called")
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .lightGray
        scrollView.addSubview(spinner)
        spinner.snp.makeConstraints({ (make) in
            
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
            
        })
        spinner.tag = 1000
        spinner.startAnimating()
        
    }
    
    private func hideSpinner() {
        
        view.viewWithTag(1000)?.removeFromSuperview()
        
    }
    
    private func showNothingFoundLabel() {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = "Nothing Found"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.sizeToFit()
        
        var rect = label.frame
        rect.size.width = ceil(rect.size.width/2) * 2
        rect.size.height = ceil(rect.size.height/2) * 2
        label.frame = rect
        label.center = CGPoint(
            x: scrollView.bounds.midX,
            y: scrollView.bounds.midY)
        
        view.addSubview(label)
    }
    
}

extension LandscapeSearchVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        
        let page = Int((scrollView.contentOffset.x + (width / 2))/width)
        
        pageControl.currentPage = page
        
    }
    
    
}
