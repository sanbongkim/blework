//
//  ScBleListViewController.swift
//  BleTest
//
//  Created by sb_dev on 2022/12/13.

import Foundation
import UIKit
import CoreBluetooth
class ScBleListViewController: UIViewController{
    fileprivate var peripherals: [CBPeripheral] = []
    var bluetoothManager:BluetoothManager? = nil
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.bluetoothManager = BluetoothManager.getInstance()
        self.bluetoothManager!.delegate = self
        scanPeripheral()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func scanPeripheral(){
        
        
        self.bluetoothManager!.startScanPeripheral()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
            self.bluetoothManager?.stopScanPeripheral()
        }
    }
}
extension ScBleListViewController: UITableViewDelegate,UITableViewDataSource,BluetoothDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ...code...
        return peripherals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ...code...
        let pname = peripherals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "blecell", for: indexPath)
        cell.imageView!.image = UIImage(named: "bleicon")
        cell.textLabel!.text = pname.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let connectPeripheral = peripherals[indexPath.row]
        self.bluetoothManager?.connectPeripheral(connectPeripheral)
    }
    // MARK: -블루투스 델리게이트
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber){
        if peripheral.name != nil {
            print("peripheral"+"\(peripheral.identifier.uuidString)"+"\(peripheral.name!)")
            if !peripherals.contains(peripheral){
                peripherals.append(peripheral)
                tableView.reloadData()
            }
        }
    }
    func didDiscoverServices(_ peripheral: CBPeripheral){
        
        for service in peripheral.services! {
            print("Service found with UUID: " + service.uuid.uuidString)
            if (service.uuid.uuidString == Constant.SEND_DATA_SERVICE_UUID) {
                peripheral.discoverCharacteristics(nil, for: service)
                break
            }
        }
    }
    func didDiscoverCharacteritics(_ service: CBService, pripheral: CBPeripheral) {
        
        print("didDiscoverCharacteristicsFor")
        if (service.uuid.uuidString == Constant.SEND_DATA_SERVICE_UUID) {
            for characteristic in service.characteristics! {
                print(characteristic.uuid.uuidString)
                if characteristic.uuid.uuidString == Constant.RECIEVE_DATA_CHARACTERISTIC {
                    bluetoothManager?.connectedPeripheral?.setNotifyValue(true, for: characteristic)
                    break
                }
            }
        }
        else if (service.uuid.uuidString == Constant.SEND_DATA_SERVICE_UUID) {
            for characteristic in service.characteristics! {
                print(characteristic.uuid.uuidString)
                if characteristic.uuid.uuidString == Constant.SEND_DATA_CHARACTERISTIC {
                    bluetoothManager?.connectedPeripheral?.setNotifyValue(true, for: characteristic)
                    break
                }
            }
        }
        self.dismiss(animated: true)
    }
}
