//
//  ViewController.swift
//  SampleAppforPayUMoney
//
//  Created by Apple on 14/01/17.
//  Copyright © 2017 vijayvirSingh. All rights reserved.
//


import UIKit


enum PayuMerchant {
    case key
    
    case salt
    
    case id
    
//  
//    Name on Card: Any name
//    Card Number: 5123456789012346 / 4012001038443335
//    CVV: 123
//    Expiry Date: 05/2017


    
    //------------
    case surl
    
    case furl
    
    case service_provider
    
    var  name: String
    {
        switch self
        {
        case .key: return "gtKFFx"
            
        case .salt : return "eCwWELxi"
            
        case .id : return "5726640"
            

        case .surl : return "https://www.google.com"
            
        case .furl : return "https://www.bing.com"
            
        case .service_provider : return "5726640"
            
            
            
            
        }
    }
    
}

struct PayURequest : StructJSONSerializable
{
    var txnid : String = ""
    
    var key : String = PayuMerchant.key.name
    
    var amount : String = ""
    
    var productinfo : String = ""
    
    var firstname : String = ""
    
    var email : String = ""
    
    var phone : String = ""
    
    var surl : String = PayuMerchant.surl.name
    
    var furl : String = PayuMerchant.furl.name
    
    var hash : String = ""
    
    var service_provider : String = "payu_paisa"
    
    
    
    init (txnid : String , key : String ,amount : String ,productinfo : String ,firstname : String ,email : String ,phone : String ,surl : String ,furl : String ,hash : String ,service_provider : String )
    {
        self.txnid = txnid
        
        self.key = key
        
        self.amount = amount
        
        self.productinfo = productinfo
        
        self.firstname = firstname
        
        self.email = email
        
        self.phone = phone
        
        self.surl = surl
        
        self.furl = furl
        
        self.hash = hash
        
        self.service_provider = service_provider
        
    }
}




class ViewController: UIViewController,UIWebViewDelegate
{
    
    @IBOutlet weak var myWebView: UIWebView!
    
    var paymentParamForPassing  = PayUModelPaymentParams()
    
    var webServiceResponse = PayUWebServiceResponse()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.initPayment()
    }
    
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
    
 
    

    
}


