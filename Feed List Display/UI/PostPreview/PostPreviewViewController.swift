//
//  PostPreviewViewController.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import UIKit

class PostPreviewViewController: ViewController {
    typealias ViewModelType = PostPreviewViewModel
    var viewModel: PostPreviewViewModel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure()
    }
}
