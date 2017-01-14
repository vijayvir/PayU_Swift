# PayU_Swift
PayU_Swift
Before proceeding further, make sure you have read this document

To integrate with iOS SDK,download latest sample app from github using link : https://github.com/payu-intrepos/iOS-SDK-Sample-App/releases/tag/3.8.2
Prerequisites:

Add libz.tbd libraries into your project (Project->Build Phases->Link Binary With Libraries)
Add -ObjC and $(OTHER_LDFLAGS)in Other Linker Flags in Project Build Settings(Project->Build Settings->Other Linker Flags)
To run the app on iOS9, please add the below code in info.plist

<key>NSAppTransportSecurity</key>
   <dict>
   <key>NSAllowsArbitraryLoads</key>
   <true/>
  </dict>
Integration steps:

Drag and drop PayU folder into your App.
In AppDelegate.h add the below property




```bash
 func initPayment()
    {

        self.paymentParamForPassing.key = PayuMerchant.key.name;
        self.paymentParamForPassing.transactionID = PayuMerchant.id.name;
        self.paymentParamForPassing.amount = "10.0";
        self.paymentParamForPassing.productInfo = "Nokia";
        
        self.paymentParamForPassing.surl = PayuMerchant.surl.name;
        self.paymentParamForPassing.furl = PayuMerchant.furl.name;
    
        self.paymentParamForPassing.firstName = "Ram";
        self.paymentParamForPassing.email = "email@testsdk1.com";
        

        
        
        self.paymentParamForPassing.userCredentials = "\(PayuMerchant.key.name):Baalak@gmail.com";
        
        self.paymentParamForPassing.environment = ENVIRONMENT_TEST;

        self.paymentParamForPassing.offerKey = "";
        
        
        

        let generateHashesVlaue = PayUDontUseThisClass()
        
    
        
        generateHashesVlaue.getPayUHashes(withPaymentParam:  self.paymentParamForPassing, merchantSalt: PayuMerchant.salt.name, withCompletionBlock:
            {
            (allHashes: PayUModelHashes?, hashString:PayUModelHashes?, errorMessage : String?)in
            
             self.paymentParamForPassing.hashes = allHashes
            
            
            self.getPayUPaymentRelatedDetail()
          })

        
        

     
    }
    
 ```
 
 
 ```bash
  func getPayUPaymentRelatedDetail()
    {
        
        webServiceResponse.getPayUPaymentRelatedDetail(forMobileSDK:  self.paymentParamForPassing)
        { ( payUModelPaymentRelatedDetail :PayUModelPaymentRelatedDetail?, errorMessage :String?, extraParam :Any?) in
            
        
            let storyboard = UIStoryboard(name: "PUUIMainStoryBoard", bundle: nil)
            
            let paymentOptionVC : PUUIPaymentOptionVC = storyboard.instantiateViewController(withIdentifier: VC_IDENTIFIER_PAYMENT_OPTION) as! PUUIPaymentOptionVC
            
            paymentOptionVC.paymentParam =  self.paymentParamForPassing;
            
            paymentOptionVC.paymentRelatedDetail = payUModelPaymentRelatedDetail;
            
            
            self.navigationController?.pushViewController(paymentOptionVC, animated: true)
            
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(responseReceived), name: NSNotification.Name(rawValue: kPUUINotiPaymentResponse), object: nil)
    }

    func responseReceived(notification:Notification)
    {
        print("Response Receive" , notification.object ?? "Some Value")
    }
    
 
 ```
 
 
 
 
