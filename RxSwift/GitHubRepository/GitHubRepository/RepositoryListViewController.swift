//
//  RepositoryListViewController.swift
//  GitHubRepository
//
//  Created by 이상훈 on 8/9/25.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryListViewController: UITableViewController {
    private let organization = "Apple"
    private let repositories = BehaviorSubject<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = organization + "Repositories"
        
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(RepositroyListCell.self, forCellReuseIdentifier: "RepositoryListCell")
        tableView.rowHeight = 140
    }
    
    @objc func refresh() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            self.fetchRepositories(of: self.organization)
        }
    }
    
    func fetchRepositories(of organization: String) {
        let url = URL(string: "https://api.github.com/orgs/\(organization)/repos")!
        
        Observable.just(url)
            .map {
                var req = URLRequest(url: $0)
                req.httpMethod = "GET"
                return req
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .flatMap { response, data -> Observable<[Repository]> in
                guard 200..<300 ~= response.statusCode else {
                    return .error(NSError(domain: "HTTP", code: response.statusCode, userInfo: nil))
                }
                do {
                    let repos = try JSONDecoder().decode([Repository].self, from: data)
                    return .just(repos)
                } catch {
                    return .error(error)
                }
            }
            .observe(on: MainScheduler.instance) // 이후 UI는 메인
            .subscribe(
                onNext: { [weak self] repos in
                    self?.repositories.onNext(repos)
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                },
                onError: { [weak self] error in
                    // 에러 UI/로그
                    self?.refreshControl?.endRefreshing()
                    print("fetchRepositories error:", error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    //    func fetchRepositories(of organization: String) {
    //        Observable.from([organization])
    //            .map { organization -> URL in
    //                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
    //            }
    //            .map { url -> URLRequest in
    //                var request = URLRequest(url: url)
    //                request.httpMethod = "GET"
    //                return request
    //            }
    //            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
    //                return URLSession.shared.rx.response(request: request)
    //            }
    //            .filter { responds, _ in
    //                return 200..<300 ~= responds.statusCode
    //            }
    //            .map { _, data -> [[String:Any]] in
    //                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
    //                      let result = json as? [[String:Any]] else {
    //                    return []
    //                }
    //                return result
    //            }
    //            .filter { result in
    //                return result.count > 0
    //            }
    //            .map { objects in
    //                return objects.compactMap { dic -> Repository? in //compactMap은 RxSwift 구문이 아닌 Swift 구문
    //                    guard let id = dic["id"] as? Int,
    //                          let name = dic["name"] as? String,
    //                          let description = dic["description"] as? String,
    //                          let stargazersCount = dic["stargazers_count"] as? Int,
    //                          let language = dic["language"] as? String else {
    //                        return nil
    //                    }
    //                    return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
    //                }
    //            }
    //            .subscribe(onNext: { [weak self] newRepositories in
    //                self?.repositories.onNext(newRepositories)
    //
    //                DispatchQueue.main.async {
    //                    self?.tableView.reloadData()
    //                    self?.refreshControl?.endRefreshing() //새로운 아이템 받아왔으면 새로고침 그만하게
    //                }
    //            })
    //            .disposed(by: disposeBag)
    //    }
}

//UITableView DataSource Delegate
extension RepositoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try repositories.value().count
        } catch {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositroyListCell else { return UITableViewCell() }
        
        var currentRepository: Repository? {
            do {
                return try repositories.value()[indexPath.row]
            } catch {
                return nil
            }
        }
        
        cell.repository = currentRepository
        
        return cell
    }
}
