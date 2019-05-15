//
//  BaseModel.swift
//  CathAssist
//
//  Created by yaojinhai on 2017/7/22.
//  Copyright © 2017年 CathAssist. All rights reserved.
//

import UIKit

enum CodeType: Int {
    case fail_code = 0
    case success_code = 200
    case un_authorization = 401 //"授权认证失败"
    case unbind_phone = 426 // "该账号未绑定小助手"
    case didRegisterPhone = 408 // "该手机号已经被注册"
    case already_bind = 429 //"该账号已经绑定小助手"
}

class BaseModel: NSObject {
    
    var errorCode: CodeType {
        guard let sCode = CodeType.init(rawValue: code) else {
            return .fail_code
        }
        return sCode;
    }
    var isSuccess: Bool {
        return errorCode == .success_code;
    }
    var code = 0;
    var message = "";
    var content: AnyObject!
    var contentList: [BaseModel]!
    
    private var anyCls: AnyClass!

    required override init() {
        super.init();
    }
    convenience init(dict: [String:Any]){
        self.init();
        configModel(dict: dict);
        setData();
    }
    convenience init(dictM: NSDictionary){
        self.init(dict: dictM as! [String : Any]);
        
    }
    
    convenience init(model: AnyClass,dict: Any){
        self.init();
        anyCls = model;
        configModel(dict: dict as! [String : Any]);
        setData();
    }
    
    
    convenience init(item: Any) {
        self.init(dict: item as! [String:Any]);
    }
    
    func setData() -> Void {
        
    }
    
    func autoSaveModel(key: String) -> Void {
        FileDataManager.saveData(data: modelDict, fileName: key);
    }
    
    class func modelFromDisk(cls: AnyClass,key: String) -> BaseModel? {
        
        if let modelDict = FileDataManager.readData(fileName: key) as? [String:Any],let modelCls = cls as? BibleContentModel.Type {
            let model = modelCls.init();
            model.configModel(dict: modelDict);
            return model;
        }
        return nil;
    }
    
    
  
    
    var modelDict: NSDictionary {
        
        var counts: UInt32 = 0;
        let propertis = class_copyPropertyList(classForCoder, &counts);
    
        let keyValueDict = NSMutableDictionary();
        for idx in 0..<Int(counts) {
            let property = propertis?[idx];
            if let pty = property_getAttributes(property) {
                let attribute = String(cString: pty);
                if attribute.contains("R") || attribute.contains("NSAttributedString") {
                    continue;
                }
            }
            let cName = property_getName(property);
            let name = String(cString: cName!);
            var value = self.value(forKey: name);
            if value == nil {
                value = self.value(forKeyPath: name);
            }
            
            guard let keyValue = value else{
                continue;
            }
            
            if let model = keyValue as? BaseModel{
                let dict = model.modelDict;
                if dict.count > 0 {
                    keyValueDict[name] = model.modelDict;
                }
                
            }else if (keyValue is String) || (keyValue is NSNumber){
                
                keyValueDict[name] = keyValue;
                
            }else if let list = keyValue as? NSArray{
                if let tempList = forArray(array: list) {
                    keyValueDict[name] = tempList;
                }
            }
        }
        
        return keyValueDict;
    }
    
    private func forArray(array: NSArray) -> NSArray? {
        if array.count == 0 {
            return nil;
        }
        let tempArray = NSMutableArray();
        for item in array {
            if let model = item as? BaseModel {
                let dict = model.modelDict;
                if dict.count > 0 {
                    tempArray.add(model.modelDict);
                }
            }else if let listArray = item as? NSArray {
                if let tempList = forArray(array: listArray) {
                    tempArray.addObjects(from: tempList as! [Any]);
                }
            }else if (item is String) || (item is NSNumber){
                tempArray.add(item);
            }
        }
        if tempArray.count > 0 {
            return tempArray;
        }
        return nil;
    }
    
    func configModel(dict: [String:Any]) -> Void {
        self.setValuesForKeys(dict);
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        guard let value = value else {
            return;
        }
        
        
        if key == "content"  {
            if let list = value as? NSArray {
                
                contentList = [BaseModel]();
                for item in list {
                    guard let cls = anyCls as? BaseModel.Type else{
                        return;
                    }
                    let model = cls.init();
                    model.configModel(dict: item as! [String : Any]);
                    model.setData();
                    contentList.append(model);
                }
                content = contentList as AnyObject;
                
            }else if let dict = value as? NSDictionary {
                
                if let cls = anyCls as? BaseModel.Type{
                    let model = cls.init();
                    model.configModel(dict: dict as! [String : Any]);
                    model.setData();
                    content = model as AnyObject;
                }
                
            }else if let strl = value as? String {
                
                content = strl as AnyObject;
            }
        }else if key == "code"{
            if let value = value as? Int{
                code = value;
            }
            
        }else {
            super.setValue(value, forKey: key);
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
