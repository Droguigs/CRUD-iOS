//
//  ClientListViewController.swift
//  CRUD-iOS
//
//  Created by Douglas Schiavi on 09/07/20.
//  Copyright © 2020 Douglas Schiavi. All rights reserved.
//

import UIKit

protocol NewClientDelegate {
    func addClient(callback: @escaping () -> Bool)
}

class ClientListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noClientView: UIView!
    var clientList: [Client] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noClientView.isHidden = true
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noClientView.isHidden = true
        loadData()
        self.tableView.reloadData()
    }
    
    func loadData() {
        if clientList.isEmpty {
            self.noClientView.isHidden = false
        }
    }
    
    func getUserTableName(client: Client) -> String {
        let now = Date()
        let birthday: Date = client.birthDate
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        
        return client.name + "- \(age)"
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClientListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchViewControllerCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientViewControllerCell
            
            cell.name.text = getUserTableName(client: clientList[indexPath.row])

            return cell
        }
    }
    
}

extension ClientListViewController: NewClientDelegate {
    
    func addClient(callback: @escaping () -> Bool) {
        <#code#>
    }
    
}

class SearchViewControllerCell: UITableViewCell { }

class ClientViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    
}
