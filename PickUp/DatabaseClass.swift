//
//  DatabaseTest.swift
//  PickUp
//
//  Created by Krish Patel on 11/4/21.
import UIKit
import Firebase
import FirebaseDatabase
///This has all the components of the database, can  read, write, and edit order
class DATABASE{
    var ref: DatabaseReference!
    var Children: [[String : String]]
    var Order: Int
    init(){
        self.Children = []
        self.ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
        self.Order = -1
    }
    func GetInfo(_ queryWord: String) ->  [[String: String]] {
        //enter the group for async I guess
        self.Children = []
        let group = DispatchGroup.init()
        group.enter()
        //Get info, with given query info
        self.ref.child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let ID = child.key
                let Name = dict["Name"]! as! String
                let Grade = dict["Grade"]! as! String
                let Status = dict["Status"] as! String
                let Order = dict["Order"] as! String
                if Status == queryWord{
                    let childInfo: [String: String] = ["Id": ID, "Name": Name, "Grade": Grade, "Status": Status, "Order": Order]
                    self.Children.append(childInfo)
                }
                else if queryWord == "All" {
                    let childInfo: [String: String] = ["Id": ID, "Name": Name, "Grade": Grade, "Status": Status, "Order": Order]
                    self.Children.append(childInfo)
                } 
            }
            group.leave()
        }
        //wait for competion
        group.wait()
        //make a seperate function to return self.children
        //Returns array of dictionaries
        return(self.Children)
    }
    func AddInfo(_ name: String, _ grade: String, _ plates: [String]){
        let uuid = "Child:\(UUID().uuidString)"
        let object: [String: Any] = ["Name": name, "Grade": grade, "Status": "notHere", "Order": "0", "CarPlates": plates]
        self.ref.child("Children").child(uuid).setValue(object)
    }
    func EditInfo(_ id: String, _ Status: String){
        ref.child("Children").child(id).updateChildValues(["Status": Status])
        Task.init{
            let order = StudentOrder()
            ref.child("Children").child(id).updateChildValues(["Order": order])
        }
    }
    func StudentOrder() -> String{
        let group = DispatchGroup.init()
        group.enter()
        self.ref.child("Order").child("recentOrder").getData(completion:  { error, snapshot in
            guard error == nil else {
              return
            }
            guard let OrderDict = snapshot.value as? [String: String]
            else {return}
            self.Order = Int(OrderDict["Order"] ?? ("0")) ?? (1)
            //self.Order = ((((snapshot.value! as? NSDictionary)!["Order"]!)as? Int)!)
            group.leave()
          })
        group.wait()
        self.ref.child("Order").child("recentOrder").updateChildValues(["Order": String(self.Order + 1)])
        return String(self.Order)
    }
    func ResetValues() {
        self.ref.child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                self.ref.child("Children").child(child.key).updateChildValues(["Order": "0", "Status": "notHere"])
            }
        }
        self.ref.child("Order").child("recentOrder").updateChildValues(["Order": "1"])
    }
    func FindIDWithPlate(_ plate: String) -> [String] {
        //works finds student or students with matching plate
        var StudentId: [String] = []
        let group = DispatchGroup.init()
        group.enter()
        self.ref.child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let ID = child.key
                let carPlates = dict["CarPlates"] as! [String]
                for plates in carPlates {
                    if plates == plate {
                        StudentId.append(ID)
                        break
                    }
                }
            }
            group.leave()
        }
        group.wait()
        return StudentId
    }
}
    
