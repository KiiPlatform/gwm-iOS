import ThingIFSDK

typealias ColorRGB = (Int8,Int8,Int8)
//TODO: implementation
struct LightState {
    var power : Bool
    var brightness : Int = 0
    var color : ColorRGB = (255,255,255)
    var colorTemperature = 0

}
