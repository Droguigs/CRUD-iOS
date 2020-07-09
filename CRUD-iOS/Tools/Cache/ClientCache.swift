//
//  ClientCache.swift
//  CRUD-iOS
//
//  Created by Douglas Schiavi on 09/07/20.
//  Copyright © 2020 Douglas Schiavi. All rights reserved.
//

import Foundation
import RealmSwift

class ClientCache: ClientCacheType {
    
    private var realm: Realm!
    
    init() {
        do {
            self.realm = try Realm()
        } catch { }
    }
    
    func add(client: Client) {
        let realmClient = self.toRealm(client: client)
        do {
            try self.realm.write {
                self.realm.add(realmClient)
            }
        } catch { }
    }
    
    func allClients() -> [Client] {
        var clients: [Client] = []
        let objects = self.realm.objects(ClientRealm.self)
        objects.forEach { client in
            clients.append(self.fromRealm(client: client))
        }
        return clients
    }
    
    func allClients(cpf: String) -> [Client] {
        var clients: [Client] = []
        let objects = self.realm.objects(ClientRealm.self).filter("cpf == %@", cpf)
        objects.forEach { client in
            clients.append(self.fromRealm(client: client))
        }
        return clients
    }
    
    func deleteClient(client: Client) {
        let objects = self.realm.objects(ClientRealm.self).filter("cpf == %@", client.cpf)
        objects.forEach { client in
            do {
                try self.realm.write {
                    self.realm.delete(client)
                }
            } catch { }
        }
    }
    
    func editClient(client: Client) {
        let objects = self.realm.objects(ClientRealm.self).filter("cpf == %@", client.cpf)
        objects.forEach { obj in
            do {
                try self.realm.write {
                    self.realm.delete(obj)
                }
            } catch { }
        }
        self.add(client: client)
    }
    
    private func toRealm(clients: [Client]) -> [ClientRealm] {
        var cli: [ClientRealm] = []
        for old in clients {
            cli.append(self.toRealm(client: old))
        }
        return cli
    }
    
    private func toRealm(client: Client) -> ClientRealm {
        let cli = ClientRealm()
        cli.name = client.name
        cli.telephone = client.telephone
        cli.cpf = client.cpf
        cli.birthDate = client.birthDate
        cli.gender = client.gender
        
        return cli
    }
    
    private func fromRealm(clients: [ClientRealm]) -> [Client] {
        var cli: [Client] = []
        for client in clients {
            cli.append(self.fromRealm(client: client))
        }
        return cli
    }
    
    private func fromRealm(client: ClientRealm) -> Client {
        return Client(name: client.name,
                      telephone: client.telephone,
                      cpf: client.cpf,
                      birthDate: client.birthDate,
                      gender: client.gender,
                      tableText: client.tableText)
    }
    
}

class ClientRealm: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var telephone: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var birthDate: Date = Date()
    @objc dynamic var gender: String = ""
    @objc dynamic var tableText: String = ""
}

struct Client {
    
    var name: String
    var telephone: String
    var cpf: String
    var birthDate: Date
    var gender: String
    var tableText: String
    
    init(name: String, telephone: String, cpf: String, birthDate: Date, gender: String, tableText: String) {
        self.name = name
        self.telephone = telephone
        self.cpf = cpf
        self.birthDate = birthDate
        self.gender = gender
        self.tableText = tableText
    }
    
}
