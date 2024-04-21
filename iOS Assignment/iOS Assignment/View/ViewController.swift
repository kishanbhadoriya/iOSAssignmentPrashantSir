//
//  ViewController.swift
//  iOS Assignment
//
//  Created by Kishan on 20/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel = ImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        bindViewModel()
        viewModel.fetchImageURLData()
    }
    
    private func setupUI() {
        let nibCell = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "cell")
        collectionView.allowsSelection = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (collectionView.bounds.width - 10)/3, height: (collectionView.bounds.width - 10)/3)
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func bindViewModel() {
        viewModel.imageURLsFetched = { [weak self] urls in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
           
        viewModel.onError = { error in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.backgroundColor = .red
        
        let imageURL = viewModel.imageURLs[indexPath.row]
        let urlString = imageURL
        cell.configureCell(in: urlString)
        return cell
    }
    
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.bounds.width - 10) / 3
            return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

