//
//  StudentlistViewController.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/25/21.
//

import UIKit

// MARK: - Student List View Controller
class StudentlistViewController: UIViewController{
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get the student locations
        getStudentLocations()
        
    }
    
    // MARK: - Refresh List
    @IBAction func refreshList(_ sender: Any) {
        //get the locations and reload the map
        getStudentLocations()
    }
    
    // MARK: - Get Student Locations
    func getStudentLocations(){
        //get the locations and handle the response
        OnTheMapUser.getStudentLocations(completion: handleStudentInfoResponse(studentInfo:error:))
    }
    
    // MARK: - Handle Student Info Response
    func handleStudentInfoResponse(studentInfo: [StudentInfo], error: Error?){
        
        if error == nil {
            //stored the information
            StudentInfoModel.studentInfo = studentInfo
            
            //reload the table list
            self.tableView.reloadData()
        } else {
            
            //inform the user if the download fails
            showFailureMessage(title: "Student Locations Failed", message: error?.localizedDescription ?? "")
        }
    }
   
    
}

// MARK: - Extension Student List View Controller :
extension StudentlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return StudentInfoModel.studentInfo.count
    }
    
    // MARK: - TableView Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListViewCell")!
        let student = StudentInfoModel.studentInfo[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = student.firstName + " " + student.lastName
        
        cell.detailTextLabel?.text = student.mediaURL
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        
        return cell
    }
    
    // MARK: - TableView Did Select Row At
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = StudentInfoModel.studentInfo[(indexPath as NSIndexPath).row]
        
        if validateUrl(urlString: student.mediaURL)   {
            
            UIApplication.shared.open(URL(string: student.mediaURL)!, options: [:], completionHandler: nil)
        } else {
            showFailureMessage(title: "Invalid Link", message: "This is not a valid link. Try another one.")
        }
        
    }
}
