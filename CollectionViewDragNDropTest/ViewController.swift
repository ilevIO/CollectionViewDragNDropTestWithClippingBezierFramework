//
//  ViewController.swift
//  CollectionViewDragNDropTest
//
//  Created by Ilya Yelagov on 06.01.2020.
//  Copyright © 2020 Ilya Yelagov. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    var collectionView: UICollectionView!
    var items = [ExampleItem(cornerRadius: 0), ExampleItem(cornerRadius: 0.1), ExampleItem(cornerRadius: 10)]
    let cellReuseIdentifier = "GenericCell"
    func testIntersections() {
        let path1 = UIBezierPath(rect: .init(x: 10, y: 10, width: 100, height: 100))
        let path2 = UIBezierPath(rect: .init(x: 20, y: 20, width: 100, height: 100))
        var x: ObjCBool = false
        if let intersections = path1.findIntersections(withClosedPath: path2, andBeginsInside: &x) {
            for intersection in intersections {
                guard let intersection = intersection as? DKUIBezierPathIntersectionPoint else {
                    continue
                }
                print(intersection.location1())
                print(intersection.location2())
                print()
            }
        }
    }
    private func initViewController() {
        let guide = self.view.safeAreaLayoutGuide
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        testIntersections()
        initViewController()
    }
}

extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        cell.layer.cornerRadius = items[indexPath.row].cornerRadius
        //green for zero radius, red -- for non-zero
        if cell.layer.cornerRadius > CGFloat.ulpOfOne {
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .green
        }
        return cell
    }
}

extension MyViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider(object: "item" as NSString))]
    }
    
}
