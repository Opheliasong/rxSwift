//
//  ViewController.swift
//  rxSwift
//
//  Created by Sung Min Park on 2021/04/22.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga", "Not London"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CitiesCell.self, forCellReuseIdentifier: CitiesCell.identifier)
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .subscribe( onNext:{ [unowned self] query in
                self.shownCities = self.allCities.filter {
                    $0.hasPrefix(query)
                }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CitiesCell.identifier, for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}

