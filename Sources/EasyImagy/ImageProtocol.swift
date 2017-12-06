public protocol ImageProtocol : Sequence {
    associatedtype Pixel = Iterator.Element
    
    init(width: Int, height: Int, pixels: [Pixel])
    
    var width: Int { get }
    var height: Int { get }
    
    var xRange: CountableRange<Int> { get }
    var yRange: CountableRange<Int> { get }

    subscript(x: Int, y: Int) -> Pixel { get set }

    subscript(xRange: CountableRange<Int>, yRange: CountableRange<Int>) -> ImageSlice<Pixel> { get }
    subscript<R1: RangeExpression, R2: RangeExpression>(xRange: R1, yRange: R2) -> ImageSlice<Pixel> where R1.Bound == Int, R2.Bound == Int { get }
    subscript<R1: RangeExpression>(xRange: R1, yRange: UnboundedRange) -> ImageSlice<Pixel> where R1.Bound == Int { get }
    subscript<R2: RangeExpression>(xRange: UnboundedRange, yRange: R2) -> ImageSlice<Pixel> where R2.Bound == Int { get }
    subscript(xRange: UnboundedRange, yRange: UnboundedRange) -> ImageSlice<Pixel> { get }
}

extension ImageProtocol {
    public var width: Int {
        return xRange.count
    }
    
    public var height: Int {
        return yRange.count
    }
    
    public subscript<R1: RangeExpression, R2: RangeExpression>(xRange: R1, yRange: R2) -> ImageSlice<Pixel> where R1.Bound == Int, R2.Bound == Int {
        return self[countableRange(from: xRange, relativeTo: self.xRange), countableRange(from: yRange, relativeTo: self.yRange)]
    }
    
    public subscript<R1: RangeExpression>(xRange: R1, yRange: UnboundedRange) -> ImageSlice<Pixel> where R1.Bound == Int {
        return self[countableRange(from: xRange, relativeTo: self.xRange), self.yRange]
    }
    
    public subscript<R2: RangeExpression>(xRange: UnboundedRange, yRange: R2) -> ImageSlice<Pixel> where R2.Bound == Int {
        return self[self.xRange, countableRange(from: yRange, relativeTo: self.yRange)]
    }
    
    public subscript(xRange: UnboundedRange, yRange: UnboundedRange) -> ImageSlice<Pixel> {
        return self[self.xRange, self.yRange]
    }
}

extension ImageProtocol {
    public init() {
        self.init(width: 0, height: 0, pixels: [])
    }
    
    public init(pixel: Pixel) {
        self.init(width: 1, height: 1, pixel: pixel)
    }
    
    public init(width: Int, height: Int, pixel: Pixel) {
        self.init(width: width, height: height, pixels: [Pixel](repeating: pixel, count: width * height))
    }
    
    public init<S: Sequence>(width: Int, height: Int, pixels: S) where S.Element == Pixel {
        self.init(width: width, height: height, pixels: Array(pixels))
    }

    public var count: Int {
        return width * height
    }
}