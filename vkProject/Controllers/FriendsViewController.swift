//
//  FriendsViewController.swift
//  vkProject
//
//  Created by Антон Григорьев on 12.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var searchController: UISearchController!
    
    private var friends: [Person]?
    private var filteredFriends: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 117/255, blue: 163/255, alpha: 1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Друзья"
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 211/255, green: 225/255, blue: 241/255, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor.darkGray
        definesPresentationContext = true
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        
        getFriendsList()
    }
    
    /*
     Filters friends array for search
     */
    func filterContentFor(searchText text: String) {
        filteredFriends = friends?.filter({ (friend) -> Bool in
            return ((friend.info["first_name"] as! String).lowercased().contains(text.lowercased()) || (friend.info["last_name"] as! String).lowercased().contains(text.lowercased()))
        })
    }
    
    @objc private func refreshTableData(_ sender: Any) {
        getFriendsList()
    }
    
    /*
     Get friends list and reload data. After that we will get avatars 50x50 acync
     */
    func getFriendsList(){
        VKClient().getFriendsList { (friends, error) in
            if (error != nil) {
                self.getFriendsList()
            } else {
                DispatchQueue.main.async {
                    if friends != nil {
                        self.friends = friends
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        
                    } else {
                        self.getFriendsList()
                        self.refreshControl.endRefreshing()
                    }
                }
                DispatchQueue.main.async {
                    self.getFriendsAvatars()
                }
            }
            
        }
    }
    
    /*
     Get avatar for each user and reload its row
     */
    func getFriendsAvatars() {
        for friend in friends! {
            VKClient().getAvatar50(forUser: friend, callback: { (imageData, error) in
                DispatchQueue.main.async {
                    if imageData != nil {
                        let row = (self.friends)!.index(of: friend)
                        self.friends![row!].info["avatar50_imageData"] = imageData
                        self.tableView.reloadRows(at: [[0, row!]], with: .none)
                    }
                }
            })
        }
        
    }
    
    /*
     If searching is active returns filtered friends array. Else - full array
     */
    func friendsToDisplayAt(indexPath: IndexPath) -> Person {
        let friend: Person
        if searchController.isActive && searchController.searchBar.text != "" {
            friend = filteredFriends![indexPath.row]
        } else {
            friend = friends![indexPath.row]
        }
        return friend
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredFriends!.count
        } else {
            if (friends == nil) {
                return 0
            } else {
                return friends!.count
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        let friend = friendsToDisplayAt(indexPath: indexPath)
        
        cell.friend = friend
        
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        
        return cell
    }
    
    /*
     Selecting the row we will open controller to show chosen friends avatar preview
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let strbrd: UIStoryboard = self.storyboard!
        let avatarController: AvatarViewController = strbrd.instantiateViewController(withIdentifier: "AvatarViewController") as! AvatarViewController
        
        let friend = friendsToDisplayAt(indexPath: indexPath)
        
        avatarController.friendToGetAvatar = friend
        self.showDetailViewController(avatarController, sender: self)
    }

}

extension FriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = nil
        } else {
            refreshControl.removeFromSuperview()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    
}
