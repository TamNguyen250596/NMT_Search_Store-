//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import UIKit
import SnapKit
import SMSegmentView
import Localize_Swift

class SearchViewController: UIViewController {
    //MARK: Properties
    private var search = Search()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.placeholder = "text_placeholder_on_searchbar".localized()
        searchBar.isTranslucent = false
        searchBar.resignFirstResponder()
        searchBar.barTintColor = #colorLiteral(red: 0, green: 0.639043808, blue: 0.6328900456, alpha: 0)
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.keyboardDismissMode = .interactive
        table.delegate = self
        table.dataSource = self
        table.register(SearchTableCell.self, forCellReuseIdentifier: CellID_Of_SearchCell)
        return table
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.color = .lightGray
        return spinner
    }()
    
    let loadingLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Loading..."
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .lightGray
        lbl.isHidden = true
        return lbl
    }()
    
    let categorySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: [
            "text_all_segment".localized(),
            "text_music_segment".localized(),
            "text_software_segment".localized(),
            "text_ebook_segment".localized()])
        segment.backgroundColor = .white
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(handleEventFromSegment(sender:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var languagesSegment: SMSegmentView = {
        let segment = SMSegmentAppearance()
        segment.segmentOnSelectionColour = #colorLiteral(red: 0.2262691259, green: 0.6917769313, blue: 0.4410685599, alpha: 1)
        segment.segmentOffSelectionColour = .white
        segment.titleOnSelectionFont = UIFont.systemFont(ofSize: 12)
        segment.titleOffSelectionFont = UIFont.systemFont(ofSize: 12)
        segment.titleOnSelectionColour = .white
        segment.titleOffSelectionColour = .darkGray
        segment.contentVerticalMargin = 10.0
        
        let segmentView = SMSegmentView(
            frame: .zero,
            dividerColour: .white,
            dividerWidth: 1,
            segmentAppearance: segment)
        
        segmentView.addSegmentWithTitle(
            "VN",
            onSelectionImage: UIImage(named: "vietnam flag"),
            offSelectionImage: UIImage(named: "vietnam flag"))
        
        segmentView.addSegmentWithTitle(
            "Eng",
            onSelectionImage: UIImage(named: "united-states"),
            offSelectionImage: UIImage(named: "united-states"))
        segmentView.selectedSegmentIndex = 0
        segmentView.organiseMode = .vertical
        segmentView.layer.cornerRadius = 20
        segmentView.clipsToBounds = true
        segmentView.addTarget(self, action: #selector(handleEventFromLanguagesSegment), for: .valueChanged)
        
        return segmentView
    }()
    
    
    var landscapeVC: LandscapeSearchVC? = nil
    weak var splitViewDetail: DetailViewController? = nil
    
    //MARK: View cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addObservers()
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        switch newCollection.verticalSizeClass {
            
        case .compact:
            
            showLandscape(with: coordinator)
            break
            
        case .regular, .unspecified:
            
            hideLandscape(with: coordinator)
            break
            
        @unknown default:
            
            print("DEBUG: transition default")
            break
        }
    }
    
    //MARK: Actions
    @objc fileprivate func handleEventFromSegment(sender: UISegmentedControl) {
        
        performSearch()
        
    }
    
    @objc fileprivate func handleEventFromLanguagesSegment(sender: SMSegmentView) {
        
        if sender.selectedSegmentIndex == 0 {
            
            Localize.setCurrentLanguage("vi")
            
        } else if sender.selectedSegmentIndex == 1{
            
            Localize.setCurrentLanguage("en")
            
        }
        
    }
    
    @objc func switchLanguages() {
        
        searchBar.placeholder = "text_placeholder_on_searchbar".localized()
        loadingLbl.text = "text_loading".localized()
        categorySegment.setTitle("text_all_segment".localized(), forSegmentAt: 0)
        categorySegment.setTitle("text_music_segment".localized(), forSegmentAt: 1)
        categorySegment.setTitle("text_software_segment".localized(), forSegmentAt: 2)
        categorySegment.setTitle("text_ebook_segment".localized(), forSegmentAt: 3)
        
    }
    
    // MARK: Helpers
    func configureUI() {
        
        title = "text_title_searchVC".localized()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints({ (make) in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            
        })
        
        view.addSubview(categorySegment)
        categorySegment.snp.makeConstraints({ (make) in
            
            make.centerX.equalTo(searchBar.snp.centerX)
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(300)
            
        })
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            
            make.top.equalTo(categorySegment.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            
        })
        
        let stackView = UIStackView(arrangedSubviews: [spinner, loadingLbl])
        stackView.axis = .horizontal
        stackView.spacing = 2
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            
            make.center.equalToSuperview()
            
        })
        
        view.addSubview(languagesSegment)
        languagesSegment.snp.makeConstraints({ (make) in
            
            make.bottom.trailing.equalToSuperview().inset(10)
            make.width.equalTo(80)
            make.height.equalTo(120)
            
        })
        
    }
    
    private func performSearch() {
        
        search.performSearch(for: searchBar.text!, category: Category(rawValue: categorySegment.selectedSegmentIndex) ?? .all, completion: { [weak self] (success) in
            
            guard let self = self else {return}
            
            if success {
                
                self.tableView.reloadData()
                
            } else {
                
                self.showNetworkError()
                
            }
            
        })
        
    }
    
    
    private func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        
        landscapeVC = LandscapeSearchVC()
        guard let landscapeVC = landscapeVC else {return}
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            
            guard let self = self else {return}
            
            landscapeVC.view.alpha = 1
            self.searchBar.resignFirstResponder()
            
        }, completion: { [weak self] _ in
            
            guard let self = self else {return}
            
            landscapeVC.results = self.search
            self.dismiss(animated: true, completion: nil)
            landscapeVC.view.frame = self.view.bounds
            self.view.addSubview(landscapeVC.view)
            self.addChild(landscapeVC)
            landscapeVC.didMove(toParent: self)
            
        })
        
    }
    
    private func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        
        guard let landscapeVC = landscapeVC else {return}
        
        landscapeVC.willMove(toParent: nil)
        landscapeVC.view.removeFromSuperview()
        landscapeVC.removeFromParent()
        self.landscapeVC = nil
        
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(switchLanguages),
            name: NSNotification.Name(LCLLanguageChangeNotification),
            object: nil)
        
    }
    
}

