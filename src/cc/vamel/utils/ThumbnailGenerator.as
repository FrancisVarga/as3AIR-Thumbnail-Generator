package cc.vamel.utils
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.system.System;
	import flash.utils.ByteArray;

	public final class ThumbnailGenerator
	{
		

		
		//set the compressions of the files here
		private static const COMPRESSION : uint = 80;
		
		//here is the jpeg encoder for encoding the jpeg that was loaded
		//private var encoder = new JPEGEncoder(COMPRESSION);
		
		//Don't forget to change this uint if when u create than more 2 files
		private static const FILES_TO_CREATE:uint=2;
		
		private var realHeight : uint=0;
		private var realWidth : uint=0;
		private var callBackFunction=null;
		private var outputFile : File = null;
		private var byteArrayFromOriginalFile:*;
		
		private var jpegEncoder: Object = AlchemyJPEG.instance().encoder;
		private var createdFilesIndex:uint=0;
		private var _loader:Object;
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DELETE ALL OBJ AFTER CREATION COMPLETE
		private var bmp = null;
		private var bmpd = null;
		private var encoder = null;
		private var img = null;
		private var matrix : Matrix = null;
		private var ratio = 0;
		private var outputHeight = 0;
		private var outputWidth = 0;
		private var outputByteArray: ByteArray = new ByteArray();
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DELETE ALL OBJ AFTER CREATION COMPLETE
		
		[Bindable]
		public var saveToFolder : File = null;
		
		//the callback function need a object as parameters
		public function ThumbnailGenerator(loader : Object, width:int, height:int, $callBackFunction : Function = null)
		{			
			
			this.saveToFolder = saveToFolder;
			
			trace("++++++++++++++++++++++++++++++++++++++++++++++++++")
			trace("Generate Thumbnail - Width: "+width+" Height: "+ height);
			trace("++++++++++++++++++++++++++++++++++++++++++++++++++")
			
			_loader = loader; 
			
			if($callBackFunction)
				callBackFunction = $callBackFunction;
			
			byteArrayFromOriginalFile = loader.bytes;
			
			realHeight = loader.height;	
			realWidth = loader.width;
			
			
			if( realWidth > realHeight )
			{
				
				outputWidth = width;
				outputHeight = Math.round( ( width / realWidth ) * realHeight );
				ratio = width / realWidth;
				
			} else {
				
				outputHeight = height;
				outputWidth = Math.round( ( height / realHeight ) * realWidth );
				ratio = height / realHeight;		
				
			}
			
			matrix = new Matrix();
			matrix.scale( ratio, ratio );		
			
			bmpd = new BitmapData( outputWidth, outputHeight );	
			
			bmpd.draw( _loader.content.bitmapData, matrix, null, null, null, true );
			byteArrayFromOriginalFile = bmpd.getPixels( bmpd.rect );
			byteArrayFromOriginalFile.position = 0;
			
			//This is the function what encode the JPEG file
			jpegEncoder.encodeAsync( compressFinished, byteArrayFromOriginalFile, outputByteArray, bmpd.width, bmpd.height, COMPRESSION );
			
		}
	
		//this function will wirte the thumbnails
		private function compressFinished( compressedByteArray: ByteArray ):void {
			var stream = null;
			
			stream = new FileStream();
			stream.addEventListener(Event.COMPLETE, creationComplete);
			
			//outputFile = File.applicationDirectory.resolvePath("temp/thumbs/"+(Math.random()*10000000).toFixed(0) + '.jpg');			
			outputFile = File.desktopDirectory.resolvePath("Vamel Thumbnail Generator/Created Thumbnail/" +(Math.random()*10000000).toFixed(0) + '.jpg');
			stream.open( outputFile, FileMode.WRITE );
			stream.writeBytes( compressedByteArray, 0, 0 );
			
			stream.close();				
			creationComplete();
			
		}
		
		
		private function creationComplete():void{
			createdFilesIndex++;
			if(callBackFunction){
				callBackFunction(outputFile);
			}
			else{
				trace('Files created but no callback function was created');	
			}
			
			clearAllObjects();
			
		}
		
		//this function clear all objects and invoke the garbage collector
		private function clearAllObjects():void{		
			outputFile = null;
			byteArrayFromOriginalFile = null;
			jpegEncoder = null;
			_loader = null;
			bmp = null;
			bmpd =null;
			encoder = null;
			img = null;
			matrix = null;
			ratio = null;
			outputHeight = null;
			outputWidth = null;
			outputByteArray = null;
			 
			System.gc();
		}
		
	}
}