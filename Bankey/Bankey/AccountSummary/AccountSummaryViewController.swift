//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by praveen mack on 02/01/22.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    // Request models
    var profile: Profile?
    var accounts: [Account] = []
    
    // View models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome!", name: "", date: Date())
    var accountCellViewModel: [AccountSummaryCell.ViewModel] = []
    
    let tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
}

extension AccountSummaryViewController {
    
    private func setup() {
        setupTableView()
        setupTableHeaderView()
//        fetchAccounts()
        fetchDataAndLoadViews()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    
}

extension AccountSummaryViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModel.isEmpty else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
        let account = accountCellViewModel[indexPath.row]
        cell.configure(with: account)
        return cell
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AccountSummaryViewController {
    private func fetchAccounts() {
        let savings = AccountSummaryCell.ViewModel(accountType: .Banking, accountName: "Basic Savings", balance: 929455.35)
        let chequing = AccountSummaryCell.ViewModel(accountType: .Banking, accountName: "No-fee All-In Chequing", balance: 17635.66)
        let visa = AccountSummaryCell.ViewModel(accountType: .CreditCard, accountName: "Visa Avion Card", balance: 346.29)
        let masterCard = AccountSummaryCell.ViewModel(accountType: .CreditCard, accountName: "Student Mastercard", balance: 929455.35)
        let investment1 = AccountSummaryCell.ViewModel(accountType: .Investment, accountName: "Tax-free Saver", balance: 17635.66)
        let investment2 = AccountSummaryCell.ViewModel(accountType: .Investment, accountName: "Growth Fund", balance: 346.29)
        
        accountCellViewModel.append(savings)
        accountCellViewModel.append(chequing)
        accountCellViewModel.append(visa)
        accountCellViewModel.append(masterCard)
        accountCellViewModel.append(investment1)
        accountCellViewModel.append(investment2)
    }
}

// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchDataAndLoadViews() {
        
        fetchProfile(forUserId: "1") { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.configureTableHeaderView(with: profile)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        fetchAccounts(forUserId: "1") { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                self.configureTableCell(with: accounts)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCell(with account: [Account]) {
        accountCellViewModel = account.map({
            AccountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        })
    }
}


