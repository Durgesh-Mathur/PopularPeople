//
//  DetailViewController.swift
//  PopularCelebrities
//
//  Created by Durgesh Mathur on 24/12/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblKnownForDepartment: UILabel!
    @IBOutlet weak var lblAdult: UILabel!
    @IBOutlet weak var imgPerson: UIImageView!
    
    var detailOfPerson: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        lblName.text = detailOfPerson?.name
        lblKnownForDepartment.text = detailOfPerson?.knownForDepartment
        lblAdult.text = detailOfPerson?.adult ?? false ? "Adult" : "Not Adult"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


