package com.finegamedesign.recyclesort
{
    import flash.display.MovieClip;

    public class PearlClip extends MovieClip
    {
        internal static var instances:Array = [];

        /**
         * Add to list of pearls.
         */
        public function PearlClip() 
        {
            super();
            if (instances.indexOf(this) <= -1) {
                instances.push(this);
            }
        }
    }
}
