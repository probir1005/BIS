//
//  BISVerifyOTPDBWorker.swift
//  BIS
//
//  Created by TSSIOS on 30/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import CoreData
import UIKit

protocol VerifyOTPDBWorker {
    func saveUser(userDTO: UserDTO, callBack: @escaping (Bool) -> Void)
    func fetchUser(callBack: (UserDTO?) -> Void)
}

class BISVerifyOTPDBWorker: VerifyOTPDBWorker {
    let coreDataManager: CoreDataManager

    init(manager: CoreDataManager) {
        self.coreDataManager = manager
    }



    func fetchUser(callBack: (UserDTO?) -> Void) {
        if let user = try? coreDataManager.backgroundContext.fetch(User.fetchRequestUser()), !user.isEmpty {
            let dto = UserDTO(user: user.first!)
            callBack(dto)
        } else {
            callBack(nil)
        }
    }

    func saveUser(userDTO: UserDTO, callBack: @escaping (Bool) -> Void) {
        coreDataManager.backgroundContext.perform {
            _ = User(dto: userDTO, context: self.coreDataManager.backgroundContext)
            do {
                try self.coreDataManager.backgroundContext.save()
                callBack(true)
            } catch {
                callBack(false)
            }
        }

    }

}
