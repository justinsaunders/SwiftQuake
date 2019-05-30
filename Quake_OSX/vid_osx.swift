//
//  vid_osx.swift
//  Quake_OSX
//
//  Created by Justin on 5/29/19.
//

import Foundation

struct VID
{
    var screenWidth:Int32 = 320
    var screenHeight:Int32 = 200
    
    var glvr_mode:Int32 = 0
    
    var buffer:UnsafeMutablePointer<byte>! = nil;
    var zbuffer:UnsafeMutablePointer<CShort>! = nil;
    var surfcache:UnsafeMutablePointer<byte>! = nil;
    
    var d_8to16table:Array<ushort> = Array(repeating: 0, count: 256)
    var d_8to24table:UnsafeMutablePointer<Int32>! = nil;
    
    func SetSize(width:Int32, height:Int32)
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
        
    }
    
    func Shutdown()
    {
        
    }
    
    //void VID_Update (vrect_t *rects) {}
    //void D_BeginDirectRect (int x, int y, byte *pbitmap, int width, int height)
    //void D_EndDirectRect (int x, int y, int width, int height)
}
