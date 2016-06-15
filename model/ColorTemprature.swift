
private let _actionName = "SetColorTemprature"

struct SetColorTempratureAction : NamedAction{
    var colorTemperature = 0
    func actionName() -> String {return _actionName}
}
struct SetColorTempratureActionResult : NamedAction{
    func actionName() -> String {return _actionName}
}
