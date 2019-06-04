//
//  vid_osx.swift
//  Quake_OSX
//
//  Created by Justin on 5/29/19.
//

import Foundation

class VID
{
    var screenWidth:Int = 320
    var screenHeight:Int = 200
    
    var glvr_mode:Int = 0
    
    var buffer:UnsafeMutablePointer<byte>! = nil;
    var zbuffer:UnsafeMutablePointer<CShort>! = nil;
    var surfcache:UnsafeMutablePointer<byte>! = nil;
    
    var d_8to16table:Array<ushort> = Array(repeating: 0, count: 256)
    var d_8to24table:UnsafeMutablePointer<Int>! = nil;
    
    func SetSize(width:Int, height:Int)
    {
        
    }
    
    func SetPalette(palette:UnsafeMutablePointer<CUnsignedChar>!)
    {
        
    }
    
    func ShiftPalette(palette:UnsafeMutablePointer<CUnsignedChar>!)
    {
        self.SetPalette(palette: palette)
    }
    
    func Init(palette:UnsafeMutablePointer<CUnsignedChar>!)
    {
        buffer =  UnsafeMutablePointer<byte>.allocate(capacity: screenWidth * screenHeight)
        zbuffer = UnsafeMutablePointer<CShort>.allocate(capacity: screenWidth * screenHeight)
        d_8to24table = UnsafeMutablePointer<Int>.allocate(capacity: 256)
        
        vid.maxwarpwidth = WARP_WIDTH
        vid.maxwarpheight = WARP_HEIGHT
        vid.conwidth = UInt32(vid_screenWidth)
        vid.width = UInt32(vid_screenWidth)
        vid.conheight = UInt32(vid_screenHeight)
        vid.height = UInt32(vid_screenHeight)
        vid.aspect = (Float(vid.height) / Float(vid.width)) * (320.0 / 240.0)
        vid.numpages = 1
        vid.colormap = host_colormap
        let tempColorMapVoid = UnsafeMutableRawPointer(vid.colormap) + 2048 * MemoryLayout<Int>.size
        let value:Int32 = tempColorMapVoid.load(as: Int32.self)
        
        typealias LittleLongFunc = (@convention(c)(Int32) -> Int32)
        let f:LittleLongFunc = LittleLong
        vid.fullbright = 256 - f(value)
    

    }
    
    func Shutdown()
    {
        
    }
    
    //void VID_Update (vrect_t *rects) {}
    //void D_BeginDirectRect (int x, int y, byte *pbitmap, int width, int height)
    //void D_EndDirectRect (int x, int y, int width, int height)
}
