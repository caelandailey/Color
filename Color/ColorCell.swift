//
//  ColorCell.swift
//  Color
//
//  Created by Caelan Dailey on 7/31/17.
//  Copyright © 2017 Caelan Dailey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ColorCell: BaseCell  {
    
    var firPathObserver : String? { //This will make sure that as soon as you set the value, it will fetch from firebase
        didSet {
            let  ref = Database.database().reference().child(firPathObserver!)
            ref.observe(.value, with: { snapshot in
                
                if let value = snapshot.value! as? Int {
                    self.setCellColor(value)
                }
                
            })
        }
    }
    
    let color = 121212
    
    func setCellColor(_ color: Int) {

        DispatchQueue.main.async {
                self.backgroundColor = UIColor(rgb: color)
            
        }
    }
    
    override func setupViews() {
        
        addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(uploadCellColor)))
        backgroundColor = UIColor.clear
    }
    
    func uploadCellColor() {
        let itemRef = Database.database().reference().child(firPathObserver!)
        print(firPathObserver!)
        
        itemRef.setValue(color) // 3
    }
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.clear
        
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


