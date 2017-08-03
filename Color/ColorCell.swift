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

class ColorCell: UICollectionViewCell {
    
    let color = 121121
    
    var firPathObserver : String? { //This will make sure that as soon as you set the value, it will fetch from firebase
        didSet {

            let ref = Database.database().reference().child(firPathObserver!)
            ref.removeAllObservers()
            
            ref.observe(.value, with: { snapshot in
                
                if let value = snapshot.value! as? Int {
                    self.setCellColor(value)
                    
                };
            })
        }
    }
    
    func setCellColor(_ color: Int) {

        DispatchQueue.main.async {
            
            self.backgroundColor = UIColor(rgb: color)
            //self.layer.borderWidth = 0
        }
    }
    
    func setupViews() {
        
        addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(uploadCellColor)))
        backgroundColor = UIColor.clear
    }
    
    func uploadCellColor() {
     
        let itemRef = Database.database().reference().child(firPathObserver!)
        itemRef.setValue(color) // 3
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

