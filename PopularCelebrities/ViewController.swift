//
//  ViewController.swift
//  PopularCelebrities
//
//  Created by Durgesh Mathur on 24/12/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var viewModel = OAHomeScreenViewModel()
    var isLoadingMore = false // Flag to prevent multiple API calls

    override func viewDidLoad() {
        super.viewDidLoad()
        // View setup
        view.backgroundColor = .white
        title = "Custom TableView"
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        callApi()
    }
    
    func callApi() {
        Task {
            await viewModel.fetchHomeData(completion: {
                isLoadingMore = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    
    func navigateToDetails(result: Result) {
          // Get the storyboard
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          
          // Instantiate the destination view controller using its Storyboard ID
          guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
              print("Could not find view controller with Storyboard ID: DetailsViewController")
              return
          }
        detailsViewController.detailOfPerson = result
          // Push the destination view controller onto the navigation stack
          navigationController?.pushViewController(detailsViewController, animated: true)
      }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listOfPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.listOfPeople[indexPath.row]
        cell.customLabel.text = model.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetails(result: viewModel.listOfPeople[indexPath.row])
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 50 { // Trigger API call when 50 points from bottom
            if !isLoadingMore {
                isLoadingMore = true
                callApi()
            }
        }
    }
}


class CustomTableViewCell: UITableViewCell {
    
    let customLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(customLabel)
        
        // Layout with Auto Layout
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