// MARK: Tableview data source
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch search.state {
        case .notSearchedYet:
            
            return 1
            
        case .loading:
            
            return 0
            
        case .noResults:
            
            return 1
            
        case .results(let list):
            
            return list.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_Of_SearchCell, for: indexPath) as! SearchTableCell
        
        switch search.state {
        case .notSearchedYet:
            
            break
            
        case .loading:
            
            spinner.startAnimating()
            loadingLbl.isHidden = false
            break
            
        case .noResults:
            
            let searchResult = SearchResult()
            cell.viewModel = SearchCellViewModel(search: searchResult)
            spinner.stopAnimating()
            loadingLbl.isHidden = true
            break
            
        case .results(let list):
            
            var searchResult = list[indexPath.row]
            searchResult.isFounded = true
            
            cell.viewModel = SearchCellViewModel(search: searchResult)
            spinner.stopAnimating()
            loadingLbl.isHidden = true
            break
            
        }
        
        return cell
    }
}

extension SearchViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if case .results(let list) = search.state {
            
            var searchResult = list[indexPath.row]
            searchResult.isFounded = true
            
            if let splitViewDetail = splitViewDetail {
                
                splitViewDetail.result = SearchCellViewModel(search: searchResult)
                splitViewController?.showDetailViewController(splitViewDetail.navigationController!, sender: nil)
                
                hideMasterPane()
                
            } else {
                
                let targetVC = DetailViewController()
                
                targetVC.result = SearchCellViewModel(search: searchResult)
                targetVC.isPopUp = true
                
                self.present(targetVC, animated: true, completion: nil)
                
                
            }
            
            
        }
        
        searchBar.resignFirstResponder()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch search.state {
        case .notSearchedYet, .loading, .noResults:
            
            return nil
            
        case .results:
            
            return indexPath
            
        }
        
    }
    
    private func hideMasterPane() {
        
        guard self.splitViewController!.displayMode != UISplitViewController.DisplayMode.oneBesideSecondary else {return}
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            
            guard let self = self else {return}
            
            self.splitViewController!.preferredDisplayMode = UISplitViewController.DisplayMode.secondaryOnly
            
            
        }, completion: { [weak self] _ in
            
            guard let self = self else {return}
            
            self.splitViewController!.preferredDisplayMode = .automatic
            
        })
        
        
    }
    
}

//MARK: Table view dimension
extension SearchViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height = 80.0
        
        if case .results(let list) = search.state {
            
            var searchResult = list[indexPath.row]
            searchResult.isFounded = true
            
            let viewModel = SearchCellViewModel(search: searchResult)
            
            height = viewModel.dynamicCellHeight(forWidth: view.bounds.width)
            
            
        }
        
        return height
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            
            searchBar.resignFirstResponder()
            loadingLbl.isHidden = false
            spinner.startAnimating()
            tableView.reloadData()
            
            performSearch()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        spinner.stopAnimating()
        loadingLbl.isHidden = true
        tableView.reloadData()
        
        guard let url = search.url else {return}
        
        ITuneService.stopFetchResults(url: url, isActived: true)
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}

