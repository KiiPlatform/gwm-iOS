//TODO: implementation
private let _actionName = "SetColor"
struct SetColorAction : NamedAction{
    var color : ColorRGB
    func actionName() -> String {return _actionName}
}
struct SetColorActionResult : NamedAction{
    func actionName() -> String {return _actionName}
}
