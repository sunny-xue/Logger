package com.logger.imple
{
	/**
	 *
	 * @author sunny.xue
	 * 
	 */	
	import com.logger.interfaces.ILogger;
	
	import deng.fzip.FZip;
	
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FileLoggerImpl implements ILogger
	{
		private var fs:FileStream;//文件流 负责读写
		
		private var logFile:File;	//日志文件
		
		private var filePrefix:String;	//日志文件名
		
		private const DIR:String = "logs";//存放日志文件的文件夹
		
		private const MAX_SIZE:uint = 5 * 1024 * 1024;//日志文件最大 5M
		
		private const EXT:String = ".txt";
		
		public function FileLoggerImpl()
		{
			var today:Date = new Date();
			
			filePrefix = DIR + File.separator + "log_" + (today.month + 1) + "_" + today.date + "_" + today.fullYear;
			
			logFile = File.applicationStorageDirectory.resolvePath(filePrefix + EXT);
			
			if( logFile.exists && logFile.size >= MAX_SIZE )
			{
				logFile = getFile();
			}
			
			fs = new FileStream();
			fs.openAsync(logFile, FileMode.APPEND);
			
			//Clean logs at 1 or 16
			if( today.date == 1 || today.date == 16 )
			{
				cleanLogs();
			}
			
			info("-----------------------");
			info("start up at " + today.toString());
		}
		
		public function debug(s:String):void
		{
			writeLine(s);
		}
		
		public function info(s:String):void
		{
			writeLine(s);
		}
		
		public function warn(s:String):void
		{
			writeLine(s);
		}
		
		public function error(s:String):void
		{
			writeLine(s);
		}
		
		public function fatal(s:String):void
		{
			writeLine(s);
		}
		
		public function export(path:String):Boolean
		{
			var dir:File = File.applicationStorageDirectory.resolvePath(DIR);
			if( dir.exists == false )
			{
				return false;
			}
			//create zip archive
			var zipOut:FZip = new FZip();
			
			var f:File;
			var fs:FileStream;
			
			var files:Array = dir.getDirectoryListing();
			
			var ba:ByteArray;
			
			for( var i:uint = 0,len:uint = files.length; i < len; i++)
			{
				f = files[i] as File;
				
				if( f == null || f.isDirectory ) continue;
				
				fs = new FileStream();
				fs.open(f, FileMode.READ);
				ba = new ByteArray();
				fs.readBytes(ba);
				
				ba.position = 0;
				zipOut.addFile(DIR + "/" + f.name, ba);
				
				fs.close();
				fs = null;
				f = null;
			}
			// end the zip
			zipOut.close();
			
			// access the zip data
			var zipData:ByteArray = new ByteArray();
			zipOut.serialize(zipData);
			
			var exportFile:File = new File(path);
			var exportFS:FileStream = new FileStream();
			exportFS.open(exportFile, FileMode.WRITE);
			exportFS.writeBytes(zipData, 0);
			exportFS.close();
			
			zipData.clear();
			zipData = null;
			zipOut = null;
			
			return true;
		}
		
		private function cleanLogs():void
		{
			var dir:File = File.applicationStorageDirectory.resolvePath(DIR);
			
			if( dir.exists )
			{
				dir.addEventListener(FileListEvent.DIRECTORY_LISTING, onFileListResult);
				dir.getDirectoryListingAsync();
			}
		}
		
		private function onFileListResult(e:FileListEvent):void
		{
			e.target.removeEventListener(FileListEvent.DIRECTORY_LISTING, onFileListResult);
			
			var lastDay:Date = new Date();
			//In 15 days
			lastDay.setDate(lastDay.date - 15);
			
			var f:File;
			var files:Array = e.files;
			for( var i:uint = 0,len:uint = files.length; i<len; i++)
			{
				f = files[i] as File;
				if( f.creationDate.time < lastDay.time )
				{
					f.deleteFileAsync();
				}
			}
		}
		
		private function writeLine(s:String):void
		{
			trace(s);
			fs.writeUTFBytes(s+"\n");
			
			//If log file size exceed 5M
			if( logFile.exists && logFile.size >= MAX_SIZE )
			{
				fs.close();
				fs = null;
				logFile = null;
				
				logFile = getFile();
				
				fs = new FileStream();
				fs.openAsync(logFile, FileMode.APPEND);
			}
		}
		
		private function getFile():File
		{
			var f:File = File.applicationStorageDirectory.resolvePath(filePrefix + EXT);
			
			var fileName:String;			
			var n:int = 1;
			
			while( f.exists && f.size >= MAX_SIZE )
			{
				fileName = filePrefix + "_" + n + EXT;
				f = File.applicationStorageDirectory.resolvePath(fileName);
				
				n++;
			}
			
			return f;
		}
		
		
	}
}