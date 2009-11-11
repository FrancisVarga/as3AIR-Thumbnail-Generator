package cc.vamel.utils
{
	import cmodule.jpegencoder.CLibInit;
	
	public class AlchemyJPEG
	{
		private static var _instance:AlchemyJPEG = null;
		private var jpegEncoder: Object;
		public function AlchemyJPEG(value:SingletonEnforcer)
		{
			jpegEncoder = (new CLibInit()).init();
		}
		
		public static function instance():AlchemyJPEG {
			if(!_instance) {
				_instance = new AlchemyJPEG(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function get encoder() : Object {
			return jpegEncoder;
		}
	}
}
	
	class SingletonEnforcer {
		
	}