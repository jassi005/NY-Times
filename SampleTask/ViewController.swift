//
//  ViewController.swift
//  SampleTask
//
//  Created by bhupendra on 13/11/18.
//  Copyright © 2018 bhupendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

     @IBOutlet var tableView: UITableView!
     var dict = String()
     var allDictValue = NSDictionary()
      var mainArr = NSArray()
    var ArrSallonNM = NSMutableArray()
    var ArrAbstract = NSMutableArray()
    var filteredData:[String] = []
     var isSearching = false
    
    
    var ArrImage = NSMutableArray()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ArrcodeTitle = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
   
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
        
        searchBar.delegate = self
         self.searchBar.returnKeyType = UIReturnKeyType.done
        
        self.tableView.emptyCellsEnabled = false

        dopostSignUPApi()
    }

    //Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            isSearching = false;
            self.tableView.reloadData()
        } else {
            filteredData = ArrAbstract.filter({ (text) -> Bool in
                let tmp: NSString = text as! NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }) as! [String]
            if(filteredData.count == 0){
                isSearching = true;         //after Change here and fix issue
            } else {
                isSearching = true;
                print("afterSearchArray",filteredData)
            }
            self.tableView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder() // hides the keyboard.
    }
    
    
    //Signup Api here.
    func dopostSignUPApi()
    {
        /*guard let name = textfieldEmail.text, !name.isEmpty,
            let pass = textfieldPassword.text, !pass.isEmpty,
            let phonenum = textfieldPhoneNum.text, !phonenum.isEmpty,
            let countrycode = textfieldCountryCd.text, !countrycode.isEmpty else { return }*/
        
        let request = NSMutableURLRequest(url: NSURL(string:"http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=869d4e276804463b8b139a47809a8e4f")! as URL)  //192.168.10.151:8084/WarrantyM/rest/generic/
        
        request.httpMethod = "GET"
        
       // request.setValue(ServerAuthorization, forHTTPHeaderField: "authorization_token")
      //  request.setValue(ServerAccessTknCheck, forHTTPHeaderField: "access_token")
        
        let postString = ""
        
        // let postString = "emailId=\(name)&reemailId=\(name)&password=\(pass)&repassword=\(pass)&phoneno=\(phonenum)&countryCode=\(91)"
        
        print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
            guard error == nil && data != nil else{
                print("error")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                
                if httpStatus.statusCode == 0
                {
                    print("user alredy regestiter")
                }
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            do
            {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary else{
                    return
                }
                
                if let dictFromJSON = json as? [String:AnyObject] {
                    print(dictFromJSON)
                    
                    self.dict = (dictFromJSON["status"] as? String)!
                    print("hfuwfhwq",self.dict)
                    
                    if (self.dict == "OK")
                    {
                        print("OK")
                      
                        self.mainArr = (dictFromJSON["results"] as? NSArray)!
                        
                        print(self.mainArr)
                        
                        for allApplinc in 0..<self.mainArr.count
                        {
                            self.allDictValue = self.mainArr[allApplinc] as! NSDictionary
                            print("self.allDictValue",self.allDictValue.value(forKey: "published_date")!)
                        
                        self.ArrSallonNM.addObjects(from: [self.allDictValue.value(forKey: "published_date")!])
                        
                        self.ArrAbstract.addObjects(from: [self.allDictValue.value(forKey: "abstract")!])
                            
                       self.ArrImage.addObjects(from: [self.allDictValue.value(forKey: "url")!])
                            
                            
                        self.ArrcodeTitle.addObjects(from: [self.allDictValue.value(forKey: "title")!])
                            
                            
                            
                            
                            
                        }
                        
                        print("dateall",self.allDictValue)
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.emptyCellsEnabled = false
                            
                        }
                        
                    }
                    
                    else {
                        print("NOt OK")
                        
                    }
                    
                    }
                        
                    else {
                        
                        print ("status 0")
                        DispatchQueue.main.async {
                            
                        }
                        
                    }
                    
                }
                
            catch
            {
                print("error")
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
   
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching
        {
            return filteredData.count
        }
        
        return ArrAbstract.count
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String = "CustomCell"
        var customCell : CustomCell!
        customCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CustomCell
        
        
        
        
        if isSearching
        {
            // customCell.textLabel?.text = self.filteredData[indexPath.row]
            //customCell.lblemailId?.text! = self.Arremailall[indexPath.row] as! String
            
            
            customCell.lblDesc?.text! = self.filteredData[indexPath.row] as! String
            
            
            
        }else {
            customCell.lblDate?.text! = self.ArrSallonNM[indexPath.row] as! String
            
            customCell.ImgUSerProfile?.setImageProfileFromURl(stringImageUrl: ArrImage[indexPath.row] as! String)
            
            customCell.lblDesc?.text! = self.ArrAbstract[indexPath.row] as! String
            
            customCell.lblTitle?.text! = self.ArrAbstract[indexPath.row] as! String
            
        }
        
        
        return customCell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
        
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
      
        
    }

    
    
    

}



extension UITableView {
    
    var emptyCellsEnabled: Bool {
        set(newValue) {
            if newValue {
                tableFooterView = nil
            } else {
                tableFooterView = UIView()
            }
            
        }
        get {
            if tableFooterView == nil {
                return true
            }
            return false
        }
    }
}
extension UIImageView{
    
    func setImageProfileFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
