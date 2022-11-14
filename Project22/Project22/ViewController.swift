//
//  ViewController.swift
//  Project22
//
//  Created by Ákos Morvai on 2022. 06. 17..
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var regionName: UILabel!
    
    var locationManager: CLLocationManager?
    
    var detectedBeacons = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let localRegion = region as? CLBeaconRegion {
            print("entered \(localRegion.identifier)")
            locationManager?.startRangingBeacons(in: localRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let localRegion = region as? CLBeaconRegion {
            print("left \(localRegion.identifier)")
            locationManager?.stopRangingBeacons(in: localRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            regionName.text = region.identifier
            if !detectedBeacons.contains(beacon.uuid.uuidString) {
                let ac = UIAlertController(title: "New beacon", message: "New beacon detected with name: \(region.identifier)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
                present(ac, animated: true)
                detectedBeacons.append(beacon.uuid.uuidString)
            }
        } else {
            regionName.text = ""
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        let beaconRegions = [
            CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "MyBeacon"),
            CLBeaconRegion(uuid: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!, major: 123, minor: 456, identifier: "Radius"),
            CLBeaconRegion(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, major: 123, minor: 456, identifier: "apple e2"),
            CLBeaconRegion(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!, major: 123, minor: 456, identifier: "apple 74")
        ]
        
        for beaconRegion in beaconRegions {
            beaconRegion.notifyOnEntry = true
            beaconRegion.notifyOnExit = true
            locationManager?.startMonitoring(for: beaconRegion)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
                case .far:
                    self.view.backgroundColor = .blue
                    self.distanceReading.text = "FAR"
                case .near:
                    self.view.backgroundColor = .orange
                    self.distanceReading.text = "NEAR"
                case .immediate:
                    self.view.backgroundColor = .red
                    self.distanceReading.text = "RIGHT HERE"
                default:
                    self.view.backgroundColor = .gray
                    self.distanceReading.text = "UNKNOWN"
            }
        }
    }
}
