//
//  ViewController.swift
//  Color
//
//  Created by Caelan Dailey on 7/31/17.
//  Copyright © 2017 Caelan Dailey. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    
    let cellId = "cellId"
    var cellSize = 15
    //let cellCount = 10000
    let cellHexColor = "#121212"
    
    var xPage = 1
    var yPage = 1
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let but = UIButton()
        but.frame = CGRect(x:0, y:0, width:100, height:100)
        
        but.backgroundColor = UIColor.blue
        
        but.addTarget(self, action: #selector(increaseCellSize), for: .touchUpInside)
        
        self.view.addSubview(but)
        
        let but2 = UIButton()
        but2.frame = CGRect(x:100, y:0, width:100, height:100)
        
        but2.backgroundColor = UIColor.blue
        
        but2.addTarget(self, action: #selector(decreaseCellSize), for: .touchUpInside)
        
        self.view.addSubview(but2)
        
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(ColorCell.self, forCellWithReuseIdentifier: cellId)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    func increaseCellSize() {
        
        cellSize += 1
        while(Int(self.view.frame.size.width) % cellSize != 0 && cellSize < 25)
        {
            cellSize += 1
        }
        
       
        if (cellSize > 25)
        {
            cellSize = 25
        }
        
        
        collectionView?.reloadData()

    }
    func decreaseCellSize() {
        
        xPage += 1
        
        collectionView?.reloadData()

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let width = Int(collectionView.frame.width)/cellSize
        let height = Int(collectionView.frame.height-64)/cellSize
        return width * height * 100
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ColorCell
        feedCell.backgroundColor = UIColor.clear
        
        let width = Int(collectionView.frame.width)/cellSize
        let height = Int(collectionView.frame.height-64)/cellSize
        print(CGFloat(indexPath.last!)/CGFloat(width*height))
   
        let pos: Int = indexPath.last!
        let cellPerLine = Int(self.view.frame.size.width)/cellSize
        var x = pos%cellPerLine
        var y = pos/cellPerLine
        
        x = x + xPage * cellPerLine - cellPerLine
        y = y + yPage * cellPerLine - cellPerLine
        
        feedCell.firPathObserver = "\(x),\(y)"   // Retreive firebase data at location

        return feedCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSize,height: cellSize)
    }


}


