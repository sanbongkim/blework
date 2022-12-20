//
//  ViewController.swift
//  BleTest
//
//  Created by sb_dev on 2022/12/12.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController{
    
    var bluetoothManager:BluetoothManager? = nil
    let dataAnalyzer = BleDataAnalyzer()
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humiLabel: UILabel!
    @IBOutlet weak var freqLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.bluetoothManager = BluetoothManager.getInstance()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.bluetoothManager!.delegate = self
    }
    @IBAction func bleListAction(_ sender: Any) {
  
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let bleVc = storyboard?.instantiateViewController(identifier: "BleVC") else{return}
        bleVc.modalPresentationStyle = .fullScreen
        self.present(bleVc, animated: true)
    }
}
extension ViewController : BluetoothDelegate{
    
    func didReadValueForCharacteristic(_ characteristic: CBCharacteristic) {
        let data  = dataAnalyzer.analyzer(characteristic)
        tempLabel.text = String(format: "%.2f",  Double(Double(data.temp) / 10.0))
        humiLabel.text = String(format: "%.2f",  Double(Double(data.humid) / 10.0))
        freqLabel.text = String(data.frequency)
    }
    func didUpdateState(_ state: CBManagerState ) {
        switch state {
        case .resetting:
            print("MainController --> State : Resetting")
            
        case .poweredOn:
            print(" MainController -->State : poweredOn")
            // bluetoothManager!.startScanPeripheral()
            
        case .poweredOff:
            print(" MainController -->State : Powered Off")
            
        case .unauthorized:
            print("MainController --> State : Unauthorized")
            
        case .unknown:
            print("MainController --> State : Unknown")
            
        case .unsupported:
            print("MainController --> State : Unsupported")
            
        @unknown default: break
            
        }
    }
    
}


