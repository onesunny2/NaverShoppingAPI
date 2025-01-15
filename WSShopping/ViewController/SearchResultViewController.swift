//
//  SearchResultViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var nvtitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = nvtitle
    }

}

