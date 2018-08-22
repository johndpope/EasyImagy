
func step(_ lhs:UInt8,_ rhs:UInt8)->Double{
    if lhs > rhs{
        return 1
    }else{
        return 0
    }
}

extension Image where Pixel == RGBA<UInt8> {
    
    public func OLPB()->[Double]{
        var histogram :[Double] = []
        for x in self.xRange{
            for y in self.yRange{
                let olbp = self.determineLocalBinaryPatternAt(x: x, y: y, y)
                histogram.append(olbp)
            }
        }
        return histogram
    }
    
    
    public func determineLocalBinaryPatternAt(x: Int, y: Int,_ type:Int)->Double{
        //Original LBP
        
        let centerIntensity = pixels[pixelIndexAt(x: x, y: y)].gray
        let bottomLeftIntensity = pixels[pixelIndexAt(x: x-1, y: y-1)].gray
        let topRightIntensity = pixels[pixelIndexAt(x: x+1, y: y+1)].gray
        let topLeftIntensity = pixels[pixelIndexAt(x: x-1, y: y+1)].gray
        let bottomRightIntensity = pixels[pixelIndexAt(x: x+1, y: y-1)].gray
        let leftIntensity = pixels[pixelIndexAt(x: x+1, y: y)].gray
        let rightIntensity = pixels[pixelIndexAt(x: x-1, y: y)].gray
        let bottomIntensity = pixels[pixelIndexAt(x: x, y: y-1)].gray
        let topIntensity = pixels[pixelIndexAt(x: x, y: y+1)].gray
        
        var byteTally = 1.0 / 255.0 * step(centerIntensity, topRightIntensity);
        byteTally += 2.0 / 255.0 * step(centerIntensity, topIntensity);
        byteTally += 4.0 / 255.0 * step(centerIntensity, topLeftIntensity);
        byteTally += 8.0 / 255.0 * step(centerIntensity, leftIntensity);
        byteTally += 16.0 / 255.0 * step(centerIntensity, bottomLeftIntensity);
        byteTally += 32.0 / 255.0 * step(centerIntensity, bottomIntensity);
        byteTally += 64.0 / 255.0 * step(centerIntensity, bottomRightIntensity);
        byteTally += 128.0 / 255.0 * step(centerIntensity, rightIntensity);
        
        return byteTally
    }
}
