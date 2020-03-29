//
//  BLEPeripheral.swift
//  Luces Estadio
//
//  Created by Diego Atencia on 27/03/2020.
//  Copyright © 2020 Diego Atencia. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEPeripheral: NSObject {
    
    public static let bleLEDServiceUUID = CBUUID.init(string: "FFE0")
    public static let whiteLEDCharacteristicUUID = CBUUID.init(string: "FFE1")
}
