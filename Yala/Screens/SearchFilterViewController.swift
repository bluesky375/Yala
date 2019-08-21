//
//  SearchFilterViewController.swift
//  Yala
//
//  Created by Admin on 4/11/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import UIKit
class SearchFilterViewController: UIViewController
{

    
    @IBOutlet weak var viewLeftSide: UIView!
    @IBOutlet weak var viewRightSide: UIView!
    
    @IBOutlet weak var viewSortLeft: UIView!
    @IBOutlet weak var viewSortRightSide: UIView!
    
    
    
    @IBOutlet weak var btnAutoDistance: UIButton!
    @IBOutlet weak var btn05Distance: UIButton!
    @IBOutlet weak var btn2Distance: UIButton!
    @IBOutlet weak var btn10Distance: UIButton!
    @IBOutlet weak var btn25Distance: UIButton!
    @IBOutlet weak var btn50Distance: UIButton!
    
    @IBOutlet weak var btnFeaturedSort: UIButton!
    @IBOutlet weak var btnDistanceSort: UIButton!
    @IBOutlet weak var btnNameSort: UIButton!
    @IBOutlet weak var btnRatingSort: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //search filter content
    var distance = "1000"
    var sortBy = "distance"
    
    var sections : [GoogleSearchData.Section] = []
    //var expandedIndexPaths : [IndexPath] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingCornerRadius()
        clickDistanceButton(no: 0)
        clickSortButton(no: 1)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sections = GoogleSearchData.sectionsData
    }
    
  
    class func fromStoryboard() -> SearchFilterViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SearchFilterViewController.self)) as! SearchFilterViewController
        return viewController
    }
    
    func settingCornerRadius(){
        viewLeftSide.clipsToBounds = false
        viewLeftSide.layer.cornerRadius = 4
        viewLeftSide.layer.maskedCorners=[.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        btnAutoDistance.clipsToBounds = false
        btnAutoDistance.layer.cornerRadius = 3
        btnAutoDistance.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        viewRightSide.clipsToBounds = false
        viewRightSide.layer.cornerRadius = 4
        viewRightSide.layer.maskedCorners=[.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        btn50Distance.clipsToBounds = false
        btn50Distance.layer.cornerRadius = 3
        btn50Distance.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        
        
        viewSortLeft.clipsToBounds = false
        viewSortLeft.layer.cornerRadius = 4
        viewSortLeft.layer.maskedCorners=[.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        btnFeaturedSort.clipsToBounds = false
        btnFeaturedSort.layer.cornerRadius = 3
        btnFeaturedSort.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        viewSortRightSide.clipsToBounds = false
        viewSortRightSide.layer.cornerRadius = 4
        viewSortRightSide.layer.maskedCorners=[.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        btnRatingSort.clipsToBounds = false
        btnRatingSort.layer.cornerRadius = 3
        btnRatingSort.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
    }
    
    func clickDistanceButton (no : Int){
        let defaultColor = UIColor.init(displayP3Red: 75/255, green: 168/255, blue: 208/255, alpha: 1.0)
        btnAutoDistance.backgroundColor = UIColor.white
        btnAutoDistance.setTitleColor(defaultColor, for: .normal)
        btn05Distance.backgroundColor = UIColor.white
        btn05Distance.setTitleColor(defaultColor, for: .normal)
        btn2Distance.backgroundColor = UIColor.white
        btn2Distance.setTitleColor(defaultColor, for: .normal)
        btn10Distance.backgroundColor = UIColor.white
        btn10Distance.setTitleColor(defaultColor, for: .normal)
        btn25Distance.backgroundColor = UIColor.white
        btn25Distance.setTitleColor(defaultColor, for: .normal)
        btn50Distance.backgroundColor = UIColor.white
        btn50Distance.setTitleColor(defaultColor, for: .normal)
        
        switch (no){
        case 0 :
            btnAutoDistance.backgroundColor = .none
            btnAutoDistance.setTitleColor(UIColor.white, for: .normal)

            break
        case 1 :
            btn05Distance.backgroundColor = .none
            btn05Distance.setTitleColor(UIColor.white, for: .normal)
            
            break
        case 2 :
            btn2Distance.backgroundColor = .none
            btn2Distance.setTitleColor(UIColor.white, for: .normal)
          
            break
        case 3 :
            btn10Distance.backgroundColor = .none
            btn10Distance.setTitleColor(UIColor.white, for: .normal)
          
            break
        case 4 :
            btn25Distance.backgroundColor = .none
            btn25Distance.setTitleColor(UIColor.white, for: .normal)
          
            break
        case 5 :
            btn50Distance.backgroundColor = .none
            btn50Distance.setTitleColor(UIColor.white, for: .normal)
          
            break
        default:
            break
        }
    }
    func clickSortButton (no : Int){
        let defaultColor = UIColor.init(displayP3Red: 75/255, green: 168/255, blue: 208/255, alpha: 1.0)
        btnFeaturedSort.backgroundColor = UIColor.white
        btnFeaturedSort.setTitleColor(defaultColor, for: .normal)
        btnDistanceSort.backgroundColor = UIColor.white
        btnDistanceSort.setTitleColor(defaultColor, for: .normal)
        btnNameSort.backgroundColor = UIColor.white
        btnNameSort.setTitleColor(defaultColor, for: .normal)
        btnRatingSort.backgroundColor = UIColor.white
        btnRatingSort.setTitleColor(defaultColor, for: .normal)
        
        switch (no){
        case 0 :
            btnFeaturedSort.backgroundColor = .none
            btnFeaturedSort.setTitleColor(UIColor.white, for: .normal)
            
            break
        case 1 :
            btnDistanceSort.backgroundColor = .none
            btnDistanceSort.setTitleColor(UIColor.white, for: .normal)
            
            break
        case 2 :
            btnNameSort.backgroundColor = .none
            btnNameSort.setTitleColor(UIColor.white, for: .normal)
            
            break
        case 3 :
            btnRatingSort.backgroundColor = .none
            btnRatingSort.setTitleColor(UIColor.white, for: .normal)
            break
      
        default:
            break
        }
    }
    
    func returnValue(){
        
        
        
        
        
    }
    
    @IBAction func onResetTapped(_ sender: Any) {
        autoDistanceTapped((Any).self)
        onDistanceSort((Any).self)
        
    }
    
    
    @IBAction func onDismissView(_ sender: Any) {
        dismiss(animated: true, completion: {
            
            var searchFilter : [String] = ["","","","",""]
            searchFilter[0] = self.sortBy
            searchFilter[1] = self.distance
            var minPrice = 4
            var maxPrice = 0
            // searchFilter[2] =
            for(index, element) in self.sections[0].items.enumerated(){
                if(element.selected){
                    if(index<minPrice){
                        minPrice = index
                    }
                    if(index>maxPrice){
                        maxPrice = index
                    }
                }
            }
            
            searchFilter[2] = "\(minPrice)"
            searchFilter[3] = "\(maxPrice)"
            
            for(index, element) in self.sections[1].items.enumerated(){
               var flag = true
                if(element.selected){
                    if(flag){
                        searchFilter[4] = element.detail
                        flag = false
                    }else{
                        searchFilter[4] += ","+element.detail
                    }
                }
            }
            
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "requrieGoogleMapSearch"), object : searchFilter)
            
        })
    }
    
    @IBAction func autoDistanceTapped(_ sender: Any) {
        distance = "1000"
        clickDistanceButton(no: 0)
    }
    @IBAction func halfKDistanceTappped(_ sender: Any) {
        distance = "500"
        clickDistanceButton(no: 1)
    }
    @IBAction func k2DistanceTapped(_ sender: Any) {
        distance = "2000"
        clickDistanceButton(no: 2)
    }
    
    @IBAction func k10DistanceTapped(_ sender: Any) {
        distance = "10000"
        clickDistanceButton(no: 3)
        
    }
    @IBAction func k25DistanceTapped(_ sender: Any) {

        distance = "25000"
        clickDistanceButton(no: 4)
    }
    @IBAction func k50DistanceTapped(_ sender: Any) {
        distance = "50000"
        clickDistanceButton(no: 5)
    }
    
    // sort option tapped
    @IBAction func onFeaturedSort(_ sender: Any) {
        sortBy = "featured"
        clickSortButton(no: 0)
    }
    
    @IBAction func onDistanceSort(_ sender: Any) {
        sortBy = "distance"
        clickSortButton(no: 1)
    }
    @IBAction func onNameSort(_ sender: Any) {
        sortBy = "name"
        clickSortButton(no: 2)
    }
    @IBAction func onRatingSort(_ sender: Any) {
        sortBy  = "rating"
        clickSortButton(no: 3)
    }

}
extension SearchFilterViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollapTableViewCell") as! CollapTableViewCell
        
        let item: GoogleSearchData.Item = sections[indexPath.section].items[indexPath.row]
        cell.lblName.text = item.name
        if(item.selected){
            cell.imageIcon.image = UIImage(named : "ic_check")
        }else{
            cell.imageIcon.image = UIImage()
        }
        cell.lblName.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
//        cell.nameLabel.text = item.name
//        cell.detailLabel.text = item.detail
        return cell
    }
    
    
}

extension SearchFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].items[indexPath.row].selected = !(sections[indexPath.section].items[indexPath.row].selected)
        
        tableView.reloadData()
      //  print(sections)
    }
}

//
// MARK: - Section Header Delegate
//
extension SearchFilterViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.bounds.height - thickness,  width: UIScreen.main.bounds.width, height: thickness)
            
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0,  width: thickness, height: self.bounds.height)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: self.bounds.width - thickness, y: 0,  width: thickness, height: self.bounds.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
