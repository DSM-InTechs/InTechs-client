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
    case updateMypage(name: String, imageData: Data)
    case updateMyActive(isActive: Bool)
    case deleteUser
    case getMyProjects
    
    // MARK: - Project
    case dashboard(id: Int)
    case createProject(name: String, imageData: Data)
    case deleteProject(id: Int)
    case updateProject(id: Int, name: String, imageData: Data)
    
    case joinProject(id: Int)
    case exitProject(id: Int)
    case getProjectInfo(id: Int)
    case getProjectMembers(id: Int)
    
    // MARK: - Issue
    case getIssues(projectId: Int, tags: [String]?, states: [String]?, users: [String]?)
    case getIssueUsers(projectId: Int)
    case getIssueTags(projectId: Int)
    case createIssue(projectId: Int, title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?)
    case deleteIssue(projectId: Int, issueId: String)
    case updateIssue(projectId: Int, issueId: String, title: String, body: String?, date: String?, progress: Int?, state: String?, users: [String]?, tags: [String]?)
    case getDetailIssue(projectId: Int, issueId: String)
    case addComment(issueId: String, content: String)
    
    // MARK: - Calendar
    case getCalendar(projectId: Int, year: String, month: String, tags: [String]?, states: [String]?, users: [String]?)
    
    // MARK: - Other User
    case getUser(email: String)
    
    // MARK: - Chat
    case getChatList(projectId: Int)
    case getMessageList(channelId: Int, page: Int)
    case getChannelUsers(channelId: Int)
    case addChannelUser(channelId: Int, email: String)
    
    case createChannel(projectId: Int, name: String)
    case updateChannel(channelId: Int, name: String)
    case deleteChannel(channelId: Int)
    case exitChannel(channelId: Int)
    
}

extension InTechsAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://localhost:8009")!
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
        case .deleteUser:
            return "/user"
        case .getMyProjects:
            return "/user/project"
            
            // MARK: - Project
        case .dashboard(let id):
            return "/project/\(id)/dashboard"
        case .createProject(_, _):
            return "/project"
        case .deleteProject(let id):
            return "/project/\(id)"
        case .updateProject(let id, _, _):
            return "/project/\(id)"
        case .joinProject(let id):
            return "/project/\(id)/user"
        case .exitProject(let id):
            return "/project/\(id)/user"
        case .getProjectInfo(let id):
            return "/project/\(id)"
        case .getProjectMembers(let id):
            return "/project/\(id)/user"
            
            // MARK: - Issue
        case .getIssues(let projectId, _, _, _):
            return "/project/\(projectId)/issue/filter"
        case .getIssueUsers(let projectId):
            return "/project/\(projectId)/tag/1"
        case .getIssueTags(let projectId):
            return "/project/\(projectId)/tag/2"
        case .createIssue(let projectId, _, _, _, _, _, _, _):
            return "/project/\(projectId)/issue"
        case .deleteIssue(let projectId, let issueId):
            return "/project/\(projectId)/issue/\(issueId)"
        case .updateIssue(_, let issueId, _, _, _, _, _, _, _):
            return "/project/issue/\(issueId)"
        case .getDetailIssue(let projectId, let issueId):
            return "/project/\(projectId)/issue/\(issueId)"
        case .addComment(let issueId, _):
            return "/project/issue/\(issueId)/comment"
            
            // MARK: - Calendar
        case .getCalendar(let projectId, _, _, _, _, _):
            return "/project/\(projectId)/calendar"
            
            // MARK: - Other User
        case .getUser(let email):
            return "/\(email)"
            
            // MARK: - Chat
        case .getChatList(_):
            return "channel/channels"
        case .getMessageList(let id, _):
            return "/channel/\(id)/chat"
        case .getChannelUsers(let channelId):
            return "/channel/\(channelId)/users"
        case let .addChannelUser(channelId, email):
            return "/channel/\(channelId)/\(email)"
            
        case .createChannel(let projectId, _):
            return "/channel/\(projectId)"
        case .updateChannel(let channelId, _):
            return "/channel/\(channelId)"
        case .deleteChannel(let channelId):
            return "/channel/\(channelId)"
        case .exitChannel(let channelId):
            return "/channel/\(channelId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .register, .login, .refresh, .createProject, .joinProject, .createIssue, .getIssues, .addComment:
            return .post
        case .updateMypage, .updateMyActive, .updateProject, .updateIssue:
            return .patch
        case .deleteUser, .deleteProject, .exitProject, .deleteIssue:
            return .delete
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case let .register(name, email, password):
            return .requestParameters(parameters: ["name": name, "email": email, "password": password], encoding: JSONEncoding.default)
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case let .updateMypage(name, imageData):
            let data = MultipartFormData(provider: .data(imageData), name: "image", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            let nameData = MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name")
            let multipartData = [data, nameData]
            return .uploadMultipart(multipartData)
        case .updateMyActive(let isActive):
            return .requestParameters(parameters: ["isActive": isActive], encoding: JSONEncoding.default)
        case .getIssues(_, let tags, let states, let users):
            var paras: [String: Any] = [:]
            if tags != nil {
                paras["tags"] = tags!
            }
            if states != nil {
                paras["states"] = states!
            }
            if users != nil {
                paras["users"] = users!
            }
            return .requestParameters(parameters: paras, encoding: JSONEncoding.default)
        case .createIssue(_, let  title, let body, let date, let progress, let state, let users, let tags):
            var paras: [String: Any] = [:]
            paras["title"] = title
            paras["content"] = body ?? NSNull()
            paras["end_date"] = date ?? NSNull()
            paras["progress"] = progress ?? NSNull()
            paras["state"] = state ?? NSNull()
            paras["users"] = users ?? NSNull()
            paras["tags"] = tags ?? NSNull()
            return .requestParameters(parameters: paras, encoding: JSONEncoding.default)
        case .updateIssue(_, _, let  title, let body, let date, let progress, let state, let users, let tags):
            var paras: [String: Any] = [:]
            paras["title"] = title
            paras["content"] = body ?? NSNull()
            paras["end_date"] = date ?? NSNull()
            paras["progress"] = progress ?? NSNull()
            paras["state"] = state ?? NSNull()
            paras["users"] = users ?? NSNull()
            paras["tags"] = tags ?? NSNull()
            return .requestParameters(parameters: paras, encoding: JSONEncoding.default)
        case let .createProject(name, imageData):
            let data = MultipartFormData(provider: .data(imageData), name: "image", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            let nameData = MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name")
            let multipartData = [data, nameData]
            return .uploadMultipart(multipartData)
        case let .updateProject(_, name, imageData):
            let data = MultipartFormData(provider: .data(imageData), name: "image", fileName: "\(name).jpeg", mimeType: "image/jpeg")
            let nameData = MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name")
            let multipartData = [data, nameData]
            return .uploadMultipart(multipartData)
        case .getCalendar(_, let year, let month, let tags, let states, let users):
            var paras: [String: Any] = ["year": year, "month": month]
            if tags != nil {
                paras["tags"] = tags!
            }
            if states != nil {
                paras["states"] = states!
            }
            if users != nil {
                paras["users"] = users!
            }
            return .requestParameters(parameters: paras, encoding: URLEncoding.default)
        case .addComment(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .getMessageList(_, let page):
            return .requestParameters(parameters: ["page": page, "size": 20], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .register, .login:
            return nil
        case .refresh(let refreshToken):
            return ["refresh_token": refreshToken]
        default:
            @UserDefault(key: "accessToken", defaultValue: "")
            var accessToken: String
            
            return ["Authorization": "Bearer \(accessToken)"]
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
