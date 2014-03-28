package com.logger.core
{
	/**
	 * @author sunny.xue
	 */	
	import com.logger.imple.FileLoggerImpl;
	import com.logger.interfaces.ILogger;
	
	import flash.filesystem.File;
	
	public class Logger
	{
		
		public static const NAME:String = "logger";
		
		/**
		 * Log level 
		 */		
		public static const LOG_DEBUG:uint = 5;
		
		public static const LOG_INFO:uint = 4;
		
		public static const LOG_WARN:uint = 3;
		
		public static const LOG_ERROR:uint = 2;		
		
		public static const LOG_FATAL:uint = 1;
		
		/**
		 * level value 
		 */		
		public static var currentLevel:uint = LOG_INFO;
		
		private static var logger:ILogger;
		private static function get $logger():ILogger
		{
			if( logger == null )
			{
				logger = new FileLoggerImpl();
			}
			
			return logger;
		}
		
		public static function setLevel(value:int):void
		{
			currentLevel = value;
		}
		
		/**
		 * The DEBUG Level designates fine-grained informational events that are most useful to debug an application.
		 *  
		 * @param rest
		 * 
		 */		
		public static function debug( ...rest ):void
		{
			if( currentLevel < LOG_DEBUG ) return;
			
			var s:String = "[ D ]" + rest.toString();
			
			$logger.debug(s);
		}
		
		/**
		 * The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.
		 *  
		 * @param rest
		 * 
		 */		
		public static function log( ...rest ):void
		{
			if( currentLevel < LOG_INFO ) return;
			
			var s:String = "[ I ]" + rest.toString();
			
			$logger.info(s);
		}
		
		/**
		 * The WARN level designates potentially harmful situations.
		 *  
		 * @param rest
		 * 
		 */		
		public static function warn( ...rest ):void
		{
			if( currentLevel < LOG_WARN ) return;
			
			var s:String = "[ W ]" + rest.toString();
			
			$logger.warn(s);
		}
		
		/**
		 * The ERROR level designates error events that might still allow the application to continue running.
		 *  
		 * @param rest
		 * 
		 */		
		public static function error( ...rest ):void
		{
			if( currentLevel < LOG_ERROR ) return;
			
			var s:String = "[ E ]" + rest.toString();
			
			$logger.error(s);
		}
		
		/**
		 * The FATAL level designates very severe error events that will presumably lead the application to abort. 
		 *  
		 * @param rest
		 * 
		 */		
		public static function fatal( ...rest ):void
		{
			var s:String = "[ F ]" + rest.toString();
			
			$logger.fatal(s);
		}
		
		/**
		 * Export log to a file
		 *  
		 * @param savedPath
		 * @return 
		 * 
		 */		
		public static function export(savedPath:String):Boolean
		{
			var f:File = new File(savedPath);
			if( f.exists )
			{
				return false;
			}
			
			f = null;
			
			return $logger.export(savedPath);
		}
	}
}
