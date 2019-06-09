//
//  vid_osx.swift
//  Quake_OSX
//
//  Created by Justin on 5/29/19.
//

import Foundation


var vid_screenWidth:Int = 320
var vid_screenHeight:Int = 200

var glvr_mode:Int = 0

var vid_buffer:UnsafeMutablePointer<byte>! = nil;
var zbuffer:UnsafeMutablePointer<CShort>! = nil;
var surfcache:UnsafeMutablePointer<byte>! = nil;

// Global variable exposed to C 
var d_8to16table = UnsafeMutablePointer<CShort>.allocate(capacity: 256)
@_cdecl("GET_d_8to16table")
func GET_d_8to16table() -> UnsafeMutablePointer<CShort>
{
    return d_8to16table;
}

var d_8to24table:UnsafeMutablePointer<Int>! = nil;

@_cdecl("VID_SetSize")
func VID_SetSize(width:Int, height:Int)
{
    
}

@_cdecl("VID_SetPalette")
func VID_SetPalette(palette:UnsafeMutablePointer<CUnsignedChar>!)
{
    
}

@_cdecl("VID_ShiftPalette")
func VID_ShiftPalette(palette:UnsafeMutablePointer<CUnsignedChar>!)
{
    VID_SetPalette(palette: palette)
}

 @_cdecl("VID_Init")
func VID_Init(palette:UnsafeMutablePointer<CUnsignedChar>!)
{
    vid_buffer =  UnsafeMutablePointer<byte>.allocate(capacity: vid_screenWidth * vid_screenHeight)
    zbuffer = UnsafeMutablePointer<CShort>.allocate(capacity: vid_screenWidth * vid_screenHeight)
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
    
    //   vid.fullbright = 256 - LittleLong (*((int *)vid.colormap + 2048));
    let tempColorMapVoid = UnsafeMutableRawPointer(vid.colormap) + 2048 * MemoryLayout<Int>.size
    let value:Int32 = tempColorMapVoid.load(as: Int32.self)
    
    typealias LittleLongFunc = (@convention(c)(Int32) -> Int32)
    let f:LittleLongFunc = LittleLong
    vid.fullbright = 256 - f(value)

    vid.buffer = vid_buffer;
    vid.conbuffer = vid_buffer;
    
    vid.rowbytes = UInt32(vid_screenWidth);
    vid.conrowbytes = Int32(vid_screenWidth);
    
    let surfecachesize = D_SurfaceCacheForRes(Int32(vid_screenWidth), Int32(vid_screenHeight))
    
    surfcache = UnsafeMutablePointer<byte>.allocate(capacity:Int(surfecachesize))
    
    D_InitCaches(surfcache, surfecachesize)
    
    VID_SetPalette(palette: palette)
}

@_cdecl("VID_Shutdown")
func VID_Shutdown()
{
    surfcache.deallocate();
    d_8to24table.deallocate();
    zbuffer.deallocate();
    zbuffer.deallocate();
}

//void VID_Update (vrect_t *rects) {}
//void D_BeginDirectRect (int x, int y, byte *pbitmap, int width, int height)
//void D_EndDirectRect (int x, int y, int width, int height)
//}

