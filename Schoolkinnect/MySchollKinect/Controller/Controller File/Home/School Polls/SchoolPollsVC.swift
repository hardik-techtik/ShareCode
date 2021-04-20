//
//  SchoolPollsVC.swift
//  MySchollKinect
//
//  Created by Admin on 26/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SchoolPollsVC: BaseVC {

    @IBOutlet weak var btnOpenCreatePolls: UIButton!
    @IBOutlet weak var createPollsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var RecentPollsTop: NSLayoutConstraint!
    @IBOutlet weak var CreatePollsView: UIView!
    @IBOutlet weak var tablView: reloadTable!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblpolls: UIView!
    
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var PollsTitle: UILabel!
    @IBOutlet weak var lblrecentpollstitle: UILabel!
    var FromVC = false
    
    var PollsVC:CreatePollsVc?
    var Opened = false
    var polls:[Schoolpolls] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tablView.delegate = self
        self.tablView.dataSource = self
        self.tablView.RefresgDelegete = self
        self.tablView.tableFooterView = UIView()
        self.CreatePollsView.isHidden = true
        self.tablView.setEmptyMessage1111("No polls found")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSchoolpolls()
        btnOpenCreatePolls.addTarget(self, action: #selector(OpenCloseCreatePolls(_:)), for: .touchUpInside)
        //self.backView.AddDefaultShadowToTable()
        if self.FromVC
        {
            self.btnOpenCreatePolls.isHidden = true
            self.PollsTitle.text = "My Polls"
            self.lblrecentpollstitle.isHidden = true
        }
        
    }
    
    @objc func OpenCloseCreatePolls(_ button:UIButton) {
        self.Opened = !self.Opened
        self.PollsVC?.lblTIile.text = "Create a new poll"
        if self.Opened {
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                
            }) { (isCompleted) in
                UIView.animate(withDuration: 0.3) {
                  //  self.btnOpenCreatePolls.transform3D = CATransform3DMakeRotation(CGFloat((Double.pi)/4), 0, 0, 1)
                    self.CreatePollsView.isHidden = false
                }
            }
        } else {
            self.CreatePollsView.isHidden = true
           // self.btnOpenCreatePolls.transform3D = CATransform3DMakeRotation(CGFloat((Double.pi)/2), 0, 0, 1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "CreatePollsVc" {
            self.PollsVC = segue.destination as? CreatePollsVc
            //self.PollsVC?.lblTIile.text = "Create a new poll"
            PollsVC?.Delegate = self
        }
    }
}

//MARK:- web services
extension SchoolPollsVC {
    @objc func getSchoolpolls() {
        let serviceManager = ServiceManager<Schoolpolls>.init()
        serviceManager.ShowLoader = true
        if self.FromVC
        {
            serviceManager.ServiceName = "user-poll"
        }
        else
        {
            serviceManager.ServiceName = "all-poll/\(User.shared.schoolID ?? 0)"
        }
        
        serviceManager.MakeServiceCall(httpMethod: .get) { (Response) in
            let Polls = Response as? ResponseModel<Schoolpolls>
            self.polls = Polls?.Data ?? []
            if self.polls.count == 0 {
                self.tablView.setEmptyMessage1111("No polls found")
            } else {
                self.tablView.setEmptyMessage1111("")
            }
            self.tablView.reloadData()
        }
    }
    func DeletePolls(pollID:String) {
        let serviceManager = ServiceManager<Schoolpolls>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll/\(pollID)"
        serviceManager.MakeServiceCall(httpMethod: .delete) { (Response) in
            let Polls = Response as? ResponseModelSuccess
            RDalertcontoller().presentAlertWithMessage(Message:Polls?.errorMsg ?? "",onVc:self)
            self.getSchoolpolls()
        }
    }
    func LikePoll(ID:String,isLiked : Bool = false) {
        let serviceManager = ServiceManager<SchoolpollsLikeUnlike>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll-like"
        serviceManager.Parameters = [
            "poll_id":ID,
            "like": isLiked ? "0" : "1",
            "dislike": ""
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Polls = Response as? ResponseModelDic<SchoolpollsLikeUnlike>
            guard let index = self.polls.lastIndex(where: { (Polls) -> Bool in
                return (Polls.id ?? 0) == Int.init(ID) ?? 0
            }) else {return}
            self.getSchoolpolls()
            RDalertcontoller().presentAlertWithMessage(Message:Polls?.errorMsg ?? "",onVc:self)
        }
    }
    func DislikePoll(ID:String,isDisliked : Bool = false) {
        let serviceManager = ServiceManager<SchoolpollsLikeUnlike>.init()
        serviceManager.ShowLoader = true
        serviceManager.ServiceName = "poll-like"
        serviceManager.Parameters = [
            "poll_id":ID,
            "like": "",
            "dislike": isDisliked ? "0" : "1"
        ]
        serviceManager.MakeServiceCall(httpMethod: .post) { (Response) in
            let Polls = Response as? ResponseModelDic<SchoolpollsLikeUnlike>
            self.getSchoolpolls()
            RDalertcontoller().presentAlertWithMessage(Message:Polls?.errorMsg ?? "",onVc:self)
        }
    }
}

extension SchoolPollsVC:refreshProtocol {
    func didRefresh(tableView: UITableView) {
        self.getSchoolpolls()
        tablView.refreshControl?.endRefreshing()
    }
    
    
}


