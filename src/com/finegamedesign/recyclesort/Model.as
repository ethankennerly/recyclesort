package com.finegamedesign.recyclesort
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Model
    {
        internal static var levelScores:Array = [];
        internal static var score:int = 0;

        internal var onScore:Function;
        internal var highScore:int;
        internal var level:int;
        internal var levelScore:int;
        internal var pearlsCollected:int;
        private var now:int;
        private var elapsed:Number;
        private var previousTime:int;

        public function Model()
        {
            score = 0;
            highScore = 0;
            levelScores = [];
        }

        /**
         * 14/4/26 Load level.  Tyriq expects to fix swimmer does not move.
         */
        internal function populate(level:int):void
        {
            this.level = level;
            if (null == levelScores[level]) {
                levelScores[level] = 0;
            }
            levelScore = 0;
            previousTime = -1;
            now = -1;
            elapsed = 0;
            pearlsCollected = 0;
        }

        internal function clear():void
        {
        }

        internal function update(now:int):int
        {
            previousTime = 0 <= this.now ? this.now : now;
            this.now = now;
            elapsed = this.now - previousTime;
            return win();
        }

        /**
         * @return  0 continue, 1: win, -1: lose.
         */
        private function win():int
        {
            var winning:int = 0;
            return winning;
        }

        private function updateScore():int
        {
            if (levelScores[level] < levelScore) {
                levelScores[level] = levelScore;
            }
            var sum:int = 0;
            for each (var n:int in levelScores) {
                sum += n;
            }
            score = sum;
            return sum;
        }
    }
}
