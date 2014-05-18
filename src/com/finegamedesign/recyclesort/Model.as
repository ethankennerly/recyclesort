package com.finegamedesign.recyclesort
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Model
    {
        internal static var levelScores:Array = [];
        internal static var score:int = 0;

        public static function shuffle(array:Array):void
        {
            for (var i:int = array.length - 1; 1 <= i; i--) {
                var j:int = (i + 1) * Math.random();
                var tmp:* = array[i];
                array[i] = array[j];
                array[j] = tmp;
            }
        }

        internal var highScore:int;
        internal var queue:Array;
        internal var point:int = 0;
        internal var level:int;
        internal var levelScore:int;
        private var now:int;
        private var elapsed:Number;
        private var previousTime:int;

        public function Model()
        {
            score = 0;
            highScore = 0;
            levelScores = [];
        }

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
            queue = [];
            for (var i:int = 0; i < level; i++) {
                var deck:Array = ["landfill", "recycle", "recycle", "landfill",
                         "recycle", "landfill"];
                shuffle(deck);
                queue = queue.concat(deck);
            }
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
            updateScore();
            var winning:int = 0;
            if (queue.length == 0) {
                winning = 1 <= levelScore ? 1 : -1;
            }
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
        
        internal function answer(name:String):Boolean
        {
            var correct:Boolean = name == queue[0];
            if (correct) {
                point = 1;
            }
            else {
                point = -2;
            }
            levelScore += point;
            queue.shift();
            return correct;
        }
    }
}
