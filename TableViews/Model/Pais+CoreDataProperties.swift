//
//  Pais+CoreDataProperties.swift
//  TableViews
//
//  Created by Ricardo Rodriguez on 10/11/23.
//  Copyright © 2023 MoureDev. All rights reserved.
//
//

import Foundation
import CoreData


extension Pais {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pais> {
        return NSFetchRequest<Pais>(entityName: "Pais")
    }

    @NSManaged public var nombre: String?

}

extension Pais : Identifiable {

}
