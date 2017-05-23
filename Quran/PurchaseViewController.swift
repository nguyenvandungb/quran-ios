//
//  PurchaseViewController.swift
//  RapidSave
//
//  Created by Nguyen Van Dung on 5/21/17.
//  Copyright © 2017 truong.tuan.quang. All rights reserved.
//

import Foundation
import UIKit
import DhtStoreKit
import DhtKeychain

class PurchaseViewController: UIViewController {
    @IBOutlet weak var removeAdsBtn: UIButton!
    @IBOutlet weak var restorePurchaseBtn: UIButton!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Remove Ads"
        registerPurchaseNotification()
        AppDelegate.shareInstance()?.stopTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }

    @IBAction func removeAdsAction(_ sender: Any) {
        DhtStoreKit.shared().initiatePaymentRequestForProduct(withIdentifier: "com.dht.jgammarremoveads")
    }

    @IBAction func restoreAdsAction(_ sender: Any) {
        DhtStoreKit.shared().restorePurchases()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        AppDelegate.shareInstance()?.startTimer()
        self.dismiss(animated: true, completion: nil)
    }

    func registerPurchaseNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitProductPurchased, object: nil, queue: OperationQueue.main) { (note) in
            print ("Purchased product: \(String(describing: note.object))")
            if let productidentifier = note.object as? String {
                AppDelegate.shareInstance()?.didPurchaseSuccess(productId: productidentifier)
                NotificationCenter.default.post(name: NotificationName.kNotificationDidPurchase.name(), object: productidentifier)
            }
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitProductPurchaseFailed, object: nil, queue: OperationQueue.main) { (note) in
            print ("Purchased product: \(String(describing: note.object))")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitDownloadCompleted, object: nil, queue: OperationQueue.main) { (note) in
            print ("Downloaded product: \(String(describing: note.userInfo))")
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitDownloadProgress, object: nil, queue: OperationQueue.main) { (note) in
            print ("Downloading product: \(String(describing: note.userInfo))")
        }
    }
}
