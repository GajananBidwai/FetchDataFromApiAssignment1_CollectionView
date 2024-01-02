//
//  ViewController.swift
//  FetchDataFromApiAssignment1_CollectionView
//
//  Created by Mac on 19/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectViewCell: UICollectionView!
    var post : [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        initiazeTableView()
        registerXIBWithTableView()
    }
    func fetchData()
    {
        let postUrl = URL(string: "https://jsonplaceholder.typicode.com/albums")
        var postUrlRequest = URLRequest(url: postUrl!)
        postUrlRequest.httpMethod = "Get"
        
        let urlSession = URLSession(configuration: .default)
        
        let postDataTask = urlSession.dataTask(with: postUrlRequest) { postData, postResponse, postError in
            let postUrlResponse = try! JSONSerialization.jsonObject(with: postData!) as! [[String : Any]]
            
            for eachResponse in postUrlResponse
            {
                let postDictionary = eachResponse as! [String : Any]
                let postUserId = postDictionary["userId"] as! Int
                let postId = postDictionary["id"] as! Int
                let postTitle = postDictionary["title"] as! String
                
                let postObject = Post(userId: postUserId, id: postId, title: postTitle)
                
                self.post.append(postObject)
                
            }
            DispatchQueue.main.async {
                self.collectViewCell.reloadData()
            }
        }
        postDataTask.resume()
    }
    func initiazeTableView()
    {
        collectViewCell.dataSource = self
        collectViewCell.delegate = self
    }
    func registerXIBWithTableView()
    {
        let uiNib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        collectViewCell.register(uiNib, forCellWithReuseIdentifier: "PostCollectionViewCell")
    }
}
extension ViewController : UICollectionViewDelegate
{
    
}
extension ViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCollectionViewCell = self.collectViewCell.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        
        postCollectionViewCell.userIdLabel.text = String(post[indexPath.item].userId)
        
        
        postCollectionViewCell.idLabel.text = String(post[indexPath.item].id)
        postCollectionViewCell.titleLabel.text = post[indexPath.item].title
        
        return postCollectionViewCell
    }
    
    
}
extension ViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let spaceBetweenTheCell : CGFloat = (flowLayout.minimumInteritemSpacing ?? 0.0) + (flowLayout.sectionInset.left ?? 0.0) + (flowLayout.sectionInset.right ?? 0.0)
        
        let size = (self.collectViewCell.frame.width - spaceBetweenTheCell) / 2
        
        return CGSize(width: size, height: size)
        
    }
}


