//
//  ViewController.swift
//  Color
//
//  Created by Caelan Dailey on 7/31/17.
//  Copyright © 2017 Caelan Dailey. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    let cellId = "cellId"
    var cellSize: CGFloat = 15.0
    var cellHexColor = "121212"
    let colorPickerHeight:CGFloat = 100
    let topBarHeight:CGFloat = 64.0
    var ref: DatabaseReference!
    var roomName = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorPicker()
        setupTopBar()
       
        collectionView?.translatesAutoresizingMaskIntoConstraints = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor(red: 255, green: 255, blue: 255)
        
        collectionView?.register(ColorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.collectionViewLayout = ColorCellLayout(itemWidth: cellSize, itemHeight: cellSize)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ColorCell
        
        feedCell.backgroundColor = UIColor.clear
        feedCell.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(uploadCellColor)))
        feedCell.firPathObserver = roomName + "/" + "\(indexPath.item),\(indexPath.section)"  // Retreive firebase data at location
        
        return feedCell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        for view in (self.view.subviews) {
            
            if !(view is UICollectionView) {
                view.removeFromSuperview()
            }
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            
            self.setupColorPicker()
            self.setupTopBar()
            self.reloadCollectionView()
        }
    }
    
    func uploadCellColor(sender : UITapGestureRecognizer)
    {
        let tapLocation = sender.location(in: self.collectionView)
        let indexPath : NSIndexPath = self.collectionView!.indexPathForItem(at: tapLocation)! as NSIndexPath
        
        let itemRef = Database.database().reference().child(roomName + "/" + "\(indexPath.item),\(indexPath.section)")
        
        itemRef.setValue(cellHexColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSize,height: cellSize)
    }
    
    func reloadCollectionView() {
        
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout = ColorCellLayout(itemWidth: self.cellSize, itemHeight: self.cellSize)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        if (textField.text == "") {
            textField.text = roomName
        } else if (textField.text != roomName) {
            roomName = textField.text!
            reloadCollectionView()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func zoomIn() {
        
        if (cellSize < 45) {
            cellSize += 5
            reloadCollectionView()
        }
    }
    
    func zoomOut() {
        if (cellSize > 10) {
            cellSize -= 5
            reloadCollectionView()
        }
    }
    
    func setupTopBar() {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: topBarHeight)
        view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let line = UIView()
        line.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        line.frame  = CGRect(x: 0, y: topBarHeight-1.0, width: view.frame.size.width,height: 1)
        
        let textField = UITextField()
        textField.frame = CGRect(x: self.view.frame.width/3 , y:CGFloat(20), width: self.view.frame.width/3, height: CGFloat(44))
        textField.text = "All"
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        textField.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        let outButton = UIButton()
        outButton.frame = CGRect(x: 0 , y:CGFloat(20), width: self.view.frame.width/3, height: CGFloat(44))
        outButton.setTitle("-", for: .normal)
        outButton.setTitleColor(UIColor.black, for: .normal)
        outButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        
        let inButton = UIButton()
        inButton.frame = CGRect(x: self.view.frame.width*2/3 , y:CGFloat(20), width: self.view.frame.width/3, height: CGFloat(44))
        inButton.setTitle("+", for: .normal)
        inButton.titleLabel?.textColor = UIColor.black
        inButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        inButton.setTitleColor(UIColor.black, for: .normal)
        inButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        
        view.addSubview(inButton)
        view.addSubview(outButton)
        view.addSubview(line)
        view.addSubview(textField)
        
        self.view.addSubview(view)
        
    }
    
    func setupColorPicker() {
        let screenWidth = self.view.frame.width
        
        let view = UIView()
        
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: self.view.frame.height - colorPickerHeight, width: screenWidth, height: colorPickerHeight)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let line = UIView()
        line.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        line.frame  = CGRect(x: 0, y: 0, width: view.frame.size.width,height: 1)
        
        addColorButton(color: 0x000000, view: view, pos: 0) // Black
        addColorButton(color: 0xcccccc, view: view, pos: 2) // Gray
        addColorButton(color: 0xffffff, view: view, pos: 1) // White
        addColorButton(color: 0xFFC0CB, view: view, pos: 3) // Pink
        addColorButton(color: 0xff00ff, view: view, pos: 9) // Purple
        addColorButton(color: 0xff0000, view: view, pos: 5) // Red
        addColorButton(color: 0xffa500, view: view, pos: 6) // Orange
        addColorButton(color: 0x00ff00, view: view, pos: 7) // Green
        addColorButton(color: 0xffff00, view: view, pos: 8) // Yellow
        addColorButton(color: 0x0000ff, view: view, pos: 4) // Blue
      
        view.addSubview(line)
        self.view.addSubview(view)
    }
    
    private func addColorButton(color: Int, view: UIView, pos: Int) {
    
        let button = UIButton()
        let size = 35
        let height = Int(view.frame.size.height)
        let columnCount = 5
        let rowCount = 2
        
        let x = ((pos % columnCount) + 1 ) * ( (Int(self.view.frame.width) - (columnCount*size) )/(columnCount+1)) + (size * (pos % columnCount))
        let yOffset1 = (Int(pos/columnCount) + 1) * (height - rowCount*size) / (rowCount+1)
        let yOffset2 = size * Int(pos / columnCount)
        let y = yOffset1 + yOffset2
        
        button.frame = CGRect(x: x, y: y, width: size, height: size)
        button.backgroundColor = UIColor(rgb: color)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(setColor), for: .touchUpInside)
        view.addSubview(button)
    
    }
    
    func setColor(sender: UIButton) {
        
        if let color = sender.backgroundColor?.toHexString {
            cellHexColor = color
        }
    }
}

