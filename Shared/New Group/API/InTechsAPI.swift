//
//  InTechsAPI.swift
//  InTechs (iOS)
//
//  Created by GoEun Jeong on 2021/10/02.
//

import Foundation
import Moya

public enum InTechsAPI {
    // MARK: - Auth
    case register(name: String, email: String, password: String)
    case login(email: String, password: String)
    case refresh(refreshToken: String)
    
    // MARK: - Mypage
    case mypage
    case updateMypage(name: String, image: Image)
    case updateMyActive(isActive: Bool)
    case getMyProjects
    
    // MARK: - Project
    case dashboard
    case createProject(name: String, image: Image)
    case deleteProject(id: Int)
    case updateProject(id: Int, name: String, image: Image)
    
    case joinProject(id: Int)
    case exitProject(id: Int)
    case getProjectMembers(id: Int)
    
    // MARK: - Issue
    case createIssue(projectId: Int, title: String, body: String?, date: String?, progress: Int?, state: String?)
    case deleteIssue(projectId: Int, issueId: Int)
    case updateIssue(projectId: Int, issueId: Int, title: String, body: String?, date: String?, progress: Int?, state: String?)
    
    // MARK: - Calendar
    case getCalendar(projectId: Int)
    
    // MARK: - Other User
    case getUser(email: String)
    
}

extension InTechsAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://api.potatochips.live")!
    }
    
    public var path: String {
        switch self {
        // MARK: - Auth
        case .register:
            return "/join"
        case .login:
            return "/auth"
        case .refresh:
            return "/refresh"
            
        // MARK: - Mypage
        case .mypage:
            return "/user"
        case .updateMypage:
            return "/user"
        case .updateMyActive:
            return "/user/active"
        case .getMyProjects:
            return "/user/project"
            
        // MARK: - Project
        case .dashboard:
            return "/project/dashboard"
        case .createProject(let name, _):
            return "/project/\(name)"
        case .deleteProject(let id):
            return "/project/\(id)"
        case .updateProject(let id, _, _):
            return "/project/\(id)"
        case .joinProject(let id):
            return "/project/\(id)/user"
        case .exitProject(let id):
            return "/project/\(id)/user"
        case .getProjectMembers(let id):
            return "/project/\(id)/user"
            
        // MARK: - Issue
        case .createIssue(let projectId, _, _, _, _, _):
            return "/project/\(projectId)/issue"
        case .deleteIssue(let projectId, let issueId):
            return "/project/\(projectId)/issue/\(issueId)"
        case .updateIssue(let projectId, let issueId, _, _, _, _, _):
            return "/project/\(projectId)/issue/\(issueId)"
            
        // MARK: - Calendar
        case .getCalendar(let projectId):
            return "/project/\(projectId)/calendar"
            
        // MARK: - Other User
        case .getUser(let email):
            return "/\(email)"
       
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .register, .login, .refresh, .createProject, .joinProject, .createIssue:
            return .post
        case .updateMypage, .updateMyActive, .updateProject, .updateIssue:
            return .patch
        case .deleteProject, .exitProject, .deleteIssue:
            return .delete
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .register(let name, let email, let password):
            return .requestParameters(parameters: ["name": name, "email": email, "password": password], encoding: URLEncoding.default)
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: URLEncoding.default)
//        case .updateMypage(let name, let image):
//            return .requestParameters(parameters: ["name": name, "image": ""], encoding: URLEncoding.default)
        case .updateMyActive(let isActive):
            return .requestParameters(parameters: ["isActive": isActive], encoding: URLEncoding.default)
        case .createIssue(_, let  title, let body, let date, let progress, let state):
            return .requestParameters(parameters: ["title": title, "content": body, "end_date": date, "progress": progress, "state": state], encoding: URLEncoding.default)
//        case .searchLetter(let string):
//            return .requestParameters(parameters: ["q": string], encoding: URLEncoding.queryString)
//        case .addComment(_, let body):
//            return .requestParameters(parameters: ["body": body], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .register, .login:
            return ["Content-type": "application/json"]
        case .refresh(let refreshToken):
            return ["Authorization": "Bearer + \(refreshToken)"]
        default:
            return nil
//            let token = StorageManager.shared.readUser() == nil ? "" : StorageManager.shared.readUser()!.token
//            return ["Authorization": "Bearer " + token]
        }
    }
    
    public var sampleData: Data {
        switch self {
//        case .clubDetail:
//            return stub("ClubDetail")
        default:
            return Data()
        }
    }
    
    func stub(_ filename: String) -> Data! {
        let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let path = bundle?.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    // HTTP code가 200에서 299사이인 경우 요청이 성공한 것으로 간주된다.
    public var validationType: ValidationType {
        return .successCodes
    }
}