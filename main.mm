#import <Cocoa/Cocoa.h>
#import  "SsdMobilenet.h"
#include <string>
#include <iostream>


uint8_t ImageBytes[300*300*4];


CVPixelBufferRef MakePixelBuffer(size_t Width,size_t Height)
{
	auto* Pixels = ImageBytes;
	auto BytesPerRow = Width * 4;
	CVPixelBufferRef PixelBuffer = nullptr;
	/*auto Result = */CVPixelBufferCreateWithBytes( nullptr, Width, Height, kCVPixelFormatType_32BGRA, Pixels, BytesPerRow, nullptr, nullptr, nullptr, &PixelBuffer );
	return PixelBuffer;
}

int main(int argc, const char * argv[])
{
	auto* Pixels = MakePixelBuffer(300,300);
	
	SsdMobilenet* ssd = [[SsdMobilenet alloc] init];
	//SsdMobilenet* ssd = nullptr;

	for ( auto i=0;	i<10000;	i++ )
	{
		NSAutoreleasePool* pool= [[NSAutoreleasePool alloc]init];
		if ( !ssd )
		{
			ssd = [[SsdMobilenet alloc] init];
		}
		auto* Output = [ssd predictionFromPreprocessor__sub__0:Pixels error:nullptr];
		//[Output release];
		//[ssd release];
		//ssd = nullptr;
		[pool drain];
	}
	return 0;
}
