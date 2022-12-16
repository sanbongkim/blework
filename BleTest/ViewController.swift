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
    let nextVc = BleDataAnalyzer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bluetoothManager = BluetoothManager.getInstance()
        self.bluetoothManager!.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func testAction(_ sender: Any) {
      
//        nextVc.analyzer(text: "kkkkkkkkk")
//        nextVc.completionHandler = { text in
//        print(text)
//        return text
//        }
    }
    @IBAction func bleListActon(_ sender: Any) {
        print("tap")
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let bleVc = storyboard?.instantiateViewController(identifier: "BleVC") else{return}
        bleVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(bleVc, animated: true)
    }
}
extension ViewController : BluetoothDelegate{
    
    func didReadValueForCharacteristic(_ characteristic: CBCharacteristic) {
        
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


