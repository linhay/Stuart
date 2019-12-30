import Foundation
import ObjectiveC.runtime

struct OBJC {
    
    struct Protocol2 {
        
    }
    
    struct Property {
        let value: objc_property_t
        
        init(value: objc_property_t) {
            self.value = value
        }
        
    }
    
    struct Method {
        
        let pointer: OpaquePointer

        let argTypes: [Int]
        
        init(value: OpaquePointer) {
            self.pointer = value
            self.argTypes = []
        }
        
    }

    /// 实例
    struct Object {
        
        let value: AnyObject
        let type: Class
        
        init(value: AnyObject, type: Class) {
            self.value = value
            self.type = type
        }
        
    }

    /// 类型
    struct Class {

        /// 类型实例
        var type: AnyClass
        /// 类型名
        var name: String

        var bundle: Bundle

        init(type: AnyClass) {
            self.type = type
            self.name = String(cString: class_getName(type))
            self.bundle = Bundle(for: type)
        }
        
        init?(name: String, bundle: Bundle = Bundle.main) {
            self.name = name
            self.bundle = bundle

            let namespace = bundle.infoDictionary?["CFBundleExecutable"] as? String ?? ""
            if let type = NSClassFromString(name) {
                self.type = type
            } else if let type = NSClassFromString("\(namespace).\(name)") {
                self.type = type
            } else {
                return nil
            }
        }
        
        init?(name: UnsafePointer<Int8>, bundle: Bundle = Bundle.main) {
            let name = String(cString: name)
            self.init(name: name, bundle: bundle)
        }
        
    }

}

// MARK: - static
extension OBJC.Class {

    /// 加载动态库
    /// - Parameter path: 动态库路径
    @discardableResult
    static func load(_ path: String) -> Bool {
        guard let bundle = Bundle(path: path) else {
            return false
        }

        if bundle.isLoaded {
            return true
        }

        return bundle.load()
    }

}

// MARK: - func
extension OBJC.Class {

    /// 元类
    var metaClass: OBJC.Class? {
        guard let type = objc_getMetaClass(name) as? AnyClass else {
            return nil
        }
        return OBJC.Class(type: type)
    }
    
    /// 初始化实例
    func new() -> OBJC.Object? {
        guard let objc = (type as? NSObject.Type)?.perform(Selector("new"))?.takeRetainedValue() else {
            return nil
        }

        return OBJC.Object(value: objc, type: self)
    }

}

// MARK: - CustomStringConvertible
extension OBJC.Class: CustomStringConvertible {

    var description: String { return self.name }

}

// MARK: - CustomStringConvertible
extension OBJC.Method: CustomStringConvertible {

    var description: String { return method_getName(pointer).description }

}



extension OBJC.Class {

    /// 获取方法列表
      ///
      /// - Parameter classType: 所属类型
      /// - Returns: 方法列表
      var methods: [OBJC.Method] {
          return get_list(close: { class_copyMethodList(type, &$0) }, format: { OBJC.Method(value: $0) })
      }

      /// 获取属性列表
      ///
      /// - Parameter classType: 所属类型
      /// - Returns: 属性列表
      var properties: [OBJC.Property] {
          return get_list(close: { class_copyPropertyList(type, &$0) }, format: { OBJC.Property(value: $0) })
      }

      /// 获取协议列表
      ///
      /// - Parameter classType: 所属类型
      /// - Returns: 协议列表
      var protocols: [Protocol] {
          return get_list(close: { class_copyProtocolList(type, &$0) }, format: { $0 })
      }

      /// 成员变量列表
      ///
      /// - Parameter classType: 类型
      /// - Returns: 成员变量
      var ivars: [Ivar] {
          return get_list(close: { class_copyIvarList(type, &$0) }, format: { $0 })
      }

}

func get_list<T,U>(close: ( _ outcount: inout UInt32) -> AutoreleasingUnsafeMutablePointer<T>?, format: (T) -> U) -> [U] {
    var outcount: UInt32 = 0
    var list = [U]()
    guard let methods = close(&outcount) else { return [] }
    for index in 0..<Int(outcount) {
        list.append(format(methods[index]))
    }
    return list
}

func get_list<T,U>(close: ( _ outcount: inout UInt32) -> UnsafeMutablePointer<T>?, format: (T) -> U) -> [U] {
    var outcount: UInt32 = 0
    var list = [U]()
    guard let methods = close(&outcount) else { return [] }
    for index in 0..<numericCast(outcount) {
        list.append(format(methods[index]))
    }
    free(methods)
    return list
}
