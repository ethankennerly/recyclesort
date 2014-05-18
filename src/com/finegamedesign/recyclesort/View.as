package com.finegamedesign.recyclesort
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import com.greensock.TweenLite;

    public class View
    {
        private static var itemClasses:Object = {
            landfill:   ItemLandfill,
            recycle:   ItemRecycle,
            AluminumCan:   ItemAluminumCan,
            PlasticBottle:   ItemPlasticBottle,
            Styrofoam:   ItemStyrofoam,
            PlasticBag:   ItemPlasticBag
        }

        internal var main:Main;
        internal var onCorrect:Function;
        internal var model:Model;
        private var countdown:Countdown;
        private var garbage:Array;
        private var pointClip:PointClip;
        private var queue:Array;

        public function View()
        {
            countdown = new Countdown();
        }

        internal function populate(model:Model, main:Main):void
        {
            this.model = model;
            this.main = main;
            populateQueue(model.queue);
            countdown.setup(Model.seconds, main.time_txt);
        }

        private function populateQueue(queueModel:Array):void
        {
            queue = [];
            garbage = [];
            for (var i:int = queueModel.length - 1; 0 <= i; i--) {
                var itemClass:Class = itemClasses[queueModel[i]];
                var item:DisplayObjectContainer = new itemClass();
                item.x = main.input.head.x;
                item.y = queueY(i);
                item.mouseChildren = false;
                item.mouseEnabled = false;
                item.cacheAsBitmap = true;
                queue.unshift(item);
                garbage.unshift(item);
                var index:int = main.input.getChildIndex(main.input.head);
                main.input.addChildAt(item, index);
            }
        }

        private function queueY(i:int):int
        {
            return main.input.head.y - int(i * main.input.head.height);
        }

        private function shift(target:DisplayObject):void
        {
            var time:Number = 0.2;
            TweenLite.to(queue.shift(), time, {x: target.x, y: target.y});
            for (var i:int = 0; i < queue.length; i++) {
                TweenLite.to(queue[i], time, {y: queueY(i)});
            }
        }

        private function answer(name:String):void
        {
            countdown.start();
            var correct:Boolean = model.answer(name);
            pointClip = point(main.input[name]);
            main.answer(correct, pointClip);
            shift(main.input[name]);
        }

        private function point(target:DisplayObject):PointClip
        {
            var point:PointClip = new PointClip();
            point.x = target.x;
            point.y = target.y;
            point.mouseChildren = false;
            point.mouseEnabled = false;
            point.txt.text = model.point.toString();
            garbage.push(point);
            main.input.addChild(point);
            return point;
        }

        internal function update():int
        {
            if (main.keyMouse.justPressed("LEFT")) {
                answer("landfill");
            }
            else if (main.keyMouse.justPressed("RIGHT")) {
                answer("recycle");
            }
            else if (main.keyMouse.justPressed("MOUSE")) {
                var name:String = main.keyMouse.target.name;
                if (name in itemClasses) {
                    answer(name);
                }
            }
            var winning:int = model.update(countdown.remaining);
            splice(model.queueMax);
            return winning;
        }

        private function splice(max:int):void
        {
            remove(queue.splice(max, int.MAX_VALUE));
        }

        private function remove(garbage:Array):void
        {
            for each(var item:DisplayObject in garbage) {
                if (item.parent) {
                    item.parent.removeChild(item);
                }
            }
            garbage.length = 0;
        }

        internal function clear():void
        {
            countdown.stop();
            remove(garbage);
            if (model) {
                model.clear();
            }
        }
    }
}
