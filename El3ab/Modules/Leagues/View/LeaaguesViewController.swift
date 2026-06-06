//
//  LeaaguesViewController.swift
//  El3ab
//
//  Created by depo on 06/06/2026.
//

import UIKit


protocol LeaguesViewProtocol : AnyObject{
    func showData(leagues:[Leagues])
    func showLoading()
    func hideLoading()
    func navigateToDetails()
}
class LeaguesViewController: UIViewController {

    let indicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //presenter.load leaguess daata
        // Do any additional setup after loading the view.
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

extension LeaguesViewController : LeaguesViewProtocol{
    func showData(leagues:[Leagues]) {
        // table view . show data
    }
    
    func showLoading() {
        indicator.center = view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func hideLoading() {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    func navigateToDetails() {
        //interesting
    }
    
    
}
