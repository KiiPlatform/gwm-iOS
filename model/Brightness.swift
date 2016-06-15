import ThingIFSDK
protocol NamedAction{
    func actionName() -> String
}
private let _actionName = "SetBrightness"
final class SetBrightnessAction : NamedAction{
    var brightness : Int = 0
    func actionName() -> String {return _actionName}
}
struct SetBrightnessActionResult : NamedAction {
    func actionName() -> String {return _actionName}
}
