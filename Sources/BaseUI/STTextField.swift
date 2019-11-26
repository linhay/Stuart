//
//  STTextField.swift
//  Stem
//
//  Created by 林翰 on 2019/11/1.
//

import UIKit

class STTextField: UITextField {


}

public struct LimitInput {
  // 字数限制
//    public static var wordLimit: Int = Int
    // 文本替换 保证光标位置
//  public static var replaces: [LimitInputReplace] = []
//  // 判断输入是否合法的
//  public static var matchs: [LimitInputMatch] = []
//  // 菜单禁用项
//  public static var disables: [LimitInputDisableState] = []
  // 文字超出字符限制事件
  public static var overWordLimitEvent: ((_ text: String)->())? = nil
}

class STTextFieldManager: NSObject, UITextFieldDelegate {

    init(textField: UITextField) {
        super.init()
        textField.delegate = self
    }

}

// MARK: - UITextFieldDelegate
extension STTextFieldManager {

    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    @available(iOS 2.0, *)
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    @available(iOS 2.0, *)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    @available(iOS 2.0, *)
    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    @available(iOS 2.0, *)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {

    }

    @available(iOS 2.0, *)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

}
