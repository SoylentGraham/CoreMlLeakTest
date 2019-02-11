#import <Cocoa/Cocoa.h>
#import  "SsdMobilenet.h"
#include <string>
#include <iostream>


uint8_t ImageBytes[300*300*4];

void PixelReleaseCallback(void *releaseRefCon, const void *baseAddress)
{
	//std::Debug << __func__ << std::endl;
	
	if ( releaseRefCon )
	{
		//	this page says we need to release
		//	http://codefromabove.com/2015/01/av-foundation-saving-a-sequence-of-raw-rgb-frames-to-a-movie/
		CFDataRef bufferData = (CFDataRef)releaseRefCon;
		CFRelease(bufferData);
	}
}

CVPixelBufferRef MakePixelBuffer(size_t Width,size_t Height)
{
	auto* Pixels = ImageBytes;
	auto BytesPerRow = Width * 4;
	CFAllocatorRef PixelBufferAllocator = nullptr;
	OSType PixelFormatType = kCVPixelFormatType_32BGRA;
	CVPixelBufferRef PixelBuffer = nullptr;
	CFDictionaryRef PixelBufferAttributes = nullptr;
	void* ReleaseContext = nullptr;
	auto Result = CVPixelBufferCreateWithBytes( PixelBufferAllocator, Width, Height, PixelFormatType, Pixels, BytesPerRow, PixelReleaseCallback, ReleaseContext, PixelBufferAttributes, &PixelBuffer );
	
	return PixelBuffer;
}


NSString* StringToNSString(const std::string& String)
{
	NSString* MacString = [NSString stringWithCString:String.c_str() encoding:[NSString defaultCStringEncoding]];
	return MacString;
}

std::string NSStringToString(NSString* String)
{
	if ( !String )
		return "<null>";
	return std::string([String UTF8String]);
}


int main(int argc, const char * argv[])
{
	auto* Pixels = MakePixelBuffer(300,300);
	
	SsdMobilenet* ssd = nullptr;
	
	for ( auto i=0;	i<10000;	i++ )
	{
		if ( !ssd )
		{
			ssd = [[SsdMobilenet alloc] init];
		}
		
		NSError* Error = nullptr;
		auto* Output = [ssd predictionFromPreprocessor__sub__0:Pixels error:&Error];
		
		if ( Error )
		{
			auto* ErrorNs = [Error description];
			auto ErrorStr = NSStringToString( ErrorNs );
			std::cout << "#" << i << " error: " << ErrorStr << std::endl;
		}
		else if ( !Output )
		{
			std::cout << "#" << i << " got null output." << std::endl;
		}
		else
		{
			std::cout << "#" << i << " got output." << std::endl;
		}
	}
	
	CVBufferRelease(Pixels);

	auto Result = NSApplicationMain(argc, argv);

	return Result;
}
