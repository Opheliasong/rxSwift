//
//  MoyaExamViewController.swift
//  rxSwiftExam
//
//  Created by Sung Min Park on 2021/04/29.
//

import Foundation
import UIKit
import RxSwift
import Moya

class GithubIssueTableViewController: UIViewController {
    //MARK: - Rx Property
    let disposeBag: DisposeBag = DisposeBag()
    var provider:MoyaProvider<GithubIssueEndPoint>!
    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    var issueTrackerModel: IssueTrackerModel!
    
    //MARK: - UI View
    let bodyTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GithubTableViewCell.self, forCellReuseIdentifier: GithubTableViewCell.identifier)
        return tableView
    }()
    
    let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.text = ""
        return searchBar
    }()
    
    override func viewDidLoad() {
        view.addSubview(bodyTable)
        view.addSubview(searchBar)
        
        let tableViewConstraint = [
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bodyTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bodyTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            bodyTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bodyTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraint)
        
        setRxStream()
    }
    
    func setRxStream() {
        //Provider 생성
        //Provider의 lifecycle은 ViewController의 Lifecycle과 동일한게 진행한다.
        provider = MoyaProvider<GithubIssueEndPoint>()
        
        // Model 생성
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
        
        bodyTable
            .rx.itemSelected
            .subscribe ({ (indexPath) in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)

        issueTrackerModel
            .trackIssues()
            .bind(to: bodyTable.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: GithubTableViewCell.identifier,
                                                         for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item.title
                return cell
            }
            .disposed(by: disposeBag)
        
        bodyTable
            .rx.itemSelected
            .subscribe { (indexPath) in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            }
            .disposed(by: disposeBag)
    }   
}
