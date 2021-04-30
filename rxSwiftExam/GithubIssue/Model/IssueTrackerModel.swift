//
//  IssueTrackerModel.swift
//  rxSwiftExam
//
//  Created by Sung Min Park on 2021/04/29.
//

import Foundation
import Moya
import Mapper
import RxSwift
import RxOptional

struct IssueTrackerModel {
    let provider: MoyaProvider<GithubIssueEndPoint>
    let repositoryName: Observable<String>
    
    func testTrackRepo() {
        repositoryName
            .observeOn(MainScheduler.instance)
            .subscribe { name in
                self.testFindRepository(name: name)
            }
    }
    
    func testTrackIssues(disposeBag:DisposeBag) {
        repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository> in
                return self.findRepository(name: name)
            }
            .subscribe { repo in
                self.testFindIssues(repository: repo, disposeBag: disposeBag)
            }.disposed(by: disposeBag)
    }
    
    func trackIssues() -> Observable<[GithubIssueModel]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { (name) -> Observable<Repository> in
                return self.findRepository(name: name)
            }
            .flatMapLatest { (repo) -> Observable<[GithubIssueModel]> in
                return self.findIssues(repository: repo)
            }
    }
    
    private func findIssues(repository:Repository) -> Observable<[GithubIssueModel]> {
        return self.provider
            .rx.request(GithubIssueEndPoint.issues(repositoryFullName: repository.fullName))
            .debug()
            .map {
                try JSONDecoder().decode([GithubIssueModel].self, from: $0.data)
            }
            .catchErrorJustReturn([GithubIssueModel]())
            .asObservable()
    }
    
    private func findRepository(name:String) -> Observable<Repository> {
        return self.provider
            .rx.request(GithubIssueEndPoint.repo(fullName: name))
            .debug()
            .map {
                try JSONDecoder().decode(Repository.self, from: $0.data)
            }
            .catchError({ error -> PrimitiveSequence<SingleTrait, Repository> in
                print("findRepository has error: \(error.localizedDescription)")
                return PrimitiveSequence.just(Repository.empty())
            })
            .asObservable()
    }
    
    //MARK: - test function
    private func testFindRepository(name:String) {
        self.provider
            .rx.request(GithubIssueEndPoint.repo(fullName: name))
            .catchError({ error in
                return .error(error)
            })
            .map(Repository.self)
            .catchError({ error in
                return .error(error)
            })
            .debug()
            .subscribe { repo in
                print(repo.identify)
                print(repo.language)
                print(repo.name)
                print(repo.fullName)
            } onError: { error in
                print("Has Error: \(error.localizedDescription)")
            }
    }
    
    private func testFindIssues(repository:Repository, disposeBag:DisposeBag) {
        self.provider
            .rx.request(GithubIssueEndPoint.issues(repositoryFullName: repository.fullName))
            .debug()
            .map([GithubIssueModel].self)
            .catchError({ error -> PrimitiveSequence<SingleTrait, [GithubIssueModel]> in
                print(error.localizedDescription)
                let emptyIssue:[GithubIssueModel] = [GithubIssueModel(identifier: 0, number: 0, title: "", body: "'")]
                return PrimitiveSequence.just(emptyIssue)
            })
            .subscribe { issue in
                for iter in issue {
                    print("\(iter.title)")
                    print("\(iter.identifier)")
                    print("\(iter.body)")
                    print("\(iter.number)")
                }
            } onError: { error in
                print("\(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
}
