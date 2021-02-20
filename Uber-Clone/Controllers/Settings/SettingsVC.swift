//
//  SettingsVC.swift
//  Uber-Clone
//
//  Created by Saad Sherif on 2/20/21.
//

import UIKit

private let reuseIDCell = "LocationCell"

enum LocationType: Int, CaseIterable, CustomStringConvertible {
    case home
    case work
    
    var description: String {
        switch self {
        case .home: return "Home"
        case.work: return "Work"
        }
    }
    
    var subTitle: String {
        switch self {
        case .home: return "Add Home"
        case.work: return "Add Work"
        }
    }
}

class SettingsVC: UITableViewController {
    
    // MARK: - Properties
    private let user: User
    private let locationManager = LocationHandler.shared.locationManager
    
    private lazy var infoHeader: UserInfoHeader = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let view = UserInfoHeader(user: user, frame: frame)
        return view
    }()
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    // MARK: - Hepler Functions
    
    func configureTableView() {
        tableView.rowHeight = 60
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIDCell)
        tableView.tableHeaderView = infoHeader
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barTintColor = .backgroundColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate/DataSource

extension SettingsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        title.textColor = .white
        title.text = "Favorites"
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIDCell, for: indexPath) as! LocationCell
        guard let type = LocationType(rawValue: indexPath.row) else { return cell }
        cell.type = type
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = LocationType(rawValue: indexPath.row) else { return }
        guard let location = locationManager?.location else { return }
        let vc = AddLocationVC(type: type, location: location)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}
