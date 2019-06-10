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
var d_8to16table = UnsafeMutablePointer<CUnsignedShort>.allocate(capacity: 256)
@_cdecl("GET_SWIFT_d_8to16table")
func GET_SWIFT_d_8to16table() -> UnsafeMutablePointer<CUnsignedShort>
{
    return d_8to16table;
}

var d_8to24table:UnsafeMutablePointer<Int>! = nil;

@_cdecl("VID_SetSize")
func VID_SetSize(width:Int, height:Int)
{
    D_FlushCaches();
    
    if (surfcache != nil)
    {
        surfcache.deallocate();
    }
    
    if (zbuffer != nil)
    {
        zbuffer.deallocate();
    }
    
    if (vid_buffer != nil)
    {
        vid_buffer.deallocate();
    }
    
    vid_screenWidth = width;
    
    if (vid_screenWidth < 320)
    {
        vid_screenWidth = 320;
    }
    
    if (vid_screenWidth > 1280)
    {
        vid_screenWidth = 1280;
    }
    
    vid_screenHeight = height;
    
    if (vid_screenHeight < 200)
    {
        vid_screenHeight = 200;
    }
    
    if (vid_screenHeight > 960)
    {
        vid_screenHeight = 960;
    }
    
    if (vid_screenHeight > vid_screenWidth)
    {
        vid_screenHeight = vid_screenWidth;
    }
    
    vid_buffer = UnsafeMutablePointer<byte>.allocate(capacity: vid_screenWidth * vid_screenHeight)
    
    zbuffer = UnsafeMutablePointer<CShort>.allocate(capacity: vid_screenWidth * vid_screenHeight)
    
    vid.conwidth = UInt32(vid_screenWidth)
    vid.width = UInt32(vid_screenWidth)
    
    vid.conheight = UInt32(vid_screenHeight)
    
    vid.height = UInt32(vid_screenHeight)
    vid.aspect = (Float(vid.height) / Float(vid.width)) * (320.0 / 240.0)
    
    vid.buffer = vid_buffer;
    vid.conbuffer = vid_buffer;

    vid.rowbytes = UInt32(vid_screenWidth);
    vid.conrowbytes = Int32(vid_screenWidth);
    
    d_pzbuffer = zbuffer;
    
    let surfcachesize = D_SurfaceCacheForRes(Int32(vid_screenWidth), Int32(vid_screenHeight))
    
    surfcache = UnsafeMutablePointer<byte>.allocate(capacity:Int(surfcachesize))
    
    D_InitCaches (surfcache, surfcachesize);
    
    vid.recalc_refdef = 1;
}

@_cdecl("VID_SetPalette")
func VID_SetPalette(palette:UnsafeMutablePointer<CUnsignedChar>!)
{
    var pal:UnsafeMutablePointer<byte>! = palette
    let table:UnsafeMutablePointer<Int>! = d_8to24table
    
    var r:UInt, g:UInt, b:UInt
    var v:UInt
  
    //
    // 8 8 8 encoding
    //
     for i in 0 ... 255 {
        r = UInt(pal[0]);
        g = UInt(pal[1]);
        b = UInt(pal[2]);
        pal += 3;
        
        v = (255 << 24) | (b << 16) | (g << 8) | r;
        table[i] = Int(v);
    }
    d_8to24table[255] &= 0xFFFFFF;    // 255 is transparent
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
    
    d_pzbuffer = zbuffer;
    
    let surfcachesize = D_SurfaceCacheForRes(Int32(vid_screenWidth), Int32(vid_screenHeight))
    
    surfcache = UnsafeMutablePointer<byte>.allocate(capacity:Int(surfcachesize))
    
    D_InitCaches(surfcache, surfcachesize)
    
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

