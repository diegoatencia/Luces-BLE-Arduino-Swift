//
//  ViewController.swift
//  Luces Estadio
//
//  Created by Diego Atencia on 27/03/2020.
//  Copyright © 2020 Diego Atencia. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    private var whiteChar: CBCharacteristic?
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        
        if central.state != .poweredOn {
            print("Central isn't powered on")
        } else {
            print("Central is powered on")
            print("Central scanning for ", BLEPeripheral.bleLEDServiceUUID)
            centralManager.scanForPeripherals(withServices: [BLEPeripheral.bleLEDServiceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        // We've found it so stop scan
        self.centralManager.stopScan()

        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)

    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your BLE Module")
            peripheral.discoverServices([BLEPeripheral.bleLEDServiceUUID])
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLEPeripheral.bleLEDServiceUUID {
                    print("LED service found")
                    
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([BLEPeripheral.whiteLEDCharacteristicUUID], for: service)
                    
                    return
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BLEPeripheral.whiteLEDCharacteristicUUID {
                    print("White LED characteristic found")
                    whiteChar = characteristic
                    slider.isEnabled = true
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        
        if peripheral == self.peripheral {
            print("Disconnected")
            
            slider.isEnabled = false
            slider.value = 0
            
            self.peripheral = nil
            
            // Start scanning again
            print("Central scanning for", BLEPeripheral.bleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [BLEPeripheral.bleLEDServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
        
    }
    
    
    @IBAction func sliderChanged(_ sender: Any) {
        print("white: ", slider.value)
        let sl: UInt8 = UInt8(slider.value)
        writeLEDValueToChar(withCharacteristic: whiteChar!, withValue: Data([sl]))
    }
    
    private func writeLEDValueToChar( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {

        // Check if it has the write property
        if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {

            peripheral.writeValue(value, for: characteristic, type: .withoutResponse)

        }

    }
    


}

