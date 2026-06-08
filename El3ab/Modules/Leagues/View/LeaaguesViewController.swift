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
    
    @IBOutlet weak var leaguesTableView: UITableView!
    let indicator = UIActivityIndicatorView(style: .large)
    var presenter : LeaguesPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        
        leaguesTableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        leaguesTableView.backgroundColor = .bgColor
        self.view.backgroundColor = .bgColor    
        leaguesTableView.separatorStyle = .none
        self.presenter = LeaguesPresenter()
        presenter?.attachView(self)
        presenter?.loadData()
        leaguesTableView.dataSource = self
        leaguesTableView.delegate = self
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      Get the new view controller using segue.destination.
//      Pass the selected object to the new view controller.
         if segue.identifier == "LeaguesViewControllerToLeaguesDetailsViewController" {
             let LeagueDetailsVC = segue.destination as! LeagueDetailsViewController
             if let league = sender as? Leagues {
                 LeagueDetailsVC.configureSelectedLeague(league: league)
             }
         }
     }
     
    
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

extension LeaguesViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return presenter?.getLeaguesCount() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let league = presenter?.getLeague(index: indexPath.row)
         let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
            
        cell.leagueCountry.text = league?.countryName
//        cell.leagueImageView =
        cell.leagueTitle.text=league?.leagueName
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let league = presenter?.getLeague(index: indexPath.row)

        performSegue(withIdentifier: "LeaguesViewControllerToLeaguesDetailsViewController", sender: league)
    }
    
}
