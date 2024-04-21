 //
//  MyCollectionViewCell.swift
//  iOS Assignment
//
//  Created by Kishan on 21/04/24.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var acharyaPrashantImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(in imageURL: URL) {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.acharyaPrashantImage.contentMode = .scaleAspectFill
                    self.acharyaPrashantImage.clipsToBounds = true
                    self.acharyaPrashantImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.acharyaPrashantImage.image = image
                }
            } else {
                print("Error loading image:", error?.localizedDescription ?? "Unknown error")
            }
        }.resume()
    }
}
