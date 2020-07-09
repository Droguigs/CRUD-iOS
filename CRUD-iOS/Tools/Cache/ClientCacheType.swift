//
//  ClientCacheType.swift
//  CRUD-iOS
//
//  Created by Douglas Schiavi on 09/07/20.
//  Copyright © 2020 Douglas Schiavi. All rights reserved.
//

import Foundation
import UIKit

protocol ClientCacheType {
    
    func add(client: Client)
    func allClients() -> [Client]
    func allClients(cpf: String) -> [Client]
    
}
