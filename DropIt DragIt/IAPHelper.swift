//
//  IAPHelper.swift
//  DragIt
//
//  Created by iMac 27 on 10/20/15...addCreditz.1000
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//


import UIKit
import StoreKit

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{

    // Set IAPS
    func setIAPs() {
        if(SKPaymentQueue.canMakePayments()) {
            if list.isEmpty {
                print("IAP is enabled, loading")
                let productIDs = NSSet(objects: "com.garthmackenzie.DragIt.addCredits.10", "com.garthmackenzie.DragIt.addCredits.40", "com.garthmackenzie.DragIt.addCredits.70", "com.garthmackenzie.DragIt.addCredits.150", "com.garthmackenzie.DragIt.addCredits.350", "com.garthmackenzie.DragIt.addCreditz.1000", "com.garthmackenzie.DragIt.addCredits.2500")
                let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productIDs as! Set<String>)
                request.delegate = self
                request.start()
            }
        } else {
            print("please enable IAPS")
        }
    }
    @IBAction func btnRemoveAds(sender: UIButton) {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.garthmackenzie.DragIt.removeads") {
                p = product
                buyProduct()
                break;
            }
        }
    }
    @IBAction func btnRestorePurchases(sender: UIButton) {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    func pay4Credits(credits: Int) {
        for product in list {
            if product.productIdentifier.hasSuffix("\(credits)") {
                p = product
                //addCredits(credits)  //test
                buyProduct()
            }
        }
    }
    func addCredits(credits:Int) {
        Settings().availableCredits += credits
//        if let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UITabBarController {
//            let shopTabBarItem = tabBarController.tabBar.items![0]
//            shopTabBarItem.badgeValue = Settings().availableCredits.description
//        }
    }
    var list = [SKProduct]()
    var p = SKProduct()

    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    //MARK: - SKProductsRequestDelegate
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        print("product count \(response.products.count)")
        print("invalid product IDs \(response.invalidProductIdentifiers)")
        let myProduct = response.products
        for product in myProduct {
            print("product added for $\(product.price)")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            list.append(product )
        }
    }
    var hasFailed = false
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Request, didFail, (probably no wifi) please enable IAPS")
        print(error.localizedDescription)
        hasFailed = true
    }
    func removeAds() {
        //lblAdvert.removeFromSuperview()   //no ads to remove
    }
    //MARK: - SKPaymentTransactionObserver
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let prodID = transaction.payment.productIdentifier
            switch prodID {
            case "com.garthmackenzie.DragIt.removeads":
                print("remove ads")
                removeAds()
            case "com.garthmackenzie.DragIt.addCredits.10":
                print("add 10 credits to account")
                addCredits(10)
            case "com.garthmackenzie.DragIt.addCredits.40":
                print("add 40 credits to account")
                addCredits(40)
            case "com.garthmackenzie.DragIt.addCredits.70":
                print("add 70 credits to account")
                addCredits(70)
            case "com.garthmackenzie.DragIt.addCredits.150":
                print("add 150 credits to account")
                addCredits(150)
            case "com.garthmackenzie.DragIt.addCredits.350":
                print("add 350 credits to account")
                addCredits(350)
            case "com.garthmackenzie.DragIt.addCreditz.1000":
                print("add 1000 credits to account")
                addCredits(1000)
            case "com.garthmackenzie.DragIt.addCredits.2500":
                print("add 2500 credits to account")
                addCredits(2500)
            default:
                print("IAP not setup")
                break
            }
        }
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction in transactions {
            print(transaction.error?.localizedDescription)
            switch transaction.transactionState {
            case .Purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.garthmackenzie.DragIt.removeads":
                    print("remove ads")
                    removeAds()
                case "com.garthmackenzie.DragIt.addCredits.10":
                    print("add 10 credits to account")
                    addCredits(10)
                case "com.garthmackenzie.DragIt.addCredits.40":
                    print("add 40 credits to account")
                    addCredits(40)
                case "com.garthmackenzie.DragIt.addCredits.70":
                    print("add 70 credits to account")
                    addCredits(70)
                case "com.garthmackenzie.DragIt.addCredits.150":
                    print("add 150 credits to account")
                    addCredits(150)
                case "com.garthmackenzie.DragIt.addCredits.350":
                    print("add 350 credits to account")
                    addCredits(350)
                case "com.garthmackenzie.DragIt.addCreditz.1000":
                    print("add 1000 credits to account")
                    addCredits(1000)
                case "com.garthmackenzie.DragIt.addCredits.2500":
                    print("add 2500 credits to account")
                    addCredits(2500)
                default:
                    print("IAP not setup")
                    break
                }
                queue.finishTransaction(transaction)
            case .Failed:
                print("buy error")
                queue.finishTransaction(transaction)
                break
            default:
                print("fallthrough")
                break
            }
        }
    }
    func finishTransaction(trans:SKPaymentTransaction) {
        print("finish transaction")
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove transaction");
    }
}