//MARK:- pollDelegate
extension SchoolPollsVC:PollsDelegate,UIScrollViewDelegate {
    func pollDidCreated() {
        self.CreatePollsView.isHidden = true
        UIView.animate(withDuration: TimeInterval.init(0.2)) {
            //self.btnOpenCreatePolls.transform3D = CATransform3DMakeRotation(CGFloat((Double.pi)/2), 0, 0, 1)
        }
        self.getSchoolpolls()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !self.CreatePollsView.isHidden {
            self.CreatePollsView.isHidden = true
            self.Opened = !self.Opened
            UIView.animate(withDuration: TimeInterval.init(0.2)) {
                //self.btnOpenCreatePolls.transform3D = CATransform3DMakeRotation(CGFloat((Double.pi)/2), 0, 0, 1)
            }
        }
    }
}

//MARK:- collection view delegate and data Source
extension SchoolPollsVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.polls.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let poll = self.polls[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollsCell") as? PollsCell
        
        //cell?.btnReply.addTarget(self, action: #selector(Reply(_:)), for: .touchUpInside)
        
        cell?.btnReplies.addTarget(self, action: #selector(Reply(_:)), for: .touchUpInside)
        cell?.btnLike.addTarget(self, action: #selector(Like(_:)), for: .touchUpInside)
        cell?.btnDislike.addTarget(self, action: #selector(disLike(_:)), for: .touchUpInside)
        cell?.btnReply.tag = indexPath.row
        cell?.btnLike.tag = indexPath.row
        cell?.btnDislike.tag = indexPath.row
        
        ////////////////////
        
        cell?.lblPollDescription.text = poll.datumDescription
        
        cell?.btnLike.setTitle(" \(formatNumber(poll.likesCount ?? 0))", for: .normal)
        
        let liked = self.polls[indexPath.row].UserLike ?? false
        
        if liked
        {
            cell?.btnLike.setImage(UIImage.init(named: "like-sel"), for: .normal)
            cell?.btnLike.tintColor = nil
        }
        else
        {
            cell?.btnLike.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
            cell?.btnLike.tintColor = UIColor(hexFromString: "666666")
        }
        
        cell?.btnOptions.addTarget(self, action: #selector(options(_:)), for: .touchUpInside)
        cell?.btnOptions.tag = indexPath.row
        
        cell?.selectionStyle = .none
        
        let Disliked = self.polls[indexPath.row].UserDisLike ?? false
        
        if Disliked
        {
            cell?.btnDislike.setImage(UIImage.init(named: "dislike-sel"), for: .normal)
        }
        else
        {
            cell?.btnDislike.setImage(UIImage.init(named: "dislike"), for: .normal)
        }
        
        cell?.btnDislike.setTitle(" \(formatNumber(poll.dislikesCount ?? 0))", for: .normal)
        
        
        let REply = poll.pollcommentCount ?? 0
        
        if REply > 0
        {
            
            let str = REply == 1 ? "Reply" : "Replies"
            
            cell?.btnReplies.setTitle(" \(formatNumber(poll.pollcommentCount ?? 0)) \(str)", for: .normal)
        }
        else
        {
             cell?.btnReplies.setTitle(" Reply", for: .normal)
        }
        
        ////////////////////
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func Reply(_ button:UIButton) {
        let Poll = self.polls[button.tag]
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchoolPollsReplyVC") as? SchoolPollsReplyVC else { return }
        vc.Poll = Poll
        vc.FromVC = self.FromVC
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func Like(_ button:UIButton) {
        let ID = self.polls[button.tag].id
        self.LikePoll(ID: "\(ID ?? 0)",isLiked: self.polls[button.tag].UserLike ?? false)
    }
    
    @objc func disLike(_ button:UIButton) {
        let ID = self.polls[button.tag].id
        self.DislikePoll(ID: "\(ID ?? 0)", isDisliked: self.polls[button.tag].UserDisLike ?? false)
    }
    
    @objc func options(_ button:UIButton) {
        if (polls[button.tag].userID ?? "") == "\((User.shared.id ?? 0))" {
            let Alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction.init(title: "Delete", style: .default) { (Action) in
                let alert = UIAlertController.init(title: "My School Kinect", message: "Are you sure you want to delete this poll?", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                    let Tag = button.tag
                    let id = self.polls[Tag].id ?? 0
                    self.DeletePolls(pollID: "\(id)")
                }
                let no = UIAlertAction.init(title: "No", style: .default) { (action) in }
                alert.addAction(ok)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            }
            let UpdateAAction = UIAlertAction.init(title: "Edit", style: .default) { (Action) in
                let Tag = button.tag
                let text = self.polls[Tag].datumDescription
                self.PollsVC?.txtDescription.text = text
                self.PollsVC?.Updating = true
                self.PollsVC?.PostID = "\(self.polls[Tag].id ?? 0)"
                self.OpenCloseCreatePolls(self.btnOpenCreatePolls)
                self.PollsVC?.lblTIile.text = "Update a poll"
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in
            }
            
            Alert.addAction(DeleteAction)
            //Alert.addAction(UpdateAAction)
            Alert.addAction(CancelAction)
            self.present(Alert, animated: true, completion: nil)
        } else {
            let Alert = UIAlertController.init(title: "Please select action", message: nil, preferredStyle: .actionSheet)
            
            let UpdateAAction = UIAlertAction.init(title: "Report", style: .default) { (Action) in
                let Tag = button.tag
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as? ReportVC else { return }
                vc.ReportID = self.polls[Tag].id ?? 0
                vc.For = "poll"
                //vc.userId = self.polls[Tag].userID ?? 0
                vc.userId = Int(self.polls[Tag].userID!)!
                self.navigationController?.show(vc, sender: nil)
            }
            let CancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (Action) in }
            Alert.addAction(UpdateAAction)
            Alert.addAction(CancelAction)
            
            self.present(Alert, animated: true, completion: nil)
        }
    }
}
