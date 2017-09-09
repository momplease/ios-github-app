//
//  RepositoryDetailViewController.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 7/24/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = repository?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can rbe recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
