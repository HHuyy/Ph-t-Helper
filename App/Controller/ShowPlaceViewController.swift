//
//  ShowPlaceViewController.swift
//  App
//
//  Created by Đừng xóa on 9/22/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit

class ShowPlaceViewController: UIViewController {

    var dispatchWorkItem: DispatchWorkItem?
    var place: PlaceViewNam?
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if place != nil {
            nameLabel.text = place?.name
            contentLabel.text = place?.content
            getImage(from: "\((place?.image)!)", completedHandler: { (image) in
                self.backGroundImage.image = image
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getImage(from urlString: String, completedHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {return}
        var image: UIImage?
        dispatchWorkItem = DispatchWorkItem(block: {
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
        })
        DispatchQueue.global().async {
            self.dispatchWorkItem?.perform()
            DispatchQueue.main.async {
                completedHandler(image)
            }
        }
    }
}
