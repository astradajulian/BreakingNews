//
//  ViewController.swift
//  BreakingNews
//
//  Created by Julian Astrada on 06/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class TopHeadlinesViewController: UIViewController {
    
    // Instance to easy creation
    class func newInstance() -> UINavigationController {
        guard let initialViewController = UIStoryboard(name: "TopHeadlines", bundle: nil).instantiateInitialViewController() as? UINavigationController else { fatalError("Error instancing SourcesViewController") }
        
        return initialViewController
    }

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    //Properties
    private var dataSource: TopHeadlinesViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Top Headlines"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupDataSource()
        setupTableViewConfiguration()
    }

}

// MARK: - RxSetup

extension TopHeadlinesViewController {
    
    func setupDataSource() {
        //We display headlines for US in this example
        dataSource = TopHeadlinesViewModel(country: "us")
        
        //Loading Indicator
        dataSource.loading.bind { (loading) in
            self.activityIndicator.isHidden = !loading
        }.disposed(by: disposeBag)
        
        //Error
        dataSource.error.observeOn(MainScheduler.instance).subscribe { (error) in
            let alert = UIAlertController(title: "Ooops!", message: "An error ocurred loading the top headlines", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    func setupTableViewConfiguration() {
        tableView.register(UINib(nibName: HeadlineTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HeadlineTableViewCell.identifier)
        
        //Binding the data source articles to the cells on the table view
        dataSource.headlineSources.bind(to: tableView.rx.items(cellIdentifier: HeadlineTableViewCell.identifier, cellType: HeadlineTableViewCell.self)) { row, article, cell in
            cell.article = article
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Article.self).subscribe(onNext: {[unowned self] (article) in
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
              self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            
            if let urlString = article.url, let urlToOpen = URL(string: urlString) {
                self.present(SFSafariViewController(url: urlToOpen), animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
}

