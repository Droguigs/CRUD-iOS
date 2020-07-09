//
//  ClientListViewController.swift
//  CRUD-iOS
//
//  Created by Douglas Schiavi on 09/07/20.
//  Copyright © 2020 Douglas Schiavi. All rights reserved.
//

import UIKit

protocol NewClientDelegate {
    func addClient()
}

protocol ClientDelegate {
    func editClient(row: Int)
    func deleteClient(row: Int)
}

class ClientListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noClientView: UIView!
    
    var filterredClients: [Client] = []
    let cache = ClientCache()
    
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
    }
    
    func loadData() {
        filterredClients = cache.allClients()
        filterredClients = filterredClients.sorted(by: { $0.name < $1.name })
        if filterredClients.isEmpty {
            self.noClientView.isHidden = false
        } else {
            self.tableView.reloadData()
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? SignUpViewController
        destinationVC?.delegate = self
    }

}

extension ClientListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterredClients.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchViewControllerCell

            cell.textSearchBar.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientViewControllerCell
            
            cell.name.text = getUserTableName(client: filterredClients[indexPath.row-1])

            return cell
        }
    }
    
}

extension ClientListViewController: NewClientDelegate, ClientDelegate {
    
    func addClient() {
        showToast(message: "Cliente cadastrado com sucesso", font: .systemFont(ofSize: 15), color: .systemGreen)
        loadData()
    }
    
    func showToast(message : String, font: UIFont, color: UIColor) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height-100, width: 350, height: 35))
        toastLabel.backgroundColor = color.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 8.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func editClient(row: Int) {
        <#code#>
    }
    
    func deleteClient(row: Int) {
        <#code#>
    }
    
}

extension ClientListViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SearchViewControllerCell as SearchViewControllerCell
        cell.textSearchBar.resignFirstResponder()
        self.filterredClients = cache.allClients()
        if filterredClients.isEmpty {
            self.noClientView.isHidden = false
        } else {
            self.tableView.reloadData()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.filterredClients = cache.allClients(cpf: textField.text ?? "")
        if filterredClients.isEmpty {
            self.noClientView.isHidden = false
        } else {
            self.tableView.reloadData()
        }
        return true
    }
}

class SearchViewControllerCell: UITableViewCell {
    @IBOutlet weak var textSearchBar: UITextField!
}

class ClientViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBAction func editClient(_ sender: Any) {
        
    }
    
    @IBAction func deleteClient(_ sender: Any) {
        
    }
}
