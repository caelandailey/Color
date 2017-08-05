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
    
    //let color = 121121
    
    
    var firPathObserver : String? { //This will make sure that as soon as you set the value, it will fetch from firebase
        didSet {
            
            let ref = Database.database().reference().child(firPathObserver!)
            ref.removeAllObservers()
            
            ref.observe(.value, with: { snapshot in
                
                if let value = snapshot.value! as? String {
                    self.setCellColor(value)
                    
                };
            })
        }
    }
    
    private func setCellColor(_ color: String) {

        DispatchQueue.main.async {
            self.backgroundColor = UIColor(hexString: color)
        }
    }
    
    func setupViews() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = true
        backgroundColor = UIColor.clear
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

