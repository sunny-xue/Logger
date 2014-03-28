package com.logger.interfaces
{
	/**
	 *
	 * ERROR、WARN、INFO、DEBUG、fatal、export
	 * 
	 * @author sunny.xue
	 * 
	 */	
	public interface ILogger
	{
		
		function debug( value:String ):void
			
		function info( value:String ):void
		
		function warn( value:String ):void
			
		function error( value:String ):void
			
		function fatal( value:String ):void
			
		function export(path:String):Boolean
		
	}
}