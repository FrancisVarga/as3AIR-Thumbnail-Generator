package cc.vamel.utils
{
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;

	public class GarbageCollectorHelper
	{
		public function GarbageCollectorHelper()
		{
		}
		
		public static function automatedClearGBC(intevalInMS : uint):void{
			var gbCleaner : Timer = new Timer(intevalInMS);
			gbCleaner.addEventListener(TimerEvent.TIMER, clearGBC);
			gbCleaner.start();
		}
		
		private static function clearGBC(event : * = null):void{
			System.gc();	
		}
		
		
	}
}